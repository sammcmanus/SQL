/*
Title: Search SQL Error Log
Purpose: Searches a selected SQL Server error log for one or two text patterns.
Compatibility: SQL Server 2016+
Safety: READ ONLY; xp_readerrorlog access may require elevated permission

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @ArchiveNumber int = 0;       -- 0 is current, 1 is previous
DECLARE @SearchText1 nvarchar(255) = N'error';
DECLARE @SearchText2 nvarchar(255) = NULL;
DECLARE @StartDate datetime = DATEADD(DAY, -1, GETDATE());
DECLARE @EndDate datetime = GETDATE();

EXEC master.dbo.xp_readerrorlog
    @ArchiveNumber, 1, @SearchText1, @SearchText2,
    @StartDate, @EndDate, N'desc';
