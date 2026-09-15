use pizzeria_don_piccolo;

/* Vistas */ 


/* Vista de resumen de pedidos por cliente (nombre del cliente, cantidad de pedidos, total gastado).  */

create view vw_resumen_pedidos_cliente as
select c.id, c.nombre, c.email, c.telefono, count(p.id) as cantidad_pedidos, sum(p.total) as total_gastado,
avg(p.total) as promedio_pedido from cliente c
left join pedido p on c.id = p.cliente_fk group by c.id, c.nombre, c.email, c.telefono;


select * from vw_resumen_pedidos_cliente 
where cantidad_pedidos > 0 order by total_gastado desc;


/* Vista de desempeño de repartidores (número de entregas, tiempo promedio, zona). */ 


create view vw_desempeno_repartidores as
select r.id, r.nombre, r.zona, r.disponible, count(d.id) as numero_entregas,
round(avg(timestampdiff(minute, d.hora_salida, d.hora_entrega)), 2) as tiempo_promedio_minutos,
round(avg(d.distancia), 2) as distancia_promedio,
round(sum(d.costo_envio), 2) as ingresos_envios from repartidor r
left join domicilio d on r.id = d.repartidor_fk where d.hora_entrega is not null
group by r.id, r.nombre, r.zona, r.disponible;


select * from vw_desempeno_repartidores 
where numero_entregas > 0
order by numero_entregas desc;


/* Vista de stock de ingredientes por debajo del mínimo permitido. */ 

create view vw_stock_ingredientes_bajo as
select id, nombre, stock, stock_minimo, (stock_minimo - stock) as faltante, disponibilidad,
    case 
        when stock < stock_minimo then 'critico'
        when stock = stock_minimo then 'en limite'
        else 'ok'
    end as estado from ingredientes where stock <= stock_minimo;
 
 
select * from vw_stock_ingredientes_bajo 
order by faltante desc;


