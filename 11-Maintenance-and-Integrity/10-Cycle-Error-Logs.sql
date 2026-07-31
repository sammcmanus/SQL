/*
Title: Cycle Error Logs
Purpose: Previews or cycles SQL Server and SQL Agent error logs.
Compatibility: SQL Server 2016+
Safety: PREVIEW BY DEFAULT; cycling creates new log files and affects retention numbering

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

DECLARE @CycleSqlServerLog bit = 1;
DECLARE @CycleSqlAgentLog bit = 1;
DECLARE @Execute bit = 0;

SELECT
    @CycleSqlServerLog AS CycleSqlServerLog,
    @CycleSqlAgentLog AS CycleSqlAgentLog,
    @Execute AS ExecuteEnabled,
    N'EXEC master.dbo.sp_cycle_errorlog;' AS SqlServerCommand,
    N'EXEC msdb.dbo.sp_cycle_agent_errorlog;' AS SqlAgentCommand;

IF @Execute = 1
BEGIN
    IF @CycleSqlServerLog = 1 EXEC master.dbo.sp_cycle_errorlog;
    IF @CycleSqlAgentLog = 1 EXEC msdb.dbo.sp_cycle_agent_errorlog;
END;
