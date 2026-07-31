/*
Title: Search Column Names
Purpose: Finds columns by partial name and reports their data types and properties.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @ColumnNamePattern nvarchar(128) = N'%Customer%';

SELECT
    SCHEMA_NAME(t.schema_id) AS SchemaName, t.name AS TableName,
    c.column_id, c.name AS ColumnName, ty.name AS DataType,
    c.max_length, c.precision, c.scale, c.is_nullable,
    c.is_identity, c.is_computed, dc.definition AS DefaultDefinition
FROM sys.columns AS c
JOIN sys.tables AS t ON t.object_id = c.object_id
JOIN sys.types AS ty ON ty.user_type_id = c.user_type_id
LEFT JOIN sys.default_constraints AS dc ON dc.object_id = c.default_object_id
WHERE c.name LIKE @ColumnNamePattern
ORDER BY SchemaName, TableName, c.column_id;
