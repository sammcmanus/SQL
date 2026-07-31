/*
Title: Job Schedules
Purpose: Lists job schedule definitions and cached next-run dates.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    j.name AS JobName, j.enabled AS JobEnabled,
    s.name AS ScheduleName, s.enabled AS ScheduleEnabled,
    s.freq_type, s.freq_interval, s.freq_subday_type, s.freq_subday_interval,
    s.freq_relative_interval, s.freq_recurrence_factor,
    s.active_start_date, s.active_start_time,
    CASE WHEN js.next_run_date > 0
         THEN msdb.dbo.agent_datetime(js.next_run_date, js.next_run_time) END AS NextRunDateTime
FROM msdb.dbo.sysjobs AS j
JOIN msdb.dbo.sysjobschedules AS js ON js.job_id = j.job_id
JOIN msdb.dbo.sysschedules AS s ON s.schedule_id = js.schedule_id
ORDER BY j.name, s.name;
