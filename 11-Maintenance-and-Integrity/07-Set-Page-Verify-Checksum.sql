/*
Title: Set Page Verify Checksum
Purpose: Generates and optionally applies PAGE_VERIFY CHECKSUM to eligible databases.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; test operational procedures before changing database options

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DatabaseName sysname = N'YourDatabase';
DECLARE @Execute bit = 0;

IF DB_ID(@DatabaseName) IS NULL THROW 50000, 'Database does not exist.', 1;

DECLARE @CurrentSetting nvarchar(60) =
    (SELECT page_verify_option_desc FROM sys.databases WHERE name = @DatabaseName);
DECLARE @Command nvarchar(max) =
    N'ALTER DATABASE ' + QUOTENAME(@DatabaseName) + N' SET PAGE_VERIFY CHECKSUM;';

SELECT @DatabaseName AS DatabaseName, @CurrentSetting AS CurrentSetting,
       @Command AS CommandToReview, @Execute AS ExecuteEnabled;

IF @Execute = 1 EXEC sys.sp_executesql @Command;
