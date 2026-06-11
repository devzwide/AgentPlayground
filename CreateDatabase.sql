USE [master];
GO

-- Check if the database already exists
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'AgentPlaygroundDB')
BEGIN
    CREATE DATABASE [AgentPlaygroundDB];
    PRINT 'Database [AgentPlaygroundDB] created successfully.';
END
ELSE
BEGIN
    PRINT 'Database [AgentPlaygroundDB] already exists. Skipping creation.';
END
GO