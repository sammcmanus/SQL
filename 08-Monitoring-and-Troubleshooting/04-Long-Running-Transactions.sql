/*
Title: Long Running Transactions
Purpose: Finds active transactions with age, session details, waits, and SQL text.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @MinimumAgeMinutes int = 5;

SELECT
    at.transaction_id, at.name AS TransactionName,
    at.transaction_begin_time,
    DATEDIFF(MINUTE, at.transaction_begin_time, GETDATE()) AS AgeMinutes,
    st.session_id, s.login_name, s.host_name, s.program_name,
    r.status, r.wait_type, r.blocking_session_id,
    DB_NAME(dt.database_id) AS DatabaseName,
    dt.database_transaction_log_bytes_used,
    txt.text AS BatchText
FROM sys.dm_tran_active_transactions AS at
JOIN sys.dm_tran_session_transactions AS st ON st.transaction_id = at.transaction_id
JOIN sys.dm_exec_sessions AS s ON s.session_id = st.session_id
LEFT JOIN sys.dm_exec_requests AS r ON r.session_id = st.session_id
LEFT JOIN sys.dm_tran_database_transactions AS dt ON dt.transaction_id = at.transaction_id
LEFT JOIN sys.dm_exec_connections AS c ON c.session_id = st.session_id
OUTER APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) AS txt
WHERE at.transaction_begin_time < DATEADD(MINUTE, -@MinimumAgeMinutes, GETDATE())
ORDER BY at.transaction_begin_time;
