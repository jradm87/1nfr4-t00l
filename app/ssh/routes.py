from . import ssh_bp
from flask import jsonify

@ssh_bp.route("/test")
def ssh_test():
    return jsonify({"message": "SSH route working!"})
