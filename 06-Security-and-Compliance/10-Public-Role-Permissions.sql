/*
Title: Public Role Permissions
Purpose: Finds explicit permissions granted or denied to the public role in the current database.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @PublicPrincipalId int = DATABASE_PRINCIPAL_ID(N'public');

SELECT
    perm.state_desc, perm.permission_name, perm.class_desc,
    CASE perm.class
        WHEN 0 THEN DB_NAME()
        WHEN 1 THEN QUOTENAME(OBJECT_SCHEMA_NAME(perm.major_id)) + N'.' +
                    QUOTENAME(OBJECT_NAME(perm.major_id))
        WHEN 3 THEN SCHEMA_NAME(perm.major_id)
        ELSE CONVERT(nvarchar(128), perm.major_id)
    END AS SecurableName,
    grantor.name AS GrantorName
FROM sys.database_permissions AS perm
JOIN sys.database_principals AS grantor ON grantor.principal_id = perm.grantor_principal_id
WHERE perm.grantee_principal_id = @PublicPrincipalId
ORDER BY perm.class_desc, SecurableName, perm.permission_name;
