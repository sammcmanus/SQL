/*
Title: Change Compatibility Level
Purpose: Generates and optionally applies a database compatibility-level change.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; validate application behavior first

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DatabaseName sysname = N'YourDatabase';
DECLARE @CompatibilityLevel int = 130;
DECLARE @Execute bit = 0;

IF DB_ID(@DatabaseName) IS NULL
    THROW 50000, 'Database does not exist.', 1;
IF @CompatibilityLevel NOT IN (100, 110, 120, 130, 140, 150, 160)
    THROW 50000, 'Unsupported compatibility level.', 1;

DECLARE @Command nvarchar(max) =
    N'ALTER DATABASE ' + QUOTENAME(@DatabaseName) +
    N' SET COMPATIBILITY_LEVEL = ' + CONVERT(nvarchar(3), @CompatibilityLevel) + N';';

SELECT @Command AS CommandToReview, @Execute AS ExecuteEnabled;
IF @Execute = 1 EXEC sys.sp_executesql @Command;
