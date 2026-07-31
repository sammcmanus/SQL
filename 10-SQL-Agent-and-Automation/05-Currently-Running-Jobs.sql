/*
Title: Currently Running Jobs
Purpose: Shows active job executions, current steps, start times, and elapsed minutes.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

WITH CurrentSession AS
(
    SELECT MAX(session_id) AS session_id FROM msdb.dbo.syssessions
)
SELECT
    j.name AS JobName,
    ja.start_execution_date,
    DATEDIFF(MINUTE, ja.start_execution_date, GETDATE()) AS ElapsedMinutes,
    ja.last_executed_step_id,
    js.step_name AS LastExecutedStep,
    ja.stop_execution_date, ja.job_history_id
FROM msdb.dbo.sysjobactivity AS ja
JOIN CurrentSession AS cs ON cs.session_id = ja.session_id
JOIN msdb.dbo.sysjobs AS j ON j.job_id = ja.job_id
LEFT JOIN msdb.dbo.sysjobsteps AS js
  ON js.job_id = ja.job_id AND js.step_id = ja.last_executed_step_id
WHERE ja.start_execution_date IS NOT NULL
  AND ja.stop_execution_date IS NULL
ORDER BY ja.start_execution_date;
