-- Script d'insertion de données de test pour ATS_CV
USE ATS_CV;
GO

-- Ajout de départements pour les offres d'emploi
DECLARE @departments TABLE (name NVARCHAR(100));
INSERT INTO @departments VALUES 
    ('Informatique'), 
    ('Marketing'), 
    ('Ressources Humaines'), 
    ('Finance'), 
    ('Recherche et Développement');

-- Ajout d'utilisateurs (RH et managers)
-- Note: Le mot de passe hashé correspond à "password123" (utilisant bcrypt)
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [username] = 'admin')
BEGIN
    INSERT INTO [dbo].[User] ([username], [password_hash], [email], [role_id], [first_name], [last_name])
    VALUES ('admin', '$2b$12$tPRbXMBGxhvB5ORNrGFAYuXjnbZeQBYRYBQhJ8T4LMaQpYkFsXU8a', 'admin@ats.com', 1, 'Admin', 'RH');
END

-- Managers par département
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [username] = 'manager_info')
BEGIN
    INSERT INTO [dbo].[User] ([username], [password_hash], [email], [role_id], [first_name], [last_name], [department])
    VALUES ('manager_info', '$2b$12$tPRbXMBGxhvB5ORNrGFAYuXjnbZeQBYRYBQhJ8T4LMaQpYkFsXU8a', 'manager_info@ats.com', 2, 'Jean', 'Dupont', 'Informatique');
END

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [username] = 'manager_marketing')
BEGIN
    INSERT INTO [dbo].[User] ([username], [password_hash], [email], [role_id], [first_name], [last_name], [department])
    VALUES ('manager_marketing', '$2b$12$tPRbXMBGxhvB5ORNrGFAYuXjnbZeQBYRYBQhJ8T4LMaQpYkFsXU8a', 'manager_marketing@ats.com', 2, 'Marie', 'Martin', 'Marketing');
END

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [username] = 'manager_rh')
BEGIN
    INSERT INTO [dbo].[User] ([username], [password_hash], [email], [role_id], [first_name], [last_name], [department])
    VALUES ('manager_rh', '$2b$12$tPRbXMBGxhvB5ORNrGFAYuXjnbZeQBYRYBQhJ8T4LMaQpYkFsXU8a', 'manager_rh@ats.com', 2, 'Pierre', 'Durand', 'Ressources Humaines');
END

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [username] = 'manager_finance')
BEGIN
    INSERT INTO [dbo].[User] ([username], [password_hash], [email], [role_id], [first_name], [last_name], [department])
    VALUES ('manager_finance', '$2b$12$tPRbXMBGxhvB5ORNrGFAYuXjnbZeQBYRYBQhJ8T4LMaQpYkFsXU8a', 'manager_finance@ats.com', 2, 'Sophie', 'Leroy', 'Finance');
END

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [username] = 'manager_rd')
BEGIN
    INSERT INTO [dbo].[User] ([username], [password_hash], [email], [role_id], [first_name], [last_name], [department])
    VALUES ('manager_rd', '$2b$12$tPRbXMBGxhvB5ORNrGFAYuXjnbZeQBYRYBQhJ8T4LMaQpYkFsXU8a', 'manager_rd@ats.com', 2, 'Thomas', 'Moreau', 'Recherche et Développement');
END

-- Ajout d'offres d'emploi par département
-- Informatique
IF NOT EXISTS (SELECT * FROM [dbo].[JobPosition] WHERE [title] = 'Développeur Full Stack')
BEGIN
    INSERT INTO [dbo].[JobPosition] ([title], [description], [requirements], [is_active], [department])
    VALUES ('Développeur Full Stack', 'Nous recherchons un développeur Full Stack expérimenté pour rejoindre notre équipe de développement. Vous travaillerez sur des projets web innovants utilisant les dernières technologies.', 'Expérience en JavaScript, React, Node.js, et bases de données SQL/NoSQL. Minimum 3 ans d''expérience professionnelle.', 1, 'Informatique');
END

