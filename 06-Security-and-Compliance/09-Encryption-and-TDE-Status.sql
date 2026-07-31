/*
Title: Encryption and TDE Status
Purpose: Reports database encryption state and key metadata.
Compatibility: SQL Server 2016+
Safety: READ ONLY

Review results and test in a non-production environment before making changes.
*/
SET NOCOUNT ON;

SELECT
    d.name AS DatabaseName,
    dek.encryption_state,
    CASE dek.encryption_state
        WHEN 0 THEN N'No encryption key'
        WHEN 1 THEN N'Unencrypted'
        WHEN 2 THEN N'Encryption in progress'
        WHEN 3 THEN N'Encrypted'
        WHEN 4 THEN N'Key change in progress'
        WHEN 5 THEN N'Decryption in progress'
        WHEN 6 THEN N'Protection change in progress'
    END AS EncryptionStateDescription,
    dek.percent_complete, dek.key_algorithm, dek.key_length,
    dek.encryptor_type
FROM sys.databases AS d
LEFT JOIN sys.dm_database_encryption_keys AS dek ON dek.database_id = d.database_id
ORDER BY d.name;
