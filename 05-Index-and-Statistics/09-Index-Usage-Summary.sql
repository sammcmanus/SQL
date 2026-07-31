/*
Title: Index Usage Summary
Purpose: Combines read/write usage with row and size data for all current-database indexes.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

WITH SizeData AS
(
    SELECT object_id, index_id,
        SUM(row_count) AS RowCount,
        SUM(used_page_count) * 8.0 / 1024 AS UsedMB
    FROM sys.dm_db_partition_stats
    GROUP BY object_id, index_id
)
SELECT
    SCHEMA_NAME(o.schema_id) AS SchemaName, o.name AS TableName,
    i.name AS IndexName, i.type_desc, s.RowCount, s.UsedMB,
    COALESCE(u.user_seeks, 0) AS Seeks, COALESCE(u.user_scans, 0) AS Scans,
    COALESCE(u.user_lookups, 0) AS Lookups, COALESCE(u.user_updates, 0) AS Updates,
    u.last_user_seek, u.last_user_scan, u.last_user_update
FROM sys.indexes AS i
JOIN sys.objects AS o ON o.object_id = i.object_id AND o.type = 'U'
LEFT JOIN SizeData AS s ON s.object_id = i.object_id AND s.index_id = i.index_id
LEFT JOIN sys.dm_db_index_usage_stats AS u
  ON u.database_id = DB_ID() AND u.object_id = i.object_id AND u.index_id = i.index_id
ORDER BY s.UsedMB DESC, SchemaName, TableName, i.index_id;
