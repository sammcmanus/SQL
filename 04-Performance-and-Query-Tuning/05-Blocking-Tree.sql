/*
Title: Blocking Tree
Purpose: Builds a recursive view of current blocking chains.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

WITH Requests AS
(
    SELECT session_id, blocking_session_id, wait_type, wait_time, wait_resource
    FROM sys.dm_exec_requests
    WHERE session_id <> @@SPID
),
BlockingTree AS
(
    SELECT r.session_id, r.blocking_session_id, 0 AS BlockingLevel,
           CAST(CONVERT(varchar(12), r.session_id) AS varchar(8000)) AS BlockingPath
    FROM Requests AS r
    WHERE r.blocking_session_id = 0
      AND EXISTS (SELECT 1 FROM Requests AS c WHERE c.blocking_session_id = r.session_id)

    UNION ALL

    SELECT c.session_id, c.blocking_session_id, p.BlockingLevel + 1,
           CAST(p.BlockingPath + ' -> ' + CONVERT(varchar(12), c.session_id) AS varchar(8000))
    FROM Requests AS c
    JOIN BlockingTree AS p ON c.blocking_session_id = p.session_id
)
SELECT
    bt.BlockingLevel, bt.BlockingPath, bt.session_id, bt.blocking_session_id,
    s.login_name, s.host_name, r.wait_type, r.wait_time, r.wait_resource,
    txt.text AS BatchText
FROM BlockingTree AS bt
JOIN sys.dm_exec_sessions AS s ON s.session_id = bt.session_id
LEFT JOIN sys.dm_exec_requests AS r ON r.session_id = bt.session_id
LEFT JOIN sys.dm_exec_connections AS c ON c.session_id = bt.session_id
OUTER APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) AS txt
ORDER BY bt.BlockingPath
OPTION (MAXRECURSION 100);
