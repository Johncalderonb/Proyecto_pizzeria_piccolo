CREATE DATABASE pizzeria_don_piccolo;
USE pizzeria_don_piccolo;

-- ====================================================================
-- TABLA 1: CLIENTE
-- ====================================================================
CREATE TABLE cliente (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    direccion VARCHAR(255),
    email VARCHAR(100) UNIQUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- TABLA 2: REPARTIDOR
-- ====================================================================
CREATE TABLE repartidor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    zona VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'disponible',
    disponible INT DEFAULT 1,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- TABLA 3: INGREDIENTES
-- ====================================================================
CREATE TABLE ingredientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    stock INT DEFAULT 0,
    stock_minimo INT DEFAULT 10,
    disponibilidad INT DEFAULT 1,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- TABLA 4: PIZZA
-- ====================================================================
CREATE TABLE pizza (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio_base DOUBLE NOT NULL,
    tipo VARCHAR(50),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- TABLA 5: PIZZA_INGREDIENTES (Relación N:M)
-- ====================================================================
CREATE TABLE pizza_ingredientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pizza_fk INT NOT NULL,
    ingrediente_fk INT NOT NULL,
    cantidad_necesaria INT NOT NULL DEFAULT 1,
    
    FOREIGN KEY (pizza_fk) REFERENCES pizza(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ingrediente_fk) REFERENCES ingredientes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    UNIQUE KEY uk_pizza_ingrediente (pizza_fk, ingrediente_fk)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- TABLA 6: PEDIDO
-- ====================================================================
CREATE TABLE pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_fk INT NOT NULL,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(50) DEFAULT 'pendiente',
    metodo_pago VARCHAR(50),
    total DOUBLE,
    notas TEXT,
    
    FOREIGN KEY (cliente_fk) REFERENCES cliente(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- TABLA 7: DETALLE_PEDIDO
-- ====================================================================
CREATE TABLE detalle_pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_fk INT NOT NULL,
    pizza_fk INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DOUBLE NOT NULL,
    
    FOREIGN KEY (pedido_fk) REFERENCES pedido(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pizza_fk) REFERENCES pizza(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- TABLA 8: DOMICILIO
-- ====================================================================
CREATE TABLE domicilio (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_fk INT NOT NULL UNIQUE,
    repartidor_fk INT,
    hora_salida TIMESTAMP NULL,
    hora_entrega TIMESTAMP NULL,
    distancia DOUBLE,
    costo_envio DOUBLE,
    observaciones TEXT,
    
    FOREIGN KEY (pedido_fk) REFERENCES pedido(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (repartidor_fk) REFERENCES repartidor(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- TABLA 9: HISTORIAL_PRECIOS
-- ====================================================================
CREATE TABLE historial_precios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pizza_fk INT NOT NULL,
    precio_anterior DOUBLE NOT NULL,
    precio_nuevo DOUBLE NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_cambio VARCHAR(100),
    
    FOREIGN KEY (pizza_fk) REFERENCES pizza(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


