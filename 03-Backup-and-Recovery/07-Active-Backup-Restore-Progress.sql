/*
Title: Active Backup and Restore Progress
Purpose: Monitors percentage and estimated completion for active backup or restore requests.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    r.session_id, r.command, DB_NAME(r.database_id) AS DatabaseName,
    r.status, r.percent_complete, r.start_time,
    r.total_elapsed_time / 1000 AS ElapsedSeconds,
    r.estimated_completion_time / 1000 AS EstimatedRemainingSeconds,
    DATEADD(MILLISECOND, r.estimated_completion_time, GETDATE()) AS EstimatedCompletionTime,
    t.text AS CommandText
FROM sys.dm_exec_requests AS r
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE r.command LIKE N'BACKUP%' OR r.command LIKE N'RESTORE%'
ORDER BY r.start_time;
