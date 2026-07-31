/*
Title: Server Version and Edition
Purpose: Returns the SQL Server build, edition, host, and availability properties.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    @@SERVERNAME AS ServerName,
    CAST(SERVERPROPERTY('MachineName') AS nvarchar(128)) AS MachineName,
    CAST(SERVERPROPERTY('InstanceName') AS nvarchar(128)) AS InstanceName,
    CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(128)) AS ProductVersion,
    CAST(SERVERPROPERTY('ProductLevel') AS nvarchar(128)) AS ProductLevel,
    CAST(SERVERPROPERTY('ProductUpdateLevel') AS nvarchar(128)) AS ProductUpdateLevel,
    CAST(SERVERPROPERTY('Edition') AS nvarchar(128)) AS Edition,
    CAST(SERVERPROPERTY('EngineEdition') AS int) AS EngineEdition,
    CAST(SERVERPROPERTY('IsClustered') AS bit) AS IsClustered,
    CAST(SERVERPROPERTY('IsHadrEnabled') AS bit) AS IsHadrEnabled,
    sqlserver_start_time
FROM sys.dm_os_sys_info;
