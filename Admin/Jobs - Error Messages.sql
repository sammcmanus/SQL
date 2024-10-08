USE [MSDB]
GO

DECLARE @JobName AS VARCHAR(MAX) = '[JOB NAME]'

DECLARE @job_id UNIQUEIDENTIFIER

SELECT @job_id = job_id FROM dbo.sysjobs WHERE [name] = @JobName
SELECT 'Step ' + CAST(JH.step_id AS VARCHAR(3)) + ' of ' + (SELECT CAST(COUNT(*) AS VARCHAR(5)) FROM dbo.sysjobsteps WHERE job_id = @job_id) AS StepFailed,
 CAST(RIGHT(JH.run_date,2) AS CHAR(2)) + '/' + CAST(SUBSTRING(CAST(JH.run_date AS CHAR(8)),5,2) AS CHAR(2)) + '/' + CAST(LEFT(JH.run_date,4) AS CHAR(4)) AS DateRun,
 LEFT(RIGHT('0' + CAST(JH.run_time AS VARCHAR(6)),6),2) + ':' + SUBSTRING(RIGHT('0' + CAST(JH.run_time AS VARCHAR(6)),6),3,2) + ':' + LEFT(RIGHT('0' + CAST(JH.run_time AS VARCHAR(6)),6),2) AS TimeRun,
 JS.step_name, 
 JH.run_duration, 
 CASE
 WHEN JSL.[log] IS NULL THEN JH.[Message]
 ELSE JSL.[log]
 END AS LogOutput
FROM dbo.sysjobsteps JS INNER JOIN dbo.sysjobhistory JH 
 ON JS.job_id = JH.job_id AND JS.step_id = JH.step_id 
 LEFT OUTER JOIN dbo.sysjobstepslogs JSL
 ON JS.step_uid = JSL.step_uid
WHERE INSTANCE_ID >
 (SELECT MIN(INSTANCE_ID)
 FROM (
 SELECT top (2) INSTANCE_ID, job_id
 FROM dbo.sysjobhistory
 WHERE job_id = @job_id
 AND STEP_ID = 0
 ORDER BY INSTANCE_ID desc
 ) A
 )
 AND JS.step_id <> 0 
 AND JH.job_id = @job_id
 AND JH.run_status = 0
ORDER BY JS.step_id ASC