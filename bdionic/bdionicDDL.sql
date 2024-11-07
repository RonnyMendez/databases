-- Elimina la base de datos si ya existe
DROP DATABASE IF EXISTS bdionic;

-- Crea la base de datos
CREATE DATABASE bdionic;

-- Usa la base de datos recién creada
USE bdionic;

-- Elimina la tabla 'productos' si ya existe
DROP TABLE IF EXISTS productos;

-- Elimina la tabla 'categorias' si ya existe
DROP TABLE IF EXISTS categorias;

-- Crea la tabla 'categorias'
CREATE TABLE categorias
(
    idcategoria INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(30) NOT NULL,
    estado      TINYINT     NOT NULL
);

-- Crea la tabla 'productos' con la relación de clave foránea a 'categorias'
CREATE TABLE productos
(
    idproducto  BIGINT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(40) NOT NULL,
    idcategoria INT         NOT NULL,
    precio      FLOAT       NOT NULL,
    cantidad    INT         NOT NULL,
    estado      TINYINT     NOT NULL,
    FOREIGN KEY (idcategoria) REFERENCES categorias (idcategoria)
);
