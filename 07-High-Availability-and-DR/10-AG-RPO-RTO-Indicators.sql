/*
Title: AG RPO and RTO Indicators
Purpose: Estimates current data-loss and redo exposure from availability-group queue metrics.
Compatibility: SQL Server 2016+
Safety: READ ONLY; calculations are operational indicators, not guaranteed RPO or RTO

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    ag.name AS AvailabilityGroupName,
    adc.database_name, ar.replica_server_name,
    drs.synchronization_state_desc,
    drs.log_send_queue_size AS LogSendQueueKB,
    drs.log_send_rate AS LogSendRateKBPerSecond,
    CAST(drs.log_send_queue_size * 1.0 / NULLIF(drs.log_send_rate, 0)
         AS decimal(19,2)) AS EstimatedSendSeconds,
    drs.redo_queue_size AS RedoQueueKB,
    drs.redo_rate AS RedoRateKBPerSecond,
    CAST(drs.redo_queue_size * 1.0 / NULLIF(drs.redo_rate, 0)
         AS decimal(19,2)) AS EstimatedRedoSeconds,
    drs.last_commit_time
FROM sys.dm_hadr_database_replica_states AS drs
JOIN sys.availability_databases_cluster AS adc ON adc.group_database_id = drs.group_database_id
JOIN sys.availability_groups AS ag ON ag.group_id = drs.group_id
JOIN sys.availability_replicas AS ar ON ar.replica_id = drs.replica_id
WHERE drs.is_local = 1
ORDER BY ag.name, adc.database_name;
