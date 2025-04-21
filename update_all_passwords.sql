-- Mise à jour des mots de passe pour tous les utilisateurs
-- Le hash correspond au mot de passe "password123"

USE ATS_CV;
GO

-- Mettre à jour le mot de passe pour admin
UPDATE [User] 
SET password_hash = '$2b$12$ivqz2oKl6rQykP8gGt457OsW1X0l921PFjCmACjWaBRBBtVtOlCau' 
WHERE username = 'admin';

-- Mettre à jour le mot de passe pour manager_info
UPDATE [User] 
SET password_hash = '$2b$12$ivqz2oKl6rQykP8gGt457OsW1X0l921PFjCmACjWaBRBBtVtOlCau' 
WHERE username = 'manager_info';

-- Mettre à jour le mot de passe pour manager_marketing
UPDATE [User] 
SET password_hash = '$2b$12$ivqz2oKl6rQykP8gGt457OsW1X0l921PFjCmACjWaBRBBtVtOlCau' 
WHERE username = 'manager_marketing';

-- Mettre à jour le mot de passe pour manager_rh
UPDATE [User] 
SET password_hash = '$2b$12$ivqz2oKl6rQykP8gGt457OsW1X0l921PFjCmACjWaBRBBtVtOlCau' 
WHERE username = 'manager_rh';

-- Mettre à jour le mot de passe pour manager_finance
UPDATE [User] 
SET password_hash = '$2b$12$ivqz2oKl6rQykP8gGt457OsW1X0l921PFjCmACjWaBRBBtVtOlCau' 
WHERE username = 'manager_finance';

-- Mettre à jour le mot de passe pour manager_rd
UPDATE [User] 
SET password_hash = '$2b$12$ivqz2oKl6rQykP8gGt457OsW1X0l921PFjCmACjWaBRBBtVtOlCau' 
WHERE username = 'manager_rd';

PRINT 'Tous les mots de passe ont été mis à jour avec succès.';
GO
