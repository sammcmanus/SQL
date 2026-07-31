/*
Title: Backup Database Template
Purpose: Builds a full or differential backup command with checksum and compression.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; confirm destination path and service-account permissions

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DatabaseName sysname = N'YourDatabase';
DECLARE @BackupDirectory nvarchar(260) = N'D:\SQLBackups';
DECLARE @BackupType varchar(12) = 'FULL'; -- FULL or DIFF
DECLARE @CopyOnly bit = 0;
DECLARE @Execute bit = 0;

IF DB_ID(@DatabaseName) IS NULL THROW 50000, 'Database does not exist.', 1;
IF @BackupType NOT IN ('FULL', 'DIFF') THROW 50000, 'Use FULL or DIFF.', 1;

DECLARE @FileName nvarchar(4000) =
    @BackupDirectory + CASE WHEN RIGHT(@BackupDirectory, 1) IN ('\', '/') THEN N'' ELSE N'\' END +
    @DatabaseName + N'_' + CONVERT(char(8), GETDATE(), 112) + N'_' +
    REPLACE(CONVERT(char(8), GETDATE(), 108), ':', '') + N'.bak';

DECLARE @Command nvarchar(max) =
    N'BACKUP DATABASE ' + QUOTENAME(@DatabaseName) +
    N' TO DISK = N''' + REPLACE(@FileName, '''', '''''') +
    N''' WITH CHECKSUM, COMPRESSION, STATS = 5' +
    CASE WHEN @BackupType = 'DIFF' THEN N', DIFFERENTIAL' ELSE N'' END +
    CASE WHEN @CopyOnly = 1 THEN N', COPY_ONLY' ELSE N'' END + N';';

SELECT @Command AS CommandToReview, @Execute AS ExecuteEnabled;
IF @Execute = 1 EXEC sys.sp_executesql @Command;
