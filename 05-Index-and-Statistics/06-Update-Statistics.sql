/*
Title: Update Statistics
Purpose: Generates and optionally executes UPDATE STATISTICS for stale statistics.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; updates may consume CPU, memory, I/O, and plan-cache activity

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @MinimumModificationPercent decimal(6,2) = 20.0;
DECLARE @Execute bit = 0;

CREATE TABLE #Commands
(
    CommandOrder int IDENTITY(1,1) PRIMARY KEY,
    CommandText nvarchar(max) NOT NULL
);

INSERT #Commands(CommandText)
SELECT N'UPDATE STATISTICS ' + QUOTENAME(SCHEMA_NAME(o.schema_id)) + N'.' +
       QUOTENAME(o.name) + N' ' + QUOTENAME(s.name) + N' WITH RESAMPLE;'
FROM sys.stats AS s
JOIN sys.objects AS o ON o.object_id = s.object_id AND o.type = 'U'
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
WHERE sp.rows > 0
  AND 100.0 * sp.modification_counter / NULLIF(sp.rows, 0) >= @MinimumModificationPercent;

SELECT CommandText AS CommandToReview FROM #Commands ORDER BY CommandOrder;

IF @Execute = 1
BEGIN
    DECLARE @Command nvarchar(max);
    DECLARE c CURSOR LOCAL FAST_FORWARD FOR
        SELECT CommandText FROM #Commands ORDER BY CommandOrder;
    OPEN c;
    FETCH NEXT FROM c INTO @Command;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC sys.sp_executesql @Command;
        FETCH NEXT FROM c INTO @Command;
    END;
    CLOSE c;
    DEALLOCATE c;
END;
