
----------------- REPASO EXAMEN FINAL ------------------
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


create table ESTVTA(
	CustomerID nchar(5) not null,
	CompanyName nvarchar(40) not null,
	Anio int not null,
	Venta int not null,
);


alter table ESTVTA
	add QProductos int not null default (0)

select *from ESTVTA
 delete ESTVTA


insert into ESTVTA
select  c.CustomerID, c.CompanyName, year(o.OrderDate), sum(od.Quantity*od.UnitPrice*(1-od.Discount))
from Customers c join Orders o on c.CustomerID=o.CustomerID
				join [Order Details] od on o.OrderID=od.OrderID
group by  c.CustomerID, c.CompanyName, year(o.OrderDate)
having sum(od.Quantity*od.UnitPrice*(1-od.Discount))> 40000






insert into ESTVTA
select  c.CustomerID, c.CompanyName, year(o.OrderDate), sum(od.Quantity*od.UnitPrice*(1-od.Discount)), sum(od.Quantity)
from Customers c join Orders o on c.CustomerID=o.CustomerID
				join [Order Details] od on o.OrderID=od.OrderID
group by  c.CustomerID, c.CompanyName, year(o.OrderDate)
having sum(od.Quantity*od.UnitPrice*(1-od.Discount))> 40000

select * 
from ESTVTA



select e.CustomerID, o.CustomerID ,od.OrderID, od.ProductID, od.UnitPrice, od.Quantity, od.Discount
from [Order Details] od join Orders o on od.OrderID=o.OrderID
		join ESTVTA e on o.CustomerID=e.CustomerID

select *from [Order Details]


/*1.3Escriba un trigger que reste el monto de venta y la cantidad de 
productos de la tabla ESTVTA cada vez que se elimine un registro
de OrderDetails*/

create trigger tg_elimina_od
on [Order Details]
for delete 
as 
begin
	update ESTVTA
	SET Venta=(e.Venta-(od.UnitPrice*od.Quantity*(1-od.Discount))), QProductos=e.QProductos-od.Quantity
	from deleted od join Orders o on od.OrderID=o.OrderID
		join ESTVTA e on o.CustomerID=e.CustomerID
end

select*
from [Order Details]
where OrderID=10258 and ProductID=2 
--ya lo borre, le mando las imagenes de como sale
delete  [Order Details]
where OrderID=10258 and ProductID=2 

select*
from ESTVTA



	
