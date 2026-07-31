/*
Title: Identity Column Health
Purpose: Shows identity values, remaining capacity, and percentage consumed.
Compatibility: SQL Server 2016+
Safety: READ ONLY; percentage is most useful for positive incrementing integer identities

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SCHEMA_NAME(t.schema_id) AS SchemaName, t.name AS TableName,
    c.name AS IdentityColumn, ty.name AS DataType,
    ic.seed_value, ic.increment_value, ic.last_value,
    CASE ty.name
        WHEN N'tinyint' THEN CONVERT(decimal(38,0), 255)
        WHEN N'smallint' THEN CONVERT(decimal(38,0), 32767)
        WHEN N'int' THEN CONVERT(decimal(38,0), 2147483647)
        WHEN N'bigint' THEN CONVERT(decimal(38,0), 9223372036854775807)
    END AS MaximumPositiveValue,
    CAST(100.0 * TRY_CONVERT(decimal(38,0), ic.last_value) /
         NULLIF(CASE ty.name
            WHEN N'tinyint' THEN CONVERT(decimal(38,0), 255)
            WHEN N'smallint' THEN CONVERT(decimal(38,0), 32767)
            WHEN N'int' THEN CONVERT(decimal(38,0), 2147483647)
            WHEN N'bigint' THEN CONVERT(decimal(38,0), 9223372036854775807)
         END, 0) AS decimal(9,4)) AS PercentConsumed
FROM sys.identity_columns AS ic
JOIN sys.tables AS t ON t.object_id = ic.object_id
JOIN sys.columns AS c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
JOIN sys.types AS ty ON ty.user_type_id = c.user_type_id
ORDER BY PercentConsumed DESC;
