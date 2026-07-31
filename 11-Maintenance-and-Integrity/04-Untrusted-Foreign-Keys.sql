/*
Title: Untrusted Foreign Keys
Purpose: Finds enabled foreign keys that SQL Server cannot trust for query optimization.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SCHEMA_NAME(t.schema_id) AS SchemaName, t.name AS TableName,
    fk.name AS ForeignKeyName,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS ReferencedSchema,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    fk.is_disabled, fk.is_not_trusted, fk.is_not_for_replication,
    N'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' +
    QUOTENAME(t.name) + N' WITH CHECK CHECK CONSTRAINT ' +
    QUOTENAME(fk.name) + N';' AS ValidationCommand
FROM sys.foreign_keys AS fk
JOIN sys.tables AS t ON t.object_id = fk.parent_object_id
WHERE fk.is_not_trusted = 1 AND fk.is_disabled = 0
ORDER BY SchemaName, TableName, fk.name;
