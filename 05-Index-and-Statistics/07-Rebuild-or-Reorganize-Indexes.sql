/*
Title: Rebuild or Reorganize Indexes
Purpose: Generates maintenance commands using configurable fragmentation thresholds.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; maintenance can block and produce substantial transaction log activity

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @ReorganizeThreshold decimal(5,2) = 10.0;
DECLARE @RebuildThreshold decimal(5,2) = 30.0;
DECLARE @MinimumPageCount bigint = 1000;
DECLARE @Execute bit = 0;

CREATE TABLE #Commands
(
    CommandOrder int IDENTITY(1,1) PRIMARY KEY,
    CommandText nvarchar(max) NOT NULL
);

INSERT #Commands(CommandText)
SELECT
    N'ALTER INDEX ' + QUOTENAME(i.name) + N' ON ' +
    QUOTENAME(OBJECT_SCHEMA_NAME(i.object_id)) + N'.' +
    QUOTENAME(OBJECT_NAME(i.object_id)) +
    CASE WHEN ips.avg_fragmentation_in_percent >= @RebuildThreshold
         THEN N' REBUILD;' ELSE N' REORGANIZE;' END
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
JOIN sys.indexes AS i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
WHERE ips.page_count >= @MinimumPageCount
  AND ips.avg_fragmentation_in_percent >= @ReorganizeThreshold
  AND i.index_id > 0 AND i.is_disabled = 0;

SELECT CommandText AS CommandToReview FROM #Commands ORDER BY CommandOrder;

IF @Execute = 1
BEGIN
    DECLARE @Command nvarchar(max);
    DECLARE c CURSOR LOCAL FAST_FORWARD FOR SELECT CommandText FROM #Commands ORDER BY CommandOrder;
    OPEN c; FETCH NEXT FROM c INTO @Command;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC sys.sp_executesql @Command;
        FETCH NEXT FROM c INTO @Command;
    END;
    CLOSE c; DEALLOCATE c;
END;
