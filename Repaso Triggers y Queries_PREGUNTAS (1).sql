/*1.1.	Crear una tabla llamada ESTVTA a partir de los 
clientes cuya venta anual supera los S/.40,000. Los atributos a 
considerar son: ID cliente, nombre, año ,venta del año. 
Verificar definición de la nueva tabla (sp_Help).*/
--NO CREEN PK NI FK
create  table ESTVTA 
(
IDcliente nchar(10), nombre nvarchar(40), ventadelanio money, QProductos int, anio datetime
)
insert into ESTVTA
select c.CustomerID, c.CompanyName,  sum(od.Quantity*od.UnitPrice*(1-od.Discount)), year(o.OrderDate)
from Customers c join Orders o on c.CustomerID=o.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
group by  c.CustomerID, c.CompanyName, year(o.OrderDate)
having sum(od.Quantity*od.UnitPrice*(1-od.Discount)) >40000

select * from ESTVTA
/*1.2.Adicionar una nueva columna a la tabla ESTVTA 
llamada "QProductos" (de tipo INT). Verificar la nueva 
estructura de Nueva_Tabla.(sp_help). Actualice el nuevo 
atributo con la venta en unidades por cliente.*/
alter table ESTVTA 
add QProductos int



select e.IDcliente, o.CustomerID ,od.OrderID, od.ProductID, od.UnitPrice, od.Quantity, od.Discount
from [Order Details] od join Orders o on od.OrderID=o.OrderID
		join ESTVTA e on o.CustomerID=e.IDcliente

insert into ESTVTA
select c.CustomerID, c.CompanyName,  sum(od.Quantity*od.UnitPrice*(1-od.Discount)), count(od.Quantity), year(o.OrderDate)
from Customers c join Orders o on c.CustomerID=o.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
group by  c.CustomerID, c.CompanyName, year(o.OrderDate)
having sum(od.Quantity*od.UnitPrice*(1-od.Discount)) >40000

/*1.3Escriba un trigger que reste el monto de venta y la cantidad de 
productos de la tabla ESTVTA cada vez que se elimine un registro
de OrderDetails*/
create trigger tr_insert_elimineregistro 
on [Order Details]
for delete
as 
begin 
			update ESTVTA
			set ventasdelanio
			from deleted

end
select * from Empleado

/*Modificar la tabla Empleados y agregar el campo ImpVendido de 
tipo INT NOT NULL con valor por defecto de 0.00 
Crear un trigger en la tabla order details para que 
cada vez que se venda un producto se actualice el 
campo impVendido  de la tabla empleados con el el valor 
que tiene en ese momento más la cantidad vendida en el order
 details. */
 
ALTER TABLE Empleado ADD STAGE INT NOT NULL DEFAULT '0'
 select * from insertventa
 create  table insertventa 
(
ordenid int, Mtotal real, empleadoid int
)

insert into insertventa
 select od.OrderID, sum(od.Quantity*od.UnitPrice*(1-od.Discount))'Mtotal', o.EmployeeID
 from [Order Details] od join Orders o on od.OrderID=o.OrderID
 group by  od.OrderID, o.EmployeeID

 ---------------

 create trigger tr_actualizar_impvendido
 on insertventa
 for insert
 as 
 begin 
		update Empleado
		set STAGE= STAGE + (ivta.Mtotal)
		from inserted ivta
		where ivta.empleadoid=Empleado.CEmpleado
 end
  select * from insertventa
   select * from Empleado

   insert into insertventa 
   values 
   (11078, 57, 1)

/*
Pregunta 1 (3 puntos) Crear una función que retorne el nombre de cliente,
nombre del proveedor, código y nombre de los productos, cantidad vendida (quantity), 
total de importe bruto vendido(monto) de todas las órdenes emitidas en un país y un rango 
de tiempo ingresados como parámetros. */

