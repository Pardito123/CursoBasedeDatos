/*1.1.	Crear una tabla llamada ESTVTA a partir de los 
clientes cuya venta anual supera los S/.40,000. Los atributos a 
considerar son: ID cliente, nombre, a�o ,venta del a�o. 
Verificar definici�n de la nueva tabla (sp_Help).*/
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
que tiene en ese momento m�s la cantidad vendida en el order
 details. */


/*
Pregunta 1 (3 puntos) Crear una funci�n que retorne el nombre de cliente, nombre del proveedor, c�digo y nombre de los productos, cantidad vendida (quantity), total de importe bruto vendido(monto) de todas las �rdenes emitidas en un pa�s y un rango de tiempo ingresados como par�metros. */



/*Pregunta 2 (3 puntos) Crear un Procedimiento para insertar una l�nea de detalle de la orden (Order Details), incluir actualizar unidades en stock y en orden. Debe especificar los par�metros necesarios para la inserci�n*/


/*Northwind desea saber si las ventas en cantidad de unidades y 
en cantidad de �rdenes est�n creciendo por regi�n para saber si debe 
expandir su red de Compa��as de Env�o en determinadas regiones. 
Por lo tanto se le ha pedido obtener un procedimiento donde muestre la regi�n que
ha tenido m�s venta en cantidad de unidades y en cantidad de �rdenes dado un a�o
 y un mes ingresado como par�metro. Deber� mostrar adem�s la cantidad de unidades y 
 cantidades de �rdenes vendidas en esas regiones el a�o anterior*/


