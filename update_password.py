import bcrypt

# Générer un hash bcrypt pour le mot de passe "password123"
password = "password123"
password_bytes = password.encode('utf-8')
salt = bcrypt.gensalt()
hashed_password = bcrypt.hashpw(password_bytes, salt)

print(f"Mot de passe original: {password}")
print(f"Hash bcrypt généré: {hashed_password.decode('utf-8')}")

# Vérifier le hash (pour test)
is_valid = bcrypt.checkpw(password_bytes, hashed_password)
print(f"Vérification du hash: {is_valid}")

# Afficher la requête SQL pour mettre à jour le mot de passe
print("\nRequête SQL pour mettre à jour le mot de passe:")
print(f"UPDATE [User] SET password_hash = '{hashed_password.decode('utf-8')}' WHERE username = 'admin';")
