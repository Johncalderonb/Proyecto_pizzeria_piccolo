# 🚀 Guía Rápida - Pizzería Don Piccolo

Resumen ejecutivo y comandos esenciales para operación inmediata.

---

## ⚡ Setup Rápido (5 minutos)

```bash
# 1. Crear BD
mysql -u root -p < pizzeria_workbench.sql

# 2. Crear tablas
mysql -u root -p pizzeria_don_piccolo < tablas_y_estructura.sql

# 3. Cargar datos
mysql -u root -p pizzeria_don_piccolo < insert\ data.sql

# 4. Crear vistas
mysql -u root -p pizzeria_don_piccolo < Vistas.sql

# 5. Crear funciones y triggers
mysql -u root -p pizzeria_don_piccolo < "Funciones y procedimientos.sql"
mysql -u root -p pizzeria_don_piccolo < Desencadenantes.sql

# Verificar
mysql -u root -p pizzeria_don_piccolo
> SHOW TABLES;
> SHOW VIEWS;
```

---

## 📊 Consultas Frecuentes

### Top Ventas (Pizzas)
```sql
SELECT p.nombre, COUNT(*) AS vendidas, SUM(dp.cantidad * dp.precio_unitario) AS ingresos
FROM pizza p
JOIN detalle_pedido dp ON p.id = dp.pizza_fk
GROUP BY p.id, p.nombre
ORDER BY vendidas DESC LIMIT 10;
```

### Clientes VIP
```sql
SELECT * FROM vw_resumen_pedidos_cliente 
WHERE cantidad_pedidos > 5 
ORDER BY total_gastado DESC;
```

### Repartidores: Rendimiento
```sql
SELECT * FROM vw_desempeno_repartidores 
ORDER BY numero_entregas DESC;
```

### Ingredientes Bajos
```sql
SELECT * FROM vw_stock_ingredientes_bajo 
ORDER BY faltante DESC;
```

### Ganancia del Día
```sql
SELECT fn_ganancia_neta_diaria(CURDATE()) AS ganancia_hoy;
```

### Pedidos Pendientes
```sql
SELECT p.id, c.nombre, p.estado, p.total
FROM pedido p
JOIN cliente c ON p.cliente_fk = c.id
WHERE p.estado IN ('pendiente', 'en_preparacion')
ORDER BY p.fecha_hora DESC;
```

---

## ⚙️ Operaciones Comunes

### Registrar Nuevo Cliente
```sql
INSERT INTO cliente (nombre, telefono, direccion, email)
VALUES ('Nombre', '3105551234', 'Calle 1 #2-3', 'email@gmail.com');
```

### Crear Pedido
```sql
INSERT INTO pedido (cliente_fk, estado, metodo_pago, total)
VALUES (1, 'pendiente', 'efectivo', 50000);

-- Obtener ID generado
SELECT LAST_INSERT_ID() AS nuevo_pedido_id;
```

### Agregar Pizza al Pedido
```sql
INSERT INTO detalle_pedido (pedido_fk, pizza_fk, cantidad, precio_unitario)
VALUES (1, 1, 2, 25000);
-- ⚠️ TRIGGER automáticamente descuenta ingredientes del stock
```

### Asignar Repartidor
```sql
INSERT INTO domicilio (pedido_fk, repartidor_fk, hora_salida, costo_envio, distancia)
VALUES (1, 1, NOW(), 5000, 2.5);

-- Marcar como entregado (TRIGGER libera repartidor)
CALL sp_marcar_entregado(1);
```

### Cambiar Precio de Pizza
```sql
UPDATE pizza SET precio_base = 35000 WHERE id = 1;
-- ⚠️ TRIGGER automáticamente registra en historial_precios
```

### Actualizar Stock de Ingrediente
```sql
UPDATE ingredientes SET stock = 50 WHERE id = 1;
```

---

## 📈 KPIs Principales

### Ventas Diarias
```sql
SELECT DATE(fecha_hora) AS fecha, COUNT(*) AS pedidos, SUM(total) AS ventas
FROM pedido
WHERE estado = 'entregado'
GROUP BY DATE(fecha_hora)
ORDER BY fecha DESC LIMIT 30;
```

### Ticket Promedio
```sql
SELECT ROUND(AVG(total), 2) AS ticket_promedio FROM pedido WHERE estado = 'entregado';
```

### Rotación por Zona
```sql
SELECT r.zona, COUNT(d.id) AS entregas, 
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)), 0) AS min_promedio
FROM repartidor r
LEFT JOIN domicilio d ON r.id = d.repartidor_fk
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.zona
ORDER BY entregas DESC;
```

### Cliente Más Leal
```sql
SELECT c.nombre, c.email, c.telefono, COUNT(p.id) AS pedidos, SUM(p.total) AS gastado
FROM cliente c
JOIN pedido p ON c.id = p.cliente_fk
GROUP BY c.id
ORDER BY pedidos DESC, gastado DESC
LIMIT 1;
```

---

## 🚨 Alertas

### Ingredientes Críticos
```sql
SELECT * FROM vw_stock_ingredientes_bajo WHERE estado = 'critico';
```

### Pedidos sin Asignar Repartidor
```sql
SELECT p.id, c.nombre, p.fecha_hora
FROM pedido p
JOIN cliente c ON p.cliente_fk = c.id
WHERE p.id NOT IN (SELECT pedido_fk FROM domicilio)
AND p.estado != 'cancelado';
```

### Entregas Retrasadas (> 45 min)
```sql
SELECT d.id, c.nombre, r.nombre AS repartidor,
       TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega) AS minutos
FROM domicilio d
JOIN pedido p ON d.pedido_fk = p.id
JOIN cliente c ON p.cliente_fk = c.id
JOIN repartidor r ON d.repartidor_fk = r.id
WHERE TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega) > 45
AND d.hora_entrega IS NOT NULL;
```

