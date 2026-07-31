/*
Title: Disabled Constraints
Purpose: Lists disabled foreign-key and check constraints with enable-and-validate commands.
Compatibility: SQL Server 2016+
Safety: READ ONLY COMMAND GENERATOR; validation commands can fail on existing invalid data

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    N'FOREIGN KEY' AS ConstraintType,
    SCHEMA_NAME(t.schema_id) AS SchemaName, t.name AS TableName,
    fk.name AS ConstraintName,
    N'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' +
    QUOTENAME(t.name) + N' WITH CHECK CHECK CONSTRAINT ' +
    QUOTENAME(fk.name) + N';' AS EnableCommand
FROM sys.foreign_keys AS fk
JOIN sys.tables AS t ON t.object_id = fk.parent_object_id
WHERE fk.is_disabled = 1

UNION ALL

SELECT
    N'CHECK', SCHEMA_NAME(t.schema_id), t.name, cc.name,
    N'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' +
    QUOTENAME(t.name) + N' WITH CHECK CHECK CONSTRAINT ' +
    QUOTENAME(cc.name) + N';'
FROM sys.check_constraints AS cc
JOIN sys.tables AS t ON t.object_id = cc.parent_object_id
WHERE cc.is_disabled = 1
ORDER BY SchemaName, TableName, ConstraintName;
