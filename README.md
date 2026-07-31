# SQL Server DBA Script Library

A curated collection of **120 standalone SQL Server DBA scripts**, organized by task and designed for SQL Server 2016 and newer.

Every script includes a header describing its purpose, compatibility, and safety level. Scripts that can change server or database state use `@Execute = 0` by default so the command can be reviewed before it runs.

## Quick start

1. Open the category that matches the task.
2. Read the script header and set its input variables.
3. Run diagnostic scripts with the least privilege required.
4. For preview scripts, inspect the generated command or result while `@Execute = 0`.
5. Test changes outside production, confirm backups and rollback plans, then explicitly set `@Execute = 1` only when ready.

> [!CAUTION]
> These scripts are operational building blocks, not substitutes for change control. Results depend on workload history, permissions, SQL Server edition, and local standards. Never execute generated maintenance, restore, security, or cleanup commands without reviewing the target and impact.

## Compatibility and permissions

- Baseline: SQL Server 2016+.
- Designed for the boxed SQL Server Database Engine and SQL Server Agent; Azure SQL variants may require adaptation.
- Many instance-wide DMVs require `VIEW SERVER STATE`.
- Database metadata scripts may require `VIEW DATABASE STATE` or `VIEW DEFINITION`.
- Backup, restore, DBCC, registry, SQL Agent, and configuration actions require additional role membership or explicit permissions.
- DMV and plan-cache statistics are cumulative and can reset after restart, failover, cache eviction, or manual clearing.

## Safety labels

| Label | Meaning |
|---|---|
| Read only | Queries metadata, DMVs, history, or diagnostic data without intentionally changing persistent state. |
| Read-only command generator | Produces commands for separate review; it does not execute them. |
| Preview by default | Contains an action path, but `@Execute` is initialized to `0`; review all parameters and generated commands first. |

## Categories

