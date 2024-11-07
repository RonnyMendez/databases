USE gestion_financiera;

-- Tabla: monedas
INSERT INTO monedas (codigo, nombre, simbolo)
VALUES ('PEN', 'Sol Peruano', 'S/'),
       ('USD', 'Dólar Estadounidense', '$'),
       ('EUR', 'Euro', '€');

-- Tabla: usuarios
INSERT INTO usuarios (nombre_usuario, email, contrasena, nombre, apellido, rol)
VALUES ('admin', 'admin@example.com', 'hashed_password', 'Admin', 'User', 'ADMIN'),
       ('usuario1', 'user1@example.com', 'hashed_password', 'Juan', 'Perez', 'USUARIO'),
       ('usuario2', 'user2@example.com', 'hashed_password', 'Maria', 'Gomez', 'USUARIO');

-- Tabla: empleados
INSERT INTO empleados (nombre, apellido, dni, direccion, telefono, email, puesto, salario)
VALUES ('Carlos', 'Lopez', '12345678', 'Av. Siempre Viva 123', '999999999', 'carlos.lopez@example.com', 'Gerente',
        5000.00),
       ('Ana', 'Martinez', '87654321', 'Calle Falsa 456', '988888888', 'ana.martinez@example.com', 'Contador', 3500.00);

-- Tabla: clasificación de costos
INSERT INTO clasificacion_costos (nombre, descripcion)
VALUES ('Servicios Públicos', 'Gastos en servicios como luz, agua, internet'),
       ('Alquiler', 'Gastos por alquiler de locales'),
       ('Salarios', 'Pago de salarios a empleados'),
       ('Mantenimiento', 'Gastos de mantenimiento y reparaciones');

-- Tabla: proveedores
INSERT INTO proveedores (nombre, ruc, direccion, telefono, email, contacto)
VALUES ('Proveedor A', '20123456789', 'Jr. Proveedores 100', '987654321', 'contactoA@example.com', 'Luis Ramirez'),
       ('Proveedor B', '20234567890', 'Av. Principal 200', '976543210', 'contactoB@example.com', 'Elena Torres');

-- Tabla: clientes
INSERT INTO clientes (nombre, dni, direccion, telefono, email, contacto)
VALUES ('Cliente X', '45678912', 'Calle Clientes 300', '965432109', 'clienteX@example.com', 'Mario Diaz'),
       ('Cliente Y', '56789123', 'Av. Secundaria 400', '954321098', 'clienteY@example.com', 'Lucia Vega');

-- Tabla: tipos_de_cambio
-- Asumiendo que el tipo de cambio es de PEN a USD y viceversa
INSERT INTO tipos_de_cambio (moneda_origen_id, moneda_destino_id, fecha, tipo_cambio)
VALUES ((SELECT id FROM monedas WHERE codigo = 'PEN'), (SELECT id FROM monedas WHERE codigo = 'USD'), CURDATE(), 0.27),
       ((SELECT id FROM monedas WHERE codigo = 'USD'), (SELECT id FROM monedas WHERE codigo = 'PEN'), CURDATE(), 3.70);

-- Tabla: cuentas_por_pagar
INSERT INTO cuentas_por_pagar (proveedor_id, monto, moneda_id, fecha_emision, fecha_vencimiento, plazo_pago, estado,
                               nota)
VALUES ((SELECT id FROM proveedores WHERE nombre = 'Proveedor A'), 1500.00,
        (SELECT id FROM monedas WHERE codigo = 'PEN'), '2023-10-01', '2023-10-31', 30, 'PENDIENTE',
        'Compra de materiales'),
       ((SELECT id FROM proveedores WHERE nombre = 'Proveedor B'), 2500.00,
        (SELECT id FROM monedas WHERE codigo = 'USD'), '2023-09-15', '2023-10-15', 30, 'PENDIENTE',
        'Servicios de consultoría');

