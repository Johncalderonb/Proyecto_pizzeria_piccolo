# 📸 Evidencias Gráficas - Pizzería Don Piccolo

Documento interactivo para compilar evidencias visuales, capturas de ejecución y demostraciones del proyecto SQL.

---

## 📋 Instrucciones para Insertar Imágenes

Para agregar capturas de pantalla, guarda la imagen en la carpeta del proyecto y usa este formato:

```markdown
![Descripción de la imagen](./nombre_imagen.png)
```

**Ejemplo:**
```markdown
![Diagrama ER en MySQL Workbench](./diagrama_er.png)
```

---

## 🗂️ 1. Diagrama Entidad-Relación

### 📸 Captura de Pantalla: Diagrama ER (MySQL Workbench)

**Instrucciones:**
1. Abre `Diagrama Bd pizzeria.mwb` en MySQL Workbench
2. Ve a File → Export as PNG
3. Guarda como `01_diagrama_er.png`
4. Pega la imagen aquí:

![Diagrama ER - MySQL Workbench](./01_diagrama_er.png)

### Descripción Textual del Modelo

```
┌────────────────────────────────────────────────────────────────────────────────┐
│                         PIZZERIA DON PICCOLO - ER                             │
├────────────────────────────────────────────────────────────────────────────────┤
│                                                                                │
│  DATOS MAESTROS:                                                              │
│  • CLIENTE (id, nombre, telefono, direccion, email, fecha_registro)           │
│  • REPARTIDOR (id, nombre, zona, estado, disponible, fecha_registro)         │
│  • INGREDIENTES (id, nombre, stock, stock_minimo, disponibilidad)            │
│  • PIZZA (id, nombre, descripcion, precio_base, tipo)                        │
│                                                                                │
│  RELACIONES:                                                                  │
│  • PIZZA ←→ PIZZA_INGREDIENTES ←→ INGREDIENTES (N:M)                         │
│  • CLIENTE → PEDIDO → DETALLE_PEDIDO → PIZZA                                 │
│  • PEDIDO → DOMICILIO ← REPARTIDOR                                           │
│  • PIZZA → HISTORIAL_PRECIOS (Auditoría)                                      │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘
```

---

## ✅ 2. Creación de Base de Datos

### 📸 Captura: Ejecución de Estructura de Tablas

**Pasos:**
1. Ejecuta: `mysql -u root -p pizzeria_don_piccolo < tablas_y_estructura.sql`
2. Toma captura mostrando el prompt y las tablas creadas
3. Guarda como `02_creacion_tablas.png`

![Creación de Tablas SQL](./02_creacion_tablas.png)

**Verificación:**
```sql
SHOW TABLES;
DESCRIBE cliente;
DESCRIBE pedido;
```

### 📸 Captura: Resultado de SHOW TABLES

![SHOW TABLES - Resultados](./02b_show_tables.png)

---

## 📥 3. Inserción de Datos

### 📸 Captura: Carga de Datos Iniciales

**Pasos:**
1. Ejecuta: `mysql -u root -p pizzeria_don_piccolo < insert\ data.sql`
2. Toma captura mostrando los INSERT completados
3. Guarda como `03_insert_data.png`

![INSERT Data - Ejecución](./03_insert_data.png)

### 📸 Captura: Verificación de Registros

**Query:**
```sql
SELECT COUNT(*) as total_registros FROM cliente;
SELECT COUNT(*) as total_registros FROM pedido;
```

![Conteo de Registros](./03b_count_records.png)

---

## 👁️ 4. Vistas SQL

### Vista 1: Resumen de Pedidos por Cliente

#### 📸 Captura: Creación de Vista

**Pasos:**
1. Ejecuta el CREATE VIEW
2. Toma captura de la ejecución
3. Guarda como `04_vista_cliente.png`

![Vista: Resumen Clientes](./04_vista_cliente.png)

#### 📸 Captura: Resultado de la Vista

**Query:**
```sql
SELECT * FROM vw_resumen_pedidos_cliente 
WHERE cantidad_pedidos > 0 
ORDER BY total_gastado DESC 
LIMIT 5;
```

