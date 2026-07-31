/*
Title: Remap Orphaned User
Purpose: Generates and optionally executes ALTER USER to remap a user to an existing login.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; verify the login is the intended identity

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @DatabaseUser sysname = N'YourUser';
DECLARE @ServerLogin sysname = N'YourLogin';
DECLARE @Execute bit = 0;

IF DATABASE_PRINCIPAL_ID(@DatabaseUser) IS NULL
    THROW 50000, 'Database user does not exist.', 1;
IF SUSER_ID(@ServerLogin) IS NULL
    THROW 50000, 'Server login does not exist.', 1;

DECLARE @Command nvarchar(max) =
    N'ALTER USER ' + QUOTENAME(@DatabaseUser) +
    N' WITH LOGIN = ' + QUOTENAME(@ServerLogin) + N';';

SELECT @Command AS CommandToReview, @Execute AS ExecuteEnabled;
IF @Execute = 1 EXEC sys.sp_executesql @Command;
