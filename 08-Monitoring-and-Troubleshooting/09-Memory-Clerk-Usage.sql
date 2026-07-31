/*
Title: Memory Clerk Usage
Purpose: Ranks SQL Server memory clerks by current allocation.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT TOP (50)
    type AS MemoryClerkType,
    name AS MemoryClerkName,
    SUM(pages_kb) / 1024.0 AS MemoryMB,
    SUM(virtual_memory_committed_kb) / 1024.0 AS VirtualCommittedMB,
    SUM(awe_allocated_kb) / 1024.0 AS AweAllocatedMB
FROM sys.dm_os_memory_clerks
GROUP BY type, name
HAVING SUM(pages_kb) > 0
ORDER BY SUM(pages_kb) DESC;
