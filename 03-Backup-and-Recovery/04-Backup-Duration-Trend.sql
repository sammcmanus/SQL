/*
Title: Backup Duration Trend
Purpose: Shows duration and throughput for recent backups.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DaysBack int = 30;

SELECT
    database_name, backup_start_date, backup_finish_date,
    DATEDIFF(SECOND, backup_start_date, backup_finish_date) AS DurationSeconds,
    CAST(backup_size / 1048576.0 AS decimal(19,2)) AS BackupSizeMB,
    CAST(backup_size / 1048576.0 /
         NULLIF(DATEDIFF(SECOND, backup_start_date, backup_finish_date), 0)
         AS decimal(19,2)) AS ThroughputMBPerSecond,
    type AS BackupTypeCode
FROM msdb.dbo.backupset
WHERE backup_start_date >= DATEADD(DAY, -@DaysBack, GETDATE())
ORDER BY backup_start_date DESC;
