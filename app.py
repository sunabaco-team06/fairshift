from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "FairShift MVP is running!"

@app.route("/staff")
def staff():
    return "Staff page (coming soon)"

if __name__ == "__main__":
    app.run(debug=True)
