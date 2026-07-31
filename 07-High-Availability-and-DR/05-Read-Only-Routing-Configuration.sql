/*
Title: Read-Only Routing Configuration
Purpose: Reviews read-only routing URLs and priority lists for availability replicas.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    ag.name AS AvailabilityGroupName,
    ar.replica_server_name,
    ar.read_only_routing_url,
    rl.routing_priority,
    routed.replica_server_name AS ReadOnlyRouteTarget
FROM sys.availability_groups AS ag
JOIN sys.availability_replicas AS ar ON ar.group_id = ag.group_id
LEFT JOIN sys.availability_read_only_routing_lists AS rl
  ON rl.replica_id = ar.replica_id
LEFT JOIN sys.availability_replicas AS routed
  ON routed.replica_id = rl.read_only_replica_id
ORDER BY ag.name, ar.replica_server_name, rl.routing_priority;