IF NOT EXISTS (SELECT * FROM [dbo].[JobPosition] WHERE [title] = 'Ingénieur DevOps')
BEGIN
    INSERT INTO [dbo].[JobPosition] ([title], [description], [requirements], [is_active], [department])
    VALUES ('Ingénieur DevOps', 'Nous cherchons un ingénieur DevOps pour améliorer nos processus de déploiement et d''intégration continue.', 'Expérience avec Docker, Kubernetes, AWS/Azure, et CI/CD pipelines. Minimum 2 ans d''expérience.', 1, 'Informatique');
END

-- Marketing
IF NOT EXISTS (SELECT * FROM [dbo].[JobPosition] WHERE [title] = 'Responsable Marketing Digital')
BEGIN
    INSERT INTO [dbo].[JobPosition] ([title], [description], [requirements], [is_active], [department])
    VALUES ('Responsable Marketing Digital', 'Nous recherchons un responsable marketing digital pour développer et mettre en œuvre notre stratégie de marketing en ligne.', 'Expérience en SEO/SEM, réseaux sociaux, et analytics. Minimum 4 ans d''expérience.', 1, 'Marketing');
END

-- Ressources Humaines
IF NOT EXISTS (SELECT * FROM [dbo].[JobPosition] WHERE [title] = 'Chargé de Recrutement')
BEGIN
    INSERT INTO [dbo].[JobPosition] ([title], [description], [requirements], [is_active], [department])
    VALUES ('Chargé de Recrutement', 'Nous cherchons un chargé de recrutement pour gérer le processus de recrutement de l''entreprise.', 'Expérience en recrutement, sourcing, et entretiens. Minimum 2 ans d''expérience.', 1, 'Ressources Humaines');
END

-- Finance
IF NOT EXISTS (SELECT * FROM [dbo].[JobPosition] WHERE [title] = 'Analyste Financier')
BEGIN
    INSERT INTO [dbo].[JobPosition] ([title], [description], [requirements], [is_active], [department])
    VALUES ('Analyste Financier', 'Nous recherchons un analyste financier pour aider à la prise de décision financière de l''entreprise.', 'Formation en finance ou comptabilité. Expérience en analyse financière et modélisation. Minimum 3 ans d''expérience.', 1, 'Finance');
END

-- Recherche et Développement
IF NOT EXISTS (SELECT * FROM [dbo].[JobPosition] WHERE [title] = 'Chercheur en IA')
BEGIN
    INSERT INTO [dbo].[JobPosition] ([title], [description], [requirements], [is_active], [department])
    VALUES ('Chercheur en IA', 'Nous cherchons un chercheur en intelligence artificielle pour développer de nouveaux algorithmes et solutions.', 'Doctorat en informatique, mathématiques ou domaine connexe. Expérience en machine learning et deep learning.', 1, 'Recherche et Développement');
END

-- Ajout de candidats
IF NOT EXISTS (SELECT * FROM [dbo].[Candidate] WHERE [email] = 'lucas.bernard@email.com')
BEGIN
    INSERT INTO [dbo].[Candidate] ([first_name], [last_name], [email], [phone])
    VALUES ('Lucas', 'Bernard', 'lucas.bernard@email.com', '0612345678');
END

IF NOT EXISTS (SELECT * FROM [dbo].[Candidate] WHERE [email] = 'emma.petit@email.com')
BEGIN
    INSERT INTO [dbo].[Candidate] ([first_name], [last_name], [email], [phone])
    VALUES ('Emma', 'Petit', 'emma.petit@email.com', '0623456789');
END

IF NOT EXISTS (SELECT * FROM [dbo].[Candidate] WHERE [email] = 'hugo.robert@email.com')
BEGIN
    INSERT INTO [dbo].[Candidate] ([first_name], [last_name], [email], [phone])
    VALUES ('Hugo', 'Robert', 'hugo.robert@email.com', '0634567890');
END

IF NOT EXISTS (SELECT * FROM [dbo].[Candidate] WHERE [email] = 'chloe.simon@email.com')
BEGIN
    INSERT INTO [dbo].[Candidate] ([first_name], [last_name], [email], [phone])
    VALUES ('Chloé', 'Simon', 'chloe.simon@email.com', '0645678901');
END

