CREATE SCHEMA IF NOT EXISTS lucasvideoclub;
SET SCHEMA 'lucasvideoclub';

CREATE TABLE IF NOT EXISTS Socio (
    id_socio SERIAL PRIMARY KEY,
    documento_identidad VARCHAR(50) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Direccion (
    id_socio INT PRIMARY KEY,
    codigo_postal VARCHAR(5),
    calle VARCHAR(100),
    numero_calle SMALLINT,
    piso VARCHAR(10),

    CONSTRAINT socio_direccion_fk FOREIGN KEY (id_socio) REFERENCES Socio(id_socio)
);

CREATE TABLE IF NOT EXISTS Pelicula (
    id_pelicula SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    genero VARCHAR(50) NOT NULL,
    director VARCHAR(100) NOT NULL,
    sinopsis TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Copia (
    id_copia SERIAL PRIMARY KEY,
    id_pelicula INT NOT NULL,
    
    CONSTRAINT pelicula_copia_fk FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula)
);

CREATE TABLE IF NOT EXISTS Prestamo (
    id_prestamo SERIAL PRIMARY KEY,
    id_socio INT NOT NULL,
    id_copia INT NOT NULL,
    prestamo TIMESTAMP NOT NULL,
    devolucion TIMESTAMP,

    CONSTRAINT socio_prestamo_fk FOREIGN KEY (id_socio) REFERENCES Socio(id_socio),
    CONSTRAINT copia_prestamo_fk FOREIGN KEY (id_copia) REFERENCES Copia(id_copia)
);

-- CONSULTA: Saca el número de copias de cada película que están disponibles (no prestadas) en el sistema.
-- Nota: Ojo cuidao que algunas pueden no haberse prestado nunca y por tanto no tener un campo "devolucion" relleno ya que directamente no aparecen en la tabla prestamo
SELECT p.titulo, COUNT(c.id_copia) AS copias_disponibles -- cojo el titulo contando las copias que tiene
FROM Pelicula p
INNER JOIN Copia c ON p.id_pelicula = c.id_pelicula -- me quedo con todas las copias de las pelis
LEFT JOIN Prestamo pr ON c.id_copia = pr.id_copia AND pr.devolucion IS NULL -- cojo todas las copias, incluidas las que tienen el campo devolución vacío PERO...
WHERE pr.id_prestamo IS NULL -- PERO... porque nunca se han prestado
GROUP BY p.titulo;