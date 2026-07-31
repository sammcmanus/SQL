/*
Title: SQL Agent Job Inventory
Purpose: Inventories jobs, owners, categories, status, notifications, and last outcome.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    j.job_id, j.name AS JobName, j.enabled,
    SUSER_SNAME(j.owner_sid) AS OwnerName,
    c.name AS CategoryName, j.description,
    j.notify_level_email, j.notify_email_operator_id,
    CASE h.run_status WHEN 0 THEN N'Failed' WHEN 1 THEN N'Succeeded'
         WHEN 2 THEN N'Retry' WHEN 3 THEN N'Canceled' WHEN 4 THEN N'In progress'
    END AS LastRunStatus,
    msdb.dbo.agent_datetime(h.run_date, h.run_time) AS LastRunDateTime
FROM msdb.dbo.sysjobs AS j
LEFT JOIN msdb.dbo.syscategories AS c ON c.category_id = j.category_id
OUTER APPLY
(
    SELECT TOP (1) run_status, run_date, run_time
    FROM msdb.dbo.sysjobhistory
    WHERE job_id = j.job_id AND step_id = 0
    ORDER BY instance_id DESC
) AS h
ORDER BY j.name;
