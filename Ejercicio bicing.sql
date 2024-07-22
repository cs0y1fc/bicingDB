SET FOREIGN_KEY_CHECKS = 0; -- quita error 1451
SET SQL_SAFE_UPDATES = 0; -- quita error 1175

USE bicingBCN ;
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
    IN p_N_de_cuenta VARCHAR(24),
    IN p_IdTarifa INT,
	IN p_saldo DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Usuario (DNI, Nombre, Apellido, Direccion, Correo_electronico, Telefono, N_de_cuenta, IdTarifa, saldo)
    VALUES (p_DNI, p_Nombre, p_Apellido, p_Direccion, p_Correo_electronico, p_Telefono, p_N_de_cuenta, p_IdTarifa, p_saldo);
END //
DELIMITER ;

CALL InsertarUsuario('12345678A', 'Juan', 'Pérez', 'Calle Falsa 123', 'juan.perez@example.com', 123456789, 'ES1234567890123456789012', '2', '80.01');

-- 	2- Procedure para devolver una bicicleta. (1 punto)
drop procedure if exists InsertarServicio;
DELIMITER //
CREATE PROCEDURE InsertarServicio(
    IN p_Usuario_DNI VARCHAR(15),
    IN p_Codigo_Bici VARCHAR(25)
)
BEGIN
	
    declare ID_del_servicio int;
    set ID_del_servicio = (select idServicio from servicio where usuario_DNI = p_Usuario_DNI order by idServicio desc limit 1);
	
    IF (select Fecha_fin_servicio from servicio where idServicio = ID_del_servicio order by idServicio desc limit 1) is NULL then
		UPDATE Servicio SET Fecha_fin_servicio = (select now()) where idServicio = ID_del_servicio;
		UPDATE tiempo_uso SET Tiempo_uso = ( (select time(NOW())) - (select TIME(Fecha_inicio_servicio) from servicio where usuario_DNI = p_Usuario_DNI order by idServicio desc limit 1)) where idTiempo_uso = ID_del_servicio;
        Update Bicicletas set Estado = 'Disponible' where Codigo = p_Codigo_Bici;
	else
		select "Ya ha devuelto la bici";
	end if;
END //
DELIMITER ;

-- Para ejecutar este PROCEDURE es necesario ejecutar primero el PRIMER TRIGGER para alquilar una bici
CALL InsertarServicio('45678901D', 'B004');

select * from servicio;
select * from tiempo_uso;
select * from bicicletas;
select * from Tarifa;

-- 	3- Procedure para calcular el coste total de alquiler por usuario. (1 punto)
drop procedure if exists CalcularCosteTotalAlquiler;
DELIMITER //
CREATE PROCEDURE CalcularCosteTotalAlquiler(
    IN p_Usuario_DNI VARCHAR(15)
)
BEGIN
    -- Declarar una variable para almacenar el coste total
    SET @coste_total = (SELECT (t.precio + (select SUM(ti.multa) 
											from servicio s join tiempo_uso ti on s.idTiempo_uso=ti.idTiempo_uso 
											where s.usuario_DNI = p_Usuario_DNI)) 
						FROM USUARIO u JOIN Tarifa t on u.IdTarifa=t.IdTarifa 
                        WHERE u.DNI = p_Usuario_DNI);
    
    -- Obtener el valor del parámetro de salida
    SELECT @coste_total AS CosteTotalAlquiler;
    
END //
DELIMITER ;

-- Llamar al procedimiento
CALL CalcularCosteTotalAlquiler('45678901D');

select * from servicio;
select * from tiempo_uso;
select * from usuario;

-- 	4- Procedure para generar reporte de ingresos mensuales. (1 punto)
	DELIMITER //

CREATE PROCEDURE CalcularIngresosMensuales()
BEGIN
    -- Crear una tabla temporal para almacenar los ingresos mensuales
    DROP TEMPORARY TABLE IF EXISTS IngresosMensuales;
    CREATE TEMPORARY TABLE IngresosMensuales (
        Mes VARCHAR(7),
        IngresoTotal DECIMAL(10, 2)
    );

    -- Calcular los ingresos mensuales
    INSERT INTO IngresosMensuales (Mes, IngresoTotal)
    SELECT 
        DATE_FORMAT(Fecha_fin_servicio, '%Y-%m') AS Mes,
        SUM(CASE
            WHEN t.Tipo_Tarifa LIKE 'Tarifa Plana%' THEN t.Precio
            WHEN t.Tipo_Tarifa LIKE 'Tarifa por Uso%' THEN
                CASE
                    WHEN tu.Tiempo_uso <= '00:30:00' THEN 0.35
                    WHEN tu.Tiempo_uso <= '02:00:00' THEN 0.90
                    ELSE 5.00
                END
            ELSE 0
        END + tu.Multa) AS IngresoTotal
    FROM Servicio s
    JOIN usuario u ON s.usuario_DNI = u.DNI
    JOIN Tarifa t ON u.IdTarifa = t.idTarifa
    JOIN Tiempo_uso tu ON s.idTiempo_uso = tu.idTiempo_uso
    GROUP BY DATE_FORMAT(Fecha_fin_servicio, '%Y-%m');

    -- Seleccionar los resultados
    SELECT * FROM IngresosMensuales;
