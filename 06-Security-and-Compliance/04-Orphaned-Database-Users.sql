/*
Title: Orphaned Database Users
Purpose: Finds SQL or Windows users whose SID has no matching server login.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    dp.name AS DatabaseUser, dp.type_desc, dp.authentication_type_desc,
    dp.sid
FROM sys.database_principals AS dp
LEFT JOIN sys.server_principals AS sp ON sp.sid = dp.sid
WHERE dp.principal_id > 4
  AND dp.type IN ('S', 'U', 'G')
  AND dp.authentication_type_desc = N'INSTANCE'
  AND sp.sid IS NULL
ORDER BY dp.name;
