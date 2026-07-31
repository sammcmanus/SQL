/*
Title: Instance Capacity Summary
Purpose: Reports CPU, memory, worker, scheduler, and virtualization capacity.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    cpu_count, hyperthread_ratio, scheduler_count, max_workers_count,
    physical_memory_kb / 1024 AS PhysicalMemoryMB,
    committed_kb / 1024 AS SqlCommittedMemoryMB,
    committed_target_kb / 1024 AS SqlTargetMemoryMB,
    sqlserver_start_time, virtual_machine_type_desc
FROM sys.dm_os_sys_info;

SELECT COUNT(*) AS OnlineVisibleSchedulers
FROM sys.dm_os_schedulers
WHERE status = N'VISIBLE ONLINE';