END //

DELIMITER ;
call CalcularIngresosMensuales();














































-- - Ejercicios de Triggers
-- 	1- Trigger para evitar el alquiler de bicicletas no disponibles. (1 punto)

drop trigger if exists Alquiler_bicis;
delimiter //
create trigger Alquiler_bicis
after insert on solicitud_uso_bicicleta
for each row
begin 
	declare estado_bici varchar (15);
    set estado_bici = (select Estado from bicicletas where Codigo = NEW.bicicletas_Codigo);
    SET @skip_devolucion_bici = 1; -- Variable para que funcione el trigger devolucion_bici
    
	if estado_bici like 'Disponible' then
		INSERT INTO servicio values (default,NEW.usuario_DNI,NEW.bicicletas_Codigo,NEW.Fecha_inicio_solicitud,NULL,1);
        SET @last_id = (Select idServicio from servicio where usuario_DNI = NEW.usuario_DNI order by idServicio desc limit 1);
        INSERT INTO Tiempo_uso VALUES (@last_id,NULL, NULL);
        update servicio set idTiempo_uso = @last_id where idServicio = @last_id;
        update bicicletas set Estado = 'En uso' where Codigo = NEW.bicicletas_Codigo;
	end if;
    
    SET @skip_devolucion_bici = NULL;
end //
delimiter ;

-- Insert into solicitud_uso_bicicleta values (default,'12345678A','B002', DATE_SUB(DATE_SUB(NOW(), INTERVAL 3 HOUR), interval 22 MINUTE));
Insert into solicitud_uso_bicicleta values (default,'45678901D','B004', NOW());

Select * from control_de_triggers;
select * from servicio;
select * from tiempo_uso;
select * from bicicletas;
select * from solicitud_uso_bicicleta;
-- 2- Trigger para actualizar el estado de la bicicleta al devolverla. (1 punto)

drop trigger if exists devolucion_bici;
delimiter //
create trigger devolucion_bici
after update on servicio
for each row
begin 
	
    declare tarifa_usuario int; -- Obtener la tarifa que usa el usuario
	declare tiempo_bici_fuera time; -- Obtener la diferencia de tiempo entre el inicio y la finalizacion del uso de vici
    declare tiempo_bici_alquilada decimal (20,2); -- Variable de tiempo en decimal para poder calcular en el caso de que supere las 2 horas
    
	IF @skip_devolucion_bici IS NULL THEN

		set tarifa_usuario = (select IdTarifa from usuario where DNI = new.usuario_DNI);
		set tiempo_bici_fuera = ( (select time(NOW())) - (select TIME(Fecha_inicio_servicio) from servicio where usuario_DNI = new.usuario_DNI order by idServicio desc limit 1));
		set tiempo_bici_alquilada = (TIMESTAMPDIFF (MINUTE, (select TIME(Fecha_inicio_servicio) from servicio where usuario_DNI = new.usuario_DNI order by idServicio desc limit 1),(NOW()))/60);
    
		update bicicletas set Estado = 'Disponible' 
		where Codigo = (select bicicletas_Codigo from servicio where usuario_DNI = '45678901D' order by idServicio desc limit 1);
    
		if tarifa_usuario = 1 OR tarifa_usuario = 3 then
			if tiempo_bici_alquilada <= 0.5 then
				update tiempo_uso set Tiempo_uso = tiempo_bici_fuera, Multa = 0
				where idtiempo_uso = (select max(idtiempo_uso) from servicio where usuario_DNI = new.usuario_DNI);
			elseif tiempo_bici_alquilada > 0.50 AND tiempo_bici_alquilada <= 2 then
				update tiempo_uso set Tiempo_uso = tiempo_bici_fuera, Multa = 0.70
				where idtiempo_uso = (select max(idtiempo_uso) from servicio where usuario_DNI = new.usuario_DNI);
			else 
				update tiempo_uso set Tiempo_uso = tiempo_bici_fuera, Multa = (0.70 + ((select FLOOR(tiempo_bici_alquilada)-2) * 5))
				where idtiempo_uso = (select max(idtiempo_uso) from servicio where usuario_DNI = new.usuario_DNI);
			end if;
		elseif tarifa_usuario = 2 OR tarifa_usuario = 4 then
			if tiempo_bici_alquilada <= 0.5 then
				update tiempo_uso set Tiempo_uso = tiempo_bici_fuera, Multa = 0.35
				where idtiempo_uso = (select max(idtiempo_uso) from servicio where usuario_DNI = new.usuario_DNI);
			elseif tiempo_bici_alquilada > 0.50 AND tiempo_bici_alquilada <= 2 then
				update tiempo_uso set Tiempo_uso = tiempo_bici_fuera, Multa = 0.35 + 0.9
				where idtiempo_uso = (select max(idtiempo_uso) from servicio where usuario_DNI = new.usuario_DNI);
			else 
				update tiempo_uso set Tiempo_uso = tiempo_bici_fuera, Multa = (0.35 + 0.9 + ((select FLOOR(tiempo_bici_alquilada)-2) * 5))
				where idtiempo_uso = (select max(idtiempo_uso) from servicio where usuario_DNI = new.usuario_DNI);
			END IF;
		END IF;

		SET @Multa = (Select Multa from tiempo_uso t JOIN SERVICIO s on t.idTiempo_uso = s.idTiempo_uso  where s.usuario_DNI = new.usuario_DNI order by s.idServicio desc LIMIT 1);

		update usuario set saldo = saldo - @Multa
		where DNI = new.usuario_DNI;
    
 	END IF;
	
