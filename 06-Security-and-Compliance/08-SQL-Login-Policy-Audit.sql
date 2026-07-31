/*
Title: SQL Login Policy Audit
Purpose: Finds SQL logins with password policy, expiration, lockout, or age concerns.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @MaximumPasswordAgeDays int = 90;

SELECT
    name AS LoginName, is_disabled, is_policy_checked, is_expiration_checked,
    LOGINPROPERTY(name, 'IsLocked') AS IsLocked,
    LOGINPROPERTY(name, 'BadPasswordCount') AS BadPasswordCount,
    LOGINPROPERTY(name, 'PasswordLastSetTime') AS PasswordLastSetTime,
    DATEDIFF(DAY, CONVERT(datetime, LOGINPROPERTY(name, 'PasswordLastSetTime')), GETDATE())
        AS PasswordAgeDays,
    CASE WHEN is_policy_checked = 0 THEN N'Password policy disabled'
         WHEN is_expiration_checked = 0 THEN N'Expiration disabled'
         WHEN LOGINPROPERTY(name, 'IsLocked') = 1 THEN N'Login locked'
         WHEN DATEDIFF(DAY, CONVERT(datetime, LOGINPROPERTY(name, 'PasswordLastSetTime')), GETDATE())
              > @MaximumPasswordAgeDays THEN N'Password age exceeds threshold'
         ELSE N'OK' END AS Assessment
FROM sys.sql_logins
ORDER BY Assessment, name;
