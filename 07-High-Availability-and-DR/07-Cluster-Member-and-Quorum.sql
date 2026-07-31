/*
Title: Cluster Member and Quorum
Purpose: Shows Windows Server Failover Cluster members, networks, and quorum state exposed to SQL Server.
Compatibility: SQL Server 2016+
Safety: READ ONLY; returns rows only on WSFC-based availability configurations

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    member_name, member_type_desc, member_state_desc,
    number_of_quorum_votes
FROM sys.dm_hadr_cluster_members
ORDER BY member_type_desc, member_name;

SELECT
    cluster_name, quorum_type_desc, quorum_state_desc
FROM sys.dm_hadr_cluster;

SELECT
    member_name, network_subnet_ip, network_subnet_ipv4_mask,
    network_subnet_prefix_length, is_public, is_ipv4
FROM sys.dm_hadr_cluster_networks
ORDER BY member_name, network_subnet_ip;
