
DROP SCHEMA IF EXISTS bicingbcn ;

CREATE SCHEMA IF NOT EXISTS bicingbcn DEFAULT CHARACTER SET utf8 ;
USE bicingbcn ;

CREATE TABLE IF NOT EXISTS zona_de_mantenimiento (
  IDZona INT(11) NOT NULL AUTO_INCREMENT,
  Nom_Zona VARCHAR(100) NOT NULL,
  PRIMARY KEY (IDZona))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

CREATE TABLE IF NOT EXISTS personal_ayuntamiento (
  ID_Encargado INT(11) NOT NULL AUTO_INCREMENT,
  Nom_empleado VARCHAR(100) NOT NULL,
  Apellido_empleado VARCHAR(100) NOT NULL,
  Telefono INT(9) NOT NULL,
  Cargo VARCHAR(30) NOT NULL,
  Zona_de_mantenimiento_IDZona INT(3) NULL DEFAULT NULL,
  PRIMARY KEY (ID_Encargado),
  CONSTRAINT fk_Personal_Ayuntamiento_Zona_de_mantenimiento1
    FOREIGN KEY (Zona_de_mantenimiento_IDZona)
    REFERENCES bicingbcn.zona_de_mantenimiento (IDZona))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS estacion_de_bicicletas (
  idEstacion INT(11) NOT NULL AUTO_INCREMENT,
  Distrito VARCHAR(100) NOT NULL,
  Calle VARCHAR(100) NOT NULL,
  Encargados_del_man_ID_Encargado INT(11) NOT NULL,
  PRIMARY KEY (idEstacion),
  CONSTRAINT fk_Estacion_Encargados_del_man_1
    FOREIGN KEY (Encargados_del_man_ID_Encargado)
    REFERENCES bicingbcn.personal_ayuntamiento (ID_Encargado))

ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS bicicletas (
  Codigo VARCHAR(10) NOT NULL,
  Modelo VARCHAR(20) NOT NULL,
  IDEstacion INT(11) NOT NULL,
  Estado ENUM('En_uso', 'Disponible', 'En_Reparación') NOT NULL,
  Zona_de_mantenimiento_IDZona INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (Codigo),
  CONSTRAINT fk_Bicicletas_Estacion1
    FOREIGN KEY (IDEstacion)
    REFERENCES bicingbcn.estacion_de_bicicletas (idEstacion),
  CONSTRAINT fk_Bicicletas_Zona_de_mantenimiento1
    FOREIGN KEY (Zona_de_mantenimiento_IDZona)
    REFERENCES bicingbcn.zona_de_mantenimiento (IDZona));

CREATE TABLE IF NOT EXISTS Tarifa (
  idTarifa INT NOT NULL AUTO_INCREMENT,
  Tipo_Tarifa VARCHAR(45) NOT NULL,
  Precio FLOAT NOT NULL,
  Descripcion text NOT NULL,
  PRIMARY KEY (idTarifa))
ENGINE = InnoDB;
SHOW WARNINGS;


