from . import main_bp
from flask import jsonify

@main_bp.route("/", methods=["GET"])
def index():
    return jsonify({"message": "Deu bão!"})

@main_bp.route("/test", methods=["GET"])
def test():
    return jsonify({"message": "API OK"}), 200
