/*
Title: Last Backup by Database
Purpose: Shows the most recent full, differential, and log backup for every database.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

WITH BackupDates AS
(
    SELECT database_name,
        MAX(CASE WHEN type = 'D' THEN backup_finish_date END) AS LastFullBackup,
        MAX(CASE WHEN type = 'I' THEN backup_finish_date END) AS LastDifferentialBackup,
        MAX(CASE WHEN type = 'L' THEN backup_finish_date END) AS LastLogBackup
    FROM msdb.dbo.backupset
    GROUP BY database_name
)
SELECT d.name AS DatabaseName, d.recovery_model_desc,
       b.LastFullBackup, b.LastDifferentialBackup, b.LastLogBackup
FROM sys.databases AS d
LEFT JOIN BackupDates AS b ON b.database_name = d.name
ORDER BY d.name;
