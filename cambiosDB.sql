USE bicingBCN;
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


-- Cambiar la primary key de la tabla Servicio

-- Primero, se debe eliminar la clave primaria existente
ALTER TABLE Servicio
DROP PRIMARY KEY;

-- Añadir una nueva columna de ID auto-incremental
ALTER TABLE Servicio
ADD COLUMN ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

-- Para mantener los datos, si se desea usar la nueva columna como la clave primaria
-- y mantener las claves antiguas como únicas, se puede hacer lo siguiente:
-- ALTER TABLE Servicio
-- ADD CONSTRAINT UNIQUE (Usuario_DNI, Codigo_Bici);

-- Cambiar la Primary Key de la Tabla Servicio a un ID Auto-Incremental




-- Crear una Tabla Nueva de Notificaciones

CREATE TABLE IF NOT EXISTS Notificaciones (
  ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Usuario_DNI VARCHAR(9) NOT NULL,
  Mensaje TEXT NOT NULL,
  Fecha_Hora DATETIME NOT NULL,
  CONSTRAINT fk_Notificaciones_Usuario
    FOREIGN KEY (Usuario_DNI)
    REFERENCES Usuario (DNI)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;



-- Crear una Tabla Nueva de Servicios Archivados
CREATE TABLE IF NOT EXISTS Servicio_Archivado (
  ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Usuario_DNI VARCHAR(9) NOT NULL,
  Codigo_Bici VARCHAR(10) NOT NULL,
  Tipo_de_tarifa VARCHAR(45) NOT NULL,
  Precio_tarifa DECIMAL(10,2) NOT NULL,
  Tiempo_de_uso TIME NOT NULL,
  Suma_penalizacion DECIMAL(10,2) NOT NULL,
  Fecha DATETIME NOT NULL, -- Se añadirá una columna para registrar la fecha del archivo
  CONSTRAINT fk_Servicio_Archivado_Bicicletas
    FOREIGN KEY (Codigo_Bici)
    REFERENCES Bicicletas (Codigo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Servicio_Archivado_Usuario
    FOREIGN KEY (Usuario_DNI)
    REFERENCES Usuario (DNI)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;



-- Crear una columna nueva en Bicicletas: Dsiponible/Alquilada

ALTER TABLE Bicicletas
ADD COLUMN Estado_Disponibilidad ENUM('Disponible', 'Alquilada') NOT NULL DEFAULT 'Disponible';
