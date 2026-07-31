/*
Title: Current Database File Space
Purpose: Shows allocated, used, and free space for each current-database file.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    file_id, name AS LogicalFileName, type_desc, physical_name,
    CAST(size / 128.0 AS decimal(19,2)) AS AllocatedMB,
    CAST(CASE WHEN type_desc = N'ROWS'
              THEN FILEPROPERTY(name, 'SpaceUsed') / 128.0
              ELSE NULL END AS decimal(19,2)) AS UsedMB,
    CAST(CASE WHEN type_desc = N'ROWS'
              THEN (size - FILEPROPERTY(name, 'SpaceUsed')) / 128.0
              ELSE NULL END AS decimal(19,2)) AS FreeInsideFileMB,
    CASE WHEN is_percent_growth = 1 THEN CONVERT(varchar(20), growth) + '%'
         ELSE CONVERT(varchar(20), CAST(growth / 128.0 AS decimal(19,2))) + ' MB'
    END AS GrowthSetting
FROM sys.database_files
ORDER BY type_desc, file_id;
