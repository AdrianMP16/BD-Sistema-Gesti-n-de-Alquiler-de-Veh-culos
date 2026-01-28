USE Alquiler_Vehiculos;
GO

-- ============================================
-- TABLAS PRINCIPALES
-- ============================================

-- Clientes
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Cedula NVARCHAR(20) UNIQUE NOT NULL,
    Email NVARCHAR(150) UNIQUE NOT NULL,
    Telefono NVARCHAR(20),
    Direccion NVARCHAR(200)
);

-- Vehículos
CREATE TABLE Vehiculos (
    VehiculoID INT PRIMARY KEY IDENTITY(1,1),
    Placa NVARCHAR(10) UNIQUE NOT NULL,
    Marca NVARCHAR(50) NOT NULL,
    Modelo NVARCHAR(50) NOT NULL,
    Año INT CHECK (Año > 1980),
    PrecioDia DECIMAL(10,2) NOT NULL CHECK (PrecioDia > 0),
    Disponible BIT DEFAULT 1
);

-- Empleados
CREATE TABLE Empleados (
    EmpleadoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Cargo NVARCHAR(50) CHECK (Cargo IN ('Administrador','Agente','Mantenimiento')) NOT NULL,
    Email NVARCHAR(150) UNIQUE NOT NULL
);

-- Contratos de alquiler
CREATE TABLE Contratos (
    ContratoID INT PRIMARY KEY IDENTITY(1,1),
    ClienteID INT NOT NULL,
    VehiculoID INT NOT NULL,
    EmpleadoID INT NULL,
    FechaInicio DATE NOT NULL DEFAULT GETDATE(),
    FechaFin DATE NOT NULL,
    MontoTotal DECIMAL(12,2) NOT NULL CHECK (MontoTotal > 0),
    CONSTRAINT FK_Contratos_Clientes FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID) ON DELETE CASCADE,
    CONSTRAINT FK_Contratos_Vehiculos FOREIGN KEY (VehiculoID) REFERENCES Vehiculos(VehiculoID) ON DELETE CASCADE,
    CONSTRAINT FK_Contratos_Empleados FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID) ON DELETE SET NULL
);

-- Pagos
CREATE TABLE Pagos (
    PagoID INT PRIMARY KEY IDENTITY(1,1),
    ContratoID INT NOT NULL,
    FechaPago DATE NOT NULL DEFAULT GETDATE(),
    Monto DECIMAL(12,2) NOT NULL CHECK (Monto > 0),
    Metodo NVARCHAR(50) CHECK (Metodo IN ('Efectivo','Tarjeta','Transferencia')),
    CONSTRAINT FK_Pagos_Contratos FOREIGN KEY (ContratoID) REFERENCES Contratos(ContratoID) ON DELETE CASCADE
);

-- Auditoría
CREATE TABLE Auditoria (
    AuditoriaID INT PRIMARY KEY IDENTITY(1,1),
    Tabla NVARCHAR(50),
    Operacion NVARCHAR(50),
    Fecha DATETIME DEFAULT GETDATE(),
    UsuarioSistema NVARCHAR(100)
);

-- ============================================
-- VISTAS
-- ============================================
CREATE VIEW VistaContratosActivos AS
SELECT c.ContratoID, cl.Nombre + ' ' + cl.Apellido AS Cliente,
       v.Placa, v.Marca, v.Modelo,
       c.FechaInicio, c.FechaFin, c.MontoTotal
FROM Contratos c
JOIN Clientes cl ON c.ClienteID = cl.ClienteID
JOIN Vehiculos v ON c.VehiculoID = v.VehiculoID
WHERE c.FechaFin >= GETDATE();
GO

-- ============================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================
IF OBJECT_ID('spRegistrarContrato', 'P') IS NOT NULL
    DROP PROCEDURE spRegistrarContrato;
GO

CREATE PROCEDURE spRegistrarContrato
    @ClienteID INT,
    @VehiculoID INT,
    @EmpleadoID INT,
    @FechaFin DATE,
    @MontoTotal DECIMAL(12,2)
AS
BEGIN
    UPDATE Vehiculos SET Disponible = 0 WHERE VehiculoID = @VehiculoID;
    INSERT INTO Contratos (ClienteID, VehiculoID, EmpleadoID, FechaFin, MontoTotal)
    VALUES (@ClienteID, @VehiculoID, @EmpleadoID, @FechaFin, @MontoTotal);
END;
GO


-- ============================================
-- TRIGGERS DE AUDITORÍA
-- ============================================
CREATE TRIGGER trg_AuditoriaContratos
ON Contratos
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Operacion NVARCHAR(50);
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE
        SET @Operacion = 'DELETE';

    INSERT INTO Auditoria (Tabla, Operacion, UsuarioSistema)
    VALUES ('Contratos', @Operacion, SYSTEM_USER);
END;
GO

-- ============================================
-- ROLES Y PERMISOS
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'RolAdmin')
    CREATE ROLE RolAdmin;
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'RolAgente')
    CREATE ROLE RolAgente;
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'RolCliente')
    CREATE ROLE RolCliente;
GO

-- Ejemplo de permisos
GRANT SELECT, INSERT, UPDATE, DELETE ON Clientes TO RolAgente;
GRANT SELECT ON Vehiculos TO RolCliente;
GRANT SELECT, INSERT ON Contratos TO RolAgente;
GRANT SELECT ON VistaContratosActivos TO RolCliente;
GO

-- ============================================
-- DATOS DE PRUEBA
-- ============================================

-- Clientes
INSERT INTO Clientes (Nombre, Apellido, Cedula, Email, Telefono, Direccion)
VALUES 
('Juan', 'Pérez', '0102030405', 'juan.perez@email.com', '0991234567', 'Quito'),
('María', 'Gómez', '1122334455', 'maria.gomez@email.com', '0987654321', 'Guayaquil');

-- Empleados
INSERT INTO Empleados (Nombre, Apellido, Cargo, Email)
VALUES 
('Carlos', 'Ramírez', 'Administrador', 'carlos.ramirez@empresa.com'),
('Ana', 'Lopez', 'Agente', 'ana.lopez@empresa.com');

-- Vehículos
INSERT INTO Vehiculos (Placa, Marca, Modelo, Año, PrecioDia)
VALUES 
('ABC1234', 'Toyota', 'Corolla', 2020, 35.00),
('XYZ5678', 'Chevrolet', 'Spark', 2019, 25.00),
('LMN9012', 'Hyundai', 'Tucson', 2021, 50.00);

-- Contratos
INSERT INTO Contratos (ClienteID, VehiculoID, EmpleadoID, FechaFin, MontoTotal)
VALUES 
(1, 1, 2, '2026-02-05', 175.00),
(2, 3, 2, '2026-02-10', 250.00);

-- Pagos
INSERT INTO Pagos (ContratoID, FechaPago, Monto, Metodo)
VALUES 
(1, GETDATE(), 175.00, 'Tarjeta'),
(2, GETDATE(), 250.00, 'Efectivo');

