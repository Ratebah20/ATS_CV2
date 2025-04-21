from flask import Blueprint, render_template, redirect, url_for
from app.models.models import JobPosition
from datetime import datetime

bp = Blueprint('public', __name__)

@bp.route('/')
def index():
    """Page d'accueil du portail de recrutement public"""
    # Récupérer les postes actifs pour les afficher sur la page d'accueil
    active_jobs = JobPosition.query.filter_by(is_active=True).all()
    return render_template('public/index.html', jobs=active_jobs, year=datetime.now().year)

@bp.route('/about')
def about():
    """Page À propos avec informations sur l'entreprise"""
    return render_template('public/about.html', year=datetime.now().year)
