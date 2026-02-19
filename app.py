from flask import Flask, render_template
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
    return "FairShift MVP is running!"


@app.route("/staff")
def staff_list():
    # DBからスタッフ一覧を取得
    conn = get_conn()
    staff = conn.execute(
        "SELECT id, name, gender, role, created_at FROM staff ORDER BY id"
    ).fetchall()
    conn.close()

    return render_template("staff.html", staff=staff)


if __name__ == "__main__":
    app.run(debug=True)
