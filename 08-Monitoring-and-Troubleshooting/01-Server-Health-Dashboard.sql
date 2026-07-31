/*
Title: Server Health Dashboard
Purpose: Returns a compact snapshot of uptime, active work, blocking, waits, memory, and disk latency.
Compatibility: SQL Server 2016+
Safety: READ ONLY; requires VIEW SERVER STATE

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    @@SERVERNAME AS ServerName,
    osi.sqlserver_start_time,
    DATEDIFF(MINUTE, osi.sqlserver_start_time, GETDATE()) AS UptimeMinutes,
    osi.cpu_count, osi.physical_memory_kb / 1024 AS PhysicalMemoryMB,
    (SELECT COUNT(*) FROM sys.dm_exec_sessions WHERE is_user_process = 1) AS UserSessions,
    (SELECT COUNT(*) FROM sys.dm_exec_requests WHERE session_id <> @@SPID) AS ActiveRequests,
    (SELECT COUNT(*) FROM sys.dm_exec_requests WHERE blocking_session_id > 0) AS BlockedRequests,
    (SELECT COUNT(*) FROM sys.dm_exec_query_memory_grants WHERE grant_time IS NULL) AS WaitingMemoryGrants,
    (SELECT SUM(pending_disk_io_count) FROM sys.dm_os_schedulers) AS PendingSchedulerIO
FROM sys.dm_os_sys_info AS osi;

SELECT TOP (10)
    wait_type, wait_time_ms, signal_wait_time_ms, waiting_tasks_count
FROM sys.dm_os_wait_stats
ORDER BY wait_time_ms DESC;
