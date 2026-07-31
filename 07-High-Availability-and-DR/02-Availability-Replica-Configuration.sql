/*
Title: Availability Replica Configuration
Purpose: Inventories endpoints, modes, timeouts, backup priorities, and session settings.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    ag.name AS AvailabilityGroupName,
    ar.replica_server_name, ar.endpoint_url,
    ar.availability_mode_desc, ar.failover_mode_desc,
    ar.session_timeout, ar.backup_priority,
    ar.primary_role_allow_connections_desc,
    ar.secondary_role_allow_connections_desc,
    ar.seeding_mode_desc
FROM sys.availability_groups AS ag
JOIN sys.availability_replicas AS ar ON ar.group_id = ag.group_id
ORDER BY ag.name, ar.replica_server_name;
