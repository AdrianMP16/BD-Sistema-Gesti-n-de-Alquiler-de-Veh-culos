USE Alquiler_Vehiculos;
GO

-- Mostrar clientes cuyo apellido sea 'Pérez'
SELECT ClienteID, Nombre, Apellido, Email
FROM Clientes
WHERE Apellido = 'Pérez';

-- Listar contratos con datos del cliente y vehículo
SELECT c.ContratoID, cl.Nombre + ' ' + cl.Apellido AS Cliente,
       v.Placa, v.Marca, v.Modelo, c.FechaInicio, c.FechaFin, c.MontoTotal
FROM Contratos c
JOIN Clientes cl ON c.ClienteID = cl.ClienteID
JOIN Vehiculos v ON c.VehiculoID = v.VehiculoID;

-- Calcular el total de pagos realizados en el sistema
SELECT SUM(Monto) AS TotalPagos, COUNT(*) AS NumeroPagos
FROM Pagos;

-- Mostrar nombres de empleados en mayúsculas y longitud de sus apellidos
SELECT UPPER(Nombre) AS NombreMayus, LEN(Apellido) AS LargoApellido
FROM Empleados;

-- Clientes que tienen contratos con monto mayor a 200
SELECT Nombre, Apellido
FROM Clientes
WHERE ClienteID IN (
    SELECT ClienteID
    FROM Contratos
    WHERE MontoTotal > 200
);

-- Crear una vista que muestre el total pagado por contrato
CREATE VIEW VistaPagosPorContrato AS
SELECT c.ContratoID, SUM(p.Monto) AS TotalPagado
FROM Contratos c
JOIN Pagos p ON c.ContratoID = p.ContratoID
GROUP BY c.ContratoID;

-- Actualizar disponibilidad de un vehículo
UPDATE Vehiculos SET Disponible = 1 WHERE VehiculoID = 2;

-- Eliminar un pago específico
DELETE FROM Pagos WHERE PagoID = 1;

-- Insertar un nuevo cliente
INSERT INTO Clientes (Nombre, Apellido, Cedula, Email, Telefono, Direccion)
VALUES ('Pedro', 'Martínez', '5566778899', 'pedro.martinez@email.com', '0976543210', 'Cuenca');

