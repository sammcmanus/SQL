/*
Title: Failed Jobs
Purpose: Shows failed SQL Agent executions and messages in a configurable date window.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DaysBack int = 7;

SELECT
    j.name AS JobName,
    msdb.dbo.agent_datetime(h.run_date, h.run_time) AS RunDateTime,
    h.run_duration, h.sql_message_id, h.sql_severity,
    h.message, h.server
FROM msdb.dbo.sysjobhistory AS h
JOIN msdb.dbo.sysjobs AS j ON j.job_id = h.job_id
WHERE h.step_id = 0
  AND h.run_status = 0
  AND msdb.dbo.agent_datetime(h.run_date, h.run_time) >= DATEADD(DAY, -@DaysBack, GETDATE())
ORDER BY RunDateTime DESC;
