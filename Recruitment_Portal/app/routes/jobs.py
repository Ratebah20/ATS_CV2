from flask import Blueprint, render_template, abort
from app.models.models import JobPosition
from datetime import datetime

bp = Blueprint('jobs', __name__, url_prefix='/jobs')

@bp.route('/')
def list_jobs():
    """Liste de toutes les offres d'emploi actives"""
    active_jobs = JobPosition.query.filter_by(is_active=True).all()
    return render_template('public/jobs/list.html', jobs=active_jobs, year=datetime.now().year)

@bp.route('/<int:job_id>')
def job_details(job_id):
    """Détails d'une offre d'emploi spécifique"""
    job = JobPosition.query.get_or_404(job_id)
    
    if not job.is_active:
        abort(404)
        
    return render_template('public/jobs/details.html', job=job, year=datetime.now().year)
