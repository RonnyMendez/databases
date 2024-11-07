-- Crear la base de datos
DROP DATABASE IF EXISTS gestion_financiera;
CREATE DATABASE IF NOT EXISTS gestion_financiera;
USE gestion_financiera;

-- Tabla: usuarios
CREATE TABLE usuarios
(
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50)               NOT NULL UNIQUE,
    email          VARCHAR(100)              NOT NULL UNIQUE,
    contrasena     VARCHAR(255)              NOT NULL,
    nombre         VARCHAR(100),
    apellido       VARCHAR(100),
    rol            ENUM ('ADMIN', 'USUARIO') NOT NULL DEFAULT 'USUARIO',
    fecha_creacion TIMESTAMP                          DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: empleados
CREATE TABLE empleados
(
    id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(100)   NOT NULL,
    apellido  VARCHAR(100),
    dni       VARCHAR(8) UNIQUE,
    direccion VARCHAR(255),
    telefono  VARCHAR(20),
    email     VARCHAR(100),
    puesto    VARCHAR(100),
    salario   DECIMAL(15, 2) NOT NULL
);

-- Tabla: clasificación de costos
CREATE TABLE clasificacion_costos
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255)
);

-- Tabla: proveedores
CREATE TABLE proveedores
(
    id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL,
    ruc       VARCHAR(11) UNIQUE,
    direccion VARCHAR(255),
    telefono  VARCHAR(20),
    email     VARCHAR(100),
    contacto  VARCHAR(100)
);

-- Tabla: clientes
CREATE TABLE clientes
(
    id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL,
    dni       VARCHAR(8) UNIQUE,
    direccion VARCHAR(255),
    telefono  VARCHAR(20),
    email     VARCHAR(100),
    contacto  VARCHAR(100)
);

-- Tabla: monedas
CREATE TABLE monedas
(
    id      BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo  VARCHAR(3)  NOT NULL UNIQUE, -- Ejemplo: 'PEN', 'USD'
    nombre  VARCHAR(50) NOT NULL,
    simbolo VARCHAR(5)
);

-- Tabla: tipos_de_cambio
CREATE TABLE tipos_de_cambio
(
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    moneda_origen_id  BIGINT         NOT NULL,
    moneda_destino_id BIGINT         NOT NULL,
    fecha             DATE           NOT NULL,
    tipo_cambio       DECIMAL(10, 4) NOT NULL,
    FOREIGN KEY (moneda_origen_id) REFERENCES monedas (id),
    FOREIGN KEY (moneda_destino_id) REFERENCES monedas (id)
);

-- Tabla: cuentas_por_pagar
CREATE TABLE cuentas_por_pagar
(
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    proveedor_id      BIGINT                       NOT NULL,
    monto             DECIMAL(15, 2)               NOT NULL,
    moneda_id         BIGINT                       NOT NULL,
    fecha_emision     DATE                         NOT NULL,
    fecha_vencimiento DATE                         NOT NULL,
    plazo_pago        INT, -- Días para pagar
    estado            ENUM ('PENDIENTE', 'PAGADA') NOT NULL DEFAULT 'PENDIENTE',
    fecha_pago        DATE,
    monto_pagado      DECIMAL(15, 2),
    metodo_pago       VARCHAR(50),
    nota              VARCHAR(255),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores (id),
    FOREIGN KEY (moneda_id) REFERENCES monedas (id)
);

-- Tabla: cuentas_por_cobrar
CREATE TABLE cuentas_por_cobrar
(
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id        BIGINT                        NOT NULL,
    monto             DECIMAL(15, 2)                NOT NULL,
    moneda_id         BIGINT                        NOT NULL,
    fecha_emision     DATE                          NOT NULL,
    fecha_vencimiento DATE                          NOT NULL,
    plazo_pago        INT,
    estado            ENUM ('PENDIENTE', 'COBRADA') NOT NULL DEFAULT 'PENDIENTE',
    fecha_cobro       DATE,
    monto_cobrado     DECIMAL(15, 2),
    metodo_cobro      VARCHAR(50),
    nota              VARCHAR(255),
    FOREIGN KEY (cliente_id) REFERENCES clientes (id),
    FOREIGN KEY (moneda_id) REFERENCES monedas (id)
);

-- Tabla: costos_fijos
CREATE TABLE costos_fijos
(
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(100)                            NOT NULL,
    descripcion      VARCHAR(255),
    monto            DECIMAL(15, 2)                          NOT NULL,
    moneda_id        BIGINT                                  NOT NULL,
    fecha_inicio     DATE                                    NOT NULL,
    frecuencia       ENUM ('MENSUAL', 'TRIMESTRAL', 'ANUAL') NOT NULL,
    proximo_pago     DATE,
    estado           ENUM ('ACTIVO', 'INACTIVO')             NOT NULL DEFAULT 'ACTIVO',
    clasificacion_id BIGINT, -- Para clasificar el tipo de costo
    empleado_id      BIGINT, -- Si es un salario de empleado
    FOREIGN KEY (moneda_id) REFERENCES monedas (id),
    FOREIGN KEY (clasificacion_id) REFERENCES clasificacion_costos (id),
    FOREIGN KEY (empleado_id) REFERENCES empleados (id)
);

-- Tabla: costos_variables
CREATE TABLE costos_variables
(
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    descripcion      VARCHAR(255)   NOT NULL,
    monto            DECIMAL(15, 2) NOT NULL,
    moneda_id        BIGINT         NOT NULL,
    fecha            DATE           NOT NULL,
    proveedor_id     BIGINT,
    factura_numero   VARCHAR(50),
    clasificacion_id BIGINT, -- Para clasificar el tipo de costo
    FOREIGN KEY (moneda_id) REFERENCES monedas (id),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores (id),
    FOREIGN KEY (clasificacion_id) REFERENCES clasificacion_costos (id)
);

