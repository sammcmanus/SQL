/*
Title: TempDB Session Usage
Purpose: Ranks active sessions by current and cumulative tempdb allocation.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    s.session_id, s.login_name, s.host_name, s.program_name,
    (ssu.user_objects_alloc_page_count - ssu.user_objects_dealloc_page_count) * 8.0 / 1024
        AS UserObjectsMB,
    (ssu.internal_objects_alloc_page_count - ssu.internal_objects_dealloc_page_count) * 8.0 / 1024
        AS InternalObjectsMB,
    r.status, r.wait_type, r.blocking_session_id,
    txt.text AS BatchText
FROM sys.dm_db_session_space_usage AS ssu
JOIN sys.dm_exec_sessions AS s ON s.session_id = ssu.session_id
LEFT JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id
LEFT JOIN sys.dm_exec_connections AS c ON c.session_id = s.session_id
OUTER APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) AS txt
WHERE s.is_user_process = 1
ORDER BY (ssu.user_objects_alloc_page_count + ssu.internal_objects_alloc_page_count -
          ssu.user_objects_dealloc_page_count - ssu.internal_objects_dealloc_page_count) DESC;
