/*
Title: Top Queries by Duration
Purpose: Ranks cached statements by average elapsed time.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @Top int = 50;
DECLARE @MinimumExecutions bigint = 5;

SELECT TOP (@Top)
    qs.execution_count,
    qs.total_elapsed_time / 1000.0 AS TotalElapsedMs,
    qs.total_elapsed_time / NULLIF(qs.execution_count, 0) / 1000.0 AS AvgElapsedMs,
    qs.last_execution_time,
    DB_NAME(st.dbid) AS DatabaseName,
    SUBSTRING(st.text, (qs.statement_start_offset / 2) + 1,
        ((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
          ELSE qs.statement_end_offset END - qs.statement_start_offset) / 2) + 1) AS StatementText
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
WHERE qs.execution_count >= @MinimumExecutions
ORDER BY AvgElapsedMs DESC;
