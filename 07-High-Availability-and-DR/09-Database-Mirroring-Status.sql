/*
Title: Database Mirroring Status
Purpose: Inventories legacy database-mirroring state, partners, safety, and witness configuration.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    d.name AS DatabaseName,
    dm.mirroring_role_desc, dm.mirroring_state_desc,
    dm.mirroring_safety_level_desc,
    dm.mirroring_partner_name, dm.mirroring_partner_instance,
    dm.mirroring_witness_name, dm.mirroring_witness_state_desc,
    dm.mirroring_connection_timeout, dm.mirroring_redo_queue,
    dm.mirroring_redo_queue_type
FROM sys.databases AS d
JOIN sys.database_mirroring AS dm ON dm.database_id = d.database_id
WHERE dm.mirroring_guid IS NOT NULL
ORDER BY d.name;
