/*
Title: Compatibility Levels
Purpose: Lists database compatibility levels alongside the current engine version.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    name AS DatabaseName,
    compatibility_level,
    CAST(SERVERPROPERTY('ProductMajorVersion') AS int) AS EngineMajorVersion,
    state_desc
FROM sys.databases
ORDER BY compatibility_level, name;
