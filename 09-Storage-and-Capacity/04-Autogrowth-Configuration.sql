/*
Title: Autogrowth Configuration
Purpose: Finds percent growth, small increments, unlimited files, and inconsistent settings.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @MinimumDataGrowthMB decimal(19,2) = 256;
DECLARE @MinimumLogGrowthMB decimal(19,2) = 256;

SELECT
    DB_NAME(database_id) AS DatabaseName, name AS LogicalFileName,
    type_desc, physical_name,
    CAST(size / 128.0 AS decimal(19,2)) AS SizeMB,
    CASE WHEN is_percent_growth = 1 THEN CONVERT(varchar(20), growth) + '%'
         ELSE CONVERT(varchar(20), CAST(growth / 128.0 AS decimal(19,2))) + ' MB'
    END AS GrowthSetting,
    CASE WHEN is_percent_growth = 1 THEN N'Percent growth'
         WHEN type_desc = N'ROWS' AND growth / 128.0 < @MinimumDataGrowthMB THEN N'Small data growth'
         WHEN type_desc = N'LOG' AND growth / 128.0 < @MinimumLogGrowthMB THEN N'Small log growth'
         WHEN growth = 0 THEN N'Autogrowth disabled'
         ELSE N'Review complete' END AS Assessment,
    CASE WHEN max_size = -1 THEN N'Unlimited'
         ELSE CONVERT(nvarchar(30), CAST(max_size / 128.0 AS decimal(19,2))) + N' MB'
    END AS MaximumSize
FROM sys.master_files
ORDER BY DatabaseName, type_desc, file_id;
