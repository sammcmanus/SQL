/*
Title: Wait Statistics
Purpose: Summarizes instance wait statistics with common benign waits filtered out.
Compatibility: SQL Server 2016+
Safety: READ ONLY; cumulative since startup or last manual clear

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

WITH Waits AS
(
    SELECT wait_type, waiting_tasks_count, wait_time_ms,
           signal_wait_time_ms, wait_time_ms - signal_wait_time_ms AS ResourceWaitMs
    FROM sys.dm_os_wait_stats
    WHERE wait_type NOT IN
    (
        N'BROKER_EVENTHANDLER', N'BROKER_RECEIVE_WAITFOR', N'BROKER_TASK_STOP',
        N'CLR_AUTO_EVENT', N'CLR_MANUAL_EVENT', N'DBMIRROR_EVENTS_QUEUE',
        N'DBMIRRORING_CMD', N'DIRTY_PAGE_POLL', N'DISPATCHER_QUEUE_SEMAPHORE',
        N'FT_IFTS_SCHEDULER_IDLE_WAIT', N'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
        N'LAZYWRITER_SLEEP', N'LOGMGR_QUEUE', N'ONDEMAND_TASK_QUEUE',
        N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP', N'REQUEST_FOR_DEADLOCK_SEARCH',
        N'RESOURCE_QUEUE', N'SERVER_IDLE_CHECK', N'SLEEP_BPOOL_FLUSH',
        N'SLEEP_DBSTARTUP', N'SLEEP_SYSTEMTASK', N'SQLTRACE_BUFFER_FLUSH',
        N'WAITFOR', N'XE_DISPATCHER_WAIT', N'XE_TIMER_EVENT'
    )
)
SELECT TOP (50)
    wait_type, waiting_tasks_count, wait_time_ms, ResourceWaitMs,
    signal_wait_time_ms,
    CAST(100.0 * wait_time_ms / NULLIF(SUM(wait_time_ms) OVER (), 0)
         AS decimal(6,2)) AS PercentOfFilteredWaits
FROM Waits
WHERE wait_time_ms > 0
ORDER BY wait_time_ms DESC;
