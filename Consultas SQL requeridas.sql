use pizzeria_don_piccolo;

/* Consultas SQL requeridas */

/* Clientes con pedidos entre 2 fechas (ENTRE) */

SELECT c.id, c.nombre, p.id, p.fecha_hora, p.total
FROM cliente c
JOIN pedido p ON c.id = p.cliente_fk
WHERE p.fecha_hora BETWEEN '2024-09-10' AND '2024-09-15'
ORDER BY p.fecha_hora DESC;

/* Pizzas mas vendidas (group by + count) */

select p.id, p.nombre, count(dp.id) as cantidad_vendida
from pizza p left join detalle_pedido dp on p.id = dp.pizza_fk group by p.id, p.nombre
order by cantidad_vendida desc limit 10;

/* Pedidos por repartidor */

select r.id, r.nombre, r.zona, count(d.id) as total_entregas from repartidor r
left join domicilio d on r.id = d.repartidor_fk group by r.id, r.nombre, r.zona
order by r.id;
 
/* consulta 4: promedio de entrega por zona (avg + join) */
 
select r.zona, avg(timestampdiff(minute, d.hora_salida, d.hora_entrega)) as promedio_minutos
from repartidor r
left join domicilio d on r.id = d.repartidor_fk where d.hora_entrega is not null
group by r.zona;
 
 
/*  consulta 5: clientes que gastaron más de un monto (having)  */
 
select c.id, c.nombre, count(p.id) as total_pedidos, sum(p.total) as total_gastado
from cliente c
left join pedido p on c.id = p.cliente_fk group by c.id, c.nombre
having sum(p.total) > 100000 order by total_gastado desc;
 
 
/*  consulta 6: búsqueda por coincidencia parcial (like) */
 
select id, nombre, descripcion, precio_base, tipo
from pizza where nombre like '%pollo%' or nombre like '%pollo%'
order by nombre;
 
 
/*  consulta 7: clientes frecuentes - subconsulta (>5 pedidos) */
 
select c.id, c.nombre, c.telefono, count(p.id) as total_pedidos, sum(p.total) as total_gastado
from cliente c
left join pedido p on c.id = p.cliente_fk where p.id is not null group by c.id, c.nombre, c.telefono
having count(p.id) >= 1 order by total_pedidos desc;