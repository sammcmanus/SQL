/*
Title: Generate CHECKTABLE Commands
Purpose: Builds DBCC CHECKTABLE commands for every user table in the current database.
Compatibility: SQL Server 2016+
Safety: READ ONLY COMMAND GENERATOR; running generated commands can be resource intensive

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SCHEMA_NAME(schema_id) AS SchemaName,
    name AS TableName,
    N'DBCC CHECKTABLE (N''' +
    REPLACE(QUOTENAME(SCHEMA_NAME(schema_id)) + N'.' + QUOTENAME(name), '''', '''''') +
    N''') WITH NO_INFOMSGS, ALL_ERRORMSGS;' AS CheckTableCommand
FROM sys.tables
WHERE is_ms_shipped = 0
ORDER BY SchemaName, TableName;
