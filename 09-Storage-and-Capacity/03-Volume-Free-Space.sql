/*
Title: Volume Free Space
Purpose: Reports total and available capacity for volumes hosting SQL Server files.
Compatibility: SQL Server 2016+
Safety: READ ONLY; requires VIEW SERVER STATE

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT DISTINCT
    vs.volume_mount_point, vs.logical_volume_name, vs.file_system_type,
    CAST(vs.total_bytes / 1073741824.0 AS decimal(19,2)) AS TotalGB,
    CAST(vs.available_bytes / 1073741824.0 AS decimal(19,2)) AS AvailableGB,
    CAST(100.0 * vs.available_bytes / NULLIF(vs.total_bytes, 0)
         AS decimal(6,2)) AS PercentFree,
    vs.supports_compression, vs.is_compressed
FROM sys.master_files AS mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.file_id) AS vs
ORDER BY PercentFree, vs.volume_mount_point;
