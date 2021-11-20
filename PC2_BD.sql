/*Listar el importe neto vendido por cliente cuya regi�n de env�o es NM,
mostrar solo aquellos clientes con importe neto vendido mayor a 100,000 mostrar id, nombre, 
ciudad, importe ord�nelo por importe vendido*/
--PREGUNTA 1 

select c.CustomerID, c.CompanyName, c.City, monto=sum(od.Quantity*od.UnitPrice*(1-od.Discount))
from [Order Details] od join Orders o on od.OrderID=o.OrderID
join Customers c on o.CustomerID=c.CustomerID
where o.ShipRegion='NM'
group by c.CustomerID, c.CompanyName, c.City
having sum(od.Quantity*od.UnitPrice*(1-od.Discount))>100.000


--profesora como respuesta no me sale ninguno, pero es porque ning�n impoprte pasa de los 100,000 
--Ya que al quitarla condicion de que sea mayor a 100,000. Pero si pongo 100.000 si saldr�a la rpta
--Pondre ambas opciones

select c.CustomerID, c.CompanyName, c.City, monto=sum(od.Quantity*od.UnitPrice*(1-od.Discount))
from [Order Details] od join Orders o on od.OrderID=o.OrderID
join Customers c on o.CustomerID=c.CustomerID
where o.ShipRegion='NM'
group by c.CustomerID, c.CompanyName, c.City
having sum(od.Quantity*od.UnitPrice*(1-od.Discount))>100000


--PREGUNTA 2 
/* 
Northwind desea premiar la fidelidad de sus clientes. Para ello, se le pide mostrar al cliente 
con la orden (OrderDate) m�s antigua y el a�o en que m�s compr� en monto ese mismo cliente. Los 
campos por seleccionar son los siguientes: c�digo del cliente, nombre del cliente, fecha de la orden,
cantidad de a�os que han pasado desde la fecha de la orden a la fecha de hoy, a�o en el que m�s compr�
y monto vendido en ese a�o
*/

select c.CustomerID, c.CompanyName, o.OrderDate
from [Order Details] od join Orders o on od.OrderID=o.OrderID
			join Customers c on o.CustomerID=c.CustomerID 

		




--PREGUNTA 3 
/*
Seleccionar por pa�s el cliente a quien m�s se le ha vendido y el n�mero de �rdenes que se emitieron para ese cliente,
solo de las ventas del 2017 y el pa�s de env�o sea el mismo del cliente, Muestre el resultado ordenado por pa�s y nombre cliente.
Se debe mostrar pa�s, id cliente, nombre cliente, numero ordenes, importe vendido
*/




create view vw_tabla_clientes as 
select c.CustomerID, c.Country, c.CompanyName,  count(o.OrderID)'cantidad', SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) 'monto'
from  Customers  c  join Orders o on c.CustomerID=o.CustomerID
join [Order Details] od on o.OrderID=od.OrderID
where year(o.OrderDate)= 2017
group by  c.Country, c.CompanyName, c.CustomerID
order by 3 asc

create view vw_tabla_clientes_seg as 
select maximo= max(vw1.monto), vw1.Country
from vw_tabla_clientes vw1
group by vw1.Country


select vw1.Country, vw1.CustomerID, vw1.CompanyName, vw1.cantidad, vw1.monto
from vw_tabla_clientes vw1 join vw_tabla_clientes_seg vw2 on vw1.Country=vw2.Country
where vw1.monto= vw2.maximo
order by 1 asc, 3 asc
--PREGUNTA 4 
/*
Northwind desea saber cu�l es el mes del a�o en el que se tiene m�s venta en unidades (quantity)
y cu�l es el mes del a�o en el que se tiene menos en unidades. Es importante para Northwind saber esta 
informaci�n por cada a�o que tenga almacenado en la base de datos. Se debe mostrar la informaci�n con un flag 
que indique si es el mes que m�s vendi� o menos vendi�. Mostrar: a�o, mes, cantidad de venta en unidades y flag. 
*/

create view vw_ordenes_asd as
select year(o.OrderDate)'anio',month(o.OrderDate)'mes', sum(od.Quantity)'unidades'
from [Order Details] od join Orders o on od.OrderID=o.OrderID
group by o.OrderDate


select vw.anio, vw.mes, vw.unidades, 'MES DONDE SE VENDI� M�S' as Tipo
from vw_ordenes_asd vw
where vw.unidades=(select max(unidades)
					from vw_ordenes_asd)

					union
					
select vw.anio, vw.mes, vw.unidades, 'mes DONDE SE VENDI� menos' as Tipo
from vw_ordenes_asd vw
where vw.unidades=(select min(unidades)
					from vw_ordenes_asd)

--PREGUNTA 5
/*
Seleccionar por a�o de venta el cliente a quien m�s se le ha vendido en unidades y el n�mero de �rdenes que se
emitieron para ese cliente, ordenado por a�o, pa�s del cliente y nombre cliente. Se debe mostrar a�o, pa�s del cliente,
id cliente, nombre cliente, numero ordenes, importe vendido
*/

create view vw_pregunta5 as
select  c.Country, year(o.OrderDate)'anio', c.CustomerID,c.CompanyName, sum(od.Quantity)'cantidad', count(o.OrderID)'numordenes',
monto=sum(od.Quantity*od.UnitPrice*(1-od.Discount))

from Customers c join Orders o on c.CustomerID=o.CustomerID
		join [Order Details] od on o.OrderID=od.OrderID
group by c.Country, c.CustomerID,c.CompanyName, o.OrderDate


select vw.anio, vw.Country, vw.CompanyName, vw.numordenes, vw.monto
from vw_pregunta5 vw
where vw.cantidad=(select max(cantidad)
					from vw_pregunta5)
