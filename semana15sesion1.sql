/*Seleecionar por pais el clciente a quien mas se le ha vendido y el numero de 
ordende que se emitieron para ese cliente, solo de las ventas
del 2017 y el pais de envio sea el mismo del cliente , ordenado 
por paiis y nombre cliente. Se debe mostrar:
PAIS, ID CLIENTE, NOMBRE CLIENT, NUMERO ORDENES, IMPORTE VENDIDO */

create view vw_clientes_anio as
select c.CustomerID, c.CompanyName, count(o.OrderID)'NumOrdenes', c.Country, 
sum(od.Quantity*od.UnitPrice*(1-od.Discount))'importe'
from [Order Details] od join Orders o on od.OrderID=o.OrderID
						join Customers c on o.CustomerID=c.CustomerID
where year(o.OrderDate)=2017
group by  c.CustomerID, c.CompanyName, c.Country

select vw.Country, vw.CustomerID, vw.NumOrdenes, vw.CompanyName, vw.importe
from vw_clientes_anio vw
where vw.NumOrdenes = (select max(vw1.NumOrdenes)
						from vw_clientes_anio vw1
						where vw.Country=vw1.Country)
order by 1 asc 

/*
	Crear una funcion que liste los empleados con el mayor 
	numero de ordenes por producto realizado en un determinado 
	año.
	Tome como base la fecha de la orden (orderdate).
	Mostrar:
	Año, ID Empleado, Nombre Empleado, ID Producto, Nombre del Producto, #Ordenes
*/
create view vw_cantidad_ordenes  as
select e.EmployeeID, e.FirstName, count(o.OrderID)'NumOrders', year(o.OrderDate)'Anio', p.ProductID, p.ProductName
from  Employees e join Orders o on e.EmployeeID=o.EmployeeID
					join [Order Details] od on o.OrderID=od.OrderID
					join Products p on od.ProductID=p.ProductID
 group by e.EmployeeID, e.FirstName,  year(o.OrderDate), p.ProductID, p.ProductName

 select max(vw1.NumOrders), vw1.ProductID, vw1.Anio
 from vw_cantidad_ordenes vw1
 group by vw1.ProductID, vw1.Anio

 alter view vw_maximo_cantidad as
 select* 
 from vw_cantidad_ordenes vw
 where vw.NumOrders = (
						select max(vw1.NumOrders)
						from vw_cantidad_ordenes vw1
						where vw.ProductID=vw1.ProductID and vw.Anio=vw1.Anio)

create function fn_ordenes_por_anio (@anio int)
returns table 
as 
return 
(
  select vw.EmployeeID, vw.FirstName, max(vw.NumOrders)'maxorden', vw.Anio, vw.ProductID, vw.ProductName
  from vw_maximo_cantidad vw
  where vw.Anio =@anio
  group by vw.EmployeeID, vw.FirstName,  vw.Anio, vw.ProductID, vw.ProductName
 
)
select* 
from dbo.fn_ordenes_por_anio(2018)