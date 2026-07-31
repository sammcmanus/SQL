/*
Title: Log Shipping Status
Purpose: Reports primary and secondary log-shipping configuration and monitor thresholds.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    pd.primary_database AS PrimaryDatabase,
    pd.backup_directory AS BackupDirectory,
    pd.backup_share AS BackupShare,
    pd.backup_retention_period AS BackupRetentionMinutes,
    pd.backup_threshold AS BackupAlertThresholdMinutes,
    pd.last_backup_date,
    pd.last_backup_file
FROM msdb.dbo.log_shipping_primary_databases AS pd
ORDER BY pd.primary_database;

SELECT
    sd.primary_server,
    sd.primary_database,
    sd.secondary_server,
    sd.secondary_database,
    sd.restore_threshold AS RestoreAlertThresholdMinutes,
    sd.last_copied_date,
    sd.last_copied_file,
    sd.last_restored_date,
    sd.last_restored_file,
    sd.last_restored_latency
FROM msdb.dbo.log_shipping_monitor_secondary AS sd
ORDER BY sd.secondary_database;
