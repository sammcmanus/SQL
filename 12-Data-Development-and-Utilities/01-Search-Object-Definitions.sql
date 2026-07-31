/*
Title: Search Object Definitions
Purpose: Searches T-SQL module definitions in the current database for a text pattern.
Compatibility: SQL Server 2016+
Safety: READ ONLY; encrypted module definitions cannot be searched

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @SearchText nvarchar(4000) = N'YourSearchText';

SELECT
    SCHEMA_NAME(o.schema_id) AS SchemaName, o.name AS ObjectName,
    o.type_desc, o.create_date, o.modify_date,
    m.uses_ansi_nulls, m.uses_quoted_identifier,
    m.definition
FROM sys.sql_modules AS m
JOIN sys.objects AS o ON o.object_id = m.object_id
WHERE m.definition LIKE N'%' + @SearchText + N'%'
ORDER BY o.type_desc, SchemaName, o.name;
