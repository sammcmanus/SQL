/*
Title: Stale Statistics
Purpose: Shows statistics age and modification counts in the current database.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @MinimumRows bigint = 1000;

SELECT
    SCHEMA_NAME(o.schema_id) AS SchemaName, o.name AS TableName,
    s.name AS StatisticsName, s.auto_created, s.user_created, s.no_recompute,
    sp.last_updated, sp.rows, sp.rows_sampled, sp.modification_counter,
    CAST(100.0 * sp.modification_counter / NULLIF(sp.rows, 0) AS decimal(6,2))
        AS ModificationPercent
FROM sys.stats AS s
JOIN sys.objects AS o ON o.object_id = s.object_id AND o.type = 'U'
OUTER APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
WHERE sp.rows >= @MinimumRows
ORDER BY sp.modification_counter DESC, SchemaName, TableName;