---

## 🔧 Mantenimiento

### Backup Diario
```bash
mysqldump -u root -p pizzeria_don_piccolo > backup_$(date +%Y%m%d).sql
```

### Restaurar desde Backup
```bash
mysql -u root -p pizzeria_don_piccolo < backup_20240915.sql
```

### Verificar Integridad
```sql
-- Pedidos sin cliente
SELECT * FROM pedido WHERE cliente_fk NOT IN (SELECT id FROM cliente);

-- Detalles huérfanos
SELECT * FROM detalle_pedido WHERE pedido_fk NOT IN (SELECT id FROM pedido);

-- Stock negativo
SELECT * FROM ingredientes WHERE stock < 0;
```

### Optimizar BD
```sql
ANALYZE TABLE cliente, pedido, detalle_pedido, ingredientes;
OPTIMIZE TABLE cliente, pedido, detalle_pedido, ingredientes;
```

---

## 📊 Informes Ejecutivos

### Resumen Mensual
```sql
SELECT 
    DATE_TRUNC(DATE(fecha_hora), MONTH) AS mes,
    COUNT(*) AS total_pedidos,
    COUNT(DISTINCT cliente_fk) AS clientes_unicos,
    SUM(total) AS ventas_totales,
    ROUND(AVG(total), 2) AS ticket_promedio,
    ROUND(SUM(total) * 0.70, 2) AS ganancia_neta
FROM pedido
WHERE estado = 'entregado'
GROUP BY mes
ORDER BY mes DESC;
```

### Historco de Precios (Pizza X)
```sql
SELECT pizza_fk, precio_anterior, precio_nuevo, fecha_cambio, usuario_cambio
FROM historial_precios
WHERE pizza_fk = 1
ORDER BY fecha_cambio DESC;
```

### Desempeño por Repartidor (Mes)
```sql
SELECT 
    r.nombre,
    r.zona,
    COUNT(d.id) AS entregas,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)), 0) AS min_promedio,
    ROUND(SUM(d.costo_envio), 2) AS ingresos_envios
FROM repartidor r
LEFT JOIN domicilio d ON r.id = d.repartidor_fk
WHERE MONTH(d.hora_entrega) = MONTH(NOW()) 
  AND YEAR(d.hora_entrega) = YEAR(NOW())
  AND d.hora_entrega IS NOT NULL
GROUP BY r.id, r.nombre, r.zona
ORDER BY entregas DESC;
```

---

## 🔗 Relaciones Clave

```
CLIENTE → PEDIDO → DETALLE_PEDIDO → PIZZA ↔ INGREDIENTES
    ↓                    ↓
    └──→ DOMICILIO ──→ REPARTIDOR

PIZZA → HISTORIAL_PRECIOS (Auditoría)
```

---

## 🎯 Casos de Uso

### 1. Procesar un Pedido
```sql
-- 1. Crear pedido
INSERT INTO pedido (cliente_fk, estado, metodo_pago, total) 
VALUES (5, 'pendiente', 'tarjeta', 85000);
SET @pedido_id = LAST_INSERT_ID();

-- 2. Agregar pizzas (TRIGGER descuenta stock)
INSERT INTO detalle_pedido (pedido_fk, pizza_fk, cantidad, precio_unitario)
VALUES (@pedido_id, 1, 2, 30000), (@pedido_id, 3, 1, 25000);

-- 3. Crear domicilio
INSERT INTO domicilio (pedido_fk, repartidor_fk, hora_salida, costo_envio)
VALUES (@pedido_id, 2, NOW(), 5000);

-- 4. Marcar como entregado (TRIGGER libera repartidor)
CALL sp_marcar_entregado(LAST_INSERT_ID());

-- 5. Verificar
SELECT * FROM vw_resumen_pedidos_cliente WHERE id = 5;
```

### 2. Cambiar Precio
```sql
-- Trigger registra automáticamente en historial
UPDATE pizza SET precio_base = 32000 WHERE id = 2;

-- Ver histórico
SELECT * FROM historial_precios WHERE pizza_fk = 2 ORDER BY fecha_cambio DESC;
```

### 3. Reporte Diario
```sql
SELECT 
    'Ventas' AS metrica, SUM(total) AS valor,
    COUNT(*) AS pedidos
FROM pedido
WHERE DATE(fecha_hora) = CURDATE() AND estado = 'entregado'
UNION ALL
SELECT 
    'Ganancia' AS metrica,
    fn_ganancia_neta_diaria(CURDATE()) AS valor,
    NULL AS pedidos;
```

---

## 📞 Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `ERROR 1452` | FK no existe | Verificar cliente_fk, pizza_fk existen |
| `ERROR 1062` | Email duplicado | Cambiar email o usar UPDATE |
| `ERROR 1366` | Tipo dato incorrecto | Verificar tipos (INT, VARCHAR, DOUBLE) |
| Stock negativo | Pedido sin validación | Trigger protege automáticamente |
| Repartidor no libera | Trigger no activó | Usar `sp_marcar_entregado()` |

---

## 🎓 Conceptos

- **Vistas:** Consultas guardadas (reutilizables)
- **Funciones:** Retornan un valor (cálculos)
- **Procedimientos:** Ejecutan acciones complejas
- **Triggers:** Se ejecutan automáticamente en eventos (INSERT/UPDATE)
- **FK:** Garantiza relaciones válidas entre tablas
- **GROUP BY:** Agrupa resultados
- **HAVING:** Filtra grupos (como WHERE para agregados)

---

**Última actualización:** 2024-09-15  
**Versión:** 1.0  
**Desarrollador:** John Faver Calderón Barragán
