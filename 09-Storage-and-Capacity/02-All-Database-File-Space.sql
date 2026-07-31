/*
Title: All Database File Space
Purpose: Collects allocated and internally free data-file space across every online database.
Compatibility: SQL Server 2016+
Safety: READ ONLY; requires access to each database

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

CREATE TABLE #DatabaseFiles
(
    DatabaseName sysname, FileId int, LogicalName sysname,
    TypeDesc nvarchar(60), PhysicalName nvarchar(260),
    AllocatedMB decimal(19,2), UsedMB decimal(19,2), FreeMB decimal(19,2)
);

DECLARE @sql nvarchar(max) = N'';
SELECT @sql += N'
USE ' + QUOTENAME(name) + N';
SELECT DB_NAME(), file_id, name, type_desc, physical_name,
       CAST(size / 128.0 AS decimal(19,2)),
       CAST(CASE WHEN type_desc = N''ROWS'' THEN FILEPROPERTY(name, ''SpaceUsed'') / 128.0 END AS decimal(19,2)),
       CAST(CASE WHEN type_desc = N''ROWS'' THEN (size - FILEPROPERTY(name, ''SpaceUsed'')) / 128.0 END AS decimal(19,2))
FROM sys.database_files;'
FROM sys.databases
WHERE state_desc = N'ONLINE';

INSERT #DatabaseFiles EXEC sys.sp_executesql @sql;
SELECT * FROM #DatabaseFiles ORDER BY DatabaseName, TypeDesc, FileId;
