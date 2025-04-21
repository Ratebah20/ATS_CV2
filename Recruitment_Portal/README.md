# Portail de Recrutement

## Description
Application web sécurisée pour le portail de recrutement public de l'entreprise. Cette application permet aux candidats externes de consulter les offres d'emploi et de postuler facilement.

## Fonctionnalités
- Consultation des offres d'emploi disponibles
- Détails des offres et exigences
- Soumission de candidature (CV + lettre de motivation)
- Confirmation de candidature
- Interface utilisateur intuitive et responsive

## Sécurité
Cette application est conçue pour être exposée à l'extérieur de l'entreprise et ne contient aucune fonctionnalité d'administration ou d'accès aux données sensibles. Toutes les fonctionnalités de gestion RH sont uniquement disponibles dans l'application interne RH séparée.

## Installation

### Prérequis
- Python 3.8+
- pip (gestionnaire de paquets Python)

### Étapes d'installation
1. Cloner le dépôt
2. Créer un environnement virtuel Python :
   ```
   python -m venv venv
   ```
3. Activer l'environnement virtuel :
   - Windows : `venv\Scripts\activate`
   - Linux/Mac : `source venv/bin/activate`
4. Installer les dépendances :
   ```
   pip install -r requirements.txt
   ```
5. Configurer les variables d'environnement dans le fichier .env

## Utilisation

### Démarrage du serveur
```
python run.py
```

Le serveur démarre par défaut sur le port 5001 (http://localhost:5001)

### Déploiement en production
Pour un déploiement en production, il est recommandé d'utiliser un serveur WSGI comme Gunicorn ou uWSGI derrière un proxy inverse (Nginx ou Apache) avec SSL/TLS activé.

## Structure du projet
```
Recruitment_Portal/
├── app/
│   ├── models/            # Modèles de données
│   ├── routes/            # Routes de l'application
│   ├── static/            # Fichiers statiques (CSS, JS, images)
│   ├── templates/         # Templates HTML
│   └── __init__.py        # Initialisation de l'application
├── instance/              # Fichiers d'instance (base de données)
├── .env                   # Variables d'environnement
├── README.md              # Documentation
├── requirements.txt       # Dépendances
└── run.py                 # Point d'entrée de l'application
```

## Séparation des applications
Cette application fait partie d'une architecture à deux applications :
1. **Portail de Recrutement Public** (cette application) - exposée à l'internet
2. **Application RH Interne** - uniquement accessible depuis le réseau interne

Les deux applications partagent le même schéma de base de données mais sont déployées séparément pour des raisons de sécurité, conformément aux bonnes pratiques.
