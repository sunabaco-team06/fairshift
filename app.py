from flask import Flask, render_template, request, abort, Response, redirect, url_for
import json
import sqlite3
from pathlib import Path
from typing import List, Optional, Dict, Any, Tuple
from collections import deque
from datetime import date as dt_date

app = Flask(__name__)

BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "fairshift_test.db"

# スケジュール表示の時間枠（前提：1時間枠）
SLOTS = [f"{h:02d}:00" for h in range(9, 19) if h != 12]


# ----------------------------
# DB utilities
# ----------------------------
def get_conn() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn

def insert_visit(staff_id: int, user_id: int, visit_date: str, visit_time: str, status: str = "planned") -> int:
    """visitsに1件追加して new_visit_id を返す"""
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO visits (staff_id, user_id, visit_date, visit_time, status)
            VALUES (?, ?, ?, ?, ?)
        """, (staff_id, user_id, visit_date, visit_time, status))
        conn.commit()
        return int(cur.lastrowid)
    finally:
        conn.close()


def insert_reassignment(original_visit_id: int, new_visit_id: int) -> int:
    """reassignmentsに1件追加して id を返す"""
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO reassignments (original_visit_id, new_visit_id, status)
            VALUES (?, ?, 'active')
        """, (original_visit_id, new_visit_id))
        conn.commit()
        return int(cur.lastrowid)
    finally:
        conn.close()


def visit_exists(staff_id: int, visit_date: str, visit_time: str) -> bool:
    """同一スタッフ×同日×同時刻の訪問がすでにあるか（衝突チェック）"""
    conn = get_conn()
    try:
        row = conn.execute("""
            SELECT 1
            FROM visits
            WHERE staff_id = ?
              AND visit_date = ?
              AND visit_time = ?
            LIMIT 1
        """, (staff_id, visit_date, visit_time)).fetchone()
        return row is not None
    finally:
        conn.close()

# ----------------------------
# Helper functions
# ----------------------------
def today_str() -> str:
    return dt_date.today().isoformat()


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

def role_points(role_required: str, staff_role: str) -> Tuple[int, str]:
    """
    users.role_required: any / pt_only / ot_only
    staff.role: pt / ot
    """
    if role_required == "any":
        return 0, "職種条件なし（any）"

    if role_required == "pt_only":
        if staff_role == "pt":
            return 2, "職種一致（PT希望） +2"
        return -2, "職種不一致（PT希望） -2"

    if role_required == "ot_only":
        if staff_role == "ot":
            return 2, "職種一致（OT希望） +2"
        return -2, "職種不一致（OT希望） -2"

    return 0, f"職種条件不明（{role_required}）"

def time_to_minutes(t: str) -> int:
    # "09:00" -> 540
    hh, mm = t.split(":")
    return int(hh) * 60 + int(mm)

def hour_diff(a: str, b: str) -> int:
    # aとbの差（時間単位、四捨五入なしで 60分=1 として計算）
    return abs(time_to_minutes(a) - time_to_minutes(b)) // 60

def time_diff_points(diff_hours: int) -> int:
    # 時間ずれが小さいほど加点（好みで調整OK）
    if diff_hours == 0:
        return 3
    if diff_hours == 1:
        return 2
    if diff_hours == 2:
        return 1
    return 0

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
        return conn.execute("SELECT id, name FROM staff ORDER BY id").fetchall()
    finally:
        conn.close()


