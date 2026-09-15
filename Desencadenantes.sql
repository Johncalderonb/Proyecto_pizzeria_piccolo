use pizzeria_don_piccolo;

/* disparador 1: Actualizar stock de ingredientes cuando se realiza pedido  */

DELIMITER //
 
CREATE TRIGGER tr_actualizar_stock_pedido
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    DECLARE v_stock_actual INT;
    DECLARE v_cantidad_necesaria INT;
    
    /*  Obtener cantidad necesaria de cada ingrediente de la pizza  */
    SELECT cantidad_necesaria into v_cantidad_necesaria from pizza_ingredientes
    WHERE pizza_fk = NEW.pizza_fk LIMIT 1;
    
    /*  Validar NULL  */
    IF v_cantidad_necesaria IS NULL THEN
        SET v_cantidad_necesaria = 0;
    END IF;
    
    /*  Descontar stock del ingrediente  */
    UPDATE ingredientes
    SET stock = stock - (v_cantidad_necesaria * NEW.cantidad)
    WHERE id IN ( SELECT ingrediente_fk FROM pizza_ingredientes
        WHERE pizza_fk = NEW.pizza_fk);
END//
 
DELIMITER ;

SELECT id, nombre, stock  FROM ingredientes  WHERE id <= 5;

INSERT INTO detalle_pedido (pedido_fk, pizza_fk, cantidad, precio_unitario)
VALUES (1, 1, 1, 25000);


/* disparador 2: Auditoria - Registrar cambios de precio en historial  */


 DELIMITER //
 
CREATE TRIGGER tr_auditar_cambio_precio
BEFORE UPDATE ON pizza
FOR EACH ROW
BEGIN
    IF OLD.precio_base != NEW.precio_base THEN
        INSERT INTO historial_precios (pizza_fk, precio_anterior, precio_nuevo, fecha_cambio, usuario_cambio)
        VALUES (NEW.id, OLD.precio_base, NEW.precio_base, NOW(), USER());
    END IF;
END//
 
DELIMITER ;


SELECT id, nombre, precio_base FROM pizza WHERE id = 1;

UPDATE pizza SET precio_base = 35000 WHERE id = 1;

SELECT pizza_fk, precio_anterior, precio_nuevo, fecha_cambio, usuario_cambio
FROM historial_precios  WHERE pizza_fk = 1 ORDER BY fecha_cambio DESC;



/* Disparador 3: Marcar repartidor como disponible cuando termina domicilio */

DELIMITER //
 
CREATE TRIGGER tr_liberar_repartidor
AFTER UPDATE ON domicilio
FOR EACH ROW
BEGIN
    IF OLD.hora_entrega IS NULL AND NEW.hora_entrega IS NOT NULL THEN
        UPDATE repartidor
        SET disponible = 1
        WHERE id = NEW.repartidor_fk;
    END IF;
END//
 
SELECT r.id, r.nombre, r.disponible,
    CASE 
        WHEN r.disponible = 1 THEN 'Disponible'
        WHEN r.disponible = 0 THEN 'No disponible'
    END 
    AS estado FROM repartidor r WHERE r.id = 3;
    
 UPDATE domicilio SET hora_entrega = NOW() WHERE id = 41;   