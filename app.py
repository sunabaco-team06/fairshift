from flask import Flask, render_template, request
import sqlite3
from pathlib import Path

app = Flask(__name__)

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


# 🔵 Day2 追加ここから

@app.route("/absent")
def absent():
    conn = get_conn()
    staff = conn.execute(
        "SELECT id, name FROM staff ORDER BY id"
    ).fetchall()
    conn.close()
    return render_template("absent.html", staff=staff)


@app.route("/visits")
def visits():
    staff_id = request.args.get("staff_id")
    date = request.args.get("date")

    if not staff_id or not date:
        return "staff_id と date が必要です"

    conn = get_conn()
    visits = conn.execute("""
        SELECT v.visit_time,
               u.name AS user_name,
               a.name AS area_name
        FROM visits v
        JOIN users u ON u.id = v.user_id
        JOIN areas a ON a.id = u.area_id
        WHERE v.staff_id = ?
          AND v.visit_date = ?
        ORDER BY v.visit_time
    """, (staff_id, date)).fetchall()
    conn.close()

    return render_template(
        "visits.html",
        visits=visits,
        date=date
    )

# 🔵 Day2 追加ここまで


if __name__ == "__main__":
    app.run(debug=True)
