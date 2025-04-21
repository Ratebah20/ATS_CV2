from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import enum

db = SQLAlchemy()

# Adaptation pour SQL Server - utilisation de la table de statuts au lieu de l'enum
class ApplicationStatus:
    SUBMITTED = 1
    UNDER_REVIEW = 2
    INTERVIEW = 3
    REJECTED = 4
    ACCEPTED = 5
    
    @staticmethod
    def get_name(status_id):
        status_names = {
            1: "Soumise",
            2: "En cours d'analyse",
            3: "Entretien",
            4: "Rejetée",
            5: "Acceptée"
        }
        return status_names.get(status_id, "Inconnu")

# Modèle pour la table des statuts de candidature
class ApplicationStatusModel(db.Model):
    __tablename__ = 'ApplicationStatus'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)
    description = db.Column(db.String(100), nullable=True)
    applications = db.relationship('Application', backref='application_status', lazy=True, foreign_keys='Application.status_id')

class JobPosition(db.Model):
    __tablename__ = 'JobPosition'
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    requirements = db.Column(db.Text, nullable=False)
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    applications = db.relationship('Application', backref='job_position', lazy=True)
    
    def __repr__(self):
        return f'<JobPosition {self.title}>'

class Candidate(db.Model):
    __tablename__ = 'Candidate'
    
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(50), nullable=False)
    last_name = db.Column(db.String(50), nullable=False)
    email = db.Column(db.String(100), nullable=False)
    phone = db.Column(db.String(20), nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    applications = db.relationship('Application', backref='candidate', lazy=True)
    
    def __repr__(self):
        return f'<Candidate {self.first_name} {self.last_name}>'

class Application(db.Model):
    __tablename__ = 'Application'
    
    id = db.Column(db.Integer, primary_key=True)
    candidate_id = db.Column(db.Integer, db.ForeignKey('Candidate.id'), nullable=False)
    job_position_id = db.Column(db.Integer, db.ForeignKey('JobPosition.id'), nullable=False)
    cv_filename = db.Column(db.String(255), nullable=False)
    cover_letter = db.Column(db.Text, nullable=True)
    status_id = db.Column(db.Integer, db.ForeignKey('ApplicationStatus.id'), default=ApplicationStatus.SUBMITTED)
    ai_analysis = db.Column(db.Text, nullable=True)
    ai_score = db.Column(db.Float, nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    @property
    def status(self):
        return self.status_id
    
    @property
    def status_name(self):
        return ApplicationStatus.get_name(self.status_id)
    
    def __repr__(self):
        return f'<Application {self.id} - Status: {self.status_name}>'
