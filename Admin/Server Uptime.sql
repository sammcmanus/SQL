USE [master]
GO
DECLARE @server_start_time DATETIME, 
@seconds_diff INT, 
@years_online INT, 
@days_online INT, 
@hours_online INT, 
@minutes_online INT, 
@seconds_online INT ; 

SELECT @server_start_time = login_time 
FROM master.sys.sysprocesses 
WHERE spid = 1 ; 

SELECT @seconds_diff = DATEDIFF(SECOND, @server_start_time, GETDATE()), 
@years_online = @seconds_diff / 31536000, 
@seconds_diff = @seconds_diff % 31536000, 
@days_online = @seconds_diff / 86400, 
@seconds_diff = @seconds_diff % 86400, 
@hours_online = @seconds_diff / 3600, 
@seconds_diff = @seconds_diff % 3600, 
@minutes_online = @seconds_diff / 60, 
@seconds_online = @seconds_diff % 60 ; 

SELECT @server_start_time AS server_start_time, 
@years_online AS years_online, 
@days_online AS days_online, 
@hours_online AS hours_online, 
@minutes_online AS minutes_online, 
@seconds_online AS seconds_online ;