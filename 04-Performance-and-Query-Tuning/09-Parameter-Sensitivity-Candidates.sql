/*
Title: Parameter Sensitivity Candidates
Purpose: Finds query hashes with high variance between minimum and maximum elapsed time.
Compatibility: SQL Server 2016+
Safety: READ ONLY; results are candidates for investigation, not proof of parameter sniffing

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @MinimumExecutions bigint = 10;
DECLARE @MinimumVariance decimal(18,2) = 10.0;

SELECT TOP (100)
    query_hash,
    SUM(execution_count) AS Executions,
    MIN(min_elapsed_time) / 1000.0 AS MinElapsedMs,
    MAX(max_elapsed_time) / 1000.0 AS MaxElapsedMs,
    CAST(MAX(max_elapsed_time) * 1.0 / NULLIF(MIN(NULLIF(min_elapsed_time, 0)), 0)
         AS decimal(18,2)) AS MaxToMinRatio,
    MIN(last_execution_time) AS FirstCachedExecution,
    MAX(last_execution_time) AS LastExecution
FROM sys.dm_exec_query_stats
GROUP BY query_hash
HAVING SUM(execution_count) >= @MinimumExecutions
   AND MAX(max_elapsed_time) * 1.0 /
       NULLIF(MIN(NULLIF(min_elapsed_time, 0)), 0) >= @MinimumVariance
ORDER BY MaxToMinRatio DESC;
