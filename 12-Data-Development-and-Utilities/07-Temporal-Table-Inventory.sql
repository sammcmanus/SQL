/*
Title: Temporal Table Inventory
Purpose: Lists system-versioned temporal tables, history tables, and period columns.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SCHEMA_NAME(t.schema_id) AS SchemaName, t.name AS TemporalTable,
    t.temporal_type_desc,
    OBJECT_SCHEMA_NAME(t.history_table_id) AS HistorySchema,
    OBJECT_NAME(t.history_table_id) AS HistoryTable,
    start_column.name AS PeriodStartColumn,
    end_column.name AS PeriodEndColumn
FROM sys.tables AS t
LEFT JOIN sys.periods AS period ON period.object_id = t.object_id
LEFT JOIN sys.columns AS start_column
  ON start_column.object_id = t.object_id AND start_column.column_id = period.start_column_id
LEFT JOIN sys.columns AS end_column
  ON end_column.object_id = t.object_id AND end_column.column_id = period.end_column_id
WHERE t.temporal_type <> 0
ORDER BY SchemaName, TemporalTable;