![Resultado Vista Cliente](./04b_resultado_cliente.png)

**Esperado:**
```
┌─────┬──────────────────┬─────────┬──────────────┬──────────────┬────────────────┐
│ id  │ nombre           │ cantidad│ total_gastado│ promedio_    │ ...            │
├─────┼──────────────────┼─────────┼──────────────┼──────────────┼────────────────┤
│ 1   │ Carlos González  │ 15      │ $1,250,000   │ $83,333.33   │                │
│ 2   │ María López      │ 8       │ $680,000     │ $85,000      │                │
└─────┴──────────────────┴─────────┴──────────────┴──────────────┴────────────────┘
```

---

### Vista 2: Desempeño de Repartidores

#### 📸 Captura: Resultados de Desempeño

**Query:**
```sql
SELECT * FROM vw_desempeno_repartidores 
WHERE numero_entregas > 0 
ORDER BY numero_entregas DESC;
```

![Vista: Desempeño Repartidores](./05_vista_repartidores.png)

**Análisis que debes ver:**
- Repartidor más productivo
- Tiempo promedio de entrega
- Ingresos por repartidor
- Zonas y distancias

---

### Vista 3: Stock de Ingredientes Bajo

#### 📸 Captura: Alertas de Inventario

**Query:**
```sql
SELECT * FROM vw_stock_ingredientes_bajo 
ORDER BY faltante DESC;
```

![Vista: Stock Bajo](./06_vista_stock.png)

**Elementos a observar:**
- Ingredientes en estado "crítico"
- Cantidad faltante
- Stock mínimo vs actual

---

## ⚙️ 5. Funciones Almacenadas

### Función 1: Calcular Total del Pedido

#### 📸 Captura: Creación de Función

**Pasos:**
1. Ejecuta el CREATE FUNCTION
2. Toma captura
3. Guarda como `07_funcion_total.png`

![Creación Función Total](./07_funcion_total.png)

#### 📸 Captura: Ejecución de la Función

**Query:**
```sql
SELECT 
    p.id, 
    c.nombre,
    p.total,
    fn_calcular_total_pedido(p.id) AS total_con_iva
FROM pedido p
JOIN cliente c ON p.cliente_fk = c.id
LIMIT 5;
```

![Resultado Función Total](./07b_resultado_total.png)

**Esperado:**
```
Función calcula: Subtotal + Envío × 1.19 (IVA 19%)
```

---

### Función 2: Ganancia Neta Diaria

#### 📸 Captura: Resultado de Ganancia Diaria

**Query:**
```sql
SELECT fn_ganancia_neta_diaria(CURDATE()) AS ganancia_hoy;
```

![Función Ganancia Diaria](./08_funcion_ganancia.png)

**Cálculo visible:**
```
Ganancia = Ventas - (Ventas × 0.30 costo ingredientes)
```

---

## 🔔 6. Triggers (Disparadores)

### Trigger 1: Descuento de Stock Automático

#### 📸 Captura: ANTES - Stock Inicial

**Query:**
```sql
SELECT id, nombre, stock FROM ingredientes LIMIT 5;
```

![Stock Antes de Trigger](./09_stock_antes.png)

#### 📸 Captura: Ejecución INSERT (Trigger Activa)

**Query:**
```sql
INSERT INTO detalle_pedido (pedido_fk, pizza_fk, cantidad, precio_unitario)
VALUES (1, 1, 2, 25000);
```

![INSERT activando Trigger](./09b_insert_trigger.png)

#### 📸 Captura: DESPUÉS - Stock Actualizado

**Query:**
```sql
SELECT id, nombre, stock FROM ingredientes LIMIT 5;
```

![Stock Después de Trigger](./09c_stock_despues.png)

**Verificar:** El stock debe haber disminuido automáticamente

---

### Trigger 2: Auditoría de Precios

#### 📸 Captura: UPDATE de Precio

**Query:**
```sql
UPDATE pizza SET precio_base = 35000 WHERE id = 1;
```

