/*
Title: Database Owners
Purpose: Finds database owners and flags missing or disabled login mappings.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    d.name AS DatabaseName,
    SUSER_SNAME(d.owner_sid) AS OwnerName,
    sp.is_disabled AS OwnerLoginDisabled,
    CASE WHEN SUSER_SNAME(d.owner_sid) IS NULL THEN N'Owner SID has no matching login'
         WHEN sp.is_disabled = 1 THEN N'Owner login is disabled'
         ELSE N'OK' END AS Assessment
FROM sys.databases AS d
LEFT JOIN sys.server_principals AS sp ON d.owner_sid = sp.sid
ORDER BY d.name;
