/*
Title: Database State and Access
Purpose: Shows state, access mode, read-only status, and log reuse waits.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    name AS DatabaseName, state_desc, user_access_desc, is_read_only,
    is_in_standby, is_cleanly_shutdown, is_supplemental_logging_enabled,
    source_database_id, log_reuse_wait_desc
FROM sys.databases
ORDER BY state_desc, name;
