# 🍕 Pizzería Don Piccolo - Sistema de Gestión SQL

Sistema integral de gestión de pedidos, domicilios e inventario para pizzería, desarrollado en MySQL con arquitectura modular basada en tablas, vistas, funciones, procedimientos y triggers.

**Autor:** John Faver Calderón Barragán  
**Versión:** 1.0  
**Última actualización:** Septiembre 2024  
**Tecnología:** MySQL 5.7+

---

## 📋 Tabla de Contenidos

1. [Descripción General](#descripción-general)
2. [Requisitos](#requisitos)
3. [Instalación](#instalación)
4. [Estructura de Base de Datos](#estructura-de-base-de-datos)
5. [Componentes Principales](#componentes-principales)
6. [Vistas SQL](#vistas-sql)
7. [Funciones y Procedimientos](#funciones-y-procedimientos)
8. [Triggers (Disparadores)](#triggers-disparadores)
9. [Ejemplos de Uso](#ejemplos-de-uso)
10. [Evidencias de Actividad](#evidencias-de-actividad)

---

## 📊 Descripción General

**Pizzería Don Piccolo** es un sistema de gestión SQL diseñado para:

- ✅ Administrar clientes y sus historiales de pedidos
- ✅ Gestionar inventario de ingredientes en tiempo real
- ✅ Controlar catálogo de pizzas y precios
- ✅ Registrar pedidos y detalles de compra
- ✅ Asignar y rastrear domicilios
- ✅ Monitorear desempeño de repartidores
- ✅ Auditar cambios de precios automáticamente

---

## 🔧 Requisitos

- **MySQL Server:** Versión 5.7 o superior
- **MySQL Workbench:** Para visualización del diagrama ERD (opcional)
- **Cliente SQL:** MySQL CLI o cualquier gestor SQL
- **Permisos:** Acceso root o usuario con permisos de creación de bases de datos

---

## 🚀 Instalación

### 1. Crear la Base de Datos

```bash
mysql -u root -p < pizzeria_workbench.sql
```

### 2. Crear Estructura de Tablas

```bash
mysql -u root -p pizzeria_don_piccolo < tablas_y_estructura.sql
```

### 3. Cargar Datos Iniciales

```bash
mysql -u root -p pizzeria_don_piccolo < insert\ data.sql
```

### 4. Crear Vistas

```bash
mysql -u root -p pizzeria_don_piccolo < Vistas.sql
```

### 5. Crear Funciones y Procedimientos

```bash
mysql -u root -p pizzeria_don_piccolo < "Funciones y procedimientos.sql"
```

### 6. Crear Triggers

```bash
mysql -u root -p pizzeria_don_piccolo < Desencadenantes.sql
```

### Verificar Instalación

```sql
USE pizzeria_don_piccolo;
SHOW TABLES;
SHOW VIEWS;
```

---

## 🗂️ Estructura de Base de Datos

### Diagrama Entidad-Relación (ER)

```
┌─────────────────────────────────────────────────────────────────┐
│                    PIZZERIA DON PICCOLO                         │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────┐        ┌──────────────────┐
│     CLIENTE      │        │    REPARTIDOR    │
├──────────────────┤        ├──────────────────┤
│ id (PK)          │        │ id (PK)          │
│ nombre           │        │ nombre           │
│ telefono         │        │ zona             │
│ direccion        │        │ estado           │
│ email (UNIQUE)   │        │ disponible       │
│ fecha_registro   │        │ fecha_registro   │
└──────────────────┘        └──────────────────┘
         │                           │
         │                           │
         └───────────┬───────────────┘
                     │
         ┌───────────┴────────────┐
         │                        │
    ┌────────────┐         ┌─────────────┐
    │   PEDIDO   │         │  DOMICILIO  │
    ├────────────┤         ├─────────────┤
    │ id (PK)    │◄────────│ pedido_fk   │
    │ cliente_fk │         │ repartidor_ │
    │ fecha_hora │         │ fk          │
    │ estado     │         │ hora_salida │
    │ metodo_pago│         │ hora_entrega│
    │ total      │         │ distancia   │
    │ notas      │         │ costo_envio │
    └────────────┘         └─────────────┘
         │
         │ (1:N)
         │
    ┌─────────────────┐
    │ DETALLE_PEDIDO  │
    ├─────────────────┤
    │ id (PK)         │
    │ pedido_fk (FK)  │
    │ pizza_fk (FK)   │
    │ cantidad        │
    │ precio_unitario │
    └─────────────────┘
         │
         │ (N:M via PIZZA_INGREDIENTES)
         │
    ┌──────────────────┐
    │      PIZZA       │
    ├──────────────────┤
    │ id (PK)          │
    │ nombre           │
    │ descripcion      │
    │ precio_base      │
    │ tipo             │
    │ fecha_registro   │
    └──────────────────┘
         │
         │ (N:M)
         │
    ┌──────────────────────┐
    │ PIZZA_INGREDIENTES   │
    ├──────────────────────┤
    │ id (PK)              │
    │ pizza_fk (FK)        │
    │ ingrediente_fk (FK)  │
    │ cantidad_necesaria   │
    └──────────────────────┘
         │
         │
    ┌──────────────────┐
    │   INGREDIENTES   │
    ├──────────────────┤
    │ id (PK)          │
    │ nombre (UNIQUE)  │
    │ stock            │
    │ stock_minimo     │
    │ disponibilidad   │
    │ fecha_registro   │
    └──────────────────┘

┌───────────────────────┐
│ HISTORIAL_PRECIOS     │
├───────────────────────┤
│ id (PK)               │
│ pizza_fk (FK)         │
│ precio_anterior       │
│ precio_nuevo          │
│ fecha_cambio          │
│ usuario_cambio        │
└───────────────────────┘
```

---

## 📑 Componentes Principales

### 1. Tablas Principales (9 Tablas)

#### **CLIENTE**
Almacena información de clientes de la pizzería.

| Campo | Tipo | Restricción |
|-------|------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT |
| nombre | VARCHAR(100) | NOT NULL |
| telefono | VARCHAR(15) | |
| direccion | VARCHAR(255) | |
| email | VARCHAR(100) | UNIQUE |
| fecha_registro | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

```sql
SELECT * FROM cliente;
-- Retorna todos los clientes registrados
```

#### **REPARTIDOR**
Gestiona repartidores disponibles por zona.

| Campo | Tipo | Restricción |
|-------|------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT |
| nombre | VARCHAR(100) | NOT NULL |
| zona | VARCHAR(100) | |
| estado | VARCHAR(20) | DEFAULT 'disponible' |
| disponible | INT | DEFAULT 1 |
| fecha_registro | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

#### **INGREDIENTES**
Control de inventario de ingredientes.

| Campo | Tipo | Restricción |
|-------|------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT |
| nombre | VARCHAR(100) | NOT NULL, UNIQUE |
| stock | INT | DEFAULT 0 |
| stock_minimo | INT | DEFAULT 10 |
| disponibilidad | INT | DEFAULT 1 |
| fecha_registro | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

#### **PIZZA**
Catálogo de productos de la pizzería.

| Campo | Tipo | Restricción |
|-------|------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT |
| nombre | VARCHAR(100) | NOT NULL |
| descripcion | VARCHAR(255) | |
| precio_base | DOUBLE | NOT NULL |
| tipo | VARCHAR(50) | |
| fecha_registro | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

#### **PIZZA_INGREDIENTES**
Relación N:M entre pizzas e ingredientes.

| Campo | Tipo | Restricción |
|-------|------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT |
| pizza_fk | INT | NOT NULL (FK) |
| ingrediente_fk | INT | NOT NULL (FK) |
| cantidad_necesaria | INT | DEFAULT 1 |
| | | UNIQUE(pizza_fk, ingrediente_fk) |

#### **PEDIDO**
Registro de todos los pedidos realizados.

| Campo | Tipo | Restricción |
|-------|------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT |
| cliente_fk | INT | NOT NULL (FK) |
| fecha_hora | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| estado | VARCHAR(50) | DEFAULT 'pendiente' |
| metodo_pago | VARCHAR(50) | |
| total | DOUBLE | |
| notas | TEXT | |

**Estados posibles:** pendiente, en_preparacion, entregado, cancelado

#### **DETALLE_PEDIDO**
Detalles de items en cada pedido.

| Campo | Tipo | Restricción |
|-------|------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT |
| pedido_fk | INT | NOT NULL (FK) |
| pizza_fk | INT | NOT NULL (FK) |
| cantidad | INT | DEFAULT 1 |
| precio_unitario | DOUBLE | NOT NULL |

#### **DOMICILIO**
Información de entregas a domicilio.

| Campo | Tipo | Restricción |
|-------|------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT |
| pedido_fk | INT | NOT NULL, UNIQUE (FK) |
| repartidor_fk | INT | (FK) |
| hora_salida | TIMESTAMP | NULL |
| hora_entrega | TIMESTAMP | NULL |
| distancia | DOUBLE | |
| costo_envio | DOUBLE | |
| observaciones | TEXT | |

#### **HISTORIAL_PRECIOS**
Auditoría automática de cambios de precios.

| Campo | Tipo | Restricción |
|-------|------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT |
| pizza_fk | INT | NOT NULL (FK) |
| precio_anterior | DOUBLE | NOT NULL |
| precio_nuevo | DOUBLE | NOT NULL |
| fecha_cambio | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| usuario_cambio | VARCHAR(100) | |

---

## 👁️ Vistas SQL

Las vistas permiten análisis rápido sin cálculos complejos.

### 1. **vw_resumen_pedidos_cliente**
Resumen de actividad por cliente.

```sql
SELECT * FROM vw_resumen_pedidos_cliente 
WHERE cantidad_pedidos > 0 
ORDER BY total_gastado DESC;
```

| Columna | Descripción |
|---------|-------------|
| id | ID del cliente |
| nombre | Nombre del cliente |
| email | Email del cliente |
| telefono | Teléfono de contacto |
| cantidad_pedidos | Total de pedidos realizados |
| total_gastado | Monto total invertido |
| promedio_pedido | Ticket promedio |

**Caso de uso:** Identificar clientes VIP y patrones de compra.

---

### 2. **vw_desempeno_repartidores**
Análisis del desempeño de repartidores.

```sql
SELECT * FROM vw_desempeno_repartidores 
WHERE numero_entregas > 0
ORDER BY numero_entregas DESC;
```

| Columna | Descripción |
|---------|-------------|
| id | ID del repartidor |
| nombre | Nombre del repartidor |
| zona | Zona asignada |
| disponible | Estado actual |
| numero_entregas | Total de entregas realizadas |
| tiempo_promedio_minutos | Tiempo promedio por entrega |
| distancia_promedio | Distancia promedio recorrida |
| ingresos_envios | Ingresos totales en envíos |

**Caso de uso:** Evaluar productividad y eficiencia de entregas.

---

### 3. **vw_stock_ingredientes_bajo**
Alertas de ingredientes con stock bajo.

```sql
SELECT * FROM vw_stock_ingredientes_bajo 
ORDER BY faltante DESC;
```

| Columna | Descripción |
|---------|-------------|
| id | ID del ingrediente |
| nombre | Nombre del ingrediente |
| stock | Stock actual |
| stock_minimo | Stock mínimo requerido |
| faltante | Diferencia (lo que falta) |
| disponibilidad | 1=disponible, 0=no disponible |
| estado | 'critico', 'en limite', 'ok' |

**Caso de uso:** Gestión de inventario y reordenamiento automático.

---

## ⚙️ Funciones y Procedimientos

### Funciones (Functions)

#### **fn_calcular_total_pedido(p_pedido_id INT)**

Calcula el total de un pedido incluyendo subtotal, costo de envío e IVA.

**Fórmula:**
```
Total = (Subtotal de pizzas + Costo de envío) × 1.19
```

```sql
SELECT 
    p.id AS pedido_id,
    c.nombre AS cliente,
    p.total AS total_guardado,
    fn_calcular_total_pedido(p.id) AS total_calculado_con_iva
FROM pedido p
JOIN cliente c ON p.cliente_fk = c.id
LIMIT 5;
```

---

#### **fn_ganancia_neta_diaria(p_fecha DATE)**

Calcula la ganancia neta diaria asumiendo 30% de costo de ingredientes.

**Fórmula:**
```
Ganancia Neta = Ventas del día - (Ventas × 0.30)
```

```sql
SELECT 
    fecha,
    total_pedidos,
    ventas,
    ROUND(ventas * 0.30, 2) AS costo_ingredientes_30_porciento,
    fn_ganancia_neta_diaria(fecha) AS ganancia_neta
FROM (
    SELECT 
        DATE(fecha_hora) AS fecha,
        COUNT(id) AS total_pedidos,
        SUM(total) AS ventas
    FROM pedido 
    WHERE estado = 'entregado' 
    GROUP BY DATE(fecha_hora)
) AS datos
ORDER BY fecha DESC;
```

---

### Procedimientos (Stored Procedures)

#### **sp_marcar_entregado(IN p_domicilio_id INT)**

Marca un domicilio como entregado y actualiza el estado del pedido.

```sql
-- Ejecutar cuando se completa una entrega
CALL sp_marcar_entregado(15);

-- Verificar cambios
SELECT d.id, d.pedido_fk, d.hora_entrega, p.estado
FROM domicilio d
JOIN pedido p ON d.pedido_fk = p.id 
WHERE d.id = 15;
```

---

## 🔔 Triggers (Disparadores)

Los triggers automatizan procesos críticos sin intervención manual.

### 1. **tr_actualizar_stock_pedido**

**Evento:** AFTER INSERT ON detalle_pedido  
**Acción:** Descuenta automáticamente ingredientes del stock.

**Lógica:**
```
Cuando se agrega un detalle de pedido:
  1. Obtener ingredientes de la pizza
  2. Multiplicar cantidad_necesaria × cantidad_pedida
  3. Descontar del stock de cada ingrediente
```

**Evidencia:**
```sql
-- Stock antes
SELECT id, nombre, stock FROM ingredientes WHERE id <= 5;

-- Insertar un pedido
INSERT INTO detalle_pedido (pedido_fk, pizza_fk, cantidad, precio_unitario)
VALUES (1, 1, 2, 25000);

-- Stock después (verá reducción automática)
SELECT id, nombre, stock FROM ingredientes WHERE id <= 5;
```

---

### 2. **tr_auditar_cambio_precio**

**Evento:** BEFORE UPDATE ON pizza  
**Acción:** Registra todos los cambios de precio en historial_precios.

**Lógica:**
```
Cuando se modifica precio de pizza:
  1. Comparar precio_anterior vs precio_nuevo
  2. Si son diferentes, insertar en historial_precios
  3. Registrar usuario y fecha/hora del cambio
```

**Evidencia:**
```sql
-- Cambiar precio
UPDATE pizza SET precio_base = 35000 WHERE id = 1;

-- Ver historial de cambios
SELECT pizza_fk, precio_anterior, precio_nuevo, fecha_cambio, usuario_cambio
FROM historial_precios 
WHERE pizza_fk = 1 
ORDER BY fecha_cambio DESC;
```

---

### 3. **tr_liberar_repartidor**

**Evento:** AFTER UPDATE ON domicilio  
**Acción:** Marca repartidor como disponible al completar entrega.

**Lógica:**
```
Cuando se actualiza hora_entrega en domicilio:
  1. Verificar que hora_entrega pasó de NULL a un valor
  2. Actualizar repartidor.disponible = 1
  3. Liberar repartidor para nueva asignación
```

**Evidencia:**
```sql
-- Ver estado repartidor
SELECT r.id, r.nombre, r.disponible,
    CASE 
        WHEN r.disponible = 1 THEN 'Disponible'
        WHEN r.disponible = 0 THEN 'No disponible'
    END AS estado 
FROM repartidor r 
WHERE r.id = 3;

-- Actualizar domicilio (trigger libera repartidor)
UPDATE domicilio SET hora_entrega = NOW() WHERE id = 41;
```

---

## 📊 Ejemplos de Uso

### Consulta 1: Clientes con Pedidos en Rango de Fechas

```sql
SELECT 
    c.id,
    c.nombre,
    p.id AS pedido_id,
    p.fecha_hora,
    p.total
FROM cliente c
JOIN pedido p ON c.id = p.cliente_fk 
WHERE p.fecha_hora BETWEEN '2024-09-10' AND '2024-09-15'
ORDER BY p.fecha_hora DESC;
```

---

### Consulta 2: Pizzas Más Vendidas (Top 10)

```sql
SELECT 
    p.id,
    p.nombre,
    COUNT(dp.id) AS cantidad_vendida
FROM pizza p 
LEFT JOIN detalle_pedido dp ON p.id = dp.pizza_fk 
GROUP BY p.id, p.nombre
ORDER BY cantidad_vendida DESC 
LIMIT 10;
```

---

### Consulta 3: Entregas por Repartidor

```sql
SELECT 
    r.id,
    r.nombre,
    r.zona,
    COUNT(d.id) AS total_entregas
FROM repartidor r
LEFT JOIN domicilio d ON r.id = d.repartidor_fk 
GROUP BY r.id, r.nombre, r.zona
ORDER BY total_entregas DESC;
```

---

### Consulta 4: Tiempo Promedio de Entrega por Zona

```sql
SELECT 
    r.zona,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)), 2) 
        AS promedio_minutos
FROM repartidor r
LEFT JOIN domicilio d ON r.id = d.repartidor_fk 
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.zona;
```

---

### Consulta 5: Clientes que Gastaron Más de $100,000

```sql
SELECT 
    c.id,
    c.nombre,
    COUNT(p.id) AS total_pedidos,
    SUM(p.total) AS total_gastado
FROM cliente c
LEFT JOIN pedido p ON c.id = p.cliente_fk 
GROUP BY c.id, c.nombre
HAVING SUM(p.total) > 100000 
ORDER BY total_gastado DESC;
```

---

### Consulta 6: Búsqueda de Pizzas por Nombre (LIKE)

```sql
SELECT 
    id,
    nombre,
    descripcion,
    precio_base,
    tipo
FROM pizza 
WHERE nombre LIKE '%pollo%'
ORDER BY nombre;
```

---

### Consulta 7: Clientes Frecuentes (Subconsulta)

```sql
SELECT 
    c.id,
    c.nombre,
    c.telefono,
    COUNT(p.id) AS total_pedidos,
    SUM(p.total) AS total_gastado
FROM cliente c
LEFT JOIN pedido p ON c.id = p.cliente_fk 
WHERE p.id IS NOT NULL 
GROUP BY c.id, c.nombre, c.telefono
HAVING COUNT(p.id) >= 1 
ORDER BY total_pedidos DESC;
```

---

## 📈 Evidencias de Actividad

### Estadísticas del Proyecto

```
📊 RESUMEN DE COMPONENTES
├── 📋 Tablas: 9
│   ├── CLIENTE
│   ├── REPARTIDOR
│   ├── INGREDIENTES
│   ├── PIZZA
│   ├── PIZZA_INGREDIENTES
│   ├── PEDIDO
│   ├── DETALLE_PEDIDO
│   ├── DOMICILIO
│   └── HISTORIAL_PRECIOS
│
├── 👁️ Vistas: 3
│   ├── vw_resumen_pedidos_cliente
│   ├── vw_desempeno_repartidores
│   └── vw_stock_ingredientes_bajo
│
├── ⚙️ Funciones: 2
│   ├── fn_calcular_total_pedido
│   └── fn_ganancia_neta_diaria
│
├── 🔧 Procedimientos: 1
│   └── sp_marcar_entregado
│
└── 🔔 Triggers: 3
    ├── tr_actualizar_stock_pedido
    ├── tr_auditar_cambio_precio
    └── tr_liberar_repartidor
```

### Conceptos SQL Implementados

```
✅ CREACIÓN Y ESTRUCTURA
   └─ CREATE DATABASE
   └─ CREATE TABLE con constraints
   └─ PRIMARY KEY, FOREIGN KEY
   └─ UNIQUE, NOT NULL, DEFAULT
   └─ AUTO_INCREMENT, TIMESTAMP

✅ CONSULTAS AVANZADAS
   └─ JOINs (INNER, LEFT)
   └─ GROUP BY + HAVING
   └─ ORDER BY + LIMIT
   └─ BETWEEN, LIKE, IN
   └─ Funciones de agregación (COUNT, SUM, AVG)
   └─ Funciones de fecha (DATE, TIMESTAMPDIFF)

✅ VISTAS (VIEWS)
   └─ CREATE VIEW
   └─ Queries complejas reutilizables
   └─ Abstracción de datos

✅ FUNCIONES ALMACENADAS
   └─ CREATE FUNCTION
   └─ Parámetros IN, RETURN
   └─ Variables locales (DECLARE)
   └─ Control de flujo (IF, ELSE)
   └─ Operaciones matemáticas

✅ PROCEDIMIENTOS ALMACENADOS
   └─ CREATE PROCEDURE
   └─ UPDATE múltiples tablas
   └─ Lógica de negocio automatizada

✅ TRIGGERS
   └─ BEFORE/AFTER INSERT
   └─ BEFORE/AFTER UPDATE
   └─ NEW / OLD valores
   └─ Control de inventario
   └─ Auditoría automática
```

### Relaciones y Integridad Referencial

```
CLIENTE (1) ────────────────────(N) PEDIDO
                                      │
                                      │
PIZZA (1) ────────(N) DETALLE_PEDIDO ◄┘
  │
  └─(N:M)─ PIZZA_INGREDIENTES ─(N:M)─ INGREDIENTES
  
PEDIDO (1) ─────────────(1) DOMICILIO
                              │
REPARTIDOR (1) ────────────────┘

PIZZA (1) ───────────(N) HISTORIAL_PRECIOS
```

### Restricciones Implementadas

| Restricción | Tablas | Propósito |
|------------|--------|----------|
| PRIMARY KEY | Todas | Identificación única |
| FOREIGN KEY | Relaciones | Integridad referencial |
| UNIQUE | cliente.email, ingredientes.nombre | Evitar duplicados |
| NOT NULL | Campos críticos | Garantizar datos completos |
| DEFAULT | Timestamps, estados | Valores automáticos |
| ON DELETE CASCADE | Pedidos, detalles | Eliminación en cascada |
| ON DELETE RESTRICT | Detalle-Pizza | Evitar orfandad de datos |
| ON DELETE SET NULL | Domicilio-Repartidor | Permitir ausencia de asignación |

---

## 🔍 Monitoreo y Mantenimiento

### Verificar Integridad de Datos

```sql
-- Pedidos sin cliente
SELECT * FROM pedido WHERE cliente_fk NOT IN (SELECT id FROM cliente);

-- Detalles de pedidos huérfanos
SELECT * FROM detalle_pedido WHERE pedido_fk NOT IN (SELECT id FROM pedido);

-- Stock negativo
SELECT * FROM ingredientes WHERE stock < 0;

-- Ingredientes faltantes en pizzas
SELECT DISTINCT pi.pizza_fk FROM pizza_ingredientes pi 
WHERE pi.ingrediente_fk NOT IN (SELECT id FROM ingredientes);
```

### Estadísticas de Rendimiento

```sql
-- Tamaño de la base de datos
SELECT 
    SUM(ROUND(((data_length + index_length) / 1024 / 1024), 2)) AS 'DB Size in MB'
FROM information_schema.TABLES 
WHERE table_schema = 'pizzeria_don_piccolo';

-- Tablas más grandes
SELECT table_name, ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.TABLES 
WHERE table_schema = 'pizzeria_don_piccolo'
ORDER BY (data_length + index_length) DESC;
```

---

## 📝 Notas de Desarrollo

- **Charset:** UTF8MB4 (soporta caracteres especiales)
- **Motor:** InnoDB (transacciones y FK)
- **Histórico de precios:** Auditoría automática mediante trigger
- **Stock en tiempo real:** Actualización automática en cada pedido
- **Cálculo de totales:** Función reutilizable para consistencia

---

## 🎯 Próximos Pasos / Mejoras Futuras

1. **Índices:** Optimizar queries con índices en campos frecuentemente consultados
2. **Particionamiento:** Dividir tablas grandes por fecha
3. **Backups:** Automatizar respaldos diarios
4. **Reportes:** Dashboard con visualizaciones en Tableau/Power BI
5. **API REST:** Conectar con aplicación frontend
6. **Validaciones:** Agregar checks de negocio adicionales

---

## 📞 Contacto y Soporte

**Desarrollador:** John Faver Calderón Barragán  
**Email:** johncalderon0720@gmail.com  
**GitHub:** [Johncalderonb](https://github.com/Johncalderonb)  
**Ubicación:** Girón/Floridablanca, Santander, Colombia

---

## 📄 Licencia

Proyecto educativo - Campuslands Programa de Software e IA

---

**Última actualización:** 15 de septiembre de 2024  
**Versión:** 1.0.0
