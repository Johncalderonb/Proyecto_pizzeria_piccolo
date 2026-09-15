use pizzeria_don_piccolo;

/* Funciones y procedimientos */

/* 1- Calcular el total de pedido */

DELIMITER //
 
CREATE FUNCTION fn_calcular_total_pedido(p_pedido_id INT)
RETURNS DOUBLE
READS SQL DATA
BEGIN
    DECLARE v_subtotal DOUBLE;
    DECLARE v_costo_envio DOUBLE;
    DECLARE v_iva DOUBLE;
    DECLARE v_total DOUBLE;
    
   /* subtotal de pizzas */
    SELECT SUM(cantidad * precio_unitario) INTO v_subtotal FROM detalle_pedido
    WHERE pedido_fk = p_pedido_id;
    
    /* Obtener costo de envío */
    SELECT costo_envio INTO v_costo_envio FROM domicilio
    WHERE pedido_fk = p_pedido_id;
    
    /* Validar NULL */
    IF v_costo_envio IS NULL THEN
        SET v_costo_envio = 0;
    END IF;
    
    IF v_subtotal IS NULL THEN
        SET v_subtotal = 0;
    END IF;
    
    /*  Calcular IVA 19% */
    SET v_iva = (v_subtotal + v_costo_envio) * 0.19;
    
    /*  Calcular total con IVA */
    SET v_total = v_subtotal + v_costo_envio + v_iva;
    
    RETURN v_total;
END//
 
DELIMITER ;

select * from pedido;

SELECT p.id AS pedido_id, c.nombre AS cliente, p.total AS total_guardado,
    fn_calcular_total_pedido(p.id) AS total_calculado_con_iva FROM pedido p
JOIN cliente c ON p.cliente_fk = c.id LIMIT 5;


/* 2- Calucular ganancia diaria */ 

DELIMITER //
 
CREATE FUNCTION fn_ganancia_neta_diaria(p_fecha DATE)
RETURNS DOUBLE
READS SQL DATA
BEGIN
    DECLARE v_ventas DOUBLE;
    DECLARE v_costo_ingredientes DOUBLE;
    DECLARE v_ganancia_neta DOUBLE;
    
    /* Calcular ventas del día (pedidos entregados)  */
    SELECT SUM(total) INTO v_ventas FROM pedido
    WHERE DATE(fecha_hora) = p_fecha AND estado = 'entregado';
    
    /* Calcular costo estimado de ingredientes (30% del total de ventas) */
    SELECT SUM(total) * 0.30 INTO v_costo_ingredientes FROM pedido
    WHERE DATE(fecha_hora) = p_fecha AND estado = 'entregado';
    
    /* Validar NULL */
    IF v_ventas IS NULL THEN
        SET v_ventas = 0;
    END IF;
    
    IF v_costo_ingredientes IS NULL THEN
        SET v_costo_ingredientes = 0;
    END IF;
    
    /*  Calcular ganancia neta */
    SET v_ganancia_neta = v_ventas - v_costo_ingredientes;
    
    RETURN v_ganancia_neta;
END//
 
DELIMITER ;


SELECT fecha,total_pedidos,ventas, ROUND(ventas * 0.30, 2) AS costo_ingredientes_30_porciento,
    fn_ganancia_neta_diaria(fecha) AS ganancia_neta
FROM ( SELECT DATE(fecha_hora) AS fecha, COUNT(id) AS total_pedidos, SUM(total) AS ventas
    FROM pedido WHERE estado = 'entregado' GROUP BY DATE(fecha_hora)) AS datos
ORDER BY fecha DESC;

/* 3- CAMBIAR ESTADO PEDIDO A ENTREGADO */

DELIMITER //
 
CREATE PROCEDURE sp_marcar_entregado(IN p_domicilio_id INT)
BEGIN
    DECLARE v_pedido_id INT;
    
    /* Obtener ID del pedido */
    SELECT pedido_fk INTO v_pedido_id FROM domicilio WHERE id = p_domicilio_id;
    
    /*  Actualizar hora de entrega */
    UPDATE domicilio SET hora_entrega = NOW() WHERE id = p_domicilio_id;
    
    /* Cambiar estado del pedido a entregado */
    UPDATE pedido SET estado = 'entregado' WHERE id = v_pedido_id;
END//
 
DELIMITER ;


CALL sp_marcar_entregado(15);

select * from pedido where estado = 'pendiente';

SELECT d.id, d.pedido_fk, d.hora_entrega, p.id AS pedido_id, p.estado
FROM domicilio d
JOIN pedido p ON d.pedido_fk = p.id WHERE d.id = 15;
