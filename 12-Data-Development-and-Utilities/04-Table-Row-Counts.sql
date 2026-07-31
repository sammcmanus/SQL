/*
Title: Table Row Counts
Purpose: Returns fast metadata-based row counts for every user table.
Compatibility: SQL Server 2016+
Safety: READ ONLY; counts reflect metadata and can differ during active transactions

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SCHEMA_NAME(t.schema_id) AS SchemaName, t.name AS TableName,
    SUM(p.rows) AS RowCount
FROM sys.tables AS t
JOIN sys.partitions AS p ON p.object_id = t.object_id AND p.index_id IN (0,1)
WHERE t.is_ms_shipped = 0
GROUP BY t.schema_id, t.name
ORDER BY RowCount DESC, SchemaName, TableName;
