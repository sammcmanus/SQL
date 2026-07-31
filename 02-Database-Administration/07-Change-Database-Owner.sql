/*
Title: Change Database Owner
Purpose: Generates and optionally executes ALTER AUTHORIZATION for one database.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; set @Execute = 1 only after review

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DatabaseName sysname = N'YourDatabase';
DECLARE @NewOwner sysname = N'sa';
DECLARE @Execute bit = 0;

IF DB_ID(@DatabaseName) IS NULL
    THROW 50000, 'Database does not exist.', 1;
IF SUSER_ID(@NewOwner) IS NULL
    THROW 50000, 'New owner login does not exist.', 1;

DECLARE @Command nvarchar(max) =
    N'ALTER AUTHORIZATION ON DATABASE::' + QUOTENAME(@DatabaseName) +
    N' TO ' + QUOTENAME(@NewOwner) + N';';

SELECT @Command AS CommandToReview, @Execute AS ExecuteEnabled;
IF @Execute = 1 EXEC sys.sp_executesql @Command;