![UPDATE Precio](./10_update_precio.png)

#### 📸 Captura: Historial Automático

**Query:**
```sql
SELECT * FROM historial_precios 
WHERE pizza_fk = 1 
ORDER BY fecha_cambio DESC;
```

![Historial Precios](./10b_historial_precios.png)

**Verificar:** Registro automático de precio anterior y nuevo

---

### Trigger 3: Liberar Repartidor

#### 📸 Captura: Repartidor Disponible = 0

**Antes:**
```sql
SELECT id, nombre, disponible FROM repartidor WHERE id = 1;
```

![Repartidor Ocupado](./11_repartidor_antes.png)

#### 📸 Captura: Marcar Entrega Completada

**Query:**
```sql
UPDATE domicilio SET hora_entrega = NOW() WHERE id = 15;
```

![UPDATE Entrega](./11b_update_entrega.png)

#### 📸 Captura: Repartidor Disponible = 1

**Después:**
```sql
SELECT id, nombre, disponible FROM repartidor WHERE id = 1;
```

![Repartidor Liberado](./11c_repartidor_despues.png)

**Verificar:** disponible cambió a 1 automáticamente

---

## 📊 7. Consultas Avanzadas

### Consulta 1: Pizzas Más Vendidas

#### 📸 Captura: Ejecución

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

![Pizzas Más Vendidas](./12_pizzas_top10.png)

**Analiza:**
- Top 3 pizzas
- Porcentaje de ventas
- Pizza menos vendida

---

### Consulta 2: Tiempo Promedio por Zona

#### 📸 Captura: Ejecución

```sql
SELECT 
    r.zona,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)), 2) 
        AS promedio_minutos,
    COUNT(d.id) AS total_entregas
FROM repartidor r
LEFT JOIN domicilio d ON r.id = d.repartidor_fk 
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.zona
ORDER BY promedio_minutos ASC;
```

![Promedio por Zona](./13_promedio_zona.png)

**Analiza:**
- Zona más rápida
- Zona más lenta
- Diferencia de tiempo

---

### Consulta 3: Clientes VIP (>$100k)

#### 📸 Captura: Ejecución

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

![Clientes VIP](./14_clientes_vip.png)

**Analiza:**
- Cliente #1 en gasto
- Patrón de compras
- Segmentación corporativo vs individual

---

## 📈 8. Dashboard Ejecutivo

### 📸 Captura: Dashboard con KPIs

**Crear un resumen visual con:**
- Total de ventas
- Total de pedidos
- Clientes únicos
- Repartidores activos
- Ingredientes críticos

**Opciones:**
1. **Usar Excel:** Crear gráficos en Excel y capturar
2. **Usar MySQL UI:** Usar interfaz visual si está disponible
3. **Usar texto:** Tabla con KPIs importantes

![Dashboard KPIs](./15_dashboard.png)

**Métricas sugeridas:**
```
├── Ventas Totales: $XXX,XXX,XXX
├── Pedidos Entregados: XX%
├── Clientes Activos: XXX
├── Repartidores en Ruta: X/Y
└── Stock Crítico: X ingredientes
```

---

## 🔍 9. Verificaciones de Integridad

### 📸 Captura: Pedidos sin Cliente

**Query:**
```sql
SELECT * FROM pedido 
WHERE cliente_fk NOT IN (SELECT id FROM cliente);
```

![Validación Integridad 1](./16_validacion1.png)

**Esperado:** 0 registros (tabla limpia)

---

### 📸 Captura: Detalles Huérfanos

**Query:**
```sql
SELECT * FROM detalle_pedido 
WHERE pedido_fk NOT IN (SELECT id FROM pedido);
```

![Validación Integridad 2](./16b_validacion2.png)

**Esperado:** 0 registros (relaciona correctamente)

---

### 📸 Captura: Stock Negativo

**Query:**
```sql
SELECT * FROM ingredientes WHERE stock < 0;
```

![Validación Integridad 3](./16c_validacion3.png)

**Esperado:** 0 registros (triggers protege)

---

