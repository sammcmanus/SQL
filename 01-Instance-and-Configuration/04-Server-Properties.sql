/*
Title: Server Properties
Purpose: Returns commonly requested server and instance properties.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT PropertyName, PropertyValue
FROM (VALUES
    ('ServerName', CONVERT(sql_variant, SERVERPROPERTY('ServerName'))),
    ('ComputerNamePhysicalNetBIOS', CONVERT(sql_variant, SERVERPROPERTY('ComputerNamePhysicalNetBIOS'))),
    ('InstanceDefaultDataPath', CONVERT(sql_variant, SERVERPROPERTY('InstanceDefaultDataPath'))),
    ('InstanceDefaultLogPath', CONVERT(sql_variant, SERVERPROPERTY('InstanceDefaultLogPath'))),
    ('Collation', CONVERT(sql_variant, SERVERPROPERTY('Collation'))),
    ('ProcessID', CONVERT(sql_variant, SERVERPROPERTY('ProcessID'))),
    ('IsIntegratedSecurityOnly', CONVERT(sql_variant, SERVERPROPERTY('IsIntegratedSecurityOnly'))),
    ('FilestreamConfiguredLevel', CONVERT(sql_variant, SERVERPROPERTY('FilestreamConfiguredLevel')))
) AS p(PropertyName, PropertyValue)
ORDER BY PropertyName;
