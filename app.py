from flask import Flask, render_template, request, abort
import sqlite3
from pathlib import Path
from typing import List, Optional, Dict, Any, Tuple
from collections import deque

app = Flask(__name__)

BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "fairshift.db"


# ----------------------------
# DB utilities
# ----------------------------
def get_conn() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn


# ----------------------------
# DB query functions
# ----------------------------
def fetch_staff_full() -> List[sqlite3.Row]:
    conn = get_conn()
    try:
        return conn.execute(
            "SELECT id, name, gender, role, created_at FROM staff ORDER BY id"
        ).fetchall()
    finally:
        conn.close()


def fetch_staff_simple() -> List[sqlite3.Row]:
    conn = get_conn()
    try:
        return conn.execute(
            "SELECT id, name FROM staff ORDER BY id"
        ).fetchall()
    finally:
        conn.close()


def fetch_today_visits(staff_id: int, date: str) -> List[sqlite3.Row]:
    conn = get_conn()
    try:
        return conn.execute("""
            SELECT v.id,
                   v.visit_time,
                   v.user_id,
                   u.name AS user_name,
                   a.name AS area_name,
                   u.area_id AS user_area_id
            FROM visits v
            JOIN users u ON u.id = v.user_id
            JOIN areas a ON a.id = u.area_id
            WHERE v.staff_id = ?
              AND v.visit_date = ?
            ORDER BY v.visit_time
        """, (staff_id, date)).fetchall()
    finally:
        conn.close()


def fetch_user_area_id(user_id: int) -> Optional[int]:
    """対象利用者のエリアIDを取得"""
    conn = get_conn()
    try:
        row = conn.execute("""
            SELECT area_id
            FROM users
            WHERE id = ?
        """, (user_id,)).fetchone()
        if row is None:
            return None
        return int(row["area_id"])
    finally:
        conn.close()


def fetch_user_name(user_id: int) -> Optional[str]:
    """対象利用者の名前を取得（result表示用）"""
    conn = get_conn()
    try:
        row = conn.execute("""
            SELECT name
            FROM users
            WHERE id = ?
        """, (user_id,)).fetchone()
        if row is None:
            return None
        return str(row["name"])
    finally:
        conn.close()


def fetch_candidate_staff_raw(user_id: int, date: str, time: str) -> List[sqlite3.Row]:
    """
    候補スタッフを返す（DB生データ）
    条件：
    - 同じ日時に予定がない
    - NGスタッフでない
    """
    conn = get_conn()
    try:
        return conn.execute("""
            SELECT s.id, s.name
            FROM staff s
            WHERE s.id NOT IN (
                SELECT staff_id
                FROM visits
                WHERE visit_date = ?
                  AND visit_time = ?
            )
            AND s.id NOT IN (
                SELECT staff_id
                FROM user_ng_staff
                WHERE user_id = ?
            )
            ORDER BY s.id
        """, (date, time, user_id)).fetchall()
    finally:
        conn.close()


def fetch_prev_next_visit(
    staff_id: int,
    date: str,
    time: str
) -> Tuple[Optional[sqlite3.Row], Optional[sqlite3.Row]]:
    """
    同日・同スタッフで、対象時間より
    - 前（prev）：最大の訪問（visit_timeが一番近い過去）
    - 後（next）：最小の訪問（visit_timeが一番近い未来）
    を取得する。
    """
    conn = get_conn()
    try:
        prev_row = conn.execute("""
            SELECT v.visit_time, u.area_id
            FROM visits v
            JOIN users u ON u.id = v.user_id
            WHERE v.staff_id = ?
              AND v.visit_date = ?
              AND v.visit_time < ?
            ORDER BY v.visit_time DESC
            LIMIT 1
        """, (staff_id, date, time)).fetchone()

        next_row = conn.execute("""
            SELECT v.visit_time, u.area_id
            FROM visits v
            JOIN users u ON u.id = v.user_id
            WHERE v.staff_id = ?
              AND v.visit_date = ?
              AND v.visit_time > ?
            ORDER BY v.visit_time ASC
            LIMIT 1
        """, (staff_id, date, time)).fetchone()

        return prev_row, next_row
    finally:
        conn.close()


