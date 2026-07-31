/*
Title: Backup Size Trend
Purpose: Trends daily full-backup size and compression ratio by database.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DaysBack int = 90;

SELECT
    database_name, CONVERT(date, backup_finish_date) AS BackupDate,
    COUNT(*) AS BackupCount,
    CAST(SUM(backup_size) / 1073741824.0 AS decimal(19,2)) AS UncompressedGB,
    CAST(SUM(compressed_backup_size) / 1073741824.0 AS decimal(19,2)) AS CompressedGB,
    CAST(SUM(backup_size) * 1.0 / NULLIF(SUM(compressed_backup_size), 0)
         AS decimal(19,2)) AS CompressionRatio
FROM msdb.dbo.backupset
WHERE type = 'D' AND backup_finish_date >= DATEADD(DAY, -@DaysBack, GETDATE())
GROUP BY database_name, CONVERT(date, backup_finish_date)
ORDER BY database_name, BackupDate DESC;
