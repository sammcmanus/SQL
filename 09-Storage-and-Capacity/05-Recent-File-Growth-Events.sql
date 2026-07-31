/*
Title: Recent File Growth Events
Purpose: Reads data and log growth events from the default trace.
Compatibility: SQL Server 2016+
Safety: READ ONLY; requires the default trace to be enabled and retained

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @TracePath nvarchar(260);

SELECT @TracePath = path
FROM sys.traces
WHERE is_default = 1;

IF @TracePath IS NULL
    THROW 50000, 'The default trace is not enabled.', 1;

SELECT
    te.name AS EventName, t.DatabaseName, t.FileName,
    t.StartTime, t.EndTime, t.Duration / 1000 AS DurationMs,
    t.IntegerData * 8.0 / 1024 AS GrowthMB,
    t.HostName, t.ApplicationName, t.LoginName
FROM sys.fn_trace_gettable(@TracePath, DEFAULT) AS t
JOIN sys.trace_events AS te ON te.trace_event_id = t.EventClass
WHERE t.EventClass IN (92, 93)
ORDER BY t.StartTime DESC;
