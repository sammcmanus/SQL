/*
Title: Backup History
Purpose: Returns detailed backup history for a selected database and date window.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DatabaseName sysname = NULL;
DECLARE @DaysBack int = 30;

SELECT
    bs.database_name,
    CASE bs.type WHEN 'D' THEN 'Full' WHEN 'I' THEN 'Differential'
                 WHEN 'L' THEN 'Log' ELSE bs.type END AS BackupType,
    bs.backup_start_date, bs.backup_finish_date,
    DATEDIFF(SECOND, bs.backup_start_date, bs.backup_finish_date) AS DurationSeconds,
    CAST(bs.backup_size / 1048576.0 AS decimal(19,2)) AS BackupSizeMB,
    CAST(bs.compressed_backup_size / 1048576.0 AS decimal(19,2)) AS CompressedSizeMB,
    bmf.physical_device_name, bs.is_copy_only, bs.has_backup_checksums
FROM msdb.dbo.backupset AS bs
JOIN msdb.dbo.backupmediafamily AS bmf ON bmf.media_set_id = bs.media_set_id
WHERE bs.backup_start_date >= DATEADD(DAY, -@DaysBack, GETDATE())
  AND (@DatabaseName IS NULL OR bs.database_name = @DatabaseName)
ORDER BY bs.backup_start_date DESC;
