/*
Title: Availability Database Synchronization
Purpose: Shows synchronization, queue size, rates, and LSNs for availability databases.
Compatibility: SQL Server 2016+
Safety: READ ONLY; run on each replica for complete local state

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    ag.name AS AvailabilityGroupName,
    ar.replica_server_name,
    adc.database_name,
    drs.is_local, drs.is_primary_replica,
    drs.synchronization_state_desc,
    drs.synchronization_health_desc,
    drs.database_state_desc, drs.is_suspended,
    drs.suspend_reason_desc,
    drs.log_send_queue_size, drs.log_send_rate,
    drs.redo_queue_size, drs.redo_rate,
    drs.last_commit_time, drs.last_hardened_lsn, drs.last_redone_lsn
FROM sys.dm_hadr_database_replica_states AS drs
JOIN sys.availability_databases_cluster AS adc ON adc.group_database_id = drs.group_database_id
JOIN sys.availability_groups AS ag ON ag.group_id = drs.group_id
JOIN sys.availability_replicas AS ar ON ar.replica_id = drs.replica_id
ORDER BY ag.name, adc.database_name, ar.replica_server_name;
