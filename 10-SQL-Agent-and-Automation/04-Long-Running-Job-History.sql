/*
Title: Long Running Job History
Purpose: Finds completed job executions exceeding a configurable duration.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @MinimumDurationMinutes int = 30;
DECLARE @DaysBack int = 30;

SELECT
    j.name AS JobName,
    msdb.dbo.agent_datetime(h.run_date, h.run_time) AS RunDateTime,
    h.run_status,
    (h.run_duration / 10000) * 3600 +
    ((h.run_duration % 10000) / 100) * 60 +
    (h.run_duration % 100) AS DurationSeconds,
    h.message
FROM msdb.dbo.sysjobhistory AS h
JOIN msdb.dbo.sysjobs AS j ON j.job_id = h.job_id
WHERE h.step_id = 0
  AND (h.run_duration / 10000) * 3600 +
      ((h.run_duration % 10000) / 100) * 60 +
      (h.run_duration % 100) >= @MinimumDurationMinutes * 60
  AND msdb.dbo.agent_datetime(h.run_date, h.run_time) >= DATEADD(DAY, -@DaysBack, GETDATE())
ORDER BY DurationSeconds DESC;
