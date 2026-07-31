/*
Title: Heap Forwarded Records
Purpose: Finds heaps with forwarded records and their scan activity.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SCHEMA_NAME(o.schema_id) AS SchemaName, o.name AS TableName,
    ips.partition_number, ips.page_count, ips.record_count,
    ips.forwarded_record_count,
    COALESCE(us.user_scans, 0) AS UserScans,
    COALESCE(us.user_updates, 0) AS UserUpdates
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, 0, NULL, 'DETAILED') AS ips
JOIN sys.objects AS o ON o.object_id = ips.object_id AND o.type = 'U'
LEFT JOIN sys.dm_db_index_usage_stats AS us
  ON us.database_id = DB_ID() AND us.object_id = ips.object_id AND us.index_id = 0
WHERE ips.forwarded_record_count > 0
ORDER BY ips.forwarded_record_count DESC;
