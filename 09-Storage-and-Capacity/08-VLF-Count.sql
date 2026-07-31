/*
Title: VLF Count
Purpose: Counts virtual log files in one selected database using DBCC LOGINFO.
Compatibility: SQL Server 2016+
Safety: READ ONLY; DBCC output schema is designed for SQL Server 2016

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DatabaseName sysname = DB_NAME();

IF DB_ID(@DatabaseName) IS NULL THROW 50000, 'Database does not exist.', 1;

CREATE TABLE #LogInfo
(
    FileId int, FileSize bigint, StartOffset bigint,
    FSeqNo bigint, [Status] int, Parity int, CreateLSN numeric(25,0)
);

DECLARE @Command nvarchar(max) =
    N'DBCC LOGINFO (' + QUOTENAME(@DatabaseName, '''') + N') WITH NO_INFOMSGS;';

INSERT #LogInfo EXEC sys.sp_executesql @Command;

SELECT
    @DatabaseName AS DatabaseName,
    COUNT(*) AS VLFCount,
    SUM(CASE WHEN [Status] = 2 THEN 1 ELSE 0 END) AS ActiveVLFCount,
    CAST(SUM(FileSize) / 1048576.0 AS decimal(19,2)) AS TotalLogMB
FROM #LogInfo;
