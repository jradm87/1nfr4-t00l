# app/__init__.py
from flask import Flask
from .config import Config
from .main import main_bp
from .ldap import ldap_bp
from .smb import smb_bp
from .ssh import ssh_bp

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    app.register_blueprint(main_bp)
    app.register_blueprint(ldap_bp, url_prefix="/ldap")
    app.register_blueprint(smb_bp, url_prefix="/smb")
    app.register_blueprint(ssh_bp, url_prefix="/ssh")

    return app
