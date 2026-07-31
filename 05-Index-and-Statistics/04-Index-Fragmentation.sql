/*
Title: Index Fragmentation
Purpose: Reports fragmentation and page counts for indexes in the current database.
Compatibility: SQL Server 2016+
Safety: READ ONLY; LIMITED mode minimizes scanning overhead

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @MinimumPageCount bigint = 1000;
DECLARE @MinimumFragmentationPercent decimal(5,2) = 10.0;

SELECT
    OBJECT_SCHEMA_NAME(ips.object_id) AS SchemaName,
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName, ips.index_type_desc,
    ips.partition_number, ips.page_count,
    CAST(ips.avg_fragmentation_in_percent AS decimal(6,2)) AS FragmentationPercent,
    ips.fragment_count, ips.avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
JOIN sys.indexes AS i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
WHERE ips.page_count >= @MinimumPageCount
  AND ips.avg_fragmentation_in_percent >= @MinimumFragmentationPercent
ORDER BY ips.avg_fragmentation_in_percent DESC, ips.page_count DESC;