def fetch_today_schedule(date: str) -> Dict[int, Dict[str, Any]]:
    """
    index.html 用：各枠 val を必ず dict にする
    schedule = {
      staff_id: {
        "staff_name": "...",
        "slots": {
          "09:00": {
            "visit_id": 1,
            "user_name": "...",
            "area_name": "...",
            "is_original_reassigned": False,
            "is_reassigned_visit": False,
            "orig_staff_name": None,
            "orig_time": None,
          },
          ...
        }
      }
    }
    """
    staff_rows = fetch_staff_simple()

    schedule: Dict[int, Dict[str, Any]] = {}
    for s in staff_rows:
        sid = int(s["id"])
        schedule[sid] = {
            "staff_name": str(s["name"]),
            "slots": {}
        }

    # staffごとに visit を入れる（val は dict に変換して格納）
    for s in staff_rows:
        sid = int(s["id"])
        visits = fetch_today_visits(sid, date)
        for r in visits:
            t = str(r["visit_time"])
            schedule[sid]["slots"][t] = {
                "visit_id": int(r["id"]),            # ← ここがキー
                "user_id": int(r["user_id"]),
                "user_name": str(r["user_name"]),
                "area_name": str(r["area_name"]),
                "user_area_id": int(r["user_area_id"]),
                # 振替表示用フラグ（index() で埋める）
                "is_original_reassigned": False,
                "is_reassigned_visit": False,
                "orig_staff_name": None,
                "orig_time": None,
            }

    return schedule


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


def fetch_today_visits_for_absent_staff_ids(staff_ids: List[int], date: str) -> List[sqlite3.Row]:
    if not staff_ids:
        return []

    placeholders = ",".join(["?"] * len(staff_ids))
    conn = get_conn()
    try:
        return conn.execute(f"""
            SELECT v.id,
                   v.visit_time,
                   v.user_id,
                   u.name AS user_name,
                   a.name AS area_name,
                   s.name AS staff_name
            FROM visits v
            JOIN users u ON u.id = v.user_id
            JOIN areas a ON a.id = u.area_id
            JOIN staff s ON s.id = v.staff_id
            WHERE v.visit_date = ?
              AND v.staff_id IN ({placeholders})
            ORDER BY v.visit_time
        """, (date, *staff_ids)).fetchall()
    finally:
        conn.close()


def fetch_visit_detail(visit_id: int) -> Optional[sqlite3.Row]:
    conn = get_conn()
    try:
        return conn.execute("""
            SELECT v.id,
                   v.visit_date,
                   v.visit_time,
                   v.staff_id,
                   v.user_id,
                   u.name AS user_name,
                   a.name AS area_name,
                   s.name AS staff_name
            FROM visits v
            JOIN users u ON u.id = v.user_id
            JOIN areas a ON a.id = u.area_id
            JOIN staff s ON s.id = v.staff_id
            WHERE v.id = ?
        """, (visit_id,)).fetchone()
    finally:
        conn.close()


def fetch_active_reassignments_by_date(date: str):
    """
    その日(date)の active な振替リンクを取る
    戻り:
      orig_to_new: {original_visit_id: {...new情報...}}
      new_to_orig: {new_visit_id: {...orig情報...}}
    """
    conn = get_conn()
    try:
        rows = conn.execute("""
            SELECT
              r.original_visit_id,
              r.new_visit_id,
              ov.visit_time AS orig_time,
              os.name       AS orig_staff_name
            FROM reassignments r
            JOIN visits ov ON ov.id = r.original_visit_id
            JOIN staff os  ON os.id = ov.staff_id
            WHERE r.status = 'active'
              AND ov.visit_date = ?
        """, (date,)).fetchall()

        orig_to_new = {}
        new_to_orig = {}

        for row in rows:
            original_id = int(row["original_visit_id"])
            new_id = int(row["new_visit_id"])

            orig_to_new[original_id] = {"new_visit_id": new_id}
            new_to_orig[new_id] = {
                "original_visit_id": original_id,
                "orig_staff_name": str(row["orig_staff_name"]),
                "orig_time": str(row["orig_time"]),
            }

        return orig_to_new, new_to_orig
    finally:
        conn.close()


def fetch_busy_times_for_staff(date: str) -> Dict[int, set]:
    """
    { staff_id: {"09:00","10:00",...} } を返す
    """
    conn = get_conn()
    try:
        rows = conn.execute("""
            SELECT staff_id, visit_time
            FROM visits
            WHERE visit_date = ?
        """, (date,)).fetchall()

        busy: Dict[int, set] = {}
        for r in rows:
            sid = int(r["staff_id"])
            busy.setdefault(sid, set()).add(str(r["visit_time"]))
        return busy
    finally:
        conn.close()


