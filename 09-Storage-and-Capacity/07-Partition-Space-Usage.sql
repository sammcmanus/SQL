/*
Title: Partition Space Usage
Purpose: Shows row and space distribution by table, index, and partition.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SCHEMA_NAME(o.schema_id) AS SchemaName, o.name AS TableName,
    i.name AS IndexName, p.partition_number, p.rows,
    fg.name AS FilegroupName,
    SUM(a.total_pages) * 8.0 / 1024 AS ReservedMB,
    SUM(a.used_pages) * 8.0 / 1024 AS UsedMB
FROM sys.partitions AS p
JOIN sys.objects AS o ON o.object_id = p.object_id AND o.type = 'U'
JOIN sys.indexes AS i ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN sys.allocation_units AS a
  ON (a.type IN (1,3) AND a.container_id = p.hobt_id)
  OR (a.type = 2 AND a.container_id = p.partition_id)
LEFT JOIN sys.data_spaces AS ds ON ds.data_space_id = i.data_space_id
LEFT JOIN sys.filegroups AS fg ON fg.data_space_id = ds.data_space_id
GROUP BY o.schema_id, o.name, i.name, p.partition_number, p.rows, fg.name
ORDER BY SchemaName, TableName, i.name, p.partition_number;