IF NOT EXISTS (SELECT * FROM [dbo].[Candidate] WHERE [email] = 'louis.michel@email.com')
BEGIN
    INSERT INTO [dbo].[Candidate] ([first_name], [last_name], [email], [phone])
    VALUES ('Louis', 'Michel', 'louis.michel@email.com', '0656789012');
END

-- Ajout de candidatures
-- Récupérer les IDs des candidats
DECLARE @lucas_id INT = (SELECT id FROM [dbo].[Candidate] WHERE [email] = 'lucas.bernard@email.com');
DECLARE @emma_id INT = (SELECT id FROM [dbo].[Candidate] WHERE [email] = 'emma.petit@email.com');
DECLARE @hugo_id INT = (SELECT id FROM [dbo].[Candidate] WHERE [email] = 'hugo.robert@email.com');
DECLARE @chloe_id INT = (SELECT id FROM [dbo].[Candidate] WHERE [email] = 'chloe.simon@email.com');
DECLARE @louis_id INT = (SELECT id FROM [dbo].[Candidate] WHERE [email] = 'louis.michel@email.com');

-- Récupérer les IDs des offres d'emploi
DECLARE @dev_id INT = (SELECT id FROM [dbo].[JobPosition] WHERE [title] = 'Développeur Full Stack');
DECLARE @devops_id INT = (SELECT id FROM [dbo].[JobPosition] WHERE [title] = 'Ingénieur DevOps');
DECLARE @marketing_id INT = (SELECT id FROM [dbo].[JobPosition] WHERE [title] = 'Responsable Marketing Digital');
DECLARE @rh_id INT = (SELECT id FROM [dbo].[JobPosition] WHERE [title] = 'Chargé de Recrutement');
DECLARE @finance_id INT = (SELECT id FROM [dbo].[JobPosition] WHERE [title] = 'Analyste Financier');
DECLARE @ia_id INT = (SELECT id FROM [dbo].[JobPosition] WHERE [title] = 'Chercheur en IA');

-- Ajouter des candidatures si elles n'existent pas déjà
IF NOT EXISTS (SELECT * FROM [dbo].[Application] WHERE [candidate_id] = @lucas_id AND [job_position_id] = @dev_id)
BEGIN
    INSERT INTO [dbo].[Application] ([candidate_id], [job_position_id], [status_id], [cover_letter], [ai_analysis], [ai_score], [cv_filename])
    VALUES (@lucas_id, @dev_id, 2, 'Je suis très intéressé par le poste de développeur Full Stack. J''ai 5 ans d''expérience en développement web et je maîtrise les technologies demandées.', 'Candidat avec un bon profil technique. Expérience pertinente en développement web. Recommandé pour un entretien.', 85, 'cv_lucas.pdf');
END

IF NOT EXISTS (SELECT * FROM [dbo].[Application] WHERE [candidate_id] = @emma_id AND [job_position_id] = @marketing_id)
BEGIN
    INSERT INTO [dbo].[Application] ([candidate_id], [job_position_id], [status_id], [cover_letter], [ai_analysis], [ai_score], [cv_filename])
    VALUES (@emma_id, @marketing_id, 3, 'Je souhaite postuler au poste de Responsable Marketing Digital. J''ai 6 ans d''expérience en marketing digital et j''ai dirigé plusieurs campagnes réussies.', 'Excellente candidate avec une expérience significative en marketing digital. Forte recommandation pour un entretien.', 92, 'cv_emma.pdf');
END

IF NOT EXISTS (SELECT * FROM [dbo].[Application] WHERE [candidate_id] = @hugo_id AND [job_position_id] = @devops_id)
BEGIN
    INSERT INTO [dbo].[Application] ([candidate_id], [job_position_id], [status_id], [cover_letter], [ai_analysis], [ai_score], [cv_filename])
    VALUES (@hugo_id, @devops_id, 1, 'Je postule pour le poste d''Ingénieur DevOps. J''ai 3 ans d''expérience avec Docker, Kubernetes et les pipelines CI/CD.', 'Candidat avec une bonne expérience technique en DevOps. Correspond bien au profil recherché.', 78, 'cv_hugo.pdf');
END