def fetch_free_slots_by_staff(date: str, slots: List[str]) -> Dict[int, List[str]]:
    """
    { staff_id: ["09:00","12:00",...] } を返す
    """
    staff = fetch_staff_simple()
    busy = fetch_busy_times_for_staff(date)

    free: Dict[int, List[str]] = {}
    for s in staff:
        sid = int(s["id"])
        busy_set = busy.get(sid, set())
        free[sid] = [t for t in slots if t not in busy_set]
    return free

def fetch_user_area_id(user_id: int) -> Optional[int]:
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


def fetch_user_profile(user_id: int) -> sqlite3.Row:
    conn = get_conn()
    try:
        row = conn.execute("""
            SELECT id, area_id, gender_preference, role_required
            FROM users
            WHERE id = ?
        """, (user_id,)).fetchone()
        return row
    finally:
        conn.close()

def fetch_user_name(user_id: int) -> Optional[str]:
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
            SELECT s.id, s.name, s.gender, s.role
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


def has_active_reassignment_for_original(original_visit_id: int) -> bool:
    conn = get_conn()
    try:
        row = conn.execute("""
            SELECT 1
            FROM reassignments
            WHERE original_visit_id = ?
              AND status = 'active'
            LIMIT 1
        """, (original_visit_id,)).fetchone()
        return row is not None
    finally:
        conn.close()


# ----------------------------
# Area distance (BFS)
# ----------------------------
def fetch_area_adjacency() -> Dict[int, List[int]]:
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
    rows = fetch_candidate_staff_raw(user_id, date, time)

    target_area_id = fetch_user_area_id(user_id)
    user_profile = fetch_user_profile(user_id)
    gender_pref = user_profile["gender_preference"]
    role_required = str(user_profile["role_required"])

    graph = fetch_area_adjacency()
    candidates: List[Dict[str, Any]] = []

    for r in rows:
        staff_id = int(r["id"])
        staff_name = r["name"]
        staff_gender = r["gender"]

        score = 0
        reasons: List[str] = [
            "同時間帯の予定なし",
            "NGスタッフではない",
        ]

        staff_role = str(r["role"])
        rp, rtxt = role_points(role_required, staff_role)
        score += rp
        reasons.append(rtxt)

        # gender適合（減点方式）
        if gender_pref == "any":
            reasons.append("性別条件なし（any）")
        elif gender_pref == "female_only":
            if staff_gender == "F":
                score += 2
                reasons.append("性別一致（女性） +2")
            else:
                score -= 2
                reasons.append("性別不一致（女性希望） -2")
        elif gender_pref == "male_only":
            if staff_gender == "M":
                score += 2
                reasons.append("性別一致（男性） +2")
            else:
                score -= 2
                reasons.append("性別不一致（男性希望） -2")

        # エリア評価
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

