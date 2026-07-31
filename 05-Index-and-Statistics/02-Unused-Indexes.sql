/*
Title: Unused Indexes
Purpose: Identifies current-database nonclustered indexes with writes but no recorded reads.
Compatibility: SQL Server 2016+
Safety: READ ONLY; usage counters reset after restart and indexes may support rare or seasonal work

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SCHEMA_NAME(o.schema_id) AS SchemaName, o.name AS TableName,
    i.name AS IndexName, i.index_id,
    COALESCE(us.user_seeks, 0) AS UserSeeks,
    COALESCE(us.user_scans, 0) AS UserScans,
    COALESCE(us.user_lookups, 0) AS UserLookups,
    COALESCE(us.user_updates, 0) AS UserUpdates,
    p.row_count AS RowCount
FROM sys.indexes AS i
JOIN sys.objects AS o ON o.object_id = i.object_id AND o.type = 'U'
LEFT JOIN sys.dm_db_index_usage_stats AS us
  ON us.database_id = DB_ID() AND us.object_id = i.object_id AND us.index_id = i.index_id
LEFT JOIN
(
    SELECT object_id, index_id, SUM(rows) AS row_count
    FROM sys.partitions GROUP BY object_id, index_id
) AS p ON p.object_id = i.object_id AND p.index_id = i.index_id
WHERE i.index_id > 1
  AND i.is_primary_key = 0 AND i.is_unique_constraint = 0
  AND COALESCE(us.user_seeks, 0) + COALESCE(us.user_scans, 0) + COALESCE(us.user_lookups, 0) = 0
ORDER BY UserUpdates DESC, RowCount DESC;
