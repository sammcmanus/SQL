/*
Title: Transaction Log Space
Purpose: Reports transaction-log size and utilization for every online database.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

CREATE TABLE #LogSpace
(
    DatabaseName sysname,
    LogSizeMB decimal(19,4),
    LogSpaceUsedPercent decimal(9,4),
    [Status] int
);

INSERT #LogSpace EXEC ('DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS;');

SELECT
    ls.DatabaseName, ls.LogSizeMB, ls.LogSpaceUsedPercent,
    CAST(ls.LogSizeMB * ls.LogSpaceUsedPercent / 100.0 AS decimal(19,2)) AS UsedLogMB,
    d.recovery_model_desc, d.log_reuse_wait_desc
FROM #LogSpace AS ls
JOIN sys.databases AS d ON d.name = ls.DatabaseName
ORDER BY ls.LogSpaceUsedPercent DESC;
