/*
Title: File I/O Latency
Purpose: Calculates read and write latency by database file since instance startup.
Compatibility: SQL Server 2016+
Safety: READ ONLY; counters are cumulative and should be compared over intervals

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    DB_NAME(vfs.database_id) AS DatabaseName,
    mf.name AS LogicalFileName, mf.type_desc, mf.physical_name,
    vfs.num_of_reads, vfs.num_of_writes,
    CAST(vfs.io_stall_read_ms * 1.0 / NULLIF(vfs.num_of_reads, 0) AS decimal(19,2))
        AS AvgReadLatencyMs,
    CAST(vfs.io_stall_write_ms * 1.0 / NULLIF(vfs.num_of_writes, 0) AS decimal(19,2))
        AS AvgWriteLatencyMs,
    CAST((vfs.io_stall_read_ms + vfs.io_stall_write_ms) * 1.0 /
         NULLIF(vfs.num_of_reads + vfs.num_of_writes, 0) AS decimal(19,2))
        AS AvgOverallLatencyMs,
    CAST(vfs.size_on_disk_bytes / 1073741824.0 AS decimal(19,2)) AS SizeOnDiskGB
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
JOIN sys.master_files AS mf
  ON mf.database_id = vfs.database_id AND mf.file_id = vfs.file_id
ORDER BY AvgOverallLatencyMs DESC;
