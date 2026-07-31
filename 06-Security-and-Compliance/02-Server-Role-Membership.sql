/*
Title: Server Role Membership
Purpose: Lists fixed and user-defined server role membership.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    roles.name AS ServerRole,
    members.name AS MemberName,
    members.type_desc AS MemberType,
    members.is_disabled
FROM sys.server_role_members AS rm
JOIN sys.server_principals AS roles ON roles.principal_id = rm.role_principal_id
JOIN sys.server_principals AS members ON members.principal_id = rm.member_principal_id
ORDER BY roles.name, members.name;
