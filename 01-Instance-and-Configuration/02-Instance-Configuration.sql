/*
Title: Instance Configuration
Purpose: Lists configured and running values for every instance setting.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    name, value AS ConfiguredValue, value_in_use AS RunningValue,
    minimum, maximum, is_dynamic, is_advanced,
    CASE WHEN value <> value_in_use THEN 1 ELSE 0 END AS ChangePending
FROM sys.configurations
ORDER BY name;
