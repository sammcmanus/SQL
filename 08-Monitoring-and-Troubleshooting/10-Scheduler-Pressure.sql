/*
Title: Scheduler Pressure
Purpose: Reviews runnable queues, pending I/O, load, and worker counts by visible scheduler.
Compatibility: SQL Server 2016+
Safety: READ ONLY; interpret sustained values rather than a single snapshot

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    scheduler_id, cpu_id, status, is_online,
    current_tasks_count, runnable_tasks_count,
    current_workers_count, active_workers_count,
    work_queue_count, pending_disk_io_count,
    load_factor, yield_count, last_timer_activity
FROM sys.dm_os_schedulers
WHERE status = N'VISIBLE ONLINE'
ORDER BY runnable_tasks_count DESC, scheduler_id;
