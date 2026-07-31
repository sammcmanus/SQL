/*
Title: Session SET Options
Purpose: Shows current session SET-option values that affect parsing, behavior, and plan reuse.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    SESSIONPROPERTY('ANSI_NULLS') AS ANSI_NULLS,
    SESSIONPROPERTY('ANSI_PADDING') AS ANSI_PADDING,
    SESSIONPROPERTY('ANSI_WARNINGS') AS ANSI_WARNINGS,
    SESSIONPROPERTY('ARITHABORT') AS ARITHABORT,
    SESSIONPROPERTY('CONCAT_NULL_YIELDS_NULL') AS CONCAT_NULL_YIELDS_NULL,
    SESSIONPROPERTY('NUMERIC_ROUNDABORT') AS NUMERIC_ROUNDABORT,
    SESSIONPROPERTY('QUOTED_IDENTIFIER') AS QUOTED_IDENTIFIER,
    @@LANGUAGE AS SessionLanguage,
    @@DATEFIRST AS DateFirst,
    DB_NAME() AS CurrentDatabase;