## 📋 10. Resumen de Evidencias Capturadas

### Checklist de Capturas Requeridas

```markdown
## Imágenes a Capturar

### Estructura Base (2 imágenes)
- [ ] 01_diagrama_er.png — Diagrama ER de MySQL Workbench
- [ ] 02_creacion_tablas.png — Ejecución CREATE TABLE
- [ ] 02b_show_tables.png — Resultado SHOW TABLES

### Datos (2 imágenes)
- [ ] 03_insert_data.png — Ejecución INSERT
- [ ] 03b_count_records.png — Verificación de conteos

### Vistas (6 imágenes)
- [ ] 04_vista_cliente.png — Creación vista cliente
- [ ] 04b_resultado_cliente.png — Resultado SELECT vista cliente
- [ ] 05_vista_repartidores.png — Resultado vista repartidores
- [ ] 06_vista_stock.png — Resultado vista stock bajo

### Funciones (4 imágenes)
- [ ] 07_funcion_total.png — Creación función total
- [ ] 07b_resultado_total.png — Resultado función total
- [ ] 08_funcion_ganancia.png — Resultado función ganancia

### Triggers (6 imágenes)
- [ ] 09_stock_antes.png — Stock ANTES de trigger
- [ ] 09b_insert_trigger.png — INSERT ejecutando trigger
- [ ] 09c_stock_despues.png — Stock DESPUÉS de trigger
- [ ] 10_update_precio.png — UPDATE de precio
- [ ] 10b_historial_precios.png — Historial automático
- [ ] 11_repartidor_antes.png — Repartidor ocupado
- [ ] 11b_update_entrega.png — UPDATE completar entrega
- [ ] 11c_repartidor_despues.png — Repartidor liberado

### Consultas (3 imágenes)
- [ ] 12_pizzas_top10.png — Pizzas más vendidas
- [ ] 13_promedio_zona.png — Tiempo promedio por zona
- [ ] 14_clientes_vip.png — Clientes que gastaron >$100k

### Dashboard (1 imagen)
- [ ] 15_dashboard.png — Dashboard ejecutivo con KPIs

### Validaciones (3 imágenes)
- [ ] 16_validacion1.png — Pedidos sin cliente
- [ ] 16b_validacion2.png — Detalles huérfanos
- [ ] 16c_validacion3.png — Stock negativo

**TOTAL: 32 imágenes a capturar**
```

---

## 📸 Notas sobre Capturas de Pantalla

### Recomendaciones
1. **Resolución:** 1280×720 mínimo (para claridad)
2. **Formato:** PNG o JPG
3. **Nombre:** Usa el esquema `##_descripcion.png`
4. **Ubicación:** Guarda en la carpeta del proyecto
5. **Región:** Captura solo la ventana relevante (sin barras del SO)

### Herramientas Recomendadas
- **Windows:** Presiona `Win + Shift + S` (recorte de pantalla)
- **Mac:** `Cmd + Shift + 4`
- **Linux:** `gnome-screenshot`
- **Alternativa:** ShareX, Snagit

### Formato de Captura

```
┌─────────────────────────────────────────┐
│ MySQL Workbench / Terminal              │
│ (pantalla de donde tomas la captura)    │
│                                         │
│ Query/Resultado visible y legible       │
│                                         │
└─────────────────────────────────────────┘
```

---

## ✅ Checklist Final

- [ ] Diagrama ER capturado
- [ ] Tablas creadas y verificadas
- [ ] Datos insertados correctamente
- [ ] 3 Vistas funcionando
- [ ] 2 Funciones probadas
- [ ] 3 Triggers activos
- [ ] Consultas avanzadas ejecutadas
- [ ] Dashboard con KPIs
- [ ] Validaciones completadas
- [ ] Todas las imágenes insertadas

---

**Proyecto:** Pizzería Don Piccolo  
**Documentación:** Evidencias Gráficas Interactivo  
**Versión:** 2.0 (Con espacios para imágenes)  
**Desarrollador:** John Faver Calderón Barragán  
**Última actualización:** 2024-09-15
