/* El gerente de log�stica le pide revisar el stock de los productos no 
descontinuados que hayan sido pedidos m�s 2 veces en un rango de tiempo 
(fecha de ordenorderdate). Se debe mostrar mediante una funci�n solo los productos
que tengan falta de stock para la entrega de sus pedidos.*/
create view vw_stock_descontinuado_fechas as
SELECT p.ProductID,p.ProductName, p.Discontinued, count(o.OrderID)'ordenes', p.UnitsInStock, year(o.OrderDate)'anio'
from Products p join [Order Details] od on p.ProductID=od.ProductID
				join Orders o on od.OrderID=o.OrderID
where p.Discontinued=0
group by p.Discontinued, p.UnitsInStock,year(o.OrderDate), p.ProductID,p.ProductName
having count(o.OrderID)>2

order by 1 asc

create  function fn_faltastock (@anio int )
returns table
as 
return 
(
				select vw.ProductID, vw.ProductName
				from vw_stock_descontinuado_fechas vw
				where vw.ordenes> vw.UnitsInStock and vw.anio=@anio

)

select * from fn_faltastock (2017)

/*El gerente de Northwind est� proponiendo hacer una nueva negociaci�n con los proveedores
cuyos productos tengan una buena rotaci�n en el a�o, para esto es necesario construir una 
vista que devuelva los productos que han sido vendido m�s que el promedio durante un a�o. 
Para dicho fin se solicita que muestre los nombres de productos, categor�a de producto, mes
de venta, nombre del proveedor, direcci�n, cantidad vendida.

A partir de esta vista creada, implementar las consultas para:

-Agrupar por categor�a y ordenarlos en funci�n de �sta de manera descendente
-Listar aquellos productos que no hayan tenido rotaci�n en el primer semestre.
-Listar los proveedores cuya cantidad de productos vendidos supera los 3 productos, ordenar de 
 forma ascendente por el proveedor. */
 alter view vw_pregunta2 as
 select p.ProductName, p.ProductID,p.CategoryID,s.CompanyName,s.Address,sum( od.Quantity)'qcantidad',count(o.OrderID)'mayor',year(o.OrderDate)'anio' 
 from Suppliers s join Products p on s.SupplierID=p.SupplierID
				join [Order Details] od on p.ProductID=od.ProductID
				join Orders o on od.OrderID=o.OrderID
 group by  p.ProductName, p.ProductID,p.CategoryID,s.CompanyName,s.Address,year(o.OrderDate)

 create view vw_preguntados as
 select  vw.ProductName, vw.ProductID,vw.CategoryID,vw.CompanyName,vw.Address,vw.qcantidad,vw.mayor,vw.anio
 from vw_pregunta2 vw
 where vw.mayor > (select avg(vw1.mayor)
					from vw_pregunta2 vw1 
					where vw1.ProductID=vw.ProductID )

alter  function fn_categ (@cateogia nvarchar(40) )
returns table
as 
return 
(
		select *
		from vw_preguntados vw
		where  vw.CategoryID = @cateogia
		

)				
select * 
from dbo.fn_categ(1)
order by 2 asc
/*-Listar los proveedores cuya cantidad de productos vendidos supera los 3 productos, ordenar de 
 forma ascendente por el proveedor. */

		select vw.CompanyName
		from vw_preguntados vw
		where vw.qcantidad > 3 
		order by 1 asc


/*
Modifique mediante script la tabla Customers y agregue un campo de nombre Premium (bit)
Realice una sentencia Update que coloque en el campo Premium reci�n creado el valor 1 y
solo a los clientes cuya cantidad de �rdenes compradas haya superado el promedio de �rdenes compradas */
		
select *
from Customers

alter table Customers add Premium bit 

create view vw_cantidad_compras as
select c.CustomerID, c.CompanyName , count(o.OrderID)'cantidad'
from Customers c join Orders o on c.CustomerID=o.CustomerID
group by  c.CustomerID, c.CompanyName


select avg(vw.cantidad)'promedio'
from vw_cantidad_compras vw 


update Customers set Premium=1
select *
from vw_cantidad_compras vw
where vw.cantidad >( 
			select avg(vw1.cantidad)'promedio'
				from vw_cantidad_compras vw1 )



/* A�ada mediante script la columna "QOrdenes" a la tabla Employees. LLenar la tabla Employees con la cantidad de �rdenes que actualmente ha vendido ese empleado. Crear los siguientes triggers:

Cuando se inserte una orden sumar� en uno el campo �QOrdenes� al empleado que est� vendiendo
Cuando se elimine una orden restar� en uno el campo �QOrdenes� al empleado que est� vendiendo*/
select *
from Employees

alter table Employees add Qordenes real
select count(o.OrderID)
from Employees e join Orders o on e.EmployeeID=o.EmployeeID