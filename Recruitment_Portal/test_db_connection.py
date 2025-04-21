import os
import pyodbc
from dotenv import load_dotenv

# Chargement des variables d'environnement
dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
load_dotenv(dotenv_path)

# Récupération des informations de connexion
db_server = os.environ.get('DB_SERVER', 'DESKTOP-AJGEL30')
db_name = os.environ.get('DB_NAME', 'ATS_CV')

# Essayons différentes chaînes de connexion
connection_strings = [
    # 1. Connexion standard avec authentification Windows
    f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={db_server};DATABASE={db_name};Trusted_Connection=yes;TrustServerCertificate=yes;Encrypt=NO;",
    
    # 2. Connexion avec le nom d'instance par défaut
    f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={db_server}\\SQLEXPRESS;DATABASE={db_name};Trusted_Connection=yes;TrustServerCertificate=yes;Encrypt=NO;",
    
    # 3. Connexion avec localhost
    f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER=localhost;DATABASE={db_name};Trusted_Connection=yes;TrustServerCertificate=yes;Encrypt=NO;",
    
    # 4. Connexion avec adresse IP locale
    f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER=127.0.0.1;DATABASE={db_name};Trusted_Connection=yes;TrustServerCertificate=yes;Encrypt=NO;",
    
    # 5. Connexion avec le nom d'instance par défaut sur localhost
    f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER=localhost\\SQLEXPRESS;DATABASE={db_name};Trusted_Connection=yes;TrustServerCertificate=yes;Encrypt=NO;",
    
    # 6. Connexion avec le protocole TCP/IP explicite
    f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER=tcp:{db_server},1433;DATABASE={db_name};Trusted_Connection=yes;TrustServerCertificate=yes;Encrypt=NO;"
]

# Variable pour suivre si une connexion a réussi
connection_success = False

# Tester chaque chaîne de connexion
for i, conn_str in enumerate(connection_strings):
    try:
        # Tentative de connexion
        print(f"\nTentative de connexion #{i+1}...")
        print(f"Chaîne de connexion: {conn_str}")
        
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        
        # Vérification de la version du serveur
        cursor.execute('SELECT @@VERSION')
        row = cursor.fetchone()
        print('\n✅ Connexion réussie à la base de données!')
        print(f'Version du serveur: {row[0]}')
        
        # Liste des bases de données
        cursor.execute('SELECT name FROM sys.databases')
        print('\nBases de données disponibles:')
        for db in cursor.fetchall():
            print(f' - {db[0]}')
        
        # Liste des tables dans la base de données ATS_CV
        try:
            cursor.execute("USE ATS_CV; SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_NAME")
            print('\nTables dans la base de données ATS_CV:')
            for table in cursor.fetchall():
                print(f' - {table[0]}')
        except Exception as table_error:
            print(f"\nErreur lors de la récupération des tables: {str(table_error)}")
        
        # Fermeture des ressources
        cursor.close()
        conn.close()
        
        # Marquer la connexion comme réussie et sortir de la boucle
        connection_success = True
        print("\n=== IMPORTANT ====")
        print(f"Utilisez cette configuration dans votre fichier .env:")
        if "localhost" in conn_str:
            print("DB_SERVER='localhost'")
        elif "127.0.0.1" in conn_str:
            print("DB_SERVER='127.0.0.1'")
        elif "\\SQLEXPRESS" in conn_str:
            if "localhost" in conn_str:
                print("DB_SERVER='localhost\\SQLEXPRESS'")
            else:
                print(f"DB_SERVER='{db_server}\\SQLEXPRESS'")
        elif "tcp:" in conn_str:
            print(f"DB_SERVER='tcp:{db_server},1433'")
        else:
            print(f"DB_SERVER='{db_server}'")
        print("DB_WINDOWS_AUTH='yes'")
        print("=================")
        break
        
    except Exception as e:
        print(f'\n❌ Erreur de connexion: {str(e)}')

# Si aucune connexion n'a réussi
if not connection_success:
    print("\n⚠️ Aucune des méthodes de connexion n'a fonctionné.")
    print("Vérifiez que:")
    print(" - Le service SQL Server est démarré")
    print(" - Le protocole TCP/IP est activé dans SQL Server Configuration Manager")
    print(" - Les connexions distantes sont autorisées")
    print(" - Le pare-feu Windows autorise les connexions SQL Server")