def build_candidate_slots_fallback(
    user_id: int,
    date: str,
    original_time: str,
    exclude_staff_ids: Optional[List[int]] = None
) -> List[Dict[str, Any]]:
    exclude_set = set(exclude_staff_ids or [])

    # NGスタッフ一覧
    conn = get_conn()
    try:
        ng_rows = conn.execute("""
            SELECT staff_id
            FROM user_ng_staff
            WHERE user_id = ?
        """, (user_id,)).fetchall()
        ng_set = {int(r["staff_id"]) for r in ng_rows}
    finally:
        conn.close()

    target_area_id = fetch_user_area_id(user_id)
    user_profile = fetch_user_profile(user_id)
    gender_pref = user_profile["gender_preference"]
    role_required = str(user_profile["role_required"])
    graph = fetch_area_adjacency()

    free_by_staff = fetch_free_slots_by_staff(date, SLOTS)
    staff_all = fetch_staff_full()
    staff_map = {int(s["id"]): s for s in staff_all}

    candidates: List[Dict[str, Any]] = []

    for sid, free_times in free_by_staff.items():
        if sid in exclude_set:
            continue
        if sid in ng_set:
            continue

        staff_row = staff_map.get(sid)
        if staff_row is None:
            continue

        staff_name = staff_row["name"]
        staff_gender = staff_row["gender"]

        for proposed_time in free_times:
            score = 0
            reasons: List[str] = []

            staff_role = str(staff_row["role"])
            rp, rtxt = role_points(role_required, staff_role)
            score += rp
            reasons.append(rtxt)

            diff_h = hour_diff(original_time, proposed_time)
            tp = time_diff_points(diff_h)
            score += tp
            reasons.append(f"時間ずれ: {diff_h}時間 → +{tp}")

            # 性別（既存ロジック踏襲）
            if gender_pref == "any":
                reasons.append("性別条件なし（any）")
            elif gender_pref == "female_only":
                if staff_gender == "F":
                    score += 2
                    reasons.append("性別一致（女性） +2")
                else:
                    score -= 2
                    reasons.append("性別不一致（女性希望） -2")
            elif gender_pref == "male_only":
                if staff_gender == "M":
                    score += 2
                    reasons.append("性別一致（男性） +2")
                else:
                    score -= 2
                    reasons.append("性別不一致（男性希望） -2")

            # エリア評価（提案枠の前後で評価）
            if target_area_id is None:
                reasons.append("利用者エリアが不明のため移動評価なし")
            else:
                prev_row, next_row = fetch_prev_next_visit(sid, date, proposed_time)

                prev_dist: Optional[int] = None
                next_dist: Optional[int] = None

                if prev_row is not None:
                    prev_area_id = int(prev_row["area_id"])
                    prev_time = prev_row["visit_time"]
                    prev_dist = get_area_distance_bfs_cached(graph, prev_area_id, target_area_id)
                    reasons.append(f"前の訪問({prev_time})→利用者 距離: {prev_dist if prev_dist is not None else '不明'}")

                if next_row is not None:
                    next_area_id = int(next_row["area_id"])
                    next_time = next_row["visit_time"]
                    next_dist = get_area_distance_bfs_cached(graph, target_area_id, next_area_id)
                    reasons.append(f"利用者→次の訪問({next_time}) 距離: {next_dist if next_dist is not None else '不明'}")

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
                elif mark in ("◎", "○", "△"):
                    reasons.append(f"エリア評価: {mark}（距離 {effective_dist}） +{add_points}")
                else:
                    reasons.append(f"エリア評価: ×（距離 {effective_dist}） +0")

            candidates.append({
                "staff_id": sid,
                "staff_name": staff_name,
                "score": score,
                "reasons": reasons,
                "proposed_time": proposed_time,
                "is_fallback": True
            })

    candidates.sort(key=lambda x: (-x["score"], x["staff_id"], x["proposed_time"]))
    return candidates[:3]


def build_candidate_cards_with_fallback(
    user_id: int,
    date: str,
    time: str,
    exclude_staff_ids: Optional[List[int]] = None
) -> List[Dict[str, Any]]:
    # まず同時間（今のロジック）
    top3 = build_candidate_cards(user_id, date, time)
    if len(top3) > 0:
        for c in top3:
            c["proposed_time"] = time
            c["is_fallback"] = False
        return top3

    # 同時間が0件なら別時間を探す
    return build_candidate_slots_fallback(
        user_id=user_id,
        date=date,
        original_time=time,
        exclude_staff_ids=exclude_staff_ids
    )


