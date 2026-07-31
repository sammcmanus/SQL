/*
Title: Object Dependencies
Purpose: Reports objects that reference or are referenced by a selected current-database object.
Compatibility: SQL Server 2016+
Safety: READ ONLY; dynamic SQL and cross-database references may not be discoverable

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @ObjectName nvarchar(776) = N'dbo.YourObject';
DECLARE @ObjectId int = OBJECT_ID(@ObjectName);

IF @ObjectId IS NULL THROW 50000, 'Object does not exist in the current database.', 1;

SELECT
    N'REFERENCES' AS Direction,
    OBJECT_SCHEMA_NAME(@ObjectId) AS SourceSchema,
    OBJECT_NAME(@ObjectId) AS SourceObject,
    referenced_database_name AS TargetDatabase,
    referenced_schema_name AS TargetSchema,
    referenced_entity_name AS TargetObject,
    referenced_class_desc
FROM sys.sql_expression_dependencies
WHERE referencing_id = @ObjectId

UNION ALL

SELECT
    N'REFERENCED BY',
    OBJECT_SCHEMA_NAME(referencing_id),
    OBJECT_NAME(referencing_id),
    DB_NAME(), OBJECT_SCHEMA_NAME(@ObjectId), OBJECT_NAME(@ObjectId),
    referenced_class_desc
FROM sys.sql_expression_dependencies
WHERE referenced_id = @ObjectId
ORDER BY Direction, SourceSchema, SourceObject;
