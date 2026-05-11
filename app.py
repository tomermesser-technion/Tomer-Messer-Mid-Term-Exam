import os
import socket

from flask import Flask, jsonify, redirect, render_template, request

API_KEY = os.environ.get("API_KEY")
if not API_KEY:
    raise SystemExit("API_KEY environment variable is required")

PORT = int(os.environ.get("PORT", 5000))
VERSION = os.environ.get("VERSION", "1.0.0")

app = Flask(__name__)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/api/status")
def api_status_redirect():
    return redirect("/api/v1/status")


@app.route("/api/v1/status")
def api_status():
    return jsonify({
        "status": "ok",
        "hostname": socket.gethostname(),
        "version": VERSION,
    })


@app.route("/api/v1/secret")
def api_secret():
    key = request.headers.get("X-API-Key")
    if key != API_KEY:
        return jsonify({"error": "Unauthorized"}), 401
    return jsonify({"message": "you found the secret"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT)
