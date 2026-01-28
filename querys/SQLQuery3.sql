USE Alquiler_Vehiculos;
GO

-- Índice en la placa de vehículos
CREATE INDEX IX_Vehiculos_Placa ON Vehiculos(Placa);

-- Índice en el email de clientes
CREATE INDEX IX_Clientes_Email ON Clientes(Email);


-- Habilitar estadísticas para análisis de rendimiento
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Consulta de prueba optimizada
SELECT c.ContratoID, cl.Nombre, v.Placa
FROM Contratos c
JOIN Clientes cl ON c.ClienteID = cl.ClienteID
JOIN Vehiculos v ON c.VehiculoID = v.VehiculoID
WHERE v.Marca = 'Toyota';


-- Insertar 1000 contratos de prueba (ejemplo con bucle)
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO Contratos (ClienteID, VehiculoID, EmpleadoID, FechaFin, MontoTotal)
    VALUES (1, 1, 2, DATEADD(DAY, 7, GETDATE()), 200.00);
    SET @i = @i + 1;
END;

-- Crear usuario de prueba
CREATE USER UsuarioAgente WITHOUT LOGIN;
ALTER ROLE RolAgente ADD MEMBER UsuarioAgente;

CREATE USER UsuarioCliente WITHOUT LOGIN;
ALTER ROLE RolCliente ADD MEMBER UsuarioCliente;

DECLARE @Cedula NVARCHAR(20) 
SET @Cedula= '0102030405';

EXEC sp_executesql 
    N'SELECT Nombre, Apellido FROM Clientes WHERE Cedula = @Cedula',
    N'@Cedula NVARCHAR(20)',
    @Cedula = @Cedula;

-- Insertar usuario con contraseña cifrada
INSERT INTO Clientes (Nombre, Apellido, Cedula, Email, Telefono, Direccion)
VALUES ('Luis', 'Torres', '9988776655', 'luis.torres@email.com', '0912345678', 'Ambato');

-- Ejemplo de hash (SHA2_256)
DECLARE @Password NVARCHAR(100) = 'MiClaveSegura123';
SELECT HASHBYTES('SHA2_256', @Password);

