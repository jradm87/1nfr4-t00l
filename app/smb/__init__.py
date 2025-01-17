from flask import Blueprint

smb_bp = Blueprint("smb", __name__)

from . import routes
