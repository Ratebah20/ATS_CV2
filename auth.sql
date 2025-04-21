-- Création de la table des rôles si elle n'existe pas
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Role]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Role](
        [id] INT PRIMARY KEY,
        [name] NVARCHAR(50) NOT NULL UNIQUE,
        [description] NVARCHAR(255) NULL
    );

    -- Insertion des rôles
    INSERT INTO [dbo].[Role] ([id], [name], [description])
    VALUES
        (1, 'HR', 'Personnel RH avec gestion complète des candidatures et aux systèmes'),
        (2, 'MANAGER', 'Manager avec accès restreint aux candidatures et postes du département concerné');
END
GO

-- Création de la table des utilisateurs si elle n'existe pas
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[User](
        [id] INT IDENTITY(1,1) PRIMARY KEY,
        [username] NVARCHAR(100) NOT NULL UNIQUE,
        [password_hash] NVARCHAR(255) NOT NULL,
        [email] NVARCHAR(100) NOT NULL UNIQUE,
        [first_name] NVARCHAR(100) NULL,
        [last_name] NVARCHAR(100) NULL,
        [role_id] INT NOT NULL,
        [department] NVARCHAR(100) NULL,
        [created_at] DATETIME DEFAULT GETDATE(),
        [updated_at] DATETIME DEFAULT GETDATE(),
        [is_active] BIT DEFAULT 1,

        FOREIGN KEY ([role_id]) REFERENCES [dbo].[Role]([id])
    );
END
GO

-- Vérifier si la colonne department existe dans JobPosition, sinon l'ajouter
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[JobPosition]') AND name = 'department')
BEGIN
    ALTER TABLE [dbo].[JobPosition] ADD [department] NVARCHAR(100) DEFAULT 'General';
END
GO

-- Création de la table pour les demandes d'entretien si elle n'existe pas
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InterviewRequest]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[InterviewRequest](
        [id] INT IDENTITY(1,1) PRIMARY KEY,
        [application_id] INT NOT NULL,
        [manager_id] INT NOT NULL,
        [requested_date] DATETIME NOT NULL,
        [status] NVARCHAR(20) DEFAULT 'PENDING', -- Options: PENDING, APPROVED, REFUSED, COMPLETED
        [comments] NVARCHAR(MAX) NULL,
        [created_at] DATETIME DEFAULT GETDATE(),

        FOREIGN KEY ([application_id]) REFERENCES [dbo].[Application]([id]),
        FOREIGN KEY ([manager_id]) REFERENCES [dbo].[User]([id])
    );
END
GO

-- Index pour améliorer les performances des requêtes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IDX_InterviewRequest_Application' AND object_id = OBJECT_ID('dbo.InterviewRequest'))
BEGIN
    CREATE INDEX IDX_InterviewRequest_Application ON [dbo].[InterviewRequest]([application_id]);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IDX_InterviewRequest_User' AND object_id = OBJECT_ID('dbo.InterviewRequest'))
BEGIN
    CREATE INDEX IDX_InterviewRequest_User ON [dbo].[InterviewRequest]([manager_id]);
END
GO

-- Ajouter un utilisateur RH par défaut pour les tests
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [username] = 'admin')
BEGIN
    INSERT INTO [dbo].[User] ([username], [password_hash], [email], [role_id], [first_name], [last_name])
    VALUES ('admin', '$2b$12$tPRbXMBGxhvB5ORNrGFAYuXjnbZeQBYRYBQhJ8T4LMaQpYkFsXU8a', 'admin@ats.com', 1, 'Admin', 'RH');
END
GO
