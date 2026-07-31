/*
Title: Preferred Backup Replica
Purpose: Evaluates the preferred backup replica for each availability database on the local instance.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    ag.name AS AvailabilityGroupName,
    adc.database_name,
    sys.fn_hadr_backup_is_preferred_replica(adc.database_name) AS IsPreferredBackupReplica,
    ag.automated_backup_preference_desc
FROM sys.availability_groups AS ag
JOIN sys.availability_databases_cluster AS adc ON adc.group_id = ag.group_id
ORDER BY ag.name, adc.database_name;
