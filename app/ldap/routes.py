from . import ldap_bp
from flask import jsonify

@ldap_bp.route("/test")
def ldap_test():
    return jsonify({"message": "LDAP route working!"})
