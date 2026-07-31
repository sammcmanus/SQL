/*
Title: Server Permissions
Purpose: Reports explicit server-level grants, denies, and grant options.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    grantee.name AS GranteeName, grantee.type_desc AS GranteeType,
    perm.state_desc, perm.permission_name, perm.class_desc,
    grantor.name AS GrantorName
FROM sys.server_permissions AS perm
JOIN sys.server_principals AS grantee ON grantee.principal_id = perm.grantee_principal_id
JOIN sys.server_principals AS grantor ON grantor.principal_id = perm.grantor_principal_id
ORDER BY grantee.name, perm.class_desc, perm.permission_name;
