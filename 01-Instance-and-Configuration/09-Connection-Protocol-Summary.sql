/*
Title: Connection Protocol Summary
Purpose: Summarizes active transport, encryption, authentication, and network endpoints.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    net_transport, protocol_type, auth_scheme, encrypt_option,
    local_net_address, local_tcp_port, COUNT_BIG(*) AS ConnectionCount
FROM sys.dm_exec_connections
GROUP BY net_transport, protocol_type, auth_scheme, encrypt_option,
         local_net_address, local_tcp_port
ORDER BY ConnectionCount DESC;
