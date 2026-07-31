/*
Title: Job Step Inventory
Purpose: Reviews job-step subsystems, databases, retry settings, proxies, and commands.
Compatibility: SQL Server 2016+
Safety: READ ONLY; command text may contain operational paths or connection details

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    j.name AS JobName, j.enabled AS JobEnabled,
    s.step_id, s.step_name, s.subsystem, s.database_name,
    s.retry_attempts, s.retry_interval,
    p.name AS ProxyName,
    s.on_success_action, s.on_success_step_id,
    s.on_fail_action, s.on_fail_step_id,
    s.command
FROM msdb.dbo.sysjobsteps AS s
JOIN msdb.dbo.sysjobs AS j ON j.job_id = s.job_id
LEFT JOIN msdb.dbo.sysproxies AS p ON p.proxy_id = s.proxy_id
ORDER BY j.name, s.step_id;
