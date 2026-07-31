/*
Title: Recovery Model Review
Purpose: Compares recovery models with recent log-backup activity.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

WITH LastLogBackup AS
(
    SELECT database_name, MAX(backup_finish_date) AS LastLogBackup
    FROM msdb.dbo.backupset
    WHERE type = 'L'
    GROUP BY database_name
)
SELECT
    d.name AS DatabaseName, d.recovery_model_desc, llb.LastLogBackup,
    CASE WHEN d.recovery_model_desc = N'FULL' AND llb.LastLogBackup IS NULL
              THEN N'FULL recovery with no log backup history'
         WHEN d.recovery_model_desc = N'FULL'
              AND llb.LastLogBackup < DATEADD(HOUR, -24, GETDATE())
              THEN N'Log backup appears stale'
         ELSE N'Review complete' END AS Assessment
FROM sys.databases AS d
LEFT JOIN LastLogBackup AS llb ON llb.database_name = d.name
WHERE d.database_id > 4
ORDER BY d.name;
