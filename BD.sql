-- Script de création de base de données pour l'application ATS_CV
-- À exécuter sur SQL Server

-- Création de la base de données
USE master;
GO

-- Création de la base de données si elle n'existe pas déjà
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ATS_CV')
BEGIN
    CREATE DATABASE ATS_CV;
END
GO

USE ATS_CV;
GO

-- Table pour le statut des candidatures (équivalent de l'enum ApplicationStatus)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ApplicationStatus]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ApplicationStatus](
        [id] INT PRIMARY KEY,
        [name] NVARCHAR(50) NOT NULL,
        [description] NVARCHAR(100) NULL
    );

    -- Insérer les valeurs de statut (équivalent à l'enum)
    INSERT INTO [dbo].[ApplicationStatus] ([id], [name], [description])
    VALUES 
        (1, 'SUBMITTED', 'Candidature soumise'),
        (2, 'UNDER_REVIEW', 'En cours d''analyse'),
        (3, 'INTERVIEW', 'Entretien'),
        (4, 'REJECTED', 'Candidature rejetée'),
        (5, 'ACCEPTED', 'Candidature acceptée');
END
GO

-- Table des offres d'emploi
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[JobPosition]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[JobPosition](
        [id] INT IDENTITY(1,1) PRIMARY KEY,
        [title] NVARCHAR(100) NOT NULL,
        [description] NVARCHAR(MAX) NOT NULL,
        [requirements] NVARCHAR(MAX) NOT NULL,
        [is_active] BIT NOT NULL DEFAULT 1,
        [created_at] DATETIME NOT NULL DEFAULT GETDATE(),
        [updated_at] DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- Table des candidats
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Candidate]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Candidate](
        [id] INT IDENTITY(1,1) PRIMARY KEY,
        [first_name] NVARCHAR(50) NOT NULL,
        [last_name] NVARCHAR(50) NOT NULL,
        [email] NVARCHAR(100) NOT NULL,
        [phone] NVARCHAR(20) NULL,
        [created_at] DATETIME NOT NULL DEFAULT GETDATE(),
        [updated_at] DATETIME NOT NULL DEFAULT GETDATE()
    );

    -- Index sur l'email pour accélérer les recherches et garantir l'unicité
    CREATE UNIQUE INDEX IDX_Candidate_Email ON [dbo].[Candidate]([email]);
END
GO

-- Table des candidatures
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Application]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Application](
        [id] INT IDENTITY(1,1) PRIMARY KEY,
        [candidate_id] INT NOT NULL,
        [job_position_id] INT NOT NULL,
        [cv_filename] NVARCHAR(255) NOT NULL,
        [cover_letter] NVARCHAR(MAX) NULL,
        [status_id] INT NOT NULL DEFAULT 1, -- Par défaut SUBMITTED
        [ai_analysis] NVARCHAR(MAX) NULL,
        [ai_score] FLOAT NULL,
        [created_at] DATETIME NOT NULL DEFAULT GETDATE(),
        [updated_at] DATETIME NOT NULL DEFAULT GETDATE(),
        
        -- Contraintes de clé étrangère
        CONSTRAINT FK_Application_Candidate FOREIGN KEY ([candidate_id]) 
            REFERENCES [dbo].[Candidate]([id]),
        CONSTRAINT FK_Application_JobPosition FOREIGN KEY ([job_position_id]) 
            REFERENCES [dbo].[JobPosition]([id]),
        CONSTRAINT FK_Application_Status FOREIGN KEY ([status_id]) 
            REFERENCES [dbo].[ApplicationStatus]([id])
    );

    -- Index pour améliorer les performances des requêtes
    CREATE INDEX IDX_Application_Candidate ON [dbo].[Application]([candidate_id]);
    CREATE INDEX IDX_Application_JobPosition ON [dbo].[Application]([job_position_id]);
    CREATE INDEX IDX_Application_Status ON [dbo].[Application]([status_id]);
END
GO

-- Procédure stockée pour mettre à jour les dates de dernière modification
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateApplicationStatus]') AND type in (N'P'))
BEGIN
    EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[UpdateApplicationStatus]
        @ApplicationId INT,
        @StatusId INT
    AS
    BEGIN
        SET NOCOUNT ON;
        
        UPDATE [dbo].[Application]
        SET [status_id] = @StatusId,
            [updated_at] = GETDATE()
        WHERE [id] = @ApplicationId;
    END';
END
GO

-- Trigger pour mettre à jour la date de dernière modification
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_JobPosition_Update]'))
BEGIN
    EXEC dbo.sp_executesql @statement = N'
    CREATE TRIGGER [dbo].[trg_JobPosition_Update]
    ON [dbo].[JobPosition]
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
        
        UPDATE [dbo].[JobPosition]
        SET [updated_at] = GETDATE()
        FROM [dbo].[JobPosition] JP
        INNER JOIN inserted i ON JP.id = i.id;
    END';
END
GO

-- Vue pour obtenir des statistiques sur les candidatures
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ApplicationStats]'))
BEGIN
    EXEC dbo.sp_executesql @statement = N'
    CREATE VIEW [dbo].[vw_ApplicationStats] AS
    SELECT 
        JP.title AS job_title,
        COUNT(A.id) AS total_applications,
        SUM(CASE WHEN A.status_id = 1 THEN 1 ELSE 0 END) AS submitted_count,
        SUM(CASE WHEN A.status_id = 2 THEN 1 ELSE 0 END) AS under_review_count,
        SUM(CASE WHEN A.status_id = 3 THEN 1 ELSE 0 END) AS interview_count,
        SUM(CASE WHEN A.status_id = 4 THEN 1 ELSE 0 END) AS rejected_count,
        SUM(CASE WHEN A.status_id = 5 THEN 1 ELSE 0 END) AS accepted_count,
        AVG(ISNULL(A.ai_score, 0)) AS average_score
    FROM [dbo].[JobPosition] JP
    LEFT JOIN [dbo].[Application] A ON JP.id = A.job_position_id
    GROUP BY JP.id, JP.title';
END
GO

PRINT 'Base de données ATS_CV créée avec succès.';
GO