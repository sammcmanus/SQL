/*
Title: Disabled and Hypothetical Indexes
Purpose: Lists disabled and hypothetical indexes that may represent incomplete maintenance or tuning artifacts.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SCHEMA_NAME(o.schema_id) AS SchemaName, o.name AS TableName,
    i.name AS IndexName, i.index_id, i.type_desc,
    i.is_disabled, i.is_hypothetical, i.is_unique,
    i.is_primary_key, i.is_unique_constraint
FROM sys.indexes AS i
JOIN sys.objects AS o ON o.object_id = i.object_id AND o.type = 'U'
WHERE i.is_disabled = 1 OR i.is_hypothetical = 1
ORDER BY SchemaName, TableName, i.index_id;
