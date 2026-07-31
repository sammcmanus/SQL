/*
Title: Active Memory Grants
Purpose: Finds active and waiting query memory grants, including plan and SQL text.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    mg.session_id, mg.request_id, mg.dop,
    mg.request_time, mg.grant_time,
    mg.requested_memory_kb, mg.granted_memory_kb,
    mg.required_memory_kb, mg.used_memory_kb, mg.max_used_memory_kb,
    mg.queue_id, mg.wait_order, mg.is_next_candidate,
    txt.text AS BatchText, plan.query_plan
FROM sys.dm_exec_query_memory_grants AS mg
OUTER APPLY sys.dm_exec_sql_text(mg.sql_handle) AS txt
OUTER APPLY sys.dm_exec_query_plan(mg.plan_handle) AS plan
ORDER BY mg.requested_memory_kb DESC;
