-- Usa la base de datos 'bdionic'
USE bdionic;

-- Inserta datos en la tabla 'categorias'
INSERT INTO categorias (descripcion, estado)
VALUES ('Herramientas Manuales', 1),
       ('Herramientas Eléctricas', 1),
       ('Pernería', 1),
       ('Materiales de Construcción', 1),
       ('Accesorios', 1);

-- Inserta datos en la tabla 'productos'
INSERT INTO productos (descripcion, idcategoria, precio, cantidad, estado)
VALUES ('Martillo', 1, 25.50, 100, 1),
       ('Taladro Eléctrico', 2, 150.75, 50, 1),
       ('Tornillo Phillips 1/4"', 3, 0.15, 5000, 1),
       ('Cemento Portland', 4, 10.50, 200, 1),
       ('Guantes de Protección', 5, 7.25, 300, 1);

SELECT * from productos