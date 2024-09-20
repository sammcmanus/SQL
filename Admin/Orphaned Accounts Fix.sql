USE [DATABASE NAME]
GO
-- Secure Orphaned User AutoFix 
DECLARE @autoFix bit; 
SET @autoFix = 'TRUE';  -- FALSE = Report only those user who could be auto fixed. 
                         -- TRUE  = Report and fix !!! 
 
DECLARE @user sysname, @principal sysname, @sql nvarchar(500), @found int, @fixed int; 
 
DECLARE orphans CURSOR LOCAL FOR 
    SELECT QUOTENAME(SU.[name]) AS UserName 
          ,QUOTENAME(SP.[name]) AS PrincipalName 
    FROM sys.sysusers AS SU 
         LEFT JOIN sys.server_principals AS SP 
             ON SU.[name] = SP.[name] 
                AND SP.[type] = 'S' 
    WHERE SU.issqluser = 1          -- Only SQL logins 
          AND NOT SU.[sid] IS NULL  -- Exclude system user 
          AND SU.[sid] <> 0x0       -- Exclude guest account 
          AND LEN(SU.[sid]) <= 16   -- Exclude Windows accounts & roles 
          AND SUSER_SNAME(SU.[sid]) IS NULL  -- Login for SID is null 
    ORDER BY SU.[name]; 
 
SET @found = 0; 
SET @fixed = 0; 
OPEN orphans; 
FETCH NEXT FROM orphans 
    INTO @user, @principal; 
WHILE @@FETCH_STATUS = 0 
BEGIN 
    IF @principal IS NULL 
        PRINT N'Orphan: ' + @user; 
    ELSE 
    BEGIN 
        PRINT N'Orphan: ' + @user + N' => Autofix possible, principal with same name found!'; 
        IF @autoFix = 'TRUE' 
        BEGIN 
            -- Build the DDL statement dynamically. 
            SET @sql = N'ALTER USER ' + @user + N' WITH LOGIN = ' + @principal + N';'; 
            EXEC sp_executesql @sql; 
            PRINT N'        ' + @user + N' is auto fixed.'; 
            SET @fixed = @fixed + 1; 
        END 
    END 
    SET @found = @found + 1; 
     
    FETCH NEXT FROM orphans 
        INTO @user, @principal; 
END; 
 
CLOSE orphans; 
DEALLOCATE orphans; 
 
PRINT ''; 
PRINT CONVERT(nvarchar(15), @found) + N' orphan(s) found, ' 
    + CONVERT(nvarchar(15), @fixed) + N' orphan(s) fixed.';