select o.OrderID, s.CompanyName, p.ProductID, p.ProductName, year(o.OrderDate)'Anio', o.ShipCountry, sum(od.Quantity)'cantidad', sum(od.Quantity*od.UnitPrice*(1-od.Discount))'Mtotal'
from Suppliers s join Products p on  s.SupplierID=p.SupplierID 
				 join [Order Details] od on p.ProductID=od.ProductID
				 join Orders o on od.OrderID=o.OrderID
				 join Customers c on o.CustomerID=c.CustomerID
group by o.OrderID, s.CompanyName, p.ProductID, p.ProductName, year(o.OrderDate), o.ShipCountry

create function fn_ordenspais_rango (@paiss nvarchar(15),@fechaa datetime )
returns table 
as 
return (
select o.OrderID, s.CompanyName, p.ProductID, p.ProductName, year(o.OrderDate)'Anio', o.ShipCountry, sum(od.Quantity)'cantidad', sum(od.Quantity*od.UnitPrice*(1-od.Discount))'Mtotal'
from Suppliers s join Products p on  s.SupplierID=p.SupplierID 
				 join [Order Details] od on p.ProductID=od.ProductID
				 join Orders o on od.OrderID=o.OrderID
				 join Customers c on o.CustomerID=c.CustomerID
where year(o.OrderDate)=@fechaa and o.ShipCountry=@paiss
group by o.OrderID, s.CompanyName, p.ProductID, p.ProductName, year(o.OrderDate), o.ShipCountry

)
select * from fn_ordenspais_rango('Germany', 2016)

/*Pregunta 2 (3 puntos) Crear un Procedimiento para insertar una línea de detalle de la
orden (Order Details), incluir actualizar unidades en stock y en orden. Debe especificar 
los parámetros necesarios para la inserción*/
select  od.Quantity, p.ProductID, p.UnitsInStock, p.UnitsOnOrder
from [Order Details] od join Products p on od.ProductID=p.ProductID
order by 2 asc

select* 
from [Order Details] od

select *
from Products p
 /* osea, un registro de OD tiene QProducto
pos el procedimiento lo inserta y tambn suma a los QProductos en la order
y resta en stock*/
select*
from Products p 
where p.ProductID=2
create procedure sp_insert_prodc  @idprd int,  @qcanti int
as 
begin transaction
update Products
   set UnitsInStock=UnitsInStock - @qcanti , UnitsOnOrder= UnitsOnOrder + @qcanti
   where ProductID=@idprd

   if @@ERROR<>0
			goto on_error --rollback transaction
		else
			goto fin --commit

		on_error:
			rollback transaction
		fin:
			commit
exec sp_insert_prodc 1, 1
select*
from Products p 
where p.ProductID=1
/*Northwind desea saber si las ventas en cantidad de unidades y 
en cantidad de órdenes están creciendo por región para saber si debe 
expandir su red de Compañías de Envío en determinadas regiones. 
Por lo tanto se le ha pedido obtener un procedimiento donde muestre la región que
ha tenido más venta en cantidad de unidades y en cantidad de órdenes dado un año
 y un mes ingresado como parámetro. Deberá mostrar además la cantidad de unidades y 
 cantidades de órdenes vendidas en esas regiones el año anterior*/
 create view vw_qordenes_mesanio as 
 select o.ShipCountry, count(o.OrderID)'Qordenes', sum(od.Quantity)'Qunidades', year(o.OrderDate)'anio', month(o.OrderDate)'mes'
 from Orders o  join [Order Details] od on o.OrderID=od.OrderID
 group by o.ShipCountry,year(o.OrderDate), month(o.OrderDate)
 

 create procedure sp_lista_anio @anio int,  @mess int
 as

 select vw.ShipCountry, vw.Qordenes,vw.Qunidades, vw.anio, vw.mes
 from vw_qordenes_mesanio vw
 where vw.Qordenes=( select max( vw1.Qordenes)
					from vw_qordenes_mesanio vw1
					where vw1.anio=@anio and vw1.mes=@mess)
		and vw.Qunidades=(
		select max( vw2.Qunidades)
		from vw_qordenes_mesanio vw2
		where vw2.anio=@anio and vw2.mes=@mess)

 select vw.ShipCountry, vw.Qordenes,vw.Qunidades, vw.anio, vw.mes
 from vw_qordenes_mesanio vw
 where vw.Qordenes=( select max( vw1.Qordenes)
					from vw_qordenes_mesanio vw1
					where vw1.anio=@anio-1 and vw1.mes=@mess)
		and vw.Qunidades=(
		select max( vw2.Qunidades)
		from vw_qordenes_mesanio vw2
		where vw2.anio=@anio-1 and vw2.mes=@mess)

		exec sp_lista_anio 2018,3

 select max( vw1.Qordenes)
 from vw_qordenes_mesanio vw1

 select max( vw2.Qunidades)
 from vw_qordenes_mesanio vw2


 
