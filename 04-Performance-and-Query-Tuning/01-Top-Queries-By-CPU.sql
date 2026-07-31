/*
Title: Top Queries by CPU
Purpose: Ranks cached query statements by cumulative and average worker time.
Compatibility: SQL Server 2016+
Safety: READ ONLY; plan cache statistics reset after restart or cache eviction

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @Top int = 50;

SELECT TOP (@Top)
    qs.execution_count,
    qs.total_worker_time / 1000.0 AS TotalCpuMs,
    qs.total_worker_time / NULLIF(qs.execution_count, 0) / 1000.0 AS AvgCpuMs,
    qs.total_elapsed_time / 1000.0 AS TotalElapsedMs,
    DB_NAME(st.dbid) AS DatabaseName,
    SUBSTRING(st.text, (qs.statement_start_offset / 2) + 1,
        ((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
          ELSE qs.statement_end_offset END - qs.statement_start_offset) / 2) + 1) AS StatementText,
    qp.query_plan
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
OUTER APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
ORDER BY qs.total_worker_time DESC;