CREATE TABLE IF NOT EXISTS usuario (
  DNI VARCHAR(9) NOT NULL,
  Nombre VARCHAR(100) NOT NULL,
  Apellido VARCHAR(100) NOT NULL,
  Direccion VARCHAR(100) NOT NULL,
  Correo_electronico VARCHAR(100) NOT NULL,
  Telefono INT(9) NOT NULL,
  N_de_cuenta VARCHAR(24) NOT NULL,
  IdTarifa INT NOT NULL,
  saldo DECIMAL(10, 2) NOT NULL DEFAULT 1000.00,
  PRIMARY KEY (DNI),
  CONSTRAINT fk_usuario_Tarifa1
    FOREIGN KEY (IdTarifa)
    REFERENCES bicingbcn.Tarifa (idTarifa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS Tiempo_uso (
  idTiempo_uso INT NOT NULL AUTO_INCREMENT,
  Tiempo_uso TIME NULL,
  Multa FLOAT NULL,
  PRIMARY KEY (idTiempo_uso))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Servicio (
  idServicio INT NOT NULL AUTO_INCREMENT,
  usuario_DNI VARCHAR(9) NOT NULL,
  bicicletas_Codigo VARCHAR(10) NOT NULL,
  Fecha_inicio_servicio DATETIME NOT NULL,
  Fecha_fin_servicio DATETIME NULL,
  idTiempo_uso INT NOT NULL,
  PRIMARY KEY (idServicio),
  CONSTRAINT fk_Servicio_usuario1
    FOREIGN KEY (usuario_DNI)
    REFERENCES bicingbcn.usuario (DNI)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Servicio_bicicletas1
    FOREIGN KEY (bicicletas_Codigo)
    REFERENCES bicingbcn.bicicletas (Codigo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Servicio_Tiempo_uso1
    FOREIGN KEY (idTiempo_uso)
    REFERENCES bicingbcn.Tiempo_uso (idTiempo_uso)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS solicitud_uso_bicicleta (
  idSolicitud INT NOT NULL AUTO_INCREMENT,
  usuario_DNI VARCHAR(9) NOT NULL,
  bicicletas_Codigo VARCHAR(10) NOT NULL,
  Fecha_inicio_solicitud DATETIME NOT NULL,
  PRIMARY KEY (idSolicitud),
  CONSTRAINT fk_solicitud_usuario1
    FOREIGN KEY (usuario_DNI)
    REFERENCES bicingbcn.usuario (DNI));
    
CREATE TABLE IF NOT EXISTS Notificaciones (
  ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Usuario_DNI VARCHAR(9) NOT NULL,
  Bicicleta varchar(10) NOT NULL,
  Mensaje TEXT NOT NULL
) ENGINE = InnoDB;
    
INSERT INTO zona_de_mantenimiento (Nom_Zona) VALUES ('Eixample');
INSERT INTO zona_de_mantenimiento (Nom_Zona) VALUES ('Gracia');
INSERT INTO zona_de_mantenimiento (Nom_Zona) VALUES ('Sants-Montjuïc');
INSERT INTO zona_de_mantenimiento (Nom_Zona) VALUES ('Sant Martí');
INSERT INTO zona_de_mantenimiento (Nom_Zona) VALUES ('Ciutat Vella');

INSERT INTO personal_ayuntamiento (Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES ('Carlos', 'González', 600123456, 'Recogida', NULL);
INSERT INTO personal_ayuntamiento (Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES ('Ana', 'Martínez', 600234567, 'Mantenimiento', 2);
INSERT INTO personal_ayuntamiento (Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES ('Luis', 'Pérez', 600345678, 'Recogida', NULL);
INSERT INTO personal_ayuntamiento (Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES ('Marta', 'López', 600456789, 'Mantenimiento', 4);
INSERT INTO personal_ayuntamiento (Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES ('Jorge', 'Rodríguez', 600567890, 'Mantenimiento', 5);

INSERT INTO estacion_de_bicicletas (Distrito, Calle, Encargados_del_man_ID_Encargado) VALUES ('Eixample', 'Calle Aragón', 1);
INSERT INTO estacion_de_bicicletas (Distrito, Calle, Encargados_del_man_ID_Encargado) VALUES ('Gracia', 'Calle Gran de Gracia', 1);
INSERT INTO estacion_de_bicicletas (Distrito, Calle, Encargados_del_man_ID_Encargado) VALUES ('Sants-Montjuïc', 'Calle Sants', 3);
INSERT INTO estacion_de_bicicletas (Distrito, Calle, Encargados_del_man_ID_Encargado) VALUES ('Sant Martí', 'Calle Rambla Prim', 1);
INSERT INTO estacion_de_bicicletas (Distrito, Calle, Encargados_del_man_ID_Encargado) VALUES ('Ciutat Vella', 'Calle Portal de l\'Àngel', 3);

INSERT INTO bicicletas (Codigo, Modelo, IDEstacion, Estado, Zona_de_mantenimiento_IDZona) VALUES ('B001', 'Mecánica', 1, 'Disponible', NULL);
INSERT INTO bicicletas (Codigo, Modelo, IDEstacion, Estado, Zona_de_mantenimiento_IDZona) VALUES ('B002', 'Eléctrica', 2, 'Disponible', NULL);
INSERT INTO bicicletas (Codigo, Modelo, IDEstacion, Estado, Zona_de_mantenimiento_IDZona) VALUES ('B003', 'Mecánica', 3, 'En_Reparación', 1);
INSERT INTO bicicletas (Codigo, Modelo, IDEstacion, Estado, Zona_de_mantenimiento_IDZona) VALUES ('B004', 'Eléctrica', 4, 'Disponible', NULL);
INSERT INTO bicicletas (Codigo, Modelo, IDEstacion, Estado, Zona_de_mantenimiento_IDZona) VALUES ('B005', 'Mecánica', 5, 'En_Reparación', 2);

INSERT INTO Tarifa (Tipo_Tarifa, Precio, Descripcion) VALUES ('Tarifa Plana', 50.00, 'Primeros 30 min: Gratis, 30m - 2h: 0,70€, A partir de 2h: +5€/hora');
INSERT INTO Tarifa (Tipo_Tarifa, Precio, Descripcion) VALUES ('Tarifa por Uso', 35.00, 'Primeros 30 min: 0,35€, 30m - 2h: 0,90€, A partir de 2h: +5€/hora');
INSERT INTO Tarifa (Tipo_Tarifa, Precio, Descripcion) VALUES ('Tarifa Plana Abono Metropolitano', 65.00, 'Primeros 30 min: Gratis, 30m - 2h: 0,70€, A partir de 2h: +5€/hora');
INSERT INTO Tarifa (Tipo_Tarifa, Precio, Descripcion) VALUES ('Tarifa por Uso Abono Metropolitano', 53.00, 'Primeros 30 min: 0,35€, 30m - 2h: 0,90€, A partir de 2h: +5€/hora');

INSERT INTO usuario (DNI, Nombre, Apellido, Direccion, Correo_electronico, Telefono, N_de_cuenta, IdTarifa, saldo) VALUES ('12345678A', 'Juan', 'Pérez', 'Calle Falsa 123', 'juan@example.com', 600678901, 'ES1234567890123456789012', 1,1000);
INSERT INTO usuario (DNI, Nombre, Apellido, Direccion, Correo_electronico, Telefono, N_de_cuenta, IdTarifa, saldo) VALUES ('23456789B', 'María', 'López', 'Avenida Siempre Viva 456', 'maria@example.com', 600789012, 'ES2345678901234567890123', 2,1000);
INSERT INTO usuario (DNI, Nombre, Apellido, Direccion, Correo_electronico, Telefono, N_de_cuenta, IdTarifa, saldo) VALUES ('34567890C', 'Pedro', 'García', 'Calle del Olmo 789', 'pedro@example.com', 600890123, 'ES3456789012345678901234', 3,1000);
INSERT INTO usuario (DNI, Nombre, Apellido, Direccion, Correo_electronico, Telefono, N_de_cuenta, IdTarifa, saldo) VALUES ('45678901D', 'Laura', 'Martínez', 'Plaza Mayor 101', 'laura@example.com', 600901234, 'ES4567890123456789012345', 4,1000);
INSERT INTO usuario (DNI, Nombre, Apellido, Direccion, Correo_electronico, Telefono, N_de_cuenta, IdTarifa, saldo) VALUES ('56789012E', 'Carlos', 'Rodríguez', 'Calle de la Paz 202', 'carlos@example.com', 600012345, 'ES5678901234567890123456', 1,1000);

INSERT INTO Tiempo_uso (Tiempo_uso, Multa) VALUES ('00:30:00', 0.00);
INSERT INTO Tiempo_uso (Tiempo_uso, Multa) VALUES ('01:00:00', 1.25);
INSERT INTO Tiempo_uso (Tiempo_uso, Multa) VALUES ('02:00:00', 3.00);
INSERT INTO Tiempo_uso (Tiempo_uso, Multa) VALUES ('03:00:00', 4.50);
INSERT INTO Tiempo_uso (Tiempo_uso, Multa) VALUES ('04:00:00', 10.70);

INSERT INTO Servicio (usuario_DNI, bicicletas_Codigo, Fecha_inicio_servicio, Fecha_fin_servicio, idTiempo_uso) VALUES ('12345678A', 'B001', '2023-07-01 08:00:00', '2023-07-01 08:30:00', 1);
INSERT INTO Servicio (usuario_DNI, bicicletas_Codigo, Fecha_inicio_servicio, Fecha_fin_servicio, idTiempo_uso) VALUES ('23456789B', 'B002', '2023-07-01 09:00:00', '2023-07-01 10:00:00', 2);
INSERT INTO Servicio (usuario_DNI, bicicletas_Codigo, Fecha_inicio_servicio, Fecha_fin_servicio, idTiempo_uso) VALUES ('34567890C', 'B003', '2023-07-01 10:00:00', '2023-07-01 12:00:00', 3);
INSERT INTO Servicio (usuario_DNI, bicicletas_Codigo, Fecha_inicio_servicio, Fecha_fin_servicio, idTiempo_uso) VALUES ('45678901D', 'B004', '2023-07-01 11:00:00', '2023-07-01 14:00:00', 4);
INSERT INTO Servicio (usuario_DNI, bicicletas_Codigo, Fecha_inicio_servicio, Fecha_fin_servicio, idTiempo_uso) VALUES ('56789012E', 'B005', '2023-07-01 12:00:00', '2023-07-01 16:00:00', 5);