--clase
/*4. 4.	Northwind desea saber si sus ventas están incrementando 
de año a año por lo tanto debe crear un procedimiento almacenado 
que muestre las ventas en monto y en cantidad de un año elegido y 
las ventas en monto y en cantidad de año anterior al elegido.*/
create procedure sp_listaventas_anio @anio int
 as

select year(o.OrderDate)'anio', count(o.OrderID)'Qventas',  sum(od.Quantity*od.UnitPrice*(1-od.Discount))'Mtotal'
from Orders o join [Order Details] od on o.OrderID =od.OrderID
where year(o.OrderDate)=@anio
group by year(o.OrderDate)


select year(o.OrderDate)'anio', count(o.OrderID)'Qventas',  sum(od.Quantity*od.UnitPrice*(1-od.Discount))'Mtotal'
from Orders o join [Order Details] od on o.OrderID =od.OrderID
where year(o.OrderDate)=@anio-1
group by year(o.OrderDate)

exec sp_listaventas_anio 2018

/*  Crear una funcion que liste los empleados con el mayor 
	numero de ordenes por producto realizado en un determinado 
	año.
	Tome como base la fecha de la orden (orderdate).
	Mostrar:
	Año, ID Empleado, Nombre Empleado, ID Producto, Nombre del Producto, #Ordenes
*/
create  function fn_prdo_anio (@anio int )
returns table
as 
return 
(
select vw.anio, vw.EmployeeID, vw.FirstName, vw.ProductID, vw.ProductName, vw.qordenes
from vw_cant_vetas_empl vw
where vw.anio=@anio and vw.qordenes=(select max(vw1.qordenes)
					from vw_cant_vetas_empl vw1
					where vw.ProductID=vw1.ProductID and vw.anio=vw1.anio)


)
select *
from dbo.fn_prdo_anio(2017)

order by 4 asc

create view vw_cant_vetas_empl as
select year(o.OrderDate)'anio', e.EmployeeID, e.FirstName, p.ProductID, p.ProductName, count(o.OrderID)'qordenes'
from Employees e join Orders o on e.EmployeeID=o.EmployeeID
				join [Order Details] od on o.OrderID=od.OrderID
				join Products p on od.ProductID=p.ProductID
group by  year(o.OrderDate), e.EmployeeID, e.FirstName, p.ProductID, p.ProductName
order by 6 asc


select vw.anio, vw.EmployeeID, vw.FirstName, vw.ProductID, vw.ProductName, vw.qordenes
from vw_cant_vetas_empl vw
where vw.qordenes=(select max(vw1.qordenes)
					from fn_asdasd vw1
					where vw.ProductID=vw1.ProductID 
					and vw.anio=2018)

drop view fn_asdasd as
select vw1.anio, vw1.ProductID, max(vw1.qordenes)'qordenes'
from vw_cant_vetas_empl vw1 
group by  vw1.anio, vw1.ProductID, vw1.EmployeeID
order by 1 asc
/*
--	Crear la tabla venta total, llenar la tabla con el monto total de cada venta (OrderID y Monto). 
--	Sobre la tabla anterior crear los siguientes triggers:
--	Si se elimina una venta en OrderDetails se debe disminuir el monto total de la venta
--	Si se agrega una venta en OrderDetails se debe aumentar el monto total de la venta
*/
--crear tabla 
create table ventaTotal (OrderID int, Monto real)

