/*
Title: Database Containment
Purpose: Reports containment settings and contained authentication status.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    name AS DatabaseName, containment_desc, default_language_name,
    default_fulltext_language_name, nested_triggers,
    transform_noise_words, two_digit_year_cutoff
FROM sys.databases
ORDER BY name;

SELECT name, value_in_use AS ContainedDatabaseAuthenticationEnabled
FROM sys.configurations
WHERE name = N'contained database authentication';
