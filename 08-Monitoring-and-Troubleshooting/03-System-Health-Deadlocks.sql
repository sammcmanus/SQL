/*
Title: System Health Deadlocks
Purpose: Extracts deadlock graphs retained in the system_health ring buffer.
Compatibility: SQL Server 2016+
Safety: READ ONLY; ring-buffer retention is limited

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

WITH RingBuffer AS
(
    SELECT CAST(t.target_data AS xml) AS TargetData
    FROM sys.dm_xe_session_targets AS t
    JOIN sys.dm_xe_sessions AS s ON s.address = t.event_session_address
    WHERE s.name = N'system_health'
      AND t.target_name = N'ring_buffer'
),
Deadlocks AS
(
    SELECT x.e.query('.') AS EventXml
    FROM RingBuffer
    CROSS APPLY TargetData.nodes('//RingBufferTarget/event[@name="xml_deadlock_report"]') AS x(e)
)
SELECT
    EventXml.value('(event/@timestamp)[1]', 'datetime2') AS UtcTimestamp,
    EventXml.query('(event/data/value/deadlock)[1]') AS DeadlockGraph
FROM Deadlocks
ORDER BY UtcTimestamp DESC;
