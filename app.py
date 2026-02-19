from flask import Flask, render_template
import sqlite3
from pathlib import Path

app = Flask(__name__)

# app.py と同じ場所にある fairshift.db を参照する
BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "fairshift.db"


def get_conn():
    """SQLite接続（Rowでdictっぽく扱う）"""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn


@app.route("/")
def index():
    """トップ画面"""
    return render_template("index.html")


@app.route("/staff")
def staff_list():
    """スタッフ一覧（DBから取得して表示）"""
    conn = get_conn()
    staff = conn.execute(
        "SELECT id, name, gender, role, created_at FROM staff ORDER BY id"
    ).fetchall()
    conn.close()

    return render_template("staff.html", staff=staff)


# ----------------------------
# Day2 / Day3 で追加予定のルート（いまは未実装）
# ----------------------------
@app.route("/absent")
def absent_placeholder():
    return "Not implemented yet. (Day2) 欠勤スタッフ選択画面を作成予定", 501


@app.route("/visits")
def visits_placeholder():
    return "Not implemented yet. (Day2) 訪問一覧画面を作成予定", 501


@app.route("/result")
def result_placeholder():
    return "Not implemented yet. (Day3) 振替候補表示画面を作成予定", 501


@app.route("/staff_adjust")
def staff_adjust_placeholder():
    return "Not implemented yet. (Day4+) 減点設定は後で実装予定", 501


if __name__ == "__main__":
    app.run(debug=True)
