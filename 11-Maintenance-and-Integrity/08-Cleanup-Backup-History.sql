/*
Title: Cleanup Backup History
Purpose: Previews backup-history volume and optionally deletes records older than a retention date.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; deletion removes msdb history, not backup files

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @RetentionDays int = 90;
DECLARE @Execute bit = 0;
DECLARE @OldestDateToKeep datetime = DATEADD(DAY, -@RetentionDays, GETDATE());

SELECT
    @OldestDateToKeep AS OldestDateToKeep,
    COUNT(*) AS BackupSetsToDelete,
    MIN(backup_finish_date) AS OldestBackup,
    MAX(backup_finish_date) AS NewestBackupToDelete
FROM msdb.dbo.backupset
WHERE backup_finish_date < @OldestDateToKeep;

IF @Execute = 1
    EXEC msdb.dbo.sp_delete_backuphistory @oldest_date = @OldestDateToKeep;
