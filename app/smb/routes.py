from . import smb_bp
from flask import jsonify

@smb_bp.route("/test")
def smb_test():
    return jsonify({"message": "SMB route working!"})
