/*
Title: Duplicate Indexes
Purpose: Finds indexes with identical ordered key columns in the current database.
Compatibility: SQL Server 2016+
Safety: READ ONLY; compare included columns, filters, uniqueness, and workload before removal

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

WITH IndexColumns AS
(
    SELECT i.object_id, i.index_id, i.name, i.is_unique, i.has_filter, i.filter_definition,
        STUFF((
            SELECT N',' + QUOTENAME(c.name)
            FROM sys.index_columns AS ic2
            JOIN sys.columns AS c ON c.object_id = ic2.object_id AND c.column_id = ic2.column_id
            WHERE ic2.object_id = i.object_id AND ic2.index_id = i.index_id
              AND ic2.is_included_column = 0
            ORDER BY ic2.key_ordinal
            FOR XML PATH(''), TYPE).value('.', 'nvarchar(max)'), 1, 1, N'') AS KeyColumns,
        STUFF((
            SELECT N',' + QUOTENAME(c.name)
            FROM sys.index_columns AS ic2
            JOIN sys.columns AS c ON c.object_id = ic2.object_id AND c.column_id = ic2.column_id
            WHERE ic2.object_id = i.object_id AND ic2.index_id = i.index_id
              AND ic2.is_included_column = 1
            ORDER BY c.name
            FOR XML PATH(''), TYPE).value('.', 'nvarchar(max)'), 1, 1, N'') AS IncludedColumns
    FROM sys.indexes AS i
    WHERE i.index_id > 0 AND i.is_hypothetical = 0
)
SELECT
    OBJECT_SCHEMA_NAME(a.object_id) AS SchemaName,
    OBJECT_NAME(a.object_id) AS TableName,
    a.name AS IndexA, b.name AS IndexB,
    a.KeyColumns, a.IncludedColumns AS IndexAIncludes,
    b.IncludedColumns AS IndexBIncludes
FROM IndexColumns AS a
JOIN IndexColumns AS b
  ON b.object_id = a.object_id AND b.index_id > a.index_id
 AND ISNULL(b.KeyColumns, N'') = ISNULL(a.KeyColumns, N'')
ORDER BY SchemaName, TableName, IndexA;
