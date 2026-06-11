USE [AgentPlaygroundDB];
GO

-- 1. Create a sample table to verify data is being updated
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PipelineLogs]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[PipelineLogs] (
        [LogID] INT IDENTITY(1,1) PRIMARY KEY,
        [DeploymentTime] DATETIME DEFAULT GETDATE(),
        [Status] VARCHAR(50) NOT NULL,
        [Message] VARCHAR(255) NOT NULL
    );
    PRINT 'Table [PipelineLogs] created successfully.';
END
GO

-- 2. Insert a fresh record into the table every time the pipeline pushes
INSERT INTO [dbo].[PipelineLogs] ([Status], [Message])
VALUES ('SUCCESS', 'Database deployment executed via Azure Self-Hosted Agent.');
PRINT 'Logged deployment status to [PipelineLogs].';
GO

-- 3. Create a custom SQL login and database user safely
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'PlaygroundAppUser')
BEGIN
    -- Creates the server login account
    CREATE LOGIN [PlaygroundAppUser] WITH PASSWORD = N'SecureP@ss123!', DEFAULT_DATABASE = [AgentPlaygroundDB];
    PRINT 'Login [PlaygroundAppUser] created.';
END
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'PlaygroundAppUser')
BEGIN
    -- Creates the user inside this specific database mapping to the login
    CREATE USER [PlaygroundAppUser] FOR LOGIN [PlaygroundAppUser];
    -- Grant read/write data privileges
    ALTER ROLE [db_datareader] ADD MEMBER [PlaygroundAppUser];
    ALTER ROLE [db_datawriter] ADD MEMBER [PlaygroundAppUser];
    PRINT 'User [PlaygroundAppUser] created and granted permissions.';
END
GO