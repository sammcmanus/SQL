/*
Title: Restore History
Purpose: Shows recent restores, source backup dates, destinations, and media paths.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DaysBack int = 90;

SELECT
    rh.destination_database_name, rh.restore_date, rh.user_name,
    rh.restore_type, rh.replace, rh.recovery, rh.restart,
    bs.database_name AS SourceDatabaseName,
    bs.backup_start_date, bs.backup_finish_date,
    bmf.physical_device_name
FROM msdb.dbo.restorehistory AS rh
LEFT JOIN msdb.dbo.backupset AS bs ON bs.backup_set_id = rh.backup_set_id
LEFT JOIN msdb.dbo.backupmediafamily AS bmf ON bmf.media_set_id = bs.media_set_id
WHERE rh.restore_date >= DATEADD(DAY, -@DaysBack, GETDATE())
ORDER BY rh.restore_date DESC;
