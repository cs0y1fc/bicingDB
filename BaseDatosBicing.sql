
DROP SCHEMA IF EXISTS bicingBCN ;

CREATE SCHEMA IF NOT EXISTS bicingBCN DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE bicingBCN ;

-- -----------------------------------------------------
-- Table `mydb`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Usuario (
  DNI VARCHAR(9) NOT NULL,
  Nombre VARCHAR(100) NOT NULL,
  Apellido VARCHAR(100) NOT NULL,
  Direccion VARCHAR(100) NOT NULL,
  Correo_electronico VARCHAR(100) NOT NULL,
  Telefono INT(9) NOT NULL,
  N_de_cuenta VARCHAR(24) NOT NULL,
  PRIMARY KEY (`DNI`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Zona de mantenimiento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Zona_de_mantenimiento (
  IDZona INT NOT NULL AUTO_INCREMENT,
  Nom_Zona VARCHAR(100) NOT NULL,
  PRIMARY KEY (`IDZona`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Personal Ayuntamiento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Personal_Ayuntamiento (
  ID_Encargado INT NOT NULL AUTO_INCREMENT,
  Nom_empleado VARCHAR(100) NOT NULL,
  Apellido_empleado VARCHAR(100) NOT NULL,
  Telefono INT(9) NOT NULL,
  Cargo VARCHAR(30) NOT NULL,
  Zona_de_mantenimiento_IDZona INT(3) NULL,
  PRIMARY KEY (`ID_Encargado`),
  CONSTRAINT `fk_Personal Ayuntamiento_Zona_de_mantenimiento1`
    FOREIGN KEY (`Zona_de_mantenimiento_IDZona`)
    REFERENCES `Zona_de_mantenimiento` (`IDZona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Estacion de bicicletas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Estacion_de_bicicletas (
  idEstacion INT NOT NULL AUTO_INCREMENT,
  Distrito VARCHAR(100) NOT NULL,
  Calle VARCHAR(100) NOT NULL,
  Encargados_del_man_ID_Encargado INT NOT NULL,
  PRIMARY KEY (`idEstacion`),
  CONSTRAINT `fk_Estacion_Encargados del man.1`
    FOREIGN KEY (`Encargados_del_man_ID_Encargado`)
    REFERENCES Personal_Ayuntamiento (`ID_Encargado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Bicicletas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Bicicletas (
  Codigo VARCHAR(10) NOT NULL,
  Modelo VARCHAR(20) NOT NULL,
  IDEstacion INT NOT NULL,
  Estado VARCHAR(15) NOT NULL,
  Zona_de_mantenimiento_IDZona INT NULL,
  PRIMARY KEY (`Codigo`),
  CONSTRAINT `fk_Bicicletas_Estacion1`
    FOREIGN KEY (`IDEstacion`)
    REFERENCES Estacion_de_bicicletas (`idEstacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bicicletas_Zona de mantenimiento1`
    FOREIGN KEY (`Zona_de_mantenimiento_IDZona`)
    REFERENCES Zona_de_mantenimiento (`IDZona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Usuario_has_Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Usuario_has_Usuario (
  Usuario_idUsuario INT NOT NULL,
  Usuario_idUsuario1 INT NOT NULL,
  PRIMARY KEY (`Usuario_idUsuario`, `Usuario_idUsuario1`))
ENGINE = InnoDB;

SHOW WARNINGS;


-- Table `mydb`.`Servicio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Servicio (
  Usuario_DNI VARCHAR(15) NOT NULL,
  Codigo_Bici VARCHAR(25) NOT NULL,
  Tipo_de_tarifa VARCHAR(45) NOT NULL,
  Precio_tarifa DECIMAL(10,2) NOT NULL,
  Tiempo_de_uso TIME NOT NULL,
  Suma_penalizacion DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`Usuario_DNI`, `Codigo_Bici`),
  CONSTRAINT `fk_Bicicletas_has_Usuario_Bicicletas2`
    FOREIGN KEY (`Codigo_Bici`)
    REFERENCES Bicicletas (`Codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bicicletas_has_Usuario_Usuario2`
    FOREIGN KEY (`Usuario_DNI`)
    REFERENCES Usuario (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SHOW WARNINGS;

START TRANSACTION;
USE bicingBCN;
INSERT INTO Usuario (DNI, Nombre, Apellido, Direccion, Correo_electronico, Telefono, N_de_cuenta) VALUES ('36351423O', 'Pepe', 'Sanchez', 'Plaza españa bq3º 2º 1ª', 'ps@gmail.com', 263514283, 'ES2736452938374653748563');
INSERT INTO Usuario (DNI, Nombre, Apellido, Direccion, Correo_electronico, Telefono, N_de_cuenta) VALUES ('27364619Y', 'Jose Maria', 'Maria Jose', 'Calle Vizcalla B7º 9º 7ª', 'jmmj@gmail.com', 263514284, 'ES2736452938374653748564');
INSERT INTO Usuario (DNI, Nombre, Apellido, Direccion, Correo_electronico, Telefono, N_de_cuenta) VALUES ('28027424E', 'Pablo', 'Pablo', 'Calle Vizcalla B7º 9º 6ª', 'pp@gmail.com', 263510004, 'ES5366452938374333335564');
COMMIT;

START TRANSACTION;
USE bicingBCN;
INSERT INTO Zona_de_mantenimiento (IDZona, Nom_Zona) VALUES (1, 'Exampla');
INSERT INTO Zona_de_mantenimiento (IDZona, Nom_Zona) VALUES (2, 'Gracia');
INSERT INTO Zona_de_mantenimiento (IDZona, Nom_Zona) VALUES (3, 'Carmel');
INSERT INTO Zona_de_mantenimiento (IDZona, Nom_Zona) VALUES (4, 'Barcelona');
INSERT INTO Zona_de_mantenimiento (IDZona, Nom_Zona) VALUES (5, 'Sans-Monjuic');
INSERT INTO Zona_de_mantenimiento (IDZona, Nom_Zona) VALUES (6, 'San Marti');

COMMIT;

START TRANSACTION;
USE bicingBCN;
INSERT INTO Personal_Ayuntamiento (ID_Encargado, Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES (1, 'Ganzo', 'Pato', 231435234, 'Recogida', NULL);
INSERT INTO Personal_Ayuntamiento (ID_Encargado, Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES (2, 'Gandalf', 'Nokia', 642345623, 'Recogida', NULL);
INSERT INTO Personal_Ayuntamiento (ID_Encargado, Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES (3, 'Maria', 'Mendez', 431563456, 'Recogida', NULL);
INSERT INTO Personal_Ayuntamiento (ID_Encargado, Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES (4, 'Josefina', 'Gutierrez', 345234643, 'Recogida', NULL);
INSERT INTO Personal_Ayuntamiento (ID_Encargado, Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES (5, 'Mariano', 'Gimenez', 123234345, 'Mantenimiento', 1);
INSERT INTO Personal_Ayuntamiento (ID_Encargado, Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES (6, 'Alvaro', 'Gonzalez', 234534634, 'Mantenimiento', 3);
INSERT INTO Personal_Ayuntamiento (ID_Encargado, Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES (7, 'Raul', 'Diez', 124234345, 'Mantenimiento', 4);
INSERT INTO Personal_Ayuntamiento (ID_Encargado, Nom_empleado, Apellido_empleado, Telefono, Cargo, Zona_de_mantenimiento_IDZona) VALUES (8, 'M.', 'Rajoy', 124234344, 'Conserje', NULL);

COMMIT;

START TRANSACTION;
USE bicingBCN;
INSERT INTO Estacion_de_bicicletas (idEstacion, Distrito, Calle, Encargados_del_man_ID_Encargado) VALUES (1, 'San Antoni', 'Calle de Manzo', 1);
INSERT INTO Estacion_de_bicicletas (idEstacion, Distrito, Calle, Encargados_del_man_ID_Encargado) VALUES (2, 'Esquerra de Exempla', 'Plaza Universitat', 1);
INSERT INTO Estacion_de_bicicletas (idEstacion, Distrito, Calle, Encargados_del_man_ID_Encargado) VALUES (3, 'Villa de Gracia', 'Calle Corsega', 3);
INSERT INTO Estacion_de_bicicletas (idEstacion, Distrito, Calle, Encargados_del_man_ID_Encargado) VALUES (4, 'Barcelona', 'Calle Cartagena', 2);
INSERT INTO Estacion_de_bicicletas (idEstacion, Distrito, Calle, Encargados_del_man_ID_Encargado) VALUES (5, 'Carmel', 'Calle Llobregos', 2);
INSERT INTO Estacion_de_bicicletas (idEstacion, Distrito, Calle, Encargados_del_man_ID_Encargado) VALUES (6, 'Esquerra de Exempla', 'Plaza Universitat', 4);

COMMIT;

START TRANSACTION;
USE bicingBCN;
INSERT INTO Bicicletas (Codigo, Modelo, IDEstacion, Estado, Zona_de_mantenimiento_IDZona) VALUES ('A001', 'Mecanica', 1, 'Dañada', 1);
INSERT INTO Bicicletas (Codigo, Modelo, IDEstacion, Estado, Zona_de_mantenimiento_IDZona) VALUES ('A002', 'Electronica', 1, 'OKEY', NULL);
INSERT INTO Bicicletas (Codigo, Modelo, IDEstacion, Estado, Zona_de_mantenimiento_IDZona) VALUES ('A003', 'Mecanica', 2, 'OKEY', NULL);
INSERT INTO Bicicletas (Codigo, Modelo, IDEstacion, Estado, Zona_de_mantenimiento_IDZona) VALUES ('A004', 'Electronica', 5, 'Dañada', 3);

COMMIT;

START TRANSACTION;
USE bicingBCN;
INSERT INTO Servicio (Usuario_DNI, Codigo_Bici, Tipo_de_tarifa, Precio_tarifa, Tiempo_de_uso, Suma_penalizacion) VALUES ('36351423O', 'A001', 'Tarifa plana', 50.00, '00:30:00', 0.00);
INSERT INTO Servicio (Usuario_DNI, Codigo_Bici, Tipo_de_tarifa, Precio_tarifa, Tiempo_de_uso, Suma_penalizacion) VALUES ('27364619Y', 'A002', 'Tarifa por uso', 35.00, '02:00:00', 0.90);
INSERT INTO Servicio (Usuario_DNI, Codigo_Bici, Tipo_de_tarifa, Precio_tarifa, Tiempo_de_uso, Suma_penalizacion) VALUES ('36351423O', 'A003', 'Tarifa plana', 50.00, '24:00:00', 115.70);
INSERT INTO Servicio (Usuario_DNI, Codigo_Bici, Tipo_de_tarifa, Precio_tarifa, Tiempo_de_uso, Suma_penalizacion) VALUES ('36351423O', 'A002', 'Tarifa plana', 50.00, '40:00:00', 190.70);

COMMIT;