# ----------------------------
# Routes
# ----------------------------
@app.route("/")
def index():
    DEMO_TODAY = "2026-03-02"
    DEMO_TOMORROW = "2026-03-03"

    d = request.args.get("date") or DEMO_TODAY

    staff = fetch_staff_simple()
    schedule = fetch_today_schedule(d)

    orig_to_new, new_to_orig = fetch_active_reassignments_by_date(d)

    # schedule の各枠に振替フラグを付与（Rowでもdict化して確実に書き込む）
    for sid, info in schedule.items():
        slots_dict = info.get("slots", {})
        for t, val in list(slots_dict.items()):
            if not val:
                continue

            if not isinstance(val, dict):
                try:
                    val = dict(val)
                    slots_dict[t] = val
                except Exception:
                    continue

            vid = val.get("visit_id")
            if vid is None:
                vid = val.get("id")
            if vid is None:
                continue
            vid = int(vid)

            if vid in orig_to_new:
                val["is_original_reassigned"] = True

            if vid in new_to_orig:
                val["is_reassigned_visit"] = True
                val["orig_staff_name"] = new_to_orig[vid]["orig_staff_name"]
                val["orig_time"] = new_to_orig[vid]["orig_time"]

            # 以後の統一のため
            val["visit_id"] = vid

    return render_template(
    "index.html",
    staff=staff,
    schedule=schedule,
    slots=SLOTS,
    date=d,
    demo_today=DEMO_TODAY,
    demo_tomorrow=DEMO_TOMORROW,
)

@app.route("/staff")
def staff_list():
    staff = fetch_staff_full()
    return render_template("staff.html", staff=staff)


@app.route("/absent")
def absent():
    # 旧UIのまま残しておく（使わなくてもOK）
    staff = fetch_staff_simple()
    return render_template("absent.html", staff=staff)


@app.route("/visits")
def visits():
    # A案：複数欠勤に対応
    d = request.args.get("date") or today_str()
    staff_ids_str = request.args.getlist("staff_ids")
    if not staff_ids_str:
        abort(400, description="欠勤者（staff_ids）が選択されていません")

    staff_ids = [int(x) for x in staff_ids_str]

    # 欠勤者名（表示用）
    staff_all = fetch_staff_simple()
    id_to_name = {int(s["id"]): s["name"] for s in staff_all}
    absent_names = [id_to_name.get(sid, f"ID:{sid}") for sid in staff_ids]

    visits_rows = fetch_today_visits_for_absent_staff_ids(staff_ids, d)

    # ✅ 追加：振替済みの元枠は UI 上で選択不可にする
    visits_list: List[Dict[str, Any]] = []
    for v in visits_rows:
        dv = dict(v)  # sqlite3.Row → dict
        vid = int(dv["id"])
        dv["is_already_reassigned"] = has_active_reassignment_for_original(vid)
        visits_list.append(dv)

    return render_template(
        "visits.html",
        visits=visits_list,
        absent_names=absent_names,
        date=d,
    )


@app.route("/result_batch", methods=["POST"])
def result_batch():
    d = request.form.get("date") or today_str()
    visit_ids_str = request.form.getlist("visit_ids")
    if not visit_ids_str:
        abort(400, description="訪問（visit_ids）が選択されていません")

    visit_ids = [int(x) for x in visit_ids_str]

    results: List[Dict[str, Any]] = []
    for vid in visit_ids:
        v = fetch_visit_detail(vid)
        if v is None:
            continue
        exclude_ids = [int(v["staff_id"])]
        candidates = build_candidate_cards_with_fallback(
            int(v["user_id"]),
            str(v["visit_date"]),
            str(v["visit_time"]),
            exclude_staff_ids=exclude_ids
        )
        results.append({
            "visit": v,
            "candidates": candidates
        })

    return render_template("result_batch.html", results=results, date=d)

