/*
Title: CDC Inventory
Purpose: Reports database and table-level Change Data Capture configuration.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    DB_NAME() AS DatabaseName,
    is_cdc_enabled AS DatabaseCdcEnabled
FROM sys.databases
WHERE database_id = DB_ID();

IF EXISTS (SELECT 1 FROM sys.databases WHERE database_id = DB_ID() AND is_cdc_enabled = 1)
BEGIN
    EXEC sys.sp_executesql N'
    SELECT
        SCHEMA_NAME(t.schema_id) AS SourceSchema, t.name AS SourceTable,
        ct.capture_instance, ct.start_lsn, ct.supports_net_changes,
        ct.index_name, ct.filegroup_name,
        OBJECT_SCHEMA_NAME(ct.object_id) AS ChangeTableSchema,
        OBJECT_NAME(ct.object_id) AS ChangeTableName,
        ct.create_date
    FROM cdc.change_tables AS ct
    JOIN sys.tables AS t ON t.object_id = ct.source_object_id
    ORDER BY SourceSchema, SourceTable, ct.capture_instance;';
END;