end //
delimiter ;

update servicio set Fecha_fin_servicio = now() where idServicio =(select max(idServicio) from servicio where usuario_DNI='45678901D');

select * from usuario;
select * from servicio;
select * from tiempo_uso;
select * from bicicletas;

-- 3- Trigger para actualizar el saldo del usuario después de un alquiler. (1 punto)



-- - Ejercicios de Eventos
-- 	1- Evento para enviar notificaciones de alquileres próximos a vencer. (1,5 punto)
-- Crea un evento que se ejecute cada hora y envíe notificaciones a los usuarios cuyas bicicletas alquiladas están próximas a vencer (por ejemplo, dentro de la próxima hora). Este ejemplo asume la existencia de una tabla notificaciones para registrar las notificaciones.
-- Frecuencia: Cada hora.
-- Acción: Enviar notificaciones a los usuarios.

-- 2- Evento para archivar alquileres antiguos. (1,5 punto)
-- Crea un evento que se ejecute una vez al año y mueva los registros de alquileres que tengan más de dos años a una tabla de archivo (alquileres_archivo).
-- Frecuencia: Anual.
-- Acción: Archivar registros antiguos.
-- Creacion tabla nueva Alquileres archivados
CREATE TABLE IF NOT EXISTS alquileres_archivo (
  idServicio INT NOT NULL,
  usuario_DNI VARCHAR(9) NOT NULL,
  bicicletas_Codigo VARCHAR(10) NOT NULL,
  Fecha_inicio_servicio DATETIME NOT NULL,
  Fecha_fin_servicio VARCHAR(45) NULL,
  idTiempo_uso INT NOT NULL,
  PRIMARY KEY (idServicio)
) ENGINE = InnoDB;
DELIMITER //


CREATE PROCEDURE ArchivarAlquileresAntiguos()
BEGIN
  -- Insertar los registros antiguos en la tabla de archivo
  INSERT INTO alquileres_archivo (idServicio, usuario_DNI, bicicletas_Codigo, Fecha_inicio_servicio, Fecha_fin_servicio, idTiempo_uso)
  SELECT idServicio, usuario_DNI, bicicletas_Codigo, Fecha_inicio_servicio, Fecha_fin_servicio, idTiempo_uso
  FROM Servicio
  WHERE Fecha_fin_servicio < DATE_SUB(NOW(), INTERVAL 2 YEAR);
  
  -- Eliminar los registros antiguos de la tabla original
  DELETE FROM Servicio
  WHERE Fecha_fin_servicio < DATE_SUB(NOW(), INTERVAL 2 YEAR);
END //

DELIMITER ;

-- Crear el evento naul de Inserción de los valores que tengan mas de 2 años
DELIMITER //

CREATE EVENT IF NOT EXISTS ArchivarAlquileresAnualmente
ON SCHEDULE
  EVERY 1 YEAR
  STARTS '2024-01-01 00:00:00'
DO
  CALL ArchivarAlquileresAntiguos();

DELIMITER ;



