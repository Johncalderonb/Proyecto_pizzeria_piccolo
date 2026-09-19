use pizzeria_don_piccolo;
/* Pedidos por cliente */ 

select c.id, c.nombre, c.email, c.telefono, count(p.id) as cantidad_pedidos, sum(p.total) as total_gastado,
avg(p.total) as promedio_pedido from cliente c
left join pedido p on c.id = p.cliente_fk group by c.id, c.nombre, c.email, c.telefono;

/* Consulta pedidos entre 2 fechas */

SELECT c.id, c.nombre, p.id, p.fecha_hora, p.total
FROM cliente c
JOIN pedido p ON c.id = p.cliente_fk
WHERE p.fecha_hora BETWEEN '2024-09-10' AND '2024-09-14'
ORDER BY p.fecha_hora DESC;

/* consulta de resumen por metodo de pago */ 

select 
	p.metodo_pago,
    count(p.id) as cantidad_pedidos,
    sum(p.total) as total_acumulado
from pedido p
group by p.metodo_pago
order by cantidad_pedidos desc;    

/* Consulta clientes frecuentes */

select 
	c.id, c.nombre, c.email,
    count(p.id) as total_pedidos, 
    sum(p.total) as total_gastado
from cliente c
left join pedido p on c.id = p.cliente_fk
group by c.id, c.nombre, c.email
having count(p.id) > 2
order by total_pedidos desc;  




