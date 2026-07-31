/*
Title: Server Time and Time Zone
Purpose: Compares local time with UTC and lists Windows time zones known to SQL Server.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SYSDATETIME() AS ServerLocalDateTime,
    SYSUTCDATETIME() AS UtcDateTime,
    SYSDATETIMEOFFSET() AS ServerDateTimeOffset,
    DATEDIFF(MINUTE, SYSUTCDATETIME(), SYSDATETIME()) AS ApproximateUtcOffsetMinutes;

SELECT name AS TimeZoneName, current_utc_offset, is_currently_dst
FROM sys.time_zone_info
ORDER BY name;
