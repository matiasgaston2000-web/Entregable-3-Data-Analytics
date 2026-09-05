CREATE DATABASE Ventas_Tech_DB;
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
USE Ventas_Tech_DB
create table categorias (id_categoria INT PRIMARY KEY,nombre_categoria VARCHAR(50) NOT NULL, descripcion VARCHAR(200));
CREATE TABLE clientes (id_cliente INT PRIMARY KEY, nombre VARCHAR(100) NOT NULL, email VARCHAR(100) UNIQUE, ciudad VARCHAR(50), fecha_registro DATE NOT NULL);
CREATE TABLE productos (id_producto INT PRIMARY KEY, nombre_producto VARCHAR(100) NOT NULL, id_categoria INT, precio DECIMAL(10,2) NOT NULL, stock INT DEFAULT 0, activo TINYINT DEFAULT 1, FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria));
CREATE TABLE ventas (id_venta INT PRIMARY KEY, id_cliente INT, id_producto INT, cantidad INT NOT NULL, precio_unitario DECIMAL(10,2) NOT NULL, fecha_venta DATE NOT NULL, FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente), FOREIGN KEY (id_producto) REFERENCES productos (id_producto));
INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');
INSERT INTO clientes VALUES (1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05');
INSERT INTO clientes VALUES (2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10');
INSERT INTO clientes VALUES (3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01');
INSERT INTO clientes VALUES (4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15');
INSERT INTO clientes VALUES (5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');
INSERT INTO productos VALUES (1, 'Laptop Pro 15',       1, 1200.00, 15, 1);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico',   2,   28.00, 80, 1);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"',      1,  450.00, 12, 1);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro',  3,  120.00, 35, 1);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB',     4,  130.00, 18, 1);
INSERT INTO productos VALUES (6, 'Teclado Mecánico',    2,   95.00, 40, 1);
INSERT INTO ventas VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas VALUES (2,  2, 2, 5,   28.00, '2024-03-06');
INSERT INTO ventas VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO ventas VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');
SELECT * FROM categorias
SELECT * FROM clientes
SELECT * FROM productos
SELECT * FROM ventas
SELECT 
    MONTH(fecha_venta) AS mes, 
    SUM(cantidad * precio_unitario) AS total_facturado, 
    COUNT(DISTINCT id_venta) AS cantidad_de_pedidos, 
    SUM(cantidad * precio_unitario) / COUNT(DISTINCT id_venta) AS ticket_promedio
FROM 
    ventas
GROUP BY 
    MONTH(fecha_venta)
ORDER BY 
    mes;
SELECT TOP 5 id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;
SELECT id_cliente,
COUNT(*) AS cantidad_de_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING 
COUNT(*) > 1;
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE 
        WHEN SUM(cantidad * precio_unitario) > (
            SELECT SUM(cantidad * precio_unitario) / COUNT(DISTINCT MONTH(fecha_venta)) 
            FROM ventas
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM 
    ventas
GROUP BY 
    MONTH(fecha_venta);
    -- HALLAZGOS Y CONCLUSIONES DEL NEGOCIO:
-- 1. Análisis de Productos: El producto con ID [1] lidera ampliamente el ranking, siendo el que más ingresos genera con un total facturado de $3600.
-- 2. Fidelización: Existe una base de clientes recurrentes. Se identificaron 5 clientes que realizaron más de un pedido, destacándose el cliente ID 1 por su alto nivel de gasto.
-- 3. Rendimiento Mensual: El mes de Marzo fue el más exitoso a nivel ventas, superando el promedio general de facturación y logrando el ticket promedio más alto del período.