# ----------------------------
# Area distance (BFS)
# ----------------------------
def fetch_area_adjacency() -> Dict[int, List[int]]:
    """area_edges から隣接リスト（グラフ）を作る（cost=1前提）"""
    conn = get_conn()
    try:
        rows = conn.execute("""
            SELECT area_id, neighbor_area_id
            FROM area_edges
            ORDER BY area_id, neighbor_area_id
        """).fetchall()
    finally:
        conn.close()

    graph: Dict[int, List[int]] = {}
    for r in rows:
        a = int(r["area_id"])
        b = int(r["neighbor_area_id"])
        graph.setdefault(a, []).append(b)
    return graph


def get_area_distance_bfs_cached(
    graph: Dict[int, List[int]],
    from_area_id: int,
    to_area_id: int
) -> Optional[int]:
    """BFSで最短距離（辺の数）を返す。到達不可ならNone。"""
    if from_area_id == to_area_id:
        return 0

    if from_area_id not in graph:
        return None

    q = deque([(from_area_id, 0)])
    visited = {from_area_id}

    while q:
        cur, dist = q.popleft()
        for nxt in graph.get(cur, []):
            if nxt in visited:
                continue
            if nxt == to_area_id:
                return dist + 1
            visited.add(nxt)
            q.append((nxt, dist + 1))

    return None


def distance_to_rank_points(dist: Optional[int]) -> Tuple[int, Optional[str]]:
    """距離→加点と記号（◎○△×）に変換"""
    if dist is None:
        return 0, None
    if dist == 0:
        return 3, "◎"
    if dist == 1:
        return 2, "○"
    if dist == 2:
        return 1, "△"
    return 0, "×"


# ----------------------------
# Candidate building
# ----------------------------
def build_candidate_cards(user_id: int, date: str, time: str) -> List[Dict[str, Any]]:
    """候補スタッフをスコア＋理由付きで返す（上位3名に絞る）"""
    rows = fetch_candidate_staff_raw(user_id, date, time)

    target_area_id = fetch_user_area_id(user_id)
    graph = fetch_area_adjacency()

    candidates: List[Dict[str, Any]] = []
    for r in rows:
        staff_id = int(r["id"])
        staff_name = r["name"]

        score = 0
        reasons: List[str] = [
            "同時間帯の予定なし",
            "NGスタッフではない",
        ]

        if target_area_id is None:
            reasons.append("利用者エリアが不明のため移動評価なし")
            candidates.append({
                "staff_id": staff_id,
                "staff_name": staff_name,
                "score": score,
                "reasons": reasons,
            })
            continue

        prev_row, next_row = fetch_prev_next_visit(staff_id, date, time)

        prev_dist: Optional[int] = None
        next_dist: Optional[int] = None

        if prev_row is not None:
            prev_area_id = int(prev_row["area_id"])
            prev_time = prev_row["visit_time"]
            prev_dist = get_area_distance_bfs_cached(graph, prev_area_id, target_area_id)
            reasons.append(f"前の訪問({prev_time})からの距離: {prev_dist if prev_dist is not None else '不明'}")

        if next_row is not None:
            next_area_id = int(next_row["area_id"])
            next_time = next_row["visit_time"]
            next_dist = get_area_distance_bfs_cached(graph, target_area_id, next_area_id)
            reasons.append(f"次の訪問({next_time})への距離: {next_dist if next_dist is not None else '不明'}")

        # 前後が両方あるなら「大きい方」を採用（どちらかが遠いと厳しい）
        effective_dist: Optional[int]
        if prev_dist is None and next_dist is None:
            effective_dist = None
            reasons.append("前後の訪問がなく移動評価なし")
        elif prev_dist is None:
            effective_dist = next_dist
        elif next_dist is None:
            effective_dist = prev_dist
        else:
            effective_dist = max(prev_dist, next_dist)

        add_points, mark = distance_to_rank_points(effective_dist)
        score += add_points

        if mark is None:
            reasons.append("エリア評価: なし（距離不明）")
        else:
            if mark in ("◎", "○", "△"):
                reasons.append(f"エリア評価: {mark}（距離 {effective_dist}） +{add_points}")
            else:
                reasons.append(f"エリア評価: ×（距離 {effective_dist}） +0")

        candidates.append({
            "staff_id": staff_id,
            "staff_name": staff_name,
            "score": score,
            "reasons": reasons,
        })

    candidates.sort(key=lambda x: (-x["score"], x["staff_id"]))
    return candidates[:3]


