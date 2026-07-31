/*
Title: File I/O Throughput
Purpose: Reports bytes, operations, stalls, and average transfer size by database file.
Compatibility: SQL Server 2016+
Safety: READ ONLY; counters are cumulative since startup

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    DB_NAME(v.database_id) AS DatabaseName,
    mf.name AS LogicalFileName, mf.type_desc, mf.physical_name,
    v.num_of_reads, v.num_of_bytes_read,
    v.num_of_writes, v.num_of_bytes_written,
    CAST(v.num_of_bytes_read / 1048576.0 AS decimal(19,2)) AS ReadMB,
    CAST(v.num_of_bytes_written / 1048576.0 AS decimal(19,2)) AS WrittenMB,
    CAST(v.num_of_bytes_read * 1.0 / NULLIF(v.num_of_reads, 0) / 1024
         AS decimal(19,2)) AS AvgReadKB,
    CAST(v.num_of_bytes_written * 1.0 / NULLIF(v.num_of_writes, 0) / 1024
         AS decimal(19,2)) AS AvgWriteKB,
    v.io_stall_read_ms, v.io_stall_write_ms
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS v
JOIN sys.master_files AS mf ON mf.database_id = v.database_id AND mf.file_id = v.file_id
ORDER BY DatabaseName, mf.type_desc, mf.file_id;
