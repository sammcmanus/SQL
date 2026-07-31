/*
Title: Server Logins
Purpose: Inventories server principals, login types, status, and policy settings.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    sp.principal_id, sp.name, sp.type_desc, sp.is_disabled,
    sp.default_database_name, sp.default_language_name,
    sp.create_date, sp.modify_date,
    sl.is_policy_checked, sl.is_expiration_checked,
    LOGINPROPERTY(sp.name, 'PasswordLastSetTime') AS PasswordLastSetTime
FROM sys.server_principals AS sp
LEFT JOIN sys.sql_logins AS sl ON sl.principal_id = sp.principal_id
WHERE sp.type IN ('S', 'U', 'G', 'C', 'K')
ORDER BY sp.type_desc, sp.name;
