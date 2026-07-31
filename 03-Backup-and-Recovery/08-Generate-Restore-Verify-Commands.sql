/*
Title: Generate Restore Verify Commands
Purpose: Generates RESTORE VERIFYONLY commands for the most recent full backups.
Compatibility: SQL Server 2016+
Safety: READ ONLY COMMAND GENERATOR; generated commands do not restore data

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DaysBack int = 7;

WITH RecentFull AS
(
    SELECT bs.database_name, bmf.physical_device_name, bs.position,
        ROW_NUMBER() OVER
        (PARTITION BY bs.database_name ORDER BY bs.backup_finish_date DESC) AS rn
    FROM msdb.dbo.backupset AS bs
    JOIN msdb.dbo.backupmediafamily AS bmf ON bmf.media_set_id = bs.media_set_id
    WHERE bs.type = 'D'
      AND bs.backup_finish_date >= DATEADD(DAY, -@DaysBack, GETDATE())
)
SELECT database_name,
    N'RESTORE VERIFYONLY FROM DISK = N''' +
    REPLACE(physical_device_name, '''', '''''') +
    N''' WITH FILE = ' + CONVERT(nvarchar(12), position) +
    N', CHECKSUM;' AS VerifyCommand
FROM RecentFull
WHERE rn = 1
ORDER BY database_name;
