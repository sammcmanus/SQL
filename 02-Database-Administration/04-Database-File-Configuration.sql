/*
Title: Database File Configuration
Purpose: Inventories database files, sizes, growth settings, and paths across the instance.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

CREATE TABLE #Files
(
    DatabaseName sysname, FileId int, LogicalName sysname,
    TypeDesc nvarchar(60), PhysicalName nvarchar(260),
    SizeMB decimal(19,2), MaxSizeMB decimal(19,2),
    GrowthSetting nvarchar(60)
);

DECLARE @sql nvarchar(max) = N'';

SELECT @sql += N'
USE ' + QUOTENAME(name) + N';
SELECT DB_NAME(), file_id, name, type_desc, physical_name,
       CAST(size / 128.0 AS decimal(19,2)),
       CASE WHEN max_size = -1 THEN -1 ELSE CAST(max_size / 128.0 AS decimal(19,2)) END,
       CASE WHEN is_percent_growth = 1 THEN CONVERT(nvarchar(20), growth) + N''%''
            ELSE CONVERT(nvarchar(20), CAST(growth / 128.0 AS decimal(19,2))) + N'' MB'' END
FROM sys.database_files;'
FROM sys.databases
WHERE state_desc = N'ONLINE';

INSERT #Files EXEC sys.sp_executesql @sql;
SELECT * FROM #Files ORDER BY DatabaseName, TypeDesc, FileId;
