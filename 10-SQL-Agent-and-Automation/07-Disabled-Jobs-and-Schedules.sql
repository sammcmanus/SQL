/*
Title: Disabled Jobs and Schedules
Purpose: Finds jobs or attached schedules that are disabled.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    j.name AS JobName, j.enabled AS JobEnabled,
    s.name AS ScheduleName, s.enabled AS ScheduleEnabled,
    CASE WHEN j.enabled = 0 THEN N'Job disabled'
         WHEN s.enabled = 0 THEN N'Schedule disabled'
         ELSE N'Enabled' END AS Assessment
FROM msdb.dbo.sysjobs AS j
LEFT JOIN msdb.dbo.sysjobschedules AS js ON js.job_id = j.job_id
LEFT JOIN msdb.dbo.sysschedules AS s ON s.schedule_id = js.schedule_id
WHERE j.enabled = 0 OR s.enabled = 0
ORDER BY j.name, s.name;
