/*
Title: Database Options
Purpose: Reviews important database options and common anti-patterns.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    name AS DatabaseName, state_desc, user_access_desc, recovery_model_desc,
    page_verify_option_desc, snapshot_isolation_state_desc,
    is_read_committed_snapshot_on, is_auto_create_stats_on,
    is_auto_update_stats_on, is_auto_update_stats_async_on,
    is_auto_close_on, is_auto_shrink_on, is_broker_enabled, is_trustworthy_on
FROM sys.databases
ORDER BY name;