# ----------------------------
# Helper functions
# ----------------------------
def parse_int(value: Optional[str], field_name: str) -> int:
    if value is None or value == "":
        abort(400, description=f"{field_name} が必要です")
    try:
        return int(value)
    except ValueError:
        abort(400, description=f"{field_name} は整数で指定してください")


def parse_date(value: Optional[str]) -> str:
    if value is None or value == "":
        abort(400, description="date が必要です（YYYY-MM-DD）")
    return value


def parse_time(value: Optional[str]) -> str:
    if value is None or value == "":
        abort(400, description="time が必要です（HH:MM）")
    return value


# ----------------------------
# Routes
# ----------------------------
@app.route("/")
def index():
    return render_template("index.html")


@app.route("/staff")
def staff_list():
    staff = fetch_staff_full()
    return render_template("staff.html", staff=staff)


@app.route("/absent")
def absent():
    staff = fetch_staff_simple()
    return render_template("absent.html", staff=staff)


@app.route("/visits")
def visits():
    staff_id = parse_int(request.args.get("staff_id"), "staff_id")
    date = parse_date(request.args.get("date"))

    visits_rows = fetch_today_visits(staff_id, date)

    return render_template(
        "visits.html",
        visits=visits_rows,
        staff_id=staff_id,
        date=date,
    )


@app.route("/result")
def result_json():
    """
    ToDo3(A): /result の最小実装（JSON）
    例:
      /result?user_id=17&date=2026-03-02&time=10:00
    """
    user_id = parse_int(request.args.get("user_id"), "user_id")
    date = parse_date(request.args.get("date"))
    time = parse_time(request.args.get("time"))

    user_name = fetch_user_name(user_id)
    candidates = build_candidate_cards(user_id, date, time)

    return {
        "user_id": user_id,
        "user_name": user_name,
        "date": date,
        "time": time,
        "top3": candidates,
    }


@app.route("/staff_adjust")
def staff_adjust_placeholder():
    return "Not implemented yet. (Day4+) 減点設定は後で実装予定", 501


# ----------------------------
# Debug routes（開発中だけ）
# ----------------------------
@app.route("/debug_prev_next")
def debug_prev_next():
    staff_id = parse_int(request.args.get("staff_id"), "staff_id")
    date = parse_date(request.args.get("date"))
    time = parse_time(request.args.get("time"))

    prev_row, next_row = fetch_prev_next_visit(staff_id, date, time)

    def row_to_dict(row: Optional[sqlite3.Row]) -> Optional[Dict[str, Any]]:
        if row is None:
            return None
        return {"visit_time": row["visit_time"], "area_id": row["area_id"]}

    return {
        "staff_id": staff_id,
        "date": date,
        "time": time,
        "prev": row_to_dict(prev_row),
        "next": row_to_dict(next_row),
    }


@app.route("/debug_distance")
def debug_distance():
    from_area_id = parse_int(request.args.get("from_area_id"), "from_area_id")
    to_area_id = parse_int(request.args.get("to_area_id"), "to_area_id")

    graph = fetch_area_adjacency()
    dist = get_area_distance_bfs_cached(graph, from_area_id, to_area_id)

    return {
        "from_area_id": from_area_id,
        "to_area_id": to_area_id,
        "distance": dist
    }


@app.route("/debug_candidates")
def debug_candidates():
    user_id = parse_int(request.args.get("user_id"), "user_id")
    date = parse_date(request.args.get("date"))
    time = parse_time(request.args.get("time"))

    candidates = build_candidate_cards(user_id, date, time)
    return {
        "user_id": user_id,
        "date": date,
        "time": time,
        "candidates": candidates
    }


if __name__ == "__main__":
    app.run(debug=True)