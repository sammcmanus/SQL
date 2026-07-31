/*
Title: Database Inventory
Purpose: Provides a one-row inventory of every database and its core operating settings.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    database_id, name AS DatabaseName, SUSER_SNAME(owner_sid) AS OwnerName,
    state_desc, user_access_desc, recovery_model_desc, compatibility_level,
    collation_name, page_verify_option_desc, is_read_only, is_auto_close_on,
    is_auto_shrink_on, is_query_store_on, create_date
FROM sys.databases
ORDER BY name;
