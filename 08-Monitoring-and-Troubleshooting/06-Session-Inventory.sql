/*
Title: Session Inventory
Purpose: Inventories user sessions, connection details, open transactions, and latest SQL text.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    s.session_id, s.status, s.login_name, s.original_login_name,
    s.host_name, s.program_name, s.client_interface_name,
    s.login_time, s.last_request_start_time, s.last_request_end_time,
    s.open_transaction_count, s.cpu_time, s.memory_usage,
    s.reads, s.writes, s.logical_reads, s.row_count,
    c.client_net_address, c.net_transport, c.auth_scheme, c.encrypt_option,
    txt.text AS MostRecentSqlText
FROM sys.dm_exec_sessions AS s
LEFT JOIN sys.dm_exec_connections AS c ON c.session_id = s.session_id
OUTER APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) AS txt
WHERE s.is_user_process = 1
ORDER BY s.session_id;
