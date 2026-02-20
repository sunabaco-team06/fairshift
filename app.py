from flask import Flask, render_template, request
import sqlite3
from pathlib import Path

app = Flask(__name__)

# app.py と同じ場所にある fairshift.db を参照する
BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "fairshift.db"


def get_conn():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/staff")
def staff_list():
    conn = get_conn()
    staff = conn.execute(
        "SELECT id, name, gender, role, created_at FROM staff ORDER BY id"
    ).fetchall()
    conn.close()

    return render_template("staff.html", staff=staff)


# ----------------------------
# ✅ Day2：ここが今日の本番
# ----------------------------
@app.route("/absent")
def absent():
    return render_template("absent.html")


@app.route("/visits")
def visits():
    staff_id = request.args.get("staff_id")
    date = request.args.get("date")

    # Day2なので仮データ
    visits = [
        {"time": "09:00", "user": "田中太郎", "area": "中央区"},
        {"time": "11:00", "user": "佐藤花子", "area": "港区"},
        {"time": "14:00", "user": "鈴木一郎", "area": "新宿区"},
    ]

    return render_template(
        "visits.html",
        staff_id=staff_id,
        date=date,
        visits=visits
    )


# ----------------------------
# まだ作らない（Day3以降）
# ----------------------------
@app.route("/result")
def result_placeholder():
    return "Not implemented yet. (Day3)", 501


@app.route("/staff_adjust")
def staff_adjust_placeholder():
    return "Not implemented yet. (Day4+)", 501


if __name__ == "__main__":
    app.run(debug=True)