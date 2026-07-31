/*
Title: Epoch Date Converter
Purpose: Converts between Unix epoch seconds and SQL Server datetime2 values.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @EpochSeconds bigint = 0;
DECLARE @DateTimeValue datetime2(0) = SYSUTCDATETIME();

SELECT
    @EpochSeconds AS EpochSeconds,
    DATEADD(SECOND, CONVERT(int, @EpochSeconds % 86400),
        DATEADD(DAY, CONVERT(int, @EpochSeconds / 86400),
            CONVERT(datetime2(0), '19700101'))) AS EpochAsUtcDateTime,
    @DateTimeValue AS InputUtcDateTime,
    DATEDIFF_BIG(SECOND, CONVERT(datetime2(0), '19700101'), @DateTimeValue)
        AS DateTimeAsEpochSeconds;
