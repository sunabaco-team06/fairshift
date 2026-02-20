from flask import Flask, render_template, request, abort
import sqlite3
from pathlib import Path
from typing import List, Optional, Dict, Any

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


def build_candidate_cards(user_id: int, date: str, time: str) -> List[Dict[str, Any]]:
    """
    候補スタッフを「スコア＋理由付きの辞書」に整形して返す（Aの完成形）
    いまはスコアは0スタート、理由も最低限だけ入れる。
    Day3以降で加点ロジック（エリア◎○△、優先度など）を足していく。
    """
    rows = fetch_candidate_staff_raw(user_id, date, time)

    candidates: List[Dict[str, Any]] = []
    for r in rows:
        candidates.append({
            "staff_id": r["id"],
            "staff_name": r["name"],
            "score": 0,
            "reasons": [
                "同時間帯の予定なし",
                "NGスタッフではない"
            ]
        })

    return candidates


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


@app.route("/staff_adjust")
def staff_adjust_placeholder():
    return "Not implemented yet. (Day4+) 減点設定は後で実装予定", 501


if __name__ == "__main__":
    app.run(debug=True)