-- Tabla: prestamos_deudas
CREATE TABLE prestamos_deudas
(
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    tipo              ENUM ('PRESTAMO', 'DEUDA')   NOT NULL,
    descripcion       VARCHAR(255),
    monto_original    DECIMAL(15, 2)               NOT NULL,
    moneda_id         BIGINT                       NOT NULL,
    tasa_interes      DECIMAL(5, 2)                NOT NULL, -- Porcentaje
    plazo_meses       INT                          NOT NULL,
    fecha_inicio      DATE                         NOT NULL,
    fecha_vencimiento DATE                         NOT NULL,
    estado            ENUM ('ACTIVO', 'CANCELADO') NOT NULL DEFAULT 'ACTIVO',
    FOREIGN KEY (moneda_id) REFERENCES monedas (id)
);

-- Tabla: calendario_pagos
CREATE TABLE calendario_pagos
(
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    prestamo_deuda_id BIGINT                       NOT NULL,
    numero_cuota      INT                          NOT NULL,
    fecha_pago        DATE                         NOT NULL,
    monto_capital     DECIMAL(15, 2)               NOT NULL,
    monto_interes     DECIMAL(15, 2)               NOT NULL,
    monto_total       DECIMAL(15, 2)               NOT NULL,
    estado            ENUM ('PENDIENTE', 'PAGADO') NOT NULL DEFAULT 'PENDIENTE',
    fecha_pagado      DATE,
    FOREIGN KEY (prestamo_deuda_id) REFERENCES prestamos_deudas (id)
);

-- Tabla: alertas
CREATE TABLE alertas
(
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id     BIGINT       NOT NULL,
    tipo_alerta    VARCHAR(50)  NOT NULL,
    mensaje        VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP             DEFAULT CURRENT_TIMESTAMP,
    leida          BOOLEAN      NOT NULL DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
);

-- Tabla: preferencias_notificaciones
CREATE TABLE preferencias_notificaciones
(
    id                       BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id               BIGINT                                NOT NULL,
    notificar_por_email      BOOLEAN                               NOT NULL DEFAULT TRUE,
    notificar_en_sistema     BOOLEAN                               NOT NULL DEFAULT TRUE,
    frecuencia_recordatorios ENUM ('DIARIO', 'SEMANAL', 'MENSUAL') NOT NULL DEFAULT 'DIARIO',
    FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
);

-- Tabla: transacciones
CREATE TABLE transacciones
(
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    tipo_transaccion ENUM (
        'PAGO_CUENTA_PAGAR',
        'COBRO_CUENTA_COBRAR',
        'PAGO_COSTO_FIJO',
        'PAGO_COSTO_VARIABLE',
        'PAGO_PRESTAMO',
        'INGRESO_CAJA_DIARIA',
        'EGRESO_CAJA_DIARIA'
        )                           NOT NULL,
    referencia_id    BIGINT         NOT NULL, -- ID del registro relacionado
    monto            DECIMAL(15, 2) NOT NULL,
    moneda_id        BIGINT         NOT NULL,
    fecha            DATE           NOT NULL,
    usuario_id       BIGINT,
    FOREIGN KEY (moneda_id) REFERENCES monedas (id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
);

-- Tabla: reportes_generados
CREATE TABLE reportes_generados
(
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id       BIGINT      NOT NULL,
    tipo_reporte     VARCHAR(50) NOT NULL,
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    parametros       VARCHAR(255),
    ruta_archivo     VARCHAR(255),
    FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
);

-- Tabla: ingresos
CREATE TABLE ingresos
(
    id                   BIGINT AUTO_INCREMENT PRIMARY KEY,
    descripcion          VARCHAR(255)                                      NOT NULL,
    monto                DECIMAL(15, 2)                                    NOT NULL,
    fecha                DATE                                              NOT NULL,
    tipo                 ENUM ('CUENTA_POR_COBRAR', 'CAJA_DIARIA', 'OTRO') NOT NULL,
    cuenta_por_cobrar_id BIGINT,
    moneda_id            BIGINT                                            NOT NULL,
    FOREIGN KEY (cuenta_por_cobrar_id) REFERENCES cuentas_por_cobrar (id),
    FOREIGN KEY (moneda_id) REFERENCES monedas (id)
);

-- Tabla: caja_diaria
CREATE TABLE caja_diaria
(
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha         DATE   NOT NULL,
    ingreso_total DECIMAL(15, 2) DEFAULT 0,
    egreso_total  DECIMAL(15, 2) DEFAULT 0,
    balance       DECIMAL(15, 2) GENERATED ALWAYS AS (ingreso_total - egreso_total) STORED,
    moneda_id     BIGINT NOT NULL,
    FOREIGN KEY (moneda_id) REFERENCES monedas (id)
);

-- Tabla: balance_financiero
CREATE TABLE balance_financiero
(
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    periodo          DATE NOT NULL,            -- Puede ser mensual, trimestral, etc.
    ingresos_totales DECIMAL(15, 2) DEFAULT 0,
    egresos_totales  DECIMAL(15, 2) DEFAULT 0,
    caja_chica       DECIMAL(15, 2) DEFAULT 0, -- Monto de caja diaria en el periodo
    balance_final    DECIMAL(15, 2) GENERATED ALWAYS AS (ingresos_totales + caja_chica - egresos_totales) STORED
);
