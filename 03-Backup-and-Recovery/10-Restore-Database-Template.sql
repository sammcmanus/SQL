/*
Title: Restore Database Template
Purpose: Builds a guarded restore command with explicit data and log relocation.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; restoring over an existing database is destructive

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DestinationDatabase sysname = N'RestoredDatabase';
DECLARE @BackupFile nvarchar(4000) = N'D:\SQLBackups\Database.bak';
DECLARE @LogicalDataName sysname = N'Database';
DECLARE @LogicalLogName sysname = N'Database_log';
DECLARE @DataFile nvarchar(4000) = N'D:\SQLData\RestoredDatabase.mdf';
DECLARE @LogFile nvarchar(4000) = N'L:\SQLLogs\RestoredDatabase_log.ldf';
DECLARE @ReplaceExisting bit = 0;
DECLARE @Execute bit = 0;

IF DB_ID(@DestinationDatabase) IS NOT NULL AND @ReplaceExisting = 0
    THROW 50000, 'Destination exists. Explicitly allow replacement to continue.', 1;

DECLARE @Command nvarchar(max) =
    N'RESTORE DATABASE ' + QUOTENAME(@DestinationDatabase) +
    N' FROM DISK = N''' + REPLACE(@BackupFile, '''', '''''') +
    N''' WITH MOVE N''' + REPLACE(@LogicalDataName, '''', '''''') +
    N''' TO N''' + REPLACE(@DataFile, '''', '''''') +
    N''', MOVE N''' + REPLACE(@LogicalLogName, '''', '''''') +
    N''' TO N''' + REPLACE(@LogFile, '''', '''''') +
    N''', CHECKSUM, STATS = 5' +
    CASE WHEN @ReplaceExisting = 1 THEN N', REPLACE' ELSE N'' END + N';';

SELECT @Command AS CommandToReview, @Execute AS ExecuteEnabled;
IF @Execute = 1 EXEC sys.sp_executesql @Command;
