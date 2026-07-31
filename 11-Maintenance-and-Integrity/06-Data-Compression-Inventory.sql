/*
Title: Data Compression Inventory
Purpose: Reports current compression and space by table, index, and partition.
Compatibility: SQL Server 2016+
Safety: READ ONLY; compression availability and benefit vary by SQL Server edition and workload

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SCHEMA_NAME(o.schema_id) AS SchemaName, o.name AS TableName,
    i.name AS IndexName, p.partition_number,
    p.data_compression_desc,
    p.rows,
    SUM(a.total_pages) * 8.0 / 1024 AS ReservedMB,
    SUM(a.used_pages) * 8.0 / 1024 AS UsedMB
FROM sys.partitions AS p
JOIN sys.objects AS o ON o.object_id = p.object_id AND o.type = 'U'
JOIN sys.indexes AS i ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN sys.allocation_units AS a
  ON (a.type IN (1,3) AND a.container_id = p.hobt_id)
  OR (a.type = 2 AND a.container_id = p.partition_id)
GROUP BY o.schema_id, o.name, i.name, p.partition_number,
         p.data_compression_desc, p.rows
ORDER BY ReservedMB DESC;
