/*
Title: Availability Group Health
Purpose: Summarizes availability groups, replicas, roles, connectivity, and synchronization health.
Compatibility: SQL Server 2016+
Safety: READ ONLY; requires VIEW SERVER STATE

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    ag.name AS AvailabilityGroupName,
    ar.replica_server_name,
    ars.role_desc, ars.operational_state_desc, ars.connected_state_desc,
    ars.synchronization_health_desc,
    ar.availability_mode_desc, ar.failover_mode_desc,
    ar.seeding_mode_desc, ar.backup_priority,
    ars.last_connect_error_number, ars.last_connect_error_description,
    ars.last_connect_error_timestamp
FROM sys.availability_groups AS ag
JOIN sys.availability_replicas AS ar ON ar.group_id = ag.group_id
LEFT JOIN sys.dm_hadr_availability_replica_states AS ars ON ars.replica_id = ar.replica_id
ORDER BY ag.name, ar.replica_server_name;
