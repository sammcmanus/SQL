/*
Title: Missing Index Recommendations
Purpose: Ranks current-database missing-index suggestions by estimated improvement.
Compatibility: SQL Server 2016+
Safety: READ ONLY; DMV suggestions are volatile and must be reviewed for overlap and write cost

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @MinimumUserSeeks bigint = 10;

SELECT TOP (100)
    DB_NAME(mid.database_id) AS DatabaseName,
    OBJECT_SCHEMA_NAME(mid.object_id, mid.database_id) AS SchemaName,
    OBJECT_NAME(mid.object_id, mid.database_id) AS TableName,
    migs.user_seeks, migs.user_scans,
    CAST(migs.avg_total_user_cost * migs.avg_user_impact *
         (migs.user_seeks + migs.user_scans) AS decimal(19,2)) AS ImprovementScore,
    mid.equality_columns, mid.inequality_columns, mid.included_columns,
    migs.last_user_seek
FROM sys.dm_db_missing_index_group_stats AS migs
JOIN sys.dm_db_missing_index_groups AS mig ON mig.index_group_handle = migs.group_handle
JOIN sys.dm_db_missing_index_details AS mid ON mid.index_handle = mig.index_handle
WHERE mid.database_id = DB_ID()
  AND migs.user_seeks >= @MinimumUserSeeks
ORDER BY ImprovementScore DESC;