-- Tabla: cuentas_por_cobrar
INSERT INTO cuentas_por_cobrar (cliente_id, monto, moneda_id, fecha_emision, fecha_vencimiento, plazo_pago, estado,
                                nota)
VALUES ((SELECT id FROM clientes WHERE nombre = 'Cliente X'), 3000.00, (SELECT id FROM monedas WHERE codigo = 'PEN'),
        '2023-10-05', '2023-11-05', 30, 'PENDIENTE', 'Venta de productos'),
       ((SELECT id FROM clientes WHERE nombre = 'Cliente Y'), 2000.00, (SELECT id FROM monedas WHERE codigo = 'USD'),
        '2023-09-20', '2023-10-20', 30, 'PENDIENTE', 'Servicios prestados');

-- Tabla: costos_fijos
INSERT INTO costos_fijos (nombre, descripcion, monto, moneda_id, fecha_inicio, frecuencia, proximo_pago, estado,
                          clasificacion_id, empleado_id)
VALUES ('Alquiler Oficina', 'Pago mensual del alquiler de la oficina principal', 2000.00,
        (SELECT id FROM monedas WHERE codigo = 'PEN'), '2023-01-01', 'MENSUAL', '2023-11-01', 'ACTIVO',
        (SELECT id FROM clasificacion_costos WHERE nombre = 'Alquiler'), NULL),
       ('Salario Carlos Lopez', 'Pago de salario al empleado Carlos Lopez', 5000.00,
        (SELECT id FROM monedas WHERE codigo = 'PEN'), '2023-01-01', 'MENSUAL', '2023-11-01', 'ACTIVO',
        (SELECT id FROM clasificacion_costos WHERE nombre = 'Salarios'),
        (SELECT id FROM empleados WHERE nombre = 'Carlos')),
       ('Servicio de Internet', 'Pago trimestral del servicio de internet', 600.00,
        (SELECT id FROM monedas WHERE codigo = 'PEN'), '2023-01-01', 'TRIMESTRAL', '2023-12-01', 'ACTIVO',
        (SELECT id FROM clasificacion_costos WHERE nombre = 'Servicios Públicos'), NULL);

-- Tabla: costos_variables
INSERT INTO costos_variables (descripcion, monto, moneda_id, fecha, proveedor_id, factura_numero, clasificacion_id)
VALUES ('Compra de suministros', 800.00, (SELECT id FROM monedas WHERE codigo = 'PEN'), '2023-10-10',
        (SELECT id FROM proveedores WHERE nombre = 'Proveedor A'), 'FAC-001',
        (SELECT id FROM clasificacion_costos WHERE nombre = 'Mantenimiento')),
       ('Reparación de equipo', 1200.00, (SELECT id FROM monedas WHERE codigo = 'USD'), '2023-10-15', NULL, NULL,
        (SELECT id FROM clasificacion_costos WHERE nombre = 'Mantenimiento'));

-- Tabla: prestamos_deudas
INSERT INTO prestamos_deudas (tipo, descripcion, monto_original, moneda_id, tasa_interes, plazo_meses, fecha_inicio,
                              fecha_vencimiento, estado)
VALUES ('PRESTAMO', 'Préstamo bancario para expansión', 100000.00, (SELECT id FROM monedas WHERE codigo = 'PEN'), 5.00,
        24, '2023-01-01', '2024-12-31', 'ACTIVO');

-- Tabla: calendario_pagos
-- Generar pagos mensuales para el préstamo anterior (simplificado)
INSERT INTO calendario_pagos (prestamo_deuda_id, numero_cuota, fecha_pago, monto_capital, monto_interes, monto_total,
                              estado)
VALUES ((SELECT id FROM prestamos_deudas WHERE descripcion = 'Préstamo bancario para expansión'), 1, '2023-02-01',
        4166.67, 416.67, 4583.34, 'PENDIENTE'),
       ((SELECT id FROM prestamos_deudas WHERE descripcion = 'Préstamo bancario para expansión'), 2, '2023-03-01',
        4166.67, 416.67, 4583.34, 'PENDIENTE');
