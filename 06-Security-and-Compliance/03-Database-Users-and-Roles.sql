/*
Title: Database Users and Roles
Purpose: Lists users and database-role memberships in the current database.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    dp.name AS UserName, dp.type_desc AS UserType,
    dp.authentication_type_desc, dp.default_schema_name,
    roles.name AS DatabaseRole,
    dp.create_date, dp.modify_date
FROM sys.database_principals AS dp
LEFT JOIN sys.database_role_members AS drm ON drm.member_principal_id = dp.principal_id
LEFT JOIN sys.database_principals AS roles ON roles.principal_id = drm.role_principal_id
WHERE dp.principal_id > 4
  AND dp.type IN ('S', 'U', 'G', 'E', 'X')
ORDER BY dp.name, roles.name;