@app.route("/confirm_batch", methods=["POST"])
def confirm_batch():
    date = request.form.get("date") or today_str()

    # result_batch.html から送られてくる元訪問ID一覧
    original_ids = request.form.getlist("original_visit_ids")
    if not original_ids:
        abort(400, description="確定対象の訪問がありません")

    # まとめてエラーを出したいので、衝突があれば集める
    conflicts = []

    for vid_str in original_ids:
        try:
            original_visit_id = int(vid_str)
        except ValueError:
            continue

        # choice_<visit_id> を読む（候補0件のvisitはchoiceが無い）
        choice_key = f"choice_{original_visit_id}"
        choice_val = request.form.get(choice_key)
        if not choice_val:
            # 候補0件など：スキップ
            continue

        # "staff_id|proposed_time"
        try:
            staff_id_str, proposed_time = choice_val.split("|", 1)
            new_staff_id = int(staff_id_str)
            proposed_time = str(proposed_time)
        except Exception:
            abort(400, description=f"選択データが不正です: {choice_val}")

        v = fetch_visit_detail(original_visit_id)
        # ✅ すでに振替済の元枠なら弾く
        if has_active_reassignment_for_original(original_visit_id):
            conflicts.append(
                f"訪問ID {original_visit_id} は既に振替済です（重複振替はできません）"
            )
            continue

        if v is None:
            continue

        user_id = int(v["user_id"])
        visit_date = str(v["visit_date"])

        # 念のため、フォームのdateとDBのvisit_dateがズレてたらDB側を優先
        # （result_batchはその日のvisitを出してるはずなので）
        if visit_exists(new_staff_id, visit_date, proposed_time):
            conflicts.append(
                f"スタッフID {new_staff_id} の {visit_date} {proposed_time} は既に予定があります"
            )
            continue

        # 1) 新しい visit を追加（振替なので status='reassigned'）
        try:
            new_visit_id = insert_visit(
                staff_id=new_staff_id,
                user_id=user_id,
                visit_date=visit_date,
                visit_time=proposed_time,
                status="reassigned"
            )
        except sqlite3.IntegrityError:
            conflicts.append(
                f"スタッフID {new_staff_id} の {visit_date} {proposed_time} は既に予定があります（UNIQUE制約）"
            )
            continue

        # 2) reassignments に紐付けを追加
        insert_reassignment(original_visit_id=original_visit_id, new_visit_id=new_visit_id)

    if conflicts:
        # まずはシンプルにエラー表示（次の段階でおしゃれにしてOK）
        return (
            "<h2>振替確定できない枠がありました</h2>"
            + "<ul>" + "".join([f"<li>{c}</li>" for c in conflicts]) + "</ul>"
            + f'<p><a href="/">トップへ戻る</a>（または戻って選び直してね）</p>'
        ), 409

    # いったんトップへ戻す（後で /schedule に変える）
    return redirect(url_for("index", date=date))

@app.route("/result")
def result_json():
    """
    /result の最小実装（JSON）
    例:
      /result?user_id=17&date=2026-03-02&time=10:00
    """
    user_id = parse_int(request.args.get("user_id"), "user_id")
    d = parse_date(request.args.get("date"))
    t = parse_time(request.args.get("time"))

    user_name = fetch_user_name(user_id)
    candidates = build_candidate_cards(user_id, d, t)

    data = {
        "user_id": user_id,
        "user_name": user_name,
        "date": d,
        "time": t,
        "top3": candidates,
    }

    return Response(
        json.dumps(data, ensure_ascii=False, indent=2),
        mimetype="application/json; charset=utf-8"
    )


@app.route("/staff_adjust")
def staff_adjust_placeholder():
    return "Not implemented yet. (Day4+) 減点設定は後で実装予定", 501


# ----------------------------
# Debug routes（開発中だけ）
# ----------------------------
@app.route("/debug_prev_next")
def debug_prev_next():
    staff_id = parse_int(request.args.get("staff_id"), "staff_id")
    d = parse_date(request.args.get("date"))
    t = parse_time(request.args.get("time"))

    prev_row, next_row = fetch_prev_next_visit(staff_id, d, t)

    def row_to_dict(row: Optional[sqlite3.Row]) -> Optional[Dict[str, Any]]:
        if row is None:
            return None
        return {"visit_time": row["visit_time"], "area_id": row["area_id"]}

    return {
        "staff_id": staff_id,
        "date": d,
        "time": t,
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
    d = parse_date(request.args.get("date"))
    t = parse_time(request.args.get("time"))

    candidates = build_candidate_cards(user_id, d, t)
    return {
        "user_id": user_id,
        "date": d,
        "time": t,
        "candidates": candidates
    }


if __name__ == "__main__":
    app.run(debug=True)