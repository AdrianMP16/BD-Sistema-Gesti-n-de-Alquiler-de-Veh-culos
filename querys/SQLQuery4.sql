-- Backup completo
BACKUP DATABASE AlquilerVehiculosDB
TO DISK = 'C:\Backups\AlquilerVehiculosDB_Full.bak';

-- Backup diferencial
BACKUP DATABASE AlquilerVehiculosDB
TO DISK = 'C:\Backups\AlquilerVehiculosDB_Diff.bak'
WITH DIFFERENTIAL;

-- Backup de log (incremental)
BACKUP LOG AlquilerVehiculosDB
TO DISK = 'C:\Backups\AlquilerVehiculosDB_Log.trn';
