---------  Missing Indexes

	SELECT user_seeks, avg_user_impact, equality_columns,included_columns,statement, DB.Name
	FROM sys.dm_db_missing_index_groups			AS MIG
	JOIN sys.dm_db_missing_index_details		AS MID  ON MID.index_handle = MIG.index_handle
	JOIN sys.dm_db_missing_index_group_stats	AS MIGS ON MIGS.group_handle = MIG.index_group_handle
	JOIN sys.databases							AS DB	ON DB.database_id = MID.database_id
	
	WHERE DB.Name = 'productdb' AND user_seeks > 1000
	
	ORDER BY USER_Seeks DESC
	--ORDER BY AVG_user_impact DESC


---------  Store Procedure Stats

	SELECT db.Name, AO.Name, execution_count, total_physical_reads, last_elapsed_time, last_worker_time, total_physical_reads 
	FROM sys.all_objects				AS AO 
	JOIN sys.dm_exec_procedure_stats	AS PCS ON AO.object_id = PCS.object_id
	JOIN sys.databases					AS DB  ON DB.database_id = pcs.database_id
	
	WHERE	execution_count > 1000 
		AND DB.name = 'HCSDB'
	
	--ORDER BY execution_count DESC
	ORDER BY last_elapsed_time DESC
	
---------  Statistics
DBCC SHOW_STATISTICS ([ContactPhoneList], ContactPhoneList_) --(table_Name, Index_Name)


--------- Create Index

CREATE NONCLUSTERED INDEX [IX_StoreProductPackagePendParameter_StoreProductPackagePendID] ON [dbo].[StoreProductPackagePendParameter] 
(
	[StoreProductPackagePendID] ASC
)

