/*
Title: Run DBCC CHECKDB
Purpose: Generates and optionally runs DBCC CHECKDB for one database with error tablock output.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; CHECKDB is read-oriented but can consume substantial I/O, CPU, memory, and tempdb

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DatabaseName sysname = DB_NAME();
DECLARE @PhysicalOnly bit = 0;
DECLARE @Execute bit = 0;

IF DB_ID(@DatabaseName) IS NULL THROW 50000, 'Database does not exist.', 1;

DECLARE @Command nvarchar(max) =
    N'DBCC CHECKDB (' + QUOTENAME(@DatabaseName, '''') +
    N') WITH NO_INFOMSGS, ALL_ERRORMSGS, TABLOCK' +
    CASE WHEN @PhysicalOnly = 1 THEN N', PHYSICAL_ONLY' ELSE N'' END + N';';

SELECT @Command AS CommandToReview, @Execute AS ExecuteEnabled;
IF @Execute = 1 EXEC sys.sp_executesql @Command;
