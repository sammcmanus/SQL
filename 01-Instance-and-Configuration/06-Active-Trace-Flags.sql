/*
Title: Active Trace Flags
Purpose: Shows trace flags enabled globally or for the current session.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

CREATE TABLE #TraceStatus
(
    TraceFlag int NOT NULL,
    Status bit NOT NULL,
    [Global] bit NOT NULL,
    [Session] bit NOT NULL
);

INSERT #TraceStatus
EXEC ('DBCC TRACESTATUS(-1) WITH NO_INFOMSGS;');

SELECT TraceFlag, Status, [Global], [Session]
FROM #TraceStatus
ORDER BY TraceFlag;