-- Agrega más cuotas según sea necesario...

-- Tabla: alertas
    INSERT
INTO alertas (usuario_id, tipo_alerta, mensaje, leida)
VALUES
    ((SELECT id FROM usuarios WHERE nombre_usuario = 'admin'), 'Pago Pendiente', 'Tienes un pago pendiente de cuentas por pagar', FALSE),
    ((SELECT id FROM usuarios WHERE nombre_usuario = 'usuario1'), 'Cobro Pendiente',
     'Tienes un cobro pendiente de cuentas por cobrar', FALSE);

-- Tabla: preferencias_notificaciones
INSERT INTO preferencias_notificaciones (usuario_id, notificar_por_email, notificar_en_sistema,
                                         frecuencia_recordatorios)
VALUES ((SELECT id FROM usuarios WHERE nombre_usuario = 'admin'), TRUE, TRUE, 'DIARIO'),
       ((SELECT id FROM usuarios WHERE nombre_usuario = 'usuario1'), TRUE, TRUE, 'SEMANAL');

-- Tabla: transacciones
INSERT INTO transacciones (tipo_transaccion, referencia_id, monto, moneda_id, fecha, usuario_id)
VALUES ('PAGO_CUENTA_PAGAR', (SELECT id FROM cuentas_por_pagar WHERE nota = 'Compra de materiales'), 1500.00,
        (SELECT id FROM monedas WHERE codigo = 'PEN'), '2023-10-20',
        (SELECT id FROM usuarios WHERE nombre_usuario = 'admin')),
       ('COBRO_CUENTA_COBRAR', (SELECT id FROM cuentas_por_cobrar WHERE nota = 'Venta de productos'), 3000.00,
        (SELECT id FROM monedas WHERE codigo = 'PEN'), '2023-10-25',
        (SELECT id FROM usuarios WHERE nombre_usuario = 'usuario1'));

-- Tabla: ingresos
INSERT INTO ingresos (descripcion, monto, fecha, tipo, cuenta_por_cobrar_id, moneda_id)
VALUES ('Cobro de cuenta por cobrar a Cliente X', 3000.00, '2023-10-25', 'CUENTA_POR_COBRAR',
        (SELECT id FROM cuentas_por_cobrar WHERE nota = 'Venta de productos'),
        (SELECT id FROM monedas WHERE codigo = 'PEN')),
       ('Ingreso por ventas directas', 5000.00, '2023-10-26', 'CAJA_DIARIA', NULL,
        (SELECT id FROM monedas WHERE codigo = 'PEN'));

-- Tabla: caja_diaria
INSERT INTO caja_diaria (fecha, ingreso_total, egreso_total, moneda_id)
VALUES ('2023-10-26', 5000.00, 1000.00, (SELECT id FROM monedas WHERE codigo = 'PEN'));


-- Tabla: reportes_generados
INSERT INTO reportes_generados (usuario_id, tipo_reporte, parametros, ruta_archivo)
VALUES ((SELECT id FROM usuarios WHERE nombre_usuario = 'admin'), 'Reporte Financiero Mensual', 'Periodo: Octubre 2023',
        '/reportes/octubre2023.pdf');

-- Tabla: balance_financiero
INSERT INTO balance_financiero (periodo, ingresos_totales, egresos_totales, caja_chica)
VALUES ('2023-10-31', 8000.00, 4500.00, 4000.00);

-- Tabla: preferencias_notificaciones
INSERT INTO preferencias_notificaciones (usuario_id, notificar_por_email, notificar_en_sistema,
                                         frecuencia_recordatorios)
VALUES ((SELECT id FROM usuarios WHERE nombre_usuario = 'usuario2'), TRUE, FALSE, 'MENSUAL');

