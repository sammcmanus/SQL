/*
Title: Currently Running Requests
Purpose: Shows active requests with waits, blockers, progress, SQL text, and plans.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    r.session_id, s.login_name, s.host_name, s.program_name,
    DB_NAME(r.database_id) AS DatabaseName, r.status, r.command,
    r.start_time, r.cpu_time, r.total_elapsed_time, r.reads, r.writes,
    r.logical_reads, r.wait_type, r.wait_time, r.wait_resource,
    r.blocking_session_id, r.percent_complete,
    SUBSTRING(t.text, (r.statement_start_offset / 2) + 1,
        ((CASE r.statement_end_offset WHEN -1 THEN DATALENGTH(t.text)
          ELSE r.statement_end_offset END - r.statement_start_offset) / 2) + 1) AS StatementText,
    p.query_plan
FROM sys.dm_exec_requests AS r
JOIN sys.dm_exec_sessions AS s ON s.session_id = r.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
OUTER APPLY sys.dm_exec_query_plan(r.plan_handle) AS p
WHERE r.session_id <> @@SPID
ORDER BY r.total_elapsed_time DESC;
