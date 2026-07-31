/*
Title: Cleanup SQL Agent History
Purpose: Previews and optionally removes SQL Agent history older than a retention date.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; deletion removes msdb job history

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @RetentionDays int = 60;
DECLARE @Execute bit = 0;
DECLARE @OldestDateToKeep datetime = DATEADD(DAY, -@RetentionDays, GETDATE());

SELECT
    COUNT(*) AS HistoryRowsToDelete,
    MIN(msdb.dbo.agent_datetime(run_date, run_time)) AS OldestHistory,
    MAX(msdb.dbo.agent_datetime(run_date, run_time)) AS NewestHistoryToDelete
FROM msdb.dbo.sysjobhistory
WHERE run_date > 0
  AND msdb.dbo.agent_datetime(run_date, run_time) < @OldestDateToKeep;

IF @Execute = 1
    EXEC msdb.dbo.sp_purge_jobhistory @oldest_date = @OldestDateToKeep;