IF NOT EXISTS (SELECT * FROM [dbo].[Application] WHERE [candidate_id] = @chloe_id AND [job_position_id] = @rh_id)
BEGIN
    INSERT INTO [dbo].[Application] ([candidate_id], [job_position_id], [status_id], [cover_letter], [ai_analysis], [ai_score], [cv_filename])
    VALUES (@chloe_id, @rh_id, 4, 'Je suis intéressée par le poste de Chargé de Recrutement. J''ai 4 ans d''expérience en recrutement dans divers secteurs.', 'Candidate avec une bonne expérience en recrutement, mais manque d''expérience spécifique au secteur de l''entreprise.', 65, 'cv_chloe.pdf');
END

IF NOT EXISTS (SELECT * FROM [dbo].[Application] WHERE [candidate_id] = @louis_id AND [job_position_id] = @finance_id)
BEGIN
    INSERT INTO [dbo].[Application] ([candidate_id], [job_position_id], [status_id], [cover_letter], [ai_analysis], [ai_score], [cv_filename])
    VALUES (@louis_id, @finance_id, 5, 'Je postule pour le poste d''Analyste Financier. J''ai un Master en Finance et 5 ans d''expérience en analyse financière.', 'Excellent candidat avec une formation et une expérience parfaitement adaptées au poste. Fortement recommandé.', 95, 'cv_louis.pdf');
END

-- Ajout de demandes d'entretien
-- Récupérer les IDs des managers
DECLARE @manager_marketing_id INT = (SELECT id FROM [dbo].[User] WHERE [username] = 'manager_marketing');
DECLARE @manager_info_id INT = (SELECT id FROM [dbo].[User] WHERE [username] = 'manager_info');
DECLARE @manager_rh_id INT = (SELECT id FROM [dbo].[User] WHERE [username] = 'manager_rh');
DECLARE @manager_finance_id INT = (SELECT id FROM [dbo].[User] WHERE [username] = 'manager_finance');

-- Récupérer les IDs des candidatures
DECLARE @app_lucas_dev INT = (SELECT id FROM [dbo].[Application] WHERE [candidate_id] = @lucas_id AND [job_position_id] = @dev_id);
DECLARE @app_emma_marketing INT = (SELECT id FROM [dbo].[Application] WHERE [candidate_id] = @emma_id AND [job_position_id] = @marketing_id);
DECLARE @app_louis_finance INT = (SELECT id FROM [dbo].[Application] WHERE [candidate_id] = @louis_id AND [job_position_id] = @finance_id);

-- Ajouter des demandes d'entretien
IF NOT EXISTS (SELECT * FROM [dbo].[InterviewRequest] WHERE [application_id] = @app_lucas_dev AND [manager_id] = @manager_info_id)
BEGIN
    INSERT INTO [dbo].[InterviewRequest] ([application_id], [manager_id], [requested_date], [status], [comments])
    VALUES (@app_lucas_dev, @manager_info_id, DATEADD(DAY, 7, GETDATE()), 'PENDING', 'Ce candidat a un profil intéressant, j''aimerais le rencontrer pour discuter de ses compétences techniques.');
END

IF NOT EXISTS (SELECT * FROM [dbo].[InterviewRequest] WHERE [application_id] = @app_emma_marketing AND [manager_id] = @manager_marketing_id)
BEGIN
    INSERT INTO [dbo].[InterviewRequest] ([application_id], [manager_id], [requested_date], [status], [comments])
    VALUES (@app_emma_marketing, @manager_marketing_id, DATEADD(DAY, 5, GETDATE()), 'APPROVED', 'Excellente candidate, entretien programmé pour la semaine prochaine.');
END

IF NOT EXISTS (SELECT * FROM [dbo].[InterviewRequest] WHERE [application_id] = @app_louis_finance AND [manager_id] = @manager_finance_id)
BEGIN
    INSERT INTO [dbo].[InterviewRequest] ([application_id], [manager_id], [requested_date], [status], [comments])
    VALUES (@app_louis_finance, @manager_finance_id, DATEADD(DAY, 3, GETDATE()), 'COMPLETED', 'Entretien très positif, nous allons lui faire une offre.');
END

PRINT 'Données de test insérées avec succès.';
GO
