from flask import Blueprint

ldap_bp = Blueprint("ldap", __name__)

from . import routes
