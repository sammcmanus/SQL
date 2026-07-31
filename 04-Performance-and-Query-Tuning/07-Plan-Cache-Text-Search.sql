/*
Title: Plan Cache Text Search
Purpose: Finds cached plans whose SQL text contains a supplied search term.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @SearchText nvarchar(4000) = N'YourTableName';

SELECT TOP (100)
    cp.usecounts, cp.size_in_bytes / 1024 AS PlanSizeKB,
    cp.cacheobjtype, cp.objtype, qs.last_execution_time,
    DB_NAME(st.dbid) AS DatabaseName, st.text AS BatchText,
    qp.query_plan
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st
OUTER APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
LEFT JOIN sys.dm_exec_query_stats AS qs ON qs.plan_handle = cp.plan_handle
WHERE st.text LIKE N'%' + @SearchText + N'%'
ORDER BY cp.usecounts DESC;
