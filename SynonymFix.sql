DECLARE @FromServerName VARCHAR(35) = NULL
		,@FromDatabaseName VARCHAR(35) = 'HCSdb%' --Can use escape characters for "Like" Searchers

DECLARE @ToServerName VARCHAR(35) = 'JVLDBUAT03'
		,@ToDatabaseName VARCHAR(35) = NULL

--Synonym Fix
SELECT 
		name, 
		COALESCE(PARSENAME(base_object_name,4),@@servername) AS serverName, 
		COALESCE(PARSENAME(base_object_name,3),DB_NAME(DB_ID())) AS dbName, 
		COALESCE(PARSENAME(base_object_name,2),SCHEMA_NAME(SCHEMA_ID())) AS schemaName, 
		PARSENAME(base_object_name,1) AS objectName 
FROM sys.synonyms 
WHERE (COALESCE(PARSENAME(base_object_name,4),@@servername) = @FromServerName OR @FromServerName IS NULL)
	   AND (COALESCE(PARSENAME(base_object_name,3),DB_NAME(DB_ID())) like @FromDatabaseName OR @FromDatabaseName IS NULL)
ORDER BY serverName,dbName,schemaName,objectName



SELECT 
'IF EXISTS (SELECT * FROM SYS.SYNONYMS WHERE name = ''' + name + ''' AND schema_id = ''' + CAST(schema_id AS VARCHAR(5)) + ''') DROP SYNONYM [' + COALESCE(PARSENAME(base_object_name,2),SCHEMA_NAME(SCHEMA_ID())) + '].[' + name + ']' AS OLD ,
'CREATE SYNONYM [' + COALESCE(PARSENAME(base_object_name,2),SCHEMA_NAME(SCHEMA_ID())) + '].[' + name + '] FOR ' + CASE WHEN @ToServerName IS NULL THEN '' ELSE '[' + @ToServerName + '].' END + '[' + CASE WHEN @ToDatabaseName IS NULL THEN COALESCE(PARSENAME(base_object_name,3),DB_NAME(DB_ID())) ELSE @ToDatabaseName END + '].[' + COALESCE(PARSENAME(base_object_name,2),SCHEMA_NAME(SCHEMA_ID())) + '].[' + PARSENAME(base_object_name,1) + ']' AS NEW,
name ,
COALESCE(PARSENAME(base_object_name,4),@@servername) AS serverName, 
COALESCE(PARSENAME(base_object_name,3),DB_NAME(DB_ID())) AS dbName, 
COALESCE(PARSENAME(base_object_name,2),SCHEMA_NAME(SCHEMA_ID())) AS schemaName, 
PARSENAME(base_object_name,1) AS objectName 
INTO #SYNONYM
FROM sys.synonyms 
WHERE (COALESCE(PARSENAME(base_object_name,4),@@servername) = @FromServerName OR @FromServerName IS NULL)
	   AND (COALESCE(PARSENAME(base_object_name,3),DB_NAME(DB_ID())) like @FromDatabaseName OR @FromDatabaseName IS NULL)
--ORDER BY dbName,schemaName,objectName,serverName

SELECT * FROM #SYNONYM

DROP TABLE #SYNONYM

/*
--- PERMISSIONS
SELECT 
'GRANT SELECT ON [' + COALESCE(PARSENAME(base_object_name,2),SCHEMA_NAME(SCHEMA_ID())) + '].[' + name + '] TO CslaOrgUnitUser',
name, 
COALESCE(PARSENAME(base_object_name,4),@@servername) AS serverName, 
COALESCE(PARSENAME(base_object_name,3),DB_NAME(DB_ID())) AS dbName, 
COALESCE(PARSENAME(base_object_name,2),SCHEMA_NAME(SCHEMA_ID())) AS schemaName, 
PARSENAME(base_object_name,1) AS objectName 
FROM sys.synonyms 
WHERE COALESCE(PARSENAME(base_object_name,3),DB_NAME(DB_ID())) = 'HierarchyDB'
--ORDER BY dbName,schemaName,objectName,serverName
*/