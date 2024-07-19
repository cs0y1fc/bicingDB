-- PROGRAMACION SOBRE BICING

-- - Ejercicios de Procedures
-- 1- Procedure para registrar un nuevo usuario. (1 punto)
drop procedure if exists InsertarUsuario;
DELIMITER //

CREATE PROCEDURE InsertarUsuario(
    IN p_DNI VARCHAR(9),
    IN p_Nombre VARCHAR(100),
    IN p_Apellido VARCHAR(100),
    IN p_Direccion VARCHAR(100),
    IN p_Correo_electronico VARCHAR(100),
    IN p_Telefono INT,
    IN p_N_de_cuenta VARCHAR(24)
)
BEGIN
    INSERT INTO Usuario (DNI, Nombre, Apellido, Direccion, Correo_electronico, Telefono, N_de_cuenta)
    VALUES (p_DNI, p_Nombre, p_Apellido, p_Direccion, p_Correo_electronico, p_Telefono, p_N_de_cuenta);
END //

DELIMITER ;

CALL InsertarUsuario('12345678A', 'Juan', 'Pérez', 'Calle Falsa 123', 'juan.perez@example.com', 123456789, 'ES1234567890123456789012');


-- 	2- Procedure para devolver una bicicleta. (1 punto)
drop procedure if exists InsertarServicio;

DELIMITER //

CREATE PROCEDURE InsertarServicio(
    IN p_Usuario_DNI VARCHAR(15),
    IN p_Codigo_Bici VARCHAR(25),
    IN p_Tipo_de_tarifa VARCHAR(45),
    IN p_Precio_tarifa DECIMAL(10,2),
    IN p_Tiempo_de_uso TIME,
    IN p_Suma_penalizacion DECIMAL(10,2),
    IN p_Fecha_servicio DATETIME
)
BEGIN
    INSERT INTO Servicio (Usuario_DNI, Codigo_Bici, Tipo_de_tarifa, Precio_tarifa, Tiempo_de_uso, Suma_penalizacion, Fecha_servicio)
    VALUES (p_Usuario_DNI, p_Codigo_Bici, p_Tipo_de_tarifa, p_Precio_tarifa, p_Tiempo_de_uso, p_Suma_penalizacion, p_Fecha_servicio);
END //

DELIMITER ;

CALL InsertarServicio('36351423O', 'A001', 'Tarifa plana', 50.00, '00:30:00', 0.00, '2023-07-01 10:00:00');

-- 	3- Procedure para calcular el coste total de alquiler por usuario. (1 punto)
drop procedure if exists CalcularCosteTotalAlquiler;
DELIMITER //

CREATE PROCEDURE CalcularCosteTotalAlquiler(
    IN p_Usuario_DNI VARCHAR(15),
    OUT p_CosteTotal DECIMAL(10,2)
)
BEGIN
    SELECT SUM(Precio_tarifa + Suma_penalizacion)
    INTO p_CosteTotal
    FROM Servicio
    WHERE Usuario_DNI = p_Usuario_DNI;
END //

DELIMITER ;

-- Declarar una variable para almacenar el coste total
SET @coste_total = 0;

-- Llamar al procedimiento
CALL CalcularCosteTotalAlquiler('36351423O', @coste_total);

-- Obtener el valor del parámetro de salida
SELECT @coste_total AS CosteTotalAlquiler;


-- 	4- Procedure para generar reporte de ingresos mensuales. (1 punto)
	
USE bicingBCN;

-- Añadir la columna Fecha_servicio
ALTER TABLE Servicio
ADD COLUMN Fecha_servicio DATETIME;

-- Actualizar registros existentes con fechas y horas específicas

UPDATE Servicio
SET Fecha_servicio = '2023-07-01 10:00:00'
WHERE Usuario_DNI = '36351423O' AND Codigo_Bici = 'A001';

UPDATE Servicio
SET Fecha_servicio = '2023-07-02 12:30:00'
WHERE Usuario_DNI = '27364619Y' AND Codigo_Bici = 'A002';

UPDATE Servicio
SET Fecha_servicio = '2023-07-03 15:00:00'
WHERE Usuario_DNI = '36351423O' AND Codigo_Bici = 'A003';

UPDATE Servicio
SET Fecha_servicio = '2023-07-04 18:45:00'
WHERE Usuario_DNI = '36351423O' AND Codigo_Bici = 'A002';

-- Verificar los cambios
SELECT * FROM Servicio;

USE bicingBCN;

-- Crear el procedimiento para calcular los ingresos mensuales
drop procedure if exists CalcularIngresosMensuales;

DELIMITER //

CREATE PROCEDURE CalcularIngresosMensuales()
BEGIN
    SELECT 
        DATE_FORMAT(Fecha_servicio, '%Y-%m') AS Mes,
        SUM(Precio_tarifa + Suma_penalizacion) AS IngresosMensuales
    FROM 
        Servicio
    GROUP BY 
        DATE_FORMAT(Fecha_servicio, '%Y-%m')
    ORDER BY 
        Mes;
END //

DELIMITER ;



-- - Ejercicios de Triggers
-- 	1- Trigger para evitar el alquiler de bicicletas no disponibles. (1 punto)
-- 2- Trigger para actualizar el estado de la bicicleta al devolverla. (1 punto)
-- 3- Trigger para actualizar el saldo del usuario después de un alquiler. (1 punto)

-- - Ejercicios de Eventos
-- 	1- Evento para enviar notificaciones de alquileres próximos a vencer. (1 punto)
-- Crea un evento que se ejecute cada hora y envíe notificaciones a los usuarios cuyas bicicletas alquiladas están próximas a vencer (por ejemplo, dentro de la próxima hora). Este ejemplo asume la existencia de una tabla notificaciones para registrar las notificaciones.
-- Frecuencia: Cada hora.
-- Acción: Enviar notificaciones a los usuarios.

-- 2- Evento para archivar alquileres antiguos. (1 punto)
-- Crea un evento que se ejecute una vez al año y mueva los registros de alquileres que tengan más de dos años a una tabla de archivo (alquileres_archivo).
-- Frecuencia: Anual.
-- Acción: Archivar registros antiguos.
