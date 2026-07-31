/*
Title: Sequence Health
Purpose: Inventories sequences, current values, cache settings, and exhaustion risk.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SCHEMA_NAME(schema_id) AS SchemaName, name AS SequenceName,
    TYPE_NAME(user_type_id) AS DataType,
    start_value, increment, minimum_value, maximum_value,
    current_value, is_cycling, is_cached, cache_size, is_exhausted,
    CAST(100.0 *
         (TRY_CONVERT(decimal(38,0), current_value) - TRY_CONVERT(decimal(38,0), minimum_value)) /
         NULLIF(TRY_CONVERT(decimal(38,0), maximum_value) -
                TRY_CONVERT(decimal(38,0), minimum_value), 0)
         AS decimal(9,4)) AS RangeConsumedPercent
FROM sys.sequences
ORDER BY RangeConsumedPercent DESC, SchemaName, SequenceName;
