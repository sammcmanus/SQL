/*
Title: Generate CHECKDB Commands
Purpose: Builds integrity-check commands for all online databases.
Compatibility: SQL Server 2016+
Safety: READ ONLY COMMAND GENERATOR; running generated commands can be resource intensive

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @IncludeSystemDatabases bit = 1;
DECLARE @PhysicalOnly bit = 0;

SELECT
    name AS DatabaseName,
    N'DBCC CHECKDB (' + QUOTENAME(name, '''') +
    N') WITH NO_INFOMSGS, ALL_ERRORMSGS' +
    CASE WHEN @PhysicalOnly = 1 THEN N', PHYSICAL_ONLY' ELSE N'' END + N';'
        AS CheckDbCommand
FROM sys.databases
WHERE state_desc = N'ONLINE'
  AND is_read_only = 0
  AND (@IncludeSystemDatabases = 1 OR database_id > 4)
ORDER BY database_id;
