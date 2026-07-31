/*
Title: Availability Group Listeners
Purpose: Lists listener DNS names, ports, IP addresses, and subnet configuration.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    ag.name AS AvailabilityGroupName,
    l.dns_name AS ListenerDnsName, l.port,
    ip.ip_address, ip.ip_subnet_mask, ip.network_subnet_ip,
    ip.network_subnet_prefix_length, ip.state_desc,
    ip.is_dhcp
FROM sys.availability_groups AS ag
JOIN sys.availability_group_listeners AS l ON l.group_id = ag.group_id
LEFT JOIN sys.availability_group_listener_ip_addresses AS ip ON ip.listener_id = l.listener_id
ORDER BY ag.name, l.dns_name, ip.ip_address;