insert ventaTotal 
select o.OrderID, sum(od.UnitPrice*od.Quantity*(1-od.Discount))
from Orders o join [Order Details] od on o.OrderID=od.OrderID
group by   o.OrderID

select*
from ventaTotal

-- TRIGGER
--	Si se elimina una venta en OrderDetails se debe disminuir el monto total de la venta
create trigger disminuir_monto 
on [Order Details]
for insert
as 
begin 
			update ventaTotal 
			set Monto = Monto -  (select SUM(od.Quantity*od.UnitPrice*(1-od.Discount))
					from inserted od join ventaTotal vt on vt.OrderId = od.OrderID)
					from inserted od 
					where od.OrderID= ventaTotal.OrderID

end



--	Si se agrega una venta en OrderDetails se debe aumentar el monto total de la venta
create trigger aumentar_monto 
on [Order Details]
for insert
as 
begin 
			update ventaTotal 
			set Monto = Monto +  (select SUM(od.Quantity*od.UnitPrice*(1-od.Discount))
					from inserted od join ventaTotal vt on vt.OrderId = od.OrderID)
					from inserted od 
					where od.OrderID= ventaTotal.OrderID

end
--NATT
create trigger aumentar_montotn
on [Order Details]
for insert
as 
begin 
			update ventaTotal 
			set Monto = Monto +  (od.Quantity*od.UnitPrice*(1-od.Discount))
					from Orders o join inserted od on o.OrderID=od.OrderID
					where od.OrderID= ventaTotal.OrderID

end

/*14.Crear un procedimiento para insertar una categoría, 
cuando inserte debe cambiar a descontinuado el un producto ingresado como parametro*/

/*14.Crear un procedimiento para insertar una categoría, 
cuando inserte debe cambiar a descontinuado el producto 8*/

select * from Categories
select * from Products

create procedure sp_modificaciones  
			@categoryname nvarchar(15), @descripcion ntext, 
			@picture image, @productid int
as
begin transaction

	insert into Categories
	values (@categoryname,@descripcion,@picture)

	update Products
	set Discontinued=1
	where ProductID=@productid

	if @@ERROR<>0
		rollback
	else
		commit

select * from Categories
select * from Products

exec sp_modificaciones 'bebidas','bebidas gaseosas',null,2 





/*5.	Seleccionar por país el cliente a quien más se le ha vendido 
y el número de órdenes que se emitieron para ese cliente, solo de las 
ventas del 2017 y el país de envío sea el mismo del cliente, 
ordenado por país y nombre cliente. Se debe mostrar país, 
id cliente, nombre cliente, numero ordenes, importe vendido
--vista*/
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

/*REPASO 1: Muestre el territorio y nombre de los jefes cuyos empleados
han superado dos órdenes vendidas y más de 1000 en monto vendido. Estos 
jefes serán acreedores de un premio siempre y cuandola diferencia en días
entre la fecha de la orden y la fecha de despacho no sea mayor a 7.*/
alter view vw_ordenestotales as

 select j.EmployeeID ,j.FirstName'jefe',t.TerritoryDescription,count(o.OrderID)'ordenes', sum(od.Quantity*od.UnitPrice*(1-od.Discount))'Mtotal',
 DATEDIFF(day, o.OrderDate, o.ShippedDate)'diferencia'
 from Employees e  join Employees j on e.ReportsTo=j.EmployeeID join EmployeeTerritories ep on ep.EmployeeID=j.EmployeeID 
			join Territories t on  t.TerritoryID=ep.TerritoryID
			join Orders o on e.EmployeeID=o.EmployeeID
			join [Order Details] od on o.OrderID=od.OrderID
group by j.EmployeeID ,DATEDIFF(day, o.OrderDate, o.ShippedDate),j.FirstName,t.TerritoryDescription

select vw.jefe, vw.TerritoryDescription, vw.EmployeeID
from vw_ordenestotales vw
where vw.diferencia < 7 and vw.ordenes >2 and vw.Mtotal >1000


