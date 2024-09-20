--- Get Current Locations

USE master 
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

DECLARE @DBName varchar(max) = '[Database Name]'

DECLARE @LogName Varchar(MAX), @DataName Varchar(MAX),
	    @LogFileName Varchar(MAX), @DataFileName Varchar(MAX), @CMDLog VARCHAR(MAX), @CMDData VARCHAR(MAX),
		@DataFile Varchar(MAX), @LogFile Varchar(MAX),
		@Data2File Varchar(MAX), @Data2FileName Varchar(MAX), @Data2Name Varchar(MAX)

SELECT Name, physical_name, * FROM sys.master_files WHERE database_id = DB_ID(@DBName) 

SELECT @DataName = Name, @DataFile = physical_name, @DataFileName = rtrim(right(physical_name, charindex('\', reverse(physical_name)) - 1))FROM sys.master_files WHERE database_id = DB_ID(@DBName) and file_id = 1
SELECT @LogName = Name, @LogFile = physical_name, @LogFileName = rtrim(right(physical_name, charindex('\', reverse(physical_name)) - 1)) FROM sys.master_files WHERE database_id = DB_ID(@DBName) and file_id = 2
--SELECT @Data2Name = Name, @Data2File = physical_name, @Data2FileName = rtrim(right(physical_name, charindex('\', reverse(physical_name)) - 1))FROM sys.master_files WHERE database_id = DB_ID(@DBName) and file_id = 3
--- CREATE Folder Path

declare @LogFileTo varchar(100) = 'R:\Logs\' + @DBName + '\'
EXEC master.dbo.xp_create_subdir @LogFileTo

declare @DataFileTo varchar(100) = 'R:\Data\' + @DBName + '\'
EXEC master.dbo.xp_create_subdir @DataFileTo

SELECT @DataName, @LogName, @DataFileName, @LogFileName, @LogFile, @DataFile, @DataFileTo, @LogFileTo

--- Move Locations

EXEC('ALTER DATABASE ' + @DBName + ' MODIFY FILE ( NAME = ' + @DataName + ', FILENAME = ''' + @DataFileTo + @DataFileName +''')')

--EXEC('ALTER DATABASE ' + @DBName + ' MODIFY FILE ( NAME = ' + @Data2Name + ', FILENAME = ''' + @DataFileTo + @Data2FileName +''')')

EXEC('ALTER DATABASE ' + @DBName + ' MODIFY FILE ( NAME = ' + @LogName + ', FILENAME = ''' + @LogFileTo + @LogFileName +''')')

--- SET DB Offline

EXEC('ALTER DATABASE ' + @DBName + ' SET OFFLINE WITH ROLLBACK IMMEDIATE')

--- Move Files
DECLARE @CMD sysname
SET @CMD = 'MOVE /Y '+ @DataFile + ' ' + @DataFileTo
EXEC sys.xp_cmdshell @CMD

--SET @CMD = 'MOVE /Y '+ @Data2File + ' ' + @DataFileTo
--EXEC sys.xp_cmdshell @CMD

SET @CMD =  'MOVE /Y '+ @LogFile +' ' + @LogFileTo 
EXEC sys.xp_cmdshell @CMD

--- Set DB Online

EXEC('ALTER DATABASE ' + @DBName + ' SET online')


