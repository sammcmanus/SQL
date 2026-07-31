/*
Title: Implicit Conversion Plans
Purpose: Finds cached execution plans containing conversion warnings.
Compatibility: SQL Server 2016+
Safety: READ ONLY; XML search can be expensive on a very large plan cache

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @Top int = 50;

WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
SELECT TOP (@Top)
    qs.execution_count, qs.last_execution_time,
    qs.total_worker_time / 1000.0 AS TotalCpuMs,
    DB_NAME(st.dbid) AS DatabaseName,
    st.text AS BatchText,
    qp.query_plan
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE qp.query_plan.exist('//Warnings/PlanAffectingConvert') = 1
ORDER BY qs.total_worker_time DESC;
