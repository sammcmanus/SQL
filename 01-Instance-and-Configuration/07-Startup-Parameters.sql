/*
Title: Startup Parameters
Purpose: Reads SQL Server service startup parameters from the instance registry.
Compatibility: SQL Server 2016+
Safety: READ ONLY; requires registry-read permission

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @Index int = 0;
DECLARE @Name sysname;
DECLARE @Value nvarchar(4000);

CREATE TABLE #StartupParameters
(
    ParameterName sysname NOT NULL,
    ParameterValue nvarchar(4000) NULL
);

WHILE @Index < 20
BEGIN
    SET @Name = N'SQLArg' + CONVERT(nvarchar(10), @Index);

    BEGIN TRY
        SET @Value = NULL;
        EXEC master.dbo.xp_instance_regread
            N'HKEY_LOCAL_MACHINE',
            N'Software\Microsoft\MSSQLServer\MSSQLServer\Parameters',
            @Name,
            @Value OUTPUT;

        IF @Value IS NULL BREAK;
        INSERT #StartupParameters(ParameterName, ParameterValue)
        VALUES (@Name, @Value);
    END TRY
    BEGIN CATCH
        BREAK;
    END CATCH;

    SET @Index += 1;
END;

SELECT ParameterName, ParameterValue
FROM #StartupParameters
ORDER BY ParameterName;
