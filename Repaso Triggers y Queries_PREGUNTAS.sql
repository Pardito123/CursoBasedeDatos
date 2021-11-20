/*1.1.	Crear una tabla llamada ESTVTA a partir de los 
clientes cuya venta anual supera los S/.40,000. Los atributos a 
considerar son: ID cliente, nombre, año ,venta del año. 
Verificar definición de la nueva tabla (sp_Help).*/
--NO CREEN PK NI FK


/*1.2.Adicionar una nueva columna a la tabla ESTVTA 
llamada "QProductos" (de tipo INT). Verificar la nueva 
estructura de Nueva_Tabla.(sp_help). Actualice el nuevo 
atributo con la venta en unidades por cliente.*/


/*1.3Escriba un trigger que reste el monto de venta y la cantidad de 
productos de la tabla ESTVTA cada vez que se elimine un registro
de OrderDetails*/


/*Modificar la tabla Empleados y agregar el campo ImpVendido de 
tipo INT NOT NULL con valor por defecto de 0.00 
Crear un trigger en la tabla order details para que 
cada vez que se venda un producto se actualice el 
campo impVendido  de la tabla empleados con el el valor 
que tiene en ese momento más la cantidad vendida en el order
 details. */


/*
Pregunta 1 (3 puntos) Crear una función que retorne el nombre de cliente, nombre del proveedor, código y nombre de los productos, cantidad vendida (quantity), total de importe bruto vendido(monto) de todas las órdenes emitidas en un país y un rango de tiempo ingresados como parámetros. */



/*Pregunta 2 (3 puntos) Crear un Procedimiento para insertar una línea de detalle de la orden (Order Details), incluir actualizar unidades en stock y en orden. Debe especificar los parámetros necesarios para la inserción*/


/*Northwind desea saber si las ventas en cantidad de unidades y 
en cantidad de órdenes están creciendo por región para saber si debe 
expandir su red de Compañías de Envío en determinadas regiones. 
Por lo tanto se le ha pedido obtener un procedimiento donde muestre la región que
ha tenido más venta en cantidad de unidades y en cantidad de órdenes dado un año
 y un mes ingresado como parámetro. Deberá mostrar además la cantidad de unidades y 
 cantidades de órdenes vendidas en esas regiones el año anterior*/


