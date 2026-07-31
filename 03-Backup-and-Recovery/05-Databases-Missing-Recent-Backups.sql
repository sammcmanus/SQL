/*
Title: Databases Missing Recent Backups
Purpose: Flags user databases outside configurable full and log backup windows.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @FullBackupMaxAgeHours int = 26;
DECLARE @LogBackupMaxAgeMinutes int = 30;

WITH LastBackup AS
(
    SELECT database_name,
        MAX(CASE WHEN type = 'D' THEN backup_finish_date END) AS LastFullBackup,
        MAX(CASE WHEN type = 'L' THEN backup_finish_date END) AS LastLogBackup
    FROM msdb.dbo.backupset
    GROUP BY database_name
)
SELECT
    d.name AS DatabaseName, d.recovery_model_desc,
    b.LastFullBackup, b.LastLogBackup,
    CASE WHEN b.LastFullBackup IS NULL
              OR b.LastFullBackup < DATEADD(HOUR, -@FullBackupMaxAgeHours, GETDATE())
         THEN 1 ELSE 0 END AS FullBackupOverdue,
    CASE WHEN d.recovery_model_desc = N'FULL'
              AND (b.LastLogBackup IS NULL
                   OR b.LastLogBackup < DATEADD(MINUTE, -@LogBackupMaxAgeMinutes, GETDATE()))
         THEN 1 ELSE 0 END AS LogBackupOverdue
FROM sys.databases AS d
LEFT JOIN LastBackup AS b ON b.database_name = d.name
WHERE d.database_id > 4 AND d.state_desc = N'ONLINE'
ORDER BY d.name;
