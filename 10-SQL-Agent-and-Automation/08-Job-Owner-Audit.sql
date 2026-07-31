/*
Title: Job Owner Audit
Purpose: Flags jobs owned by missing, disabled, or nonstandard logins.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @PreferredOwner sysname = N'sa';

SELECT
    j.name AS JobName,
    SUSER_SNAME(j.owner_sid) AS OwnerName,
    sp.is_disabled AS OwnerDisabled,
    CASE WHEN SUSER_SNAME(j.owner_sid) IS NULL THEN N'Owner SID has no login'
         WHEN sp.is_disabled = 1 THEN N'Owner login disabled'
         WHEN SUSER_SNAME(j.owner_sid) <> @PreferredOwner THEN N'Nonstandard owner'
         ELSE N'OK' END AS Assessment
FROM msdb.dbo.sysjobs AS j
LEFT JOIN sys.server_principals AS sp ON sp.sid = j.owner_sid
ORDER BY Assessment, j.name;
