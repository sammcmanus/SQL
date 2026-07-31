/*
Title: Create SQL Agent Job Template
Purpose: Builds and optionally executes a basic scheduled T-SQL job definition.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; execution creates a job and daily schedule in msdb

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @JobName sysname = N'DBA - Example Job';
DECLARE @DatabaseName sysname = N'master';
DECLARE @Command nvarchar(max) = N'SELECT @@SERVERNAME, GETDATE();';
DECLARE @DailyStartTime int = 10000; -- HHMMSS: 01:00:00
DECLARE @Execute bit = 0;

IF DB_ID(@DatabaseName) IS NULL THROW 50000, 'Database does not exist.', 1;
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @JobName)
    THROW 50000, 'A job with this name already exists.', 1;

SELECT @JobName AS JobName, @DatabaseName AS DatabaseName,
       @Command AS StepCommand, @DailyStartTime AS DailyStartTime,
       @Execute AS ExecuteEnabled;

IF @Execute = 1
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name = @JobName, @enabled = 1,
         @description = N'Created from the guarded DBA script template.';
    EXEC msdb.dbo.sp_add_jobstep @job_name = @JobName, @step_name = N'Execute T-SQL',
         @subsystem = N'TSQL', @database_name = @DatabaseName, @command = @Command;
    EXEC msdb.dbo.sp_add_schedule @schedule_name = @JobName,
         @freq_type = 4, @freq_interval = 1, @active_start_time = @DailyStartTime;
    EXEC msdb.dbo.sp_attach_schedule @job_name = @JobName, @schedule_name = @JobName;
    EXEC msdb.dbo.sp_add_jobserver @job_name = @JobName;
END;
