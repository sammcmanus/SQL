/*
Title: Largest Tables
Purpose: Ranks current-database tables by reserved space, used space, and row count.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

WITH TableSpace AS
(
    SELECT
        p.object_id,
        SUM(CASE WHEN p.index_id IN (0,1) THEN p.rows ELSE 0 END) AS RowCount,
        SUM(a.total_pages) * 8.0 / 1024 AS ReservedMB,
        SUM(a.used_pages) * 8.0 / 1024 AS UsedMB,
        SUM(a.data_pages) * 8.0 / 1024 AS DataMB
    FROM sys.partitions AS p
    JOIN sys.allocation_units AS a
      ON (a.type IN (1,3) AND a.container_id = p.hobt_id)
      OR (a.type = 2 AND a.container_id = p.partition_id)
    GROUP BY p.object_id
)
SELECT TOP (100)
    SCHEMA_NAME(o.schema_id) AS SchemaName, o.name AS TableName,
    ts.RowCount, ts.ReservedMB, ts.UsedMB, ts.DataMB,
    ts.ReservedMB - ts.UsedMB AS UnusedMB
FROM TableSpace AS ts
JOIN sys.objects AS o ON o.object_id = ts.object_id AND o.type = 'U'
ORDER BY ts.ReservedMB DESC;