-- Tabla: transacciones adicionales (opcional)
INSERT INTO transacciones (tipo_transaccion, referencia_id, monto, moneda_id, fecha, usuario_id)
VALUES ('PAGO_COSTO_FIJO', (SELECT id FROM costos_fijos WHERE nombre = 'Alquiler Oficina'), 2000.00,
        (SELECT id FROM monedas WHERE codigo = 'PEN'), '2023-10-01',
        (SELECT id FROM usuarios WHERE nombre_usuario = 'admin'));

-- Actualizar próximo pago de costo fijo
UPDATE costos_fijos
SET proximo_pago = DATE_ADD(proximo_pago, INTERVAL 1 MONTH)
WHERE nombre = 'Alquiler Oficina';

-- Tabla: ingresos adicionales
INSERT INTO ingresos (descripcion, monto, fecha, tipo, moneda_id)
VALUES ('Ingreso por servicios adicionales', 1500.00, '2023-10-27', 'OTRO',
        (SELECT id FROM monedas WHERE codigo = 'PEN'));

-- Tabla: costos variables adicionales
INSERT INTO costos_variables (descripcion, monto, moneda_id, fecha, proveedor_id, factura_numero, clasificacion_id)
VALUES ('Gastos de publicidad', 500.00, (SELECT id FROM monedas WHERE codigo = 'USD'), '2023-10-28', NULL, NULL,
        (SELECT id FROM clasificacion_costos WHERE nombre = 'Mantenimiento'));

-- Tabla: empleados adicionales
INSERT INTO empleados (nombre, apellido, dni, direccion, telefono, email, puesto, salario)
VALUES ('Luis', 'Gonzalez', '23456789', 'Av. Empleados 789', '912345678', 'luis.gonzalez@example.com', 'Asistente',
        2500.00);

-- Agregar salario de nuevo empleado a costos fijos
INSERT INTO costos_fijos (nombre, descripcion, monto, moneda_id, fecha_inicio, frecuencia, proximo_pago, estado,
                          clasificacion_id, empleado_id)
VALUES ('Salario Luis Gonzalez', 'Pago de salario al empleado Luis Gonzalez', 2500.00,
        (SELECT id FROM monedas WHERE codigo = 'PEN'), '2023-10-01', 'MENSUAL', '2023-11-01', 'ACTIVO',
        (SELECT id FROM clasificacion_costos WHERE nombre = 'Salarios'),
        (SELECT id FROM empleados WHERE nombre = 'Luis'));

-- Tabla: tipos_de_cambio adicionales
INSERT INTO tipos_de_cambio (moneda_origen_id, moneda_destino_id, fecha, tipo_cambio)
VALUES ((SELECT id FROM monedas WHERE codigo = 'PEN'), (SELECT id FROM monedas WHERE codigo = 'EUR'), CURDATE(), 0.24),
       ((SELECT id FROM monedas WHERE codigo = 'EUR'), (SELECT id FROM monedas WHERE codigo = 'PEN'), CURDATE(), 4.20);

-- Tabla: cuentas_por_pagar adicionales
INSERT INTO cuentas_por_pagar (proveedor_id, monto, moneda_id, fecha_emision, fecha_vencimiento, plazo_pago, estado,
                               nota)
VALUES ((SELECT id FROM proveedores WHERE nombre = 'Proveedor B'), 3000.00,
        (SELECT id FROM monedas WHERE codigo = 'EUR'), '2023-10-18', '2023-11-18', 30, 'PENDIENTE',
        'Compra de equipos');

-- Tabla: transacciones de caja diaria
INSERT INTO transacciones (tipo_transaccion, referencia_id, monto, moneda_id, fecha, usuario_id)
VALUES ('INGRESO_CAJA_DIARIA', NULL, 5000.00, (SELECT id FROM monedas WHERE codigo = 'PEN'), '2023-10-26',
        (SELECT id FROM usuarios WHERE nombre_usuario = 'usuario1')),
       ('EGRESO_CAJA_DIARIA', NULL, 1000.00, (SELECT id FROM monedas WHERE codigo = 'PEN'), '2023-10-26',
        (SELECT id FROM usuarios WHERE nombre_usuario = 'usuario1'));
