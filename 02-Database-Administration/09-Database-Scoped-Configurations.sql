/*
Title: Database Scoped Configurations
Purpose: Collects scoped configuration values from every online user database.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

CREATE TABLE #ScopedConfig
(
    DatabaseName sysname, ConfigurationName sysname,
    Value sql_variant, ValueForSecondary sql_variant
);

DECLARE @sql nvarchar(max) = N'';
SELECT @sql += N'
USE ' + QUOTENAME(name) + N';
SELECT DB_NAME(), name, value, value_for_secondary
FROM sys.database_scoped_configurations;'
FROM sys.databases
WHERE database_id > 4 AND state_desc = N'ONLINE';

INSERT #ScopedConfig EXEC sys.sp_executesql @sql;
SELECT * FROM #ScopedConfig ORDER BY DatabaseName, ConfigurationName;
