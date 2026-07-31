/*
Title: Lock Inventory
Purpose: Shows granted and waiting locks with associated sessions and request details.
Compatibility: SQL Server 2016+
Safety: READ ONLY; large busy systems can return many rows

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    l.request_session_id AS SessionId,
    DB_NAME(l.resource_database_id) AS DatabaseName,
    l.resource_type, l.resource_description,
    l.request_mode, l.request_type, l.request_status,
    r.blocking_session_id, r.wait_type, r.wait_time,
    s.login_name, s.host_name, s.program_name,
    txt.text AS BatchText
FROM sys.dm_tran_locks AS l
LEFT JOIN sys.dm_exec_requests AS r ON r.session_id = l.request_session_id
LEFT JOIN sys.dm_exec_sessions AS s ON s.session_id = l.request_session_id
LEFT JOIN sys.dm_exec_connections AS c ON c.session_id = l.request_session_id
OUTER APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) AS txt
WHERE l.request_session_id <> @@SPID
ORDER BY l.request_status DESC, l.request_session_id, l.resource_type;