| Category | Scripts | Coverage |
|---|---:|---|
| [Instance and Configuration](#01-instance-and-configuration) | 10 | Server build, configuration, connectivity, tempdb, and capacity. |
| [Database Administration](#02-database-administration) | 10 | Database inventory, options, ownership, files, and guarded changes. |
| [Backup and Recovery](#03-backup-and-recovery) | 10 | Backup history, coverage, trends, verification, backup, and restore. |
| [Performance and Query Tuning](#04-performance-and-query-tuning) | 10 | Expensive queries, waits, blocking, plans, and memory grants. |
| [Index and Statistics](#05-index-and-statistics) | 10 | Index usage, fragmentation, missing indexes, and statistics maintenance. |
| [Security and Compliance](#06-security-and-compliance) | 10 | Logins, roles, permissions, orphaned users, policy, and encryption. |
| [High Availability and DR](#07-high-availability-and-dr) | 10 | Availability Groups, listeners, routing, log shipping, and mirroring. |
| [Monitoring and Troubleshooting](#08-monitoring-and-troubleshooting) | 10 | Health, error logs, deadlocks, sessions, locks, I/O, and memory. |
| [Storage and Capacity](#09-storage-and-capacity) | 10 | File space, volumes, growth, tables, partitions, VLFs, and transaction logs. |
| [SQL Agent and Automation](#10-sql-agent-and-automation) | 10 | Jobs, failures, durations, schedules, owners, steps, and creation template. |
| [Maintenance and Integrity](#11-maintenance-and-integrity) | 10 | CHECKDB, constraints, compression, history cleanup, and error logs. |
| [Data Development and Utilities](#12-data-development-and-utilities) | 10 | Metadata search, dependencies, identities, temporal, CDC, and conversions. |

## Script index

### 01-Instance-and-Configuration

Server build, configuration, connectivity, tempdb, and capacity.

| Script | Purpose | Safety |
|---|---|---|
| [Server Version and Edition](01-Instance-and-Configuration/01-Server-Version-and-Edition.sql) | Returns the SQL Server build, edition, host, and availability properties. | READ ONLY |
| [Instance Configuration](01-Instance-and-Configuration/02-Instance-Configuration.sql) | Lists configured and running values for every instance setting. | READ ONLY |
| [Database Inventory](01-Instance-and-Configuration/03-Database-Inventory.sql) | Provides a one-row inventory of every database and its core operating settings. | READ ONLY |
| [Server Properties](01-Instance-and-Configuration/04-Server-Properties.sql) | Returns commonly requested server and instance properties. | READ ONLY |
| [TempDB Configuration](01-Instance-and-Configuration/05-TempDB-Configuration.sql) | Reviews tempdb files, sizing, growth, and placement. | READ ONLY |
| [Active Trace Flags](01-Instance-and-Configuration/06-Active-Trace-Flags.sql) | Shows trace flags enabled globally or for the current session. | READ ONLY |
| [Startup Parameters](01-Instance-and-Configuration/07-Startup-Parameters.sql) | Reads SQL Server service startup parameters from the instance registry. | READ ONLY; requires registry-read permission |
| [Server Time and Time Zone](01-Instance-and-Configuration/08-Server-Time-and-Time-Zone.sql) | Compares local time with UTC and lists Windows time zones known to SQL Server. | READ ONLY |
| [Connection Protocol Summary](01-Instance-and-Configuration/09-Connection-Protocol-Summary.sql) | Summarizes active transport, encryption, authentication, and network endpoints. | READ ONLY |
| [Instance Capacity Summary](01-Instance-and-Configuration/10-Instance-Capacity-Summary.sql) | Reports CPU, memory, worker, scheduler, and virtualization capacity. | READ ONLY |

### 02-Database-Administration

Database inventory, options, ownership, files, and guarded changes.

| Script | Purpose | Safety |
|---|---|---|
| [Database Options](02-Database-Administration/01-Database-Options.sql) | Reviews important database options and common anti-patterns. | READ ONLY |
| [Compatibility Levels](02-Database-Administration/02-Compatibility-Levels.sql) | Lists database compatibility levels alongside the current engine version. | READ ONLY |
| [Database Owners](02-Database-Administration/03-Database-Owners.sql) | Finds database owners and flags missing or disabled login mappings. | READ ONLY |
| [Database File Configuration](02-Database-Administration/04-Database-File-Configuration.sql) | Inventories database files, sizes, growth settings, and paths across the instance. | READ ONLY |
| [Recovery Model Review](02-Database-Administration/05-Recovery-Model-Review.sql) | Compares recovery models with recent log-backup activity. | READ ONLY |
| [Database State and Access](02-Database-Administration/06-Database-State-and-Access.sql) | Shows state, access mode, read-only status, and log reuse waits. | READ ONLY |
| [Change Database Owner](02-Database-Administration/07-Change-Database-Owner.sql) | Generates and optionally executes ALTER AUTHORIZATION for one database. | PREVIEW BY DEFAULT; set @Execute = 1 only after review |
| [Change Compatibility Level](02-Database-Administration/08-Change-Compatibility-Level.sql) | Generates and optionally applies a database compatibility-level change. | PREVIEW BY DEFAULT; validate application behavior first |
| [Database Scoped Configurations](02-Database-Administration/09-Database-Scoped-Configurations.sql) | Collects scoped configuration values from every online user database. | READ ONLY |
| [Database Containment](02-Database-Administration/10-Database-Containment.sql) | Reports containment settings and contained authentication status. | READ ONLY |

### 03-Backup-and-Recovery

Backup history, coverage, trends, verification, backup, and restore.

| Script | Purpose | Safety |
|---|---|---|
| [Last Backup by Database](03-Backup-and-Recovery/01-Last-Backup-By-Database.sql) | Shows the most recent full, differential, and log backup for every database. | READ ONLY |
| [Backup History](03-Backup-and-Recovery/02-Backup-History.sql) | Returns detailed backup history for a selected database and date window. | READ ONLY |
| [Backup Size Trend](03-Backup-and-Recovery/03-Backup-Size-Trend.sql) | Trends daily full-backup size and compression ratio by database. | READ ONLY |
| [Backup Duration Trend](03-Backup-and-Recovery/04-Backup-Duration-Trend.sql) | Shows duration and throughput for recent backups. | READ ONLY |
| [Databases Missing Recent Backups](03-Backup-and-Recovery/05-Databases-Missing-Recent-Backups.sql) | Flags user databases outside configurable full and log backup windows. | READ ONLY |
| [Restore History](03-Backup-and-Recovery/06-Restore-History.sql) | Shows recent restores, source backup dates, destinations, and media paths. | READ ONLY |
| [Active Backup and Restore Progress](03-Backup-and-Recovery/07-Active-Backup-Restore-Progress.sql) | Monitors percentage and estimated completion for active backup or restore requests. | READ ONLY |
| [Generate Restore Verify Commands](03-Backup-and-Recovery/08-Generate-Restore-Verify-Commands.sql) | Generates RESTORE VERIFYONLY commands for the most recent full backups. | READ ONLY COMMAND GENERATOR; generated commands do not restore data |
| [Backup Database Template](03-Backup-and-Recovery/09-Backup-Database-Template.sql) | Builds a full or differential backup command with checksum and compression. | PREVIEW BY DEFAULT; confirm destination path and service-account permissions |
| [Restore Database Template](03-Backup-and-Recovery/10-Restore-Database-Template.sql) | Builds a guarded restore command with explicit data and log relocation. | PREVIEW BY DEFAULT; restoring over an existing database is destructive |

### 04-Performance-and-Query-Tuning

Expensive queries, waits, blocking, plans, and memory grants.

| Script | Purpose | Safety |
|---|---|---|
| [Top Queries by CPU](04-Performance-and-Query-Tuning/01-Top-Queries-By-CPU.sql) | Ranks cached query statements by cumulative and average worker time. | READ ONLY; plan cache statistics reset after restart or cache eviction |
| [Top Queries by Logical Reads](04-Performance-and-Query-Tuning/02-Top-Queries-By-Logical-Reads.sql) | Ranks cached statements by cumulative buffer-pool reads. | READ ONLY |
| [Top Queries by Duration](04-Performance-and-Query-Tuning/03-Top-Queries-By-Duration.sql) | Ranks cached statements by average elapsed time. | READ ONLY |
| [Currently Running Requests](04-Performance-and-Query-Tuning/04-Currently-Running-Requests.sql) | Shows active requests with waits, blockers, progress, SQL text, and plans. | READ ONLY |
| [Blocking Tree](04-Performance-and-Query-Tuning/05-Blocking-Tree.sql) | Builds a recursive view of current blocking chains. | READ ONLY |
| [Wait Statistics](04-Performance-and-Query-Tuning/06-Wait-Statistics.sql) | Summarizes instance wait statistics with common benign waits filtered out. | READ ONLY; cumulative since startup or last manual clear |
| [Plan Cache Text Search](04-Performance-and-Query-Tuning/07-Plan-Cache-Text-Search.sql) | Finds cached plans whose SQL text contains a supplied search term. | READ ONLY |
| [Active Memory Grants](04-Performance-and-Query-Tuning/08-Active-Memory-Grants.sql) | Finds active and waiting query memory grants, including plan and SQL text. | READ ONLY |
| [Parameter Sensitivity Candidates](04-Performance-and-Query-Tuning/09-Parameter-Sensitivity-Candidates.sql) | Finds query hashes with high variance between minimum and maximum elapsed time. | READ ONLY; results are candidates for investigation, not proof of parameter sniffing |
| [Implicit Conversion Plans](04-Performance-and-Query-Tuning/10-Implicit-Conversion-Plans.sql) | Finds cached execution plans containing conversion warnings. | READ ONLY; XML search can be expensive on a very large plan cache |

### 05-Index-and-Statistics

Index usage, fragmentation, missing indexes, and statistics maintenance.

| Script | Purpose | Safety |
|---|---|---|
| [Missing Index Recommendations](05-Index-and-Statistics/01-Missing-Index-Recommendations.sql) | Ranks current-database missing-index suggestions by estimated improvement. | READ ONLY; DMV suggestions are volatile and must be reviewed for overlap and write cost |
| [Unused Indexes](05-Index-and-Statistics/02-Unused-Indexes.sql) | Identifies current-database nonclustered indexes with writes but no recorded reads. | READ ONLY; usage counters reset after restart and indexes may support rare or seasonal work |
| [Duplicate Indexes](05-Index-and-Statistics/03-Duplicate-Indexes.sql) | Finds indexes with identical ordered key columns in the current database. | READ ONLY; compare included columns, filters, uniqueness, and workload before removal |
| [Index Fragmentation](05-Index-and-Statistics/04-Index-Fragmentation.sql) | Reports fragmentation and page counts for indexes in the current database. | READ ONLY; LIMITED mode minimizes scanning overhead |
| [Stale Statistics](05-Index-and-Statistics/05-Stale-Statistics.sql) | Shows statistics age and modification counts in the current database. | READ ONLY |
| [Update Statistics](05-Index-and-Statistics/06-Update-Statistics.sql) | Generates and optionally executes UPDATE STATISTICS for stale statistics. | PREVIEW BY DEFAULT; updates may consume CPU, memory, I/O, and plan-cache activity |
| [Rebuild or Reorganize Indexes](05-Index-and-Statistics/07-Rebuild-or-Reorganize-Indexes.sql) | Generates maintenance commands using configurable fragmentation thresholds. | PREVIEW BY DEFAULT; maintenance can block and produce substantial transaction log activity |
| [Heap Forwarded Records](05-Index-and-Statistics/08-Heap-Forwarded-Records.sql) | Finds heaps with forwarded records and their scan activity. | READ ONLY |
| [Index Usage Summary](05-Index-and-Statistics/09-Index-Usage-Summary.sql) | Combines read/write usage with row and size data for all current-database indexes. | READ ONLY |
| [Disabled and Hypothetical Indexes](05-Index-and-Statistics/10-Disabled-and-Hypothetical-Indexes.sql) | Lists disabled and hypothetical indexes that may represent incomplete maintenance or tuning artifacts. | READ ONLY |

### 06-Security-and-Compliance

Logins, roles, permissions, orphaned users, policy, and encryption.

| Script | Purpose | Safety |
|---|---|---|
| [Server Logins](06-Security-and-Compliance/01-Server-Logins.sql) | Inventories server principals, login types, status, and policy settings. | READ ONLY |
| [Server Role Membership](06-Security-and-Compliance/02-Server-Role-Membership.sql) | Lists fixed and user-defined server role membership. | READ ONLY |
| [Database Users and Roles](06-Security-and-Compliance/03-Database-Users-and-Roles.sql) | Lists users and database-role memberships in the current database. | READ ONLY |
| [Orphaned Database Users](06-Security-and-Compliance/04-Orphaned-Database-Users.sql) | Finds SQL or Windows users whose SID has no matching server login. | READ ONLY |
| [Remap Orphaned User](06-Security-and-Compliance/05-Remap-Orphaned-User.sql) | Generates and optionally executes ALTER USER to remap a user to an existing login. | PREVIEW BY DEFAULT; verify the login is the intended identity |
| [Server Permissions](06-Security-and-Compliance/06-Server-Permissions.sql) | Reports explicit server-level grants, denies, and grant options. | READ ONLY |
| [Database Permissions](06-Security-and-Compliance/07-Database-Permissions.sql) | Reports explicit database and object permissions in the current database. | READ ONLY |
| [SQL Login Policy Audit](06-Security-and-Compliance/08-SQL-Login-Policy-Audit.sql) | Finds SQL logins with password policy, expiration, lockout, or age concerns. | READ ONLY |
| [Encryption and TDE Status](06-Security-and-Compliance/09-Encryption-and-TDE-Status.sql) | Reports database encryption state and key metadata. | READ ONLY |
| [Public Role Permissions](06-Security-and-Compliance/10-Public-Role-Permissions.sql) | Finds explicit permissions granted or denied to the public role in the current database. | READ ONLY |

### 07-High-Availability-and-DR

Availability Groups, listeners, routing, log shipping, and mirroring.

| Script | Purpose | Safety |
|---|---|---|
| [Availability Group Health](07-High-Availability-and-DR/01-Availability-Group-Health.sql) | Summarizes availability groups, replicas, roles, connectivity, and synchronization health. | READ ONLY; requires VIEW SERVER STATE |
| [Availability Replica Configuration](07-High-Availability-and-DR/02-Availability-Replica-Configuration.sql) | Inventories endpoints, modes, timeouts, backup priorities, and session settings. | READ ONLY |
| [Availability Database Synchronization](07-High-Availability-and-DR/03-Availability-Database-Synchronization.sql) | Shows synchronization, queue size, rates, and LSNs for availability databases. | READ ONLY; run on each replica for complete local state |
| [Availability Group Listeners](07-High-Availability-and-DR/04-Availability-Group-Listeners.sql) | Lists listener DNS names, ports, IP addresses, and subnet configuration. | READ ONLY |
| [Read-Only Routing Configuration](07-High-Availability-and-DR/05-Read-Only-Routing-Configuration.sql) | Reviews read-only routing URLs and priority lists for availability replicas. | READ ONLY |
| [Preferred Backup Replica](07-High-Availability-and-DR/06-Preferred-Backup-Replica.sql) | Evaluates the preferred backup replica for each availability database on the local instance. | READ ONLY |
| [Cluster Member and Quorum](07-High-Availability-and-DR/07-Cluster-Member-and-Quorum.sql) | Shows Windows Server Failover Cluster members, networks, and quorum state exposed to SQL Server. | READ ONLY; returns rows only on WSFC-based availability configurations |
| [Log Shipping Status](07-High-Availability-and-DR/08-Log-Shipping-Status.sql) | Reports primary and secondary log-shipping configuration and monitor thresholds. | READ ONLY |
| [Database Mirroring Status](07-High-Availability-and-DR/09-Database-Mirroring-Status.sql) | Inventories legacy database-mirroring state, partners, safety, and witness configuration. | READ ONLY |
| [AG RPO and RTO Indicators](07-High-Availability-and-DR/10-AG-RPO-RTO-Indicators.sql) | Estimates current data-loss and redo exposure from availability-group queue metrics. | READ ONLY; calculations are operational indicators, not guaranteed RPO or RTO |

### 08-Monitoring-and-Troubleshooting

Health, error logs, deadlocks, sessions, locks, I/O, and memory.

| Script | Purpose | Safety |
|---|---|---|
| [Server Health Dashboard](08-Monitoring-and-Troubleshooting/01-Server-Health-Dashboard.sql) | Returns a compact snapshot of uptime, active work, blocking, waits, memory, and disk latency. | READ ONLY; requires VIEW SERVER STATE |
| [Search SQL Error Log](08-Monitoring-and-Troubleshooting/02-Search-SQL-Error-Log.sql) | Searches a selected SQL Server error log for one or two text patterns. | READ ONLY; xp_readerrorlog access may require elevated permission |
| [System Health Deadlocks](08-Monitoring-and-Troubleshooting/03-System-Health-Deadlocks.sql) | Extracts deadlock graphs retained in the system_health ring buffer. | READ ONLY; ring-buffer retention is limited |
| [Long Running Transactions](08-Monitoring-and-Troubleshooting/04-Long-Running-Transactions.sql) | Finds active transactions with age, session details, waits, and SQL text. | READ ONLY |
| [TempDB Session Usage](08-Monitoring-and-Troubleshooting/05-TempDB-Session-Usage.sql) | Ranks active sessions by current and cumulative tempdb allocation. | READ ONLY |
| [Session Inventory](08-Monitoring-and-Troubleshooting/06-Session-Inventory.sql) | Inventories user sessions, connection details, open transactions, and latest SQL text. | READ ONLY |
| [Lock Inventory](08-Monitoring-and-Troubleshooting/07-Lock-Inventory.sql) | Shows granted and waiting locks with associated sessions and request details. | READ ONLY; large busy systems can return many rows |
| [File I/O Latency](08-Monitoring-and-Troubleshooting/08-File-IO-Latency.sql) | Calculates read and write latency by database file since instance startup. | READ ONLY; counters are cumulative and should be compared over intervals |
| [Memory Clerk Usage](08-Monitoring-and-Troubleshooting/09-Memory-Clerk-Usage.sql) | Ranks SQL Server memory clerks by current allocation. | READ ONLY |
| [Scheduler Pressure](08-Monitoring-and-Troubleshooting/10-Scheduler-Pressure.sql) | Reviews runnable queues, pending I/O, load, and worker counts by visible scheduler. | READ ONLY; interpret sustained values rather than a single snapshot |

### 09-Storage-and-Capacity

File space, volumes, growth, tables, partitions, VLFs, and transaction logs.

| Script | Purpose | Safety |
|---|---|---|
| [Current Database File Space](09-Storage-and-Capacity/01-Current-Database-File-Space.sql) | Shows allocated, used, and free space for each current-database file. | READ ONLY |
| [All Database File Space](09-Storage-and-Capacity/02-All-Database-File-Space.sql) | Collects allocated and internally free data-file space across every online database. | READ ONLY; requires access to each database |
| [Volume Free Space](09-Storage-and-Capacity/03-Volume-Free-Space.sql) | Reports total and available capacity for volumes hosting SQL Server files. | READ ONLY; requires VIEW SERVER STATE |
| [Autogrowth Configuration](09-Storage-and-Capacity/04-Autogrowth-Configuration.sql) | Finds percent growth, small increments, unlimited files, and inconsistent settings. | READ ONLY |
| [Recent File Growth Events](09-Storage-and-Capacity/05-Recent-File-Growth-Events.sql) | Reads data and log growth events from the default trace. | READ ONLY; requires the default trace to be enabled and retained |
| [Largest Tables](09-Storage-and-Capacity/06-Largest-Tables.sql) | Ranks current-database tables by reserved space, used space, and row count. | READ ONLY |
| [Partition Space Usage](09-Storage-and-Capacity/07-Partition-Space-Usage.sql) | Shows row and space distribution by table, index, and partition. | READ ONLY |
| [VLF Count](09-Storage-and-Capacity/08-VLF-Count.sql) | Counts virtual log files in one selected database using DBCC LOGINFO. | READ ONLY; DBCC output schema is designed for SQL Server 2016 |
| [File I/O Throughput](09-Storage-and-Capacity/09-File-IO-Throughput.sql) | Reports bytes, operations, stalls, and average transfer size by database file. | READ ONLY; counters are cumulative since startup |
| [Transaction Log Space](09-Storage-and-Capacity/10-Transaction-Log-Space.sql) | Reports transaction-log size and utilization for every online database. | READ ONLY |

### 10-SQL-Agent-and-Automation

Jobs, failures, durations, schedules, owners, steps, and creation template.

| Script | Purpose | Safety |
|---|---|---|
| [SQL Agent Job Inventory](10-SQL-Agent-and-Automation/01-SQL-Agent-Job-Inventory.sql) | Inventories jobs, owners, categories, status, notifications, and last outcome. | READ ONLY |
| [Failed Jobs](10-SQL-Agent-and-Automation/02-Failed-Jobs.sql) | Shows failed SQL Agent executions and messages in a configurable date window. | READ ONLY |
| [Job Duration Trend](10-SQL-Agent-and-Automation/03-Job-Duration-Trend.sql) | Trends job outcome and normalized duration for recent job executions. | READ ONLY |
| [Long Running Job History](10-SQL-Agent-and-Automation/04-Long-Running-Job-History.sql) | Finds completed job executions exceeding a configurable duration. | READ ONLY |
| [Currently Running Jobs](10-SQL-Agent-and-Automation/05-Currently-Running-Jobs.sql) | Shows active job executions, current steps, start times, and elapsed minutes. | READ ONLY |
| [Job Schedules](10-SQL-Agent-and-Automation/06-Job-Schedules.sql) | Lists job schedule definitions and cached next-run dates. | READ ONLY |
| [Disabled Jobs and Schedules](10-SQL-Agent-and-Automation/07-Disabled-Jobs-and-Schedules.sql) | Finds jobs or attached schedules that are disabled. | READ ONLY |
| [Job Owner Audit](10-SQL-Agent-and-Automation/08-Job-Owner-Audit.sql) | Flags jobs owned by missing, disabled, or nonstandard logins. | READ ONLY |
| [Job Step Inventory](10-SQL-Agent-and-Automation/09-Job-Step-Inventory.sql) | Reviews job-step subsystems, databases, retry settings, proxies, and commands. | READ ONLY; command text may contain operational paths or connection details |
| [Create SQL Agent Job Template](10-SQL-Agent-and-Automation/10-Create-SQL-Agent-Job-Template.sql) | Builds and optionally executes a basic scheduled T-SQL job definition. | PREVIEW BY DEFAULT; execution creates a job and daily schedule in msdb |

### 11-Maintenance-and-Integrity

CHECKDB, constraints, compression, history cleanup, and error logs.

| Script | Purpose | Safety |
|---|---|---|
| [Run DBCC CHECKDB](11-Maintenance-and-Integrity/01-Run-DBCC-CHECKDB.sql) | Generates and optionally runs DBCC CHECKDB for one database with error tablock output. | PREVIEW BY DEFAULT; CHECKDB is read-oriented but can consume substantial I/O, CPU, memory, and tempdb |
| [Generate CHECKDB Commands](11-Maintenance-and-Integrity/02-Generate-CHECKDB-Commands.sql) | Builds integrity-check commands for all online databases. | READ ONLY COMMAND GENERATOR; running generated commands can be resource intensive |
| [Generate CHECKTABLE Commands](11-Maintenance-and-Integrity/03-Generate-CHECKTABLE-Commands.sql) | Builds DBCC CHECKTABLE commands for every user table in the current database. | READ ONLY COMMAND GENERATOR; running generated commands can be resource intensive |
| [Untrusted Foreign Keys](11-Maintenance-and-Integrity/04-Untrusted-Foreign-Keys.sql) | Finds enabled foreign keys that SQL Server cannot trust for query optimization. | READ ONLY |
| [Disabled Constraints](11-Maintenance-and-Integrity/05-Disabled-Constraints.sql) | Lists disabled foreign-key and check constraints with enable-and-validate commands. | READ ONLY COMMAND GENERATOR; validation commands can fail on existing invalid data |
| [Data Compression Inventory](11-Maintenance-and-Integrity/06-Data-Compression-Inventory.sql) | Reports current compression and space by table, index, and partition. | READ ONLY; compression availability and benefit vary by SQL Server edition and workload |
| [Set Page Verify Checksum](11-Maintenance-and-Integrity/07-Set-Page-Verify-Checksum.sql) | Generates and optionally applies PAGE_VERIFY CHECKSUM to eligible databases. | PREVIEW BY DEFAULT; test operational procedures before changing database options |
| [Cleanup Backup History](11-Maintenance-and-Integrity/08-Cleanup-Backup-History.sql) | Previews backup-history volume and optionally deletes records older than a retention date. | PREVIEW BY DEFAULT; deletion removes msdb history, not backup files |
| [Cleanup SQL Agent History](11-Maintenance-and-Integrity/09-Cleanup-SQL-Agent-History.sql) | Previews and optionally removes SQL Agent history older than a retention date. | PREVIEW BY DEFAULT; deletion removes msdb job history |
| [Cycle Error Logs](11-Maintenance-and-Integrity/10-Cycle-Error-Logs.sql) | Previews or cycles SQL Server and SQL Agent error logs. | PREVIEW BY DEFAULT; cycling creates new log files and affects retention numbering |

### 12-Data-Development-and-Utilities

Metadata search, dependencies, identities, temporal, CDC, and conversions.

| Script | Purpose | Safety |
|---|---|---|
| [Search Object Definitions](12-Data-Development-and-Utilities/01-Search-Object-Definitions.sql) | Searches T-SQL module definitions in the current database for a text pattern. | READ ONLY; encrypted module definitions cannot be searched |
| [Search Column Names](12-Data-Development-and-Utilities/02-Search-Column-Names.sql) | Finds columns by partial name and reports their data types and properties. | READ ONLY |
| [Object Dependencies](12-Data-Development-and-Utilities/03-Object-Dependencies.sql) | Reports objects that reference or are referenced by a selected current-database object. | READ ONLY; dynamic SQL and cross-database references may not be discoverable |
| [Table Row Counts](12-Data-Development-and-Utilities/04-Table-Row-Counts.sql) | Returns fast metadata-based row counts for every user table. | READ ONLY; counts reflect metadata and can differ during active transactions |
| [Identity Column Health](12-Data-Development-and-Utilities/05-Identity-Column-Health.sql) | Shows identity values, remaining capacity, and percentage consumed. | READ ONLY; percentage is most useful for positive incrementing integer identities |
| [Sequence Health](12-Data-Development-and-Utilities/06-Sequence-Health.sql) | Inventories sequences, current values, cache settings, and exhaustion risk. | READ ONLY |
| [Temporal Table Inventory](12-Data-Development-and-Utilities/07-Temporal-Table-Inventory.sql) | Lists system-versioned temporal tables, history tables, and period columns. | READ ONLY |
| [CDC Inventory](12-Data-Development-and-Utilities/08-CDC-Inventory.sql) | Reports database and table-level Change Data Capture configuration. | READ ONLY |
| [Session SET Options](12-Data-Development-and-Utilities/09-Session-SET-Options.sql) | Shows current session SET-option values that affect parsing, behavior, and plan reuse. | READ ONLY |
| [Epoch Date Converter](12-Data-Development-and-Utilities/10-Epoch-Date-Converter.sql) | Converts between Unix epoch seconds and SQL Server datetime2 values. | READ ONLY |

## Contribution standards

When adding or changing a script:

- Keep one primary DBA task per `.sql` file.
- Use SQL Server 2016-compatible syntax unless the filename and header clearly state otherwise.
- Begin with `SET NOCOUNT ON;`.
- Parameterize database names, thresholds, paths, and retention windows.
- Quote identifiers with `QUOTENAME` and escape string literals used in dynamic SQL.
- Make state-changing behavior opt-in with `DECLARE @Execute bit = 0;`.
- Document required permissions, workload impact, version limitations, and destructive risk.
- Never embed passwords, tokens, private hostnames, or environment-specific credentials.

## Repository layout

Each numbered folder represents a DBA workstream. Filenames are numbered to provide a stable reading order, while the tables above provide direct links and usage context.
