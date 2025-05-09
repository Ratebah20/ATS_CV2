from flask import Flask
import os
import urllib.parse
import pyodbc
from dotenv import load_dotenv
from sqlalchemy import event, text

from app.models.models import db

def create_app():
    app = Flask(__name__, instance_relative_config=True)
    
    # Chargement des variables d'environnement
    dotenv_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), '.env')
    load_dotenv(dotenv_path)
    
    # Construction de la chaîne de connexion SQL Server
    db_driver = os.environ.get('DB_DRIVER', 'SQL Server')
    db_server = os.environ.get('DB_SERVER', 'DESKTOP-AJGEL30')
    db_name = os.environ.get('DB_NAME', 'ATS_CV')
    db_windows_auth = os.environ.get('DB_WINDOWS_AUTH', 'yes')
    
    # Chaîne de connexion ODBC avec le driver SQL Server natif et authentification Windows
    if db_windows_auth.lower() == 'yes':
        # Utiliser l'authentification Windows (trusted_connection=yes)
        odbc_connection = f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={db_server};DATABASE={db_name};Trusted_Connection=yes;TrustServerCertificate=yes;Encrypt=NO;"
        connection_string = f"mssql+pyodbc://{db_server}/{db_name}?driver=ODBC+Driver+17+for+SQL+Server&TrustServerCertificate=yes&Encrypt=NO&trusted_connection=yes"
    else:
        # Utiliser l'authentification SQL Server si nécessaire
        db_user = os.environ.get('DB_USER', 'sa')
        db_password = os.environ.get('DB_PASSWORD', '')
        encoded_password = urllib.parse.quote_plus(db_password)
        odbc_connection = f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={db_server};DATABASE={db_name};UID={db_user};PWD={encoded_password};TrustServerCertificate=yes;Encrypt=NO;"
        connection_string = f"mssql+pyodbc://{db_user}:{encoded_password}@{db_server}/{db_name}?driver=ODBC+Driver+17+for+SQL+Server&TrustServerCertificate=yes&Encrypt=NO&trusted_connection=no"
    
    # Configuration
    app.config.from_mapping(
        SECRET_KEY=os.environ.get('SECRET_KEY', 'dev_key_change_this'),
        SQLALCHEMY_DATABASE_URI=connection_string,
        SQLALCHEMY_TRACK_MODIFICATIONS=False,
        SQLALCHEMY_ENGINE_OPTIONS={
            'fast_executemany': True,  # Amélioration des performances
            'connect_args': {
                'TrustServerCertificate': 'yes',
                'Encrypt': 'NO'
            }
        },
        UPLOAD_FOLDER=os.path.join(app.root_path, 'static', 'uploads'),
        MAX_CONTENT_LENGTH=16 * 1024 * 1024,  # Limite de taille des fichiers à 16 MB
    )
    
    # Assurez-vous que le dossier instance existe
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass
    
    # Assurez-vous que le dossier uploads existe
    try:
        os.makedirs(os.path.join(app.root_path, 'static', 'uploads'))
    except OSError:
        pass
    
    # Initialisation de l'extension SQLAlchemy
    db.init_app(app)
    
    # Enregistrement des blueprints
    from app.routes import public, jobs, application
    app.register_blueprint(public.bp)
    app.register_blueprint(jobs.bp)
    app.register_blueprint(application.bp)
    
    # Ne pas recréer les tables car elles existent déjà dans SQL Server
    # Configurer SQLAlchemy pour utiliser le schéma de base de données correct
    with app.app_context():
        # Définir le gestionnaire d'événements pour la connexion
        @event.listens_for(db.engine, 'connect')
        def on_connect(dbapi_connection, connection_record):
            # Configurer la connexion pour éviter les problèmes de précision avec SQL Server
            cursor = dbapi_connection.cursor()
            cursor.execute("SET ANSI_NULLS ON")
            cursor.execute("SET ANSI_PADDING ON")
            cursor.execute("SET ANSI_WARNINGS ON")
            cursor.execute("SET ARITHABORT ON")
            cursor.execute("SET CONCAT_NULL_YIELDS_NULL ON")
            cursor.execute("SET QUOTED_IDENTIFIER ON")
            cursor.commit()
            
            # Désactiver la mise en cache des requêtes qui peut causer des problèmes
            cursor.execute("SET NOCOUNT ON")
            cursor.commit()
            
            # Configurer l'encodage pour gérer correctement les caractères spéciaux
            dbapi_connection.setdecoding(pyodbc.SQL_CHAR, encoding='latin1')
            dbapi_connection.setdecoding(pyodbc.SQL_WCHAR, encoding='utf-16le')
            dbapi_connection.setdecoding(pyodbc.SQL_WMETADATA, encoding='utf-16le')
            dbapi_connection.setencoding(encoding='latin1', ctype=pyodbc.SQL_CHAR)
            dbapi_connection.setencoding(encoding='utf-16le', ctype=pyodbc.SQL_WCHAR)
        
        # Créer les tables si elles n'existent pas déjà
        try:
            # Exécuter une requête simple pour vérifier que la connexion fonctionne
            db.session.execute(text('SELECT 1')).fetchall()
            print("Connexion à la base de données réussie!")
            
            # Créer les tables si nécessaire
            db.create_all()
            print("Tables créées ou déjà existantes.")
        except Exception as e:
            print(f"Erreur de connexion à la base de données: {str(e)}")
            # Afficher plus de détails sur l'erreur pour faciliter le débogage
            import traceback
            traceback.print_exc()
            # Log l'erreur mais ne pas arrêter l'application
            pass
    
    from markupsafe import Markup, escape
    def nl2br(value):
        return Markup('<br>'.join(escape(value).split('\n')))
    app.jinja_env.filters['nl2br'] = nl2br

    return app
