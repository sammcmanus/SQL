/*
Title: TempDB Configuration
Purpose: Reviews tempdb files, sizing, growth, and placement.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

USE tempdb;

SELECT
    file_id, name AS LogicalFileName, type_desc, physical_name,
    CAST(size / 128.0 AS decimal(18,2)) AS SizeMB,
    CASE WHEN is_percent_growth = 1 THEN CONCAT(growth, '%')
         ELSE CONCAT(CAST(growth / 128.0 AS decimal(18,2)), ' MB') END AS GrowthSetting,
    max_size, state_desc
FROM sys.database_files
ORDER BY type_desc, file_id;
