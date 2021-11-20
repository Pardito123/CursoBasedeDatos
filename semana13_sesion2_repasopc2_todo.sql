/*
DDL: Data Definition Language
	--OBJETOS (tabla, vista, sp, funcion, constraint, etc)
	-Crear : CREATE
	-Eliminar: DROP
	-Modificar: ALTER
DML: Data Manipulation Language
	--REGISTROS 
	-Crear: INSERT
	-Eliminar : DELETE
	-Modificar : UPDATE
	-Consultar: SELECT
*/

/*PD9*/
/*1.Muestre el c�digo y nombre de todos los 
clientes (companyname) que tienen �rdenes 
pendientes de despachar.*/


select CustomerID,CompanyName
from Customers --91 registros

select *
from Orders --830 registros
where ShippedDate is NULL --21 registros --tratamiento de null

---830 registros
select *
from Orders o join Customers c on o.CustomerID=c.CustomerID

---21 registros
select *
from Orders o join Customers c on o.CustomerID=c.CustomerID
where o.ShippedDate is null 

---21 registros
select c.CustomerID,c.CompanyName
from Orders o join Customers c on o.CustomerID=c.CustomerID
where o.ShippedDate is null 

/*2.Muestre el c�digo y nombre de todos los clientes
 (companyname) que tienen �rdenes pendientes de despachar, 
  y la cantidad de �rdenes con esa caracter�stica.*/

  /*
   FUNCIONES DE AGREGACION 
			--MAX
			--MIN
			--COUNT
			--AVG
			--SUM
  */
  /*
  1--- FROM (JOIN)
  2--- WHERE (FILTRA FILAS)
  3--- SELECT (FILTRA COLUMNAS)
		+ FA (MAX, MIN, AGV, COUNT, SUM)
			--GROUP BY --como MINIMO todo lo que est� en el select menos la FA
  */

select *
from Orders o join Customers c on o.CustomerID=c.CustomerID
where o.ShippedDate is null 

select c.CustomerID,c.CompanyName, COUNT(o.OrderID) 'QOrdenes'
from Orders o join Customers c on o.CustomerID=c.CustomerID
where o.ShippedDate is null 
group by c.CustomerID,c.CompanyName --como MINIMO todo lo que est� en el select menos la FA

--TAREA 30.10 +0.5 PC2 --TODOS LOS EJERCICIO A PARTIR DE AQUI

/*3.Encontrar los pedidos que debieron despacharse 
a una ciudad o c�digo postal diferente de la ciudad o
 c�digo postal del cliente que los solicit�. 
 Para estos pedidos, mostrar el pa�s, ciudad y 
 c�digo postal del destinatario, 
 as� como la cantidad total de pedidos por cada destino.*/

 select o.ShipCountry,o.ShipCity,o.ShipPostalCode,
			Cantidad=COUNT(o.OrderID)
 from Orders o join Customers c  on o.CustomerID=c.CustomerID --830 registros
 where o.ShipCity!=c.City or o.ShipPostalCode<>c.PostalCode --42 registros
 group by o.ShipCountry,o.ShipCity,o.ShipPostalCode

   /*
  1--- FROM (JOIN)
  2--- WHERE (FILTRA FILAS)
  3--- SELECT (FILTRA COLUMNAS)
		+ FA (MAX, MIN, AGV, COUNT, SUM)
			--GROUP BY --como MINIMO todo lo que est� en el select menos la FA
  */

 /*4.Seleccionar todas las compa��as de env�o 
(c�digo y nombre) que hayan efectuado alg�n despacho a M�xico 
entre el primero de enero y el 28 de febrero de 2018.*/

--shippedDate between 'fechaini' and 'fechafin'

select s.ShipperID,s.CompanyName
from Orders o join Shippers s on o.ShipVia=s.ShipperID
where o.ShipCountry='Mexico' 
		and o.ShippedDate between '20180101' and '20180228'

select *
from Orders o
where o.ShipCountry like 'a%'

select *
from Orders o
where o.ShipCountry like '%a%'

select *
from Orders o
where o.ShipCountry like '[a-c]%'

select *
from Orders o
where o.ShipCountry like '__a%'

/*Seleccionar los productos vigentes cuyos precios unitarios est�n entre 
35 y 250, con stock en almacen, pertenecientes a las categor�as 1,3,4,7 y 8, 
que son distribuidos por los proveedores 2,4,6,7,8 y 9*/

select *
from Products p 
where p.UnitPrice between 25 and 250 --PARA COMPARAR SIEMPRE DEBEN VERIFICAR EL TIPO DE DATO 
   and p.UnitsInStock>0
   and p.CategoryID in (1,3,4,7,8)
   and p.SupplierID in (2,4,6,7,8,9)

select *
from Products p 
where p.CategoryID not in (1,3,4,7,8)

select *
from Orders o
where o.ShipCountry in ('Mexico','USA')

/*Seleccionar los 7 productos con precio m�s 
caro que cuenten con stock
en almac�n*/

select top 7 *
from Products p
where p.UnitsInStock>0
order by p.UnitPrice desc

--NUNCA VAMOS A USAR TOP PARA SACAR MAXIMOS Y MINIMOS

/*Seleccionar los 9 productos con menos stock en almacen que
 pertenecen a la categor�a 3,5 y 8*/

 select top 9 *
 from Products p
 where p.CategoryID in (3,5,8)
 order by p.UnitsInStock asc

 /*5. Mostrar los nombres y apellidos de los empleados junto 
 con los nombres y apellidos de sus respectivos jefes */

 select e.EmployeeID,e.LastName,e.FirstName,e.ReportsTo, j.FirstName,j.LastName
 from Employees e inner join Employees j on e.ReportsTo=j.EmployeeID

 select e.EmployeeID,e.LastName,e.FirstName,e.ReportsTo, j.FirstName,j.LastName
 from Employees e left join Employees j on e.ReportsTo=j.EmployeeID

 select e.EmployeeID,e.LastName,e.FirstName,e.ReportsTo, j.FirstName,j.LastName
 from Employees e right join Employees j on e.ReportsTo=j.EmployeeID

   /*6.Mostrar el ranking de venta anual  por pa�s de 
 origen del empleado, tomando como base la fecha de las 
 �rdenes, y mostrando el resultado por a�o y venta total
  (descendente). */
  --Employees: Country
  --Orders : YEAR(orderDate)
  --OD: S(Q*U*(1-D)) 

  /*
	tabla1 join tabla2 on xxx=yyy
			join tabla3 on yyy=zzz
  */

  select e.Country, YEAR(o.OrderDate) 'A�o',
		Monto=convert(money,SUM(od.Quantity*od.UnitPrice*(1-od.Discount)))
  from Employees e join Orders o on e.EmployeeID=o.EmployeeID
					join [Order Details] od on o.OrderID=od.OrderID
  group by e.Country, YEAR(o.OrderDate)
  order by 1 asc, Monto desc--unica clausula que acepta renombramientos


   /*
  1--- FROM (JOIN)
  2--- WHERE (FILTRA FILAS)
  3--- SELECT (FILTRA COLUMNAS)
		+ FA (MAX, MIN, AGV, COUNT, SUM)
			--GROUP BY --como MINIMO todo lo que est� en el select menos la FA
  
  X---ORDER BY --unica clausula que acepta renombramientos
  */

   --TAREA +0.5 PC 2
 /*PD 10*/
 /*1.	Mostrar de la tabla Orders, para los pedidos cuya 
  diferencia entre la fecha de despacho y la fecha de  la orden  
  sea mayor a 4 semanas, las siguientes columnas: 
  OrderId, CustomerId, Orderdate, Shippeddate, diferencia en d�as,  
  diferencia en semanas y diferencia en meses entre ambas fechas.
*/

--DATEDIFF
select o.OrderID,o.CustomerID,o.OrderDate,o.ShippedDate,
		Dif_Dias=DATEDIFF(D,o.OrderDate,o.ShippedDate),
		Dif_Semanas=DATEDIFF(WK,o.OrderDate,o.ShippedDate),
		Dif_Meses=DATEDIFF(MONTH,o.OrderDate,o.ShippedDate)
from Orders o
where DATEDIFF(WW,o.OrderDate,o.ShippedDate)>4

/*Seleccionar las ordenes de compra realizadas por el empleado con c�digo entre el 2 y el 5
adem�s de los clientes con c�digo que comienzan con las letras A hasta la G
del 31 de julio de cualquier a�o*/

select *
from Orders o
where o.EmployeeID between 2 and 5 --revisar el tipo de dato para comparar
	and o.CustomerID like '[a-g]%'
	and DATEPART(M,o.OrderDate)=7--MONTH(o.OrderDate)=7
	and DATEPART(D,o.OrderDate)=31--DAY(o.OrderDate)=31

/*Seleccionar las ordenes de compra realizadas por el empleado con c�digo 3
de cualquier a�o pero solo de los �ltimos 5 meses (agosto-diciembre)*/

select *
from Orders o
where o.EmployeeID=3
		and MONTH(o.OrderDate) between 8 and 12

   /*2.La empresa tiene como pol�tica otorgar a los jefes una
   comisi�n del 0.5% sobre la venta de sus subordinados. 
    Calcule la comisi�n mensual que le ha correspondido a cada 
	jefe por cada a�o (bas�ndose en la fecha de la orden) 
	seg�n las ventas que figuran en la base de datos. 
	Muestre el c�digo del jefe, su apellido, el a�o y mes de c�lculo,
	 el monto acumulado  de venta de sus subordinados, y la 
	 comisi�n obtenida. */

	 select j.EmployeeID,j.FirstName+' '+j.LastName as 'Nombre y Apellidos',
			MONTH(o.OrderDate) as Mes,
			YEAR(o.OrderDate) as 'A�o',
			Venta=convert(money,SUM(od.Quantity*od.UnitPrice*(1-od.Discount))),
			Comision=convert(money,SUM(od.Quantity*od.UnitPrice*(1-od.Discount))*0.005)
	 from Employees e join Employees j on e.ReportsTo=j.EmployeeID
					  join Orders o on o.EmployeeID=e.EmployeeID
					  join [Order Details] od on o.OrderID=od.OrderID
	 group by j.EmployeeID,j.FirstName+' '+j.LastName,
			MONTH(o.OrderDate),
			YEAR(o.OrderDate)

  
/*3.Obtener los pa�ses --Shipcountry
 donde el importe total --S(q*u*1-d) anual de las 
�rdenes enviadas --SHIPPEDDATE IS NOT NULL
 supera los $45,000. Para determinar el a�o--Year(od), 
tome como base la fecha de la orden (orderdate).
 Ordene el resultado monto total de venta. 
Muestre el pa�s, el a�o, y el importe anual de venta.
*/

--1 FROM --2155 registros
select *
from Orders o join [Order Details] od on o.OrderID=od.OrderID

--2--- WHERE (FILTRA FILAS)--2082
select *
from Orders o join [Order Details] od on o.OrderID=od.OrderID
where o.ShippedDate is not null 
		--and SUM(od.Quantity*od.UnitPrice*(1-od.Discount))>45000

-- 3--- SELECT (FILTRA COLUMNAS)
--     + FA (MAX, MIN, AGV, COUNT, SUM)
--		3.1	--GROUP BY --como MINIMO todo lo que est� en el select menos la FA
select o.ShipCountry, YEAR(o.OrderDate) 'A�o',
	  venta=SUM(od.Quantity*od.UnitPrice*(1-od.Discount))
from Orders o join [Order Details] od on o.OrderID=od.OrderID
where o.ShippedDate is not null 
group by o.ShipCountry, YEAR(o.OrderDate)
having SUM(od.Quantity*od.UnitPrice*(1-od.Discount))>45000

--France	2017	45263.3824062347

 /*
  1--- FROM (JOIN)
  2--- WHERE (FILTRA FILAS)
  3--- SELECT (FILTRA COLUMNAS)
		+ FA (MAX, MIN, AGV, COUNT, SUM)
			--GROUP BY --como MINIMO todo lo que est� en el select menos la FA
  4--- HAVING -- tratar FA
  X---ORDER BY --unica clausula que acepta renombramientos
  */


/*4.De cada producto que haya tenido venta en por 
lo menos 20 transacciones (ordenes) del a�o 2017 
mostrar el c�digo, nombre y 
cantidad de unidades vendidas --SUM(Q)
y cantidad de ordenes en las que se vendi� --COUNT(OID)*/

select P.ProductID,P.ProductName, 
		SUM(od.Quantity) 'QUnidades',
		COUNT(od.OrderID) 'QOrdenes'
from Products p join [Order Details] od on p.ProductID=od.ProductID
				join Orders o on o.OrderID=od.OrderID --2155 registros
where YEAR(o.OrderDate)=2017 ---1059 --revisar el tipo de dato para comparar SINO LES PONGO 0
group by P.ProductID,P.ProductName
having COUNT(od.OrderID)>=20
 /*
  1--- FROM (JOIN)
  2--- WHERE (FILTRA FILAS)
  3--- SELECT (FILTRA COLUMNAS)
		+ FA (MAX, MIN, AGV, COUNT, SUM)
			--GROUP BY --como MINIMO todo lo que est� en el select menos la FA
  4--- HAVING -- tratar FA
  X---ORDER BY --unica clausula que acepta renombramientos
  */
  

--TAREA
--esta tarea no tiene puntos adicionales, lo resuelto podr� venir en la PC2

/*5.Determinar si existe alg�n problema de stock para 
 la atenci�n de las �rdenes pendientes de despacho --SHIPPEDDATE IS NULL. 
Para ello,  determinar la relaci�n de productos no descontinuados --D=0 cuyo
   stock actual (unitsinstock) es menor que la cantidad de unidades --S(OD.Q)
   pendientes de despacho (las que figuran en pedidos que no han sido 
   despachados) 
   Mostrar el nombre del producto, la cantidad pendiente de entrega , 
el stock actual (unitsinstock) y la cantidad de unidades que falta para
 la atenci�n de las �rdenes
*/

--DISCONTINUED: 1 SI EST� DESCONTINUADO
			--  0 NO DESCONTINUADO

SELECT p.ProductName,
		SUM(od.Quantity) 'QPendiente',
		p.UnitsInStock,
		SUM(od.Quantity)-p.UnitsInStock 'QStockFaltante'
FROM Products p join [Order Details] od on p.ProductID=od.ProductID
				join Orders o on od.OrderID=o.OrderID --2155
where p.Discontinued=0 and o.ShippedDate is null --66
group by  p.ProductName,p.UnitsInStock
having SUM(od.Quantity)>p.UnitsInStock

/*
Visualizar el m�ximo y m�nimo precio de los productos por proveedor, mostrar el
nombre de la compa��a proveedora
*/

select s.CompanyName, 
MAX(p.UnitPrice) 'Precio Maximo',
MIN(p.UnitPrice) 'Precio Minimo'
from Products p join Suppliers s on p.SupplierID=s.SupplierID
group by s.CompanyName

/*
Seleccionar las categor�as que tengan m�s de 5 productos. Mostrar el nombre de la categor�a
y el n�mero de productos
*/


/*Calcular cuantos clientes existen en cada pa�s*/



/*Mostrar el n�mero de ordenes realizadas de cada uno de los clientes por a�o*/


 /*Mostrar los c�digos de �rdenes y la cantidad de productos 
 (quantity) en cada orden de las �rdenes que hayan superado las
  250 unidades de productos vendidos. Siempre y cuando 
  la diferencia en d�as entre la fecha de la orden y la 
  fecha de despacho sea mayor a 7.*/

  Select o.OrderID, Sum(od.Quantity) 'Cantidad'
 from Orders o join [Order Details] od on o.OrderID = od.OrderID
 where DATEDIFF(day, o.OrderDate, o.ShippedDate) > 7
 group by o.OrderID
 having Sum(od.Quantity) > 250 


 /*Mostrar el ranking de los clientes que realicen 
una cantidad de compras superior a 13 y un monto comprado 
superior 30000. Mostrar el nombre del cliente,
pais, cantidad comprar y monto comprado.
 Ordenarlos en orden alfab�tico por pa�s. */

    select c.CompanyName, c.Country, COUNT(o.OrderID) 'q_ordenes',
		SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) 'monto'
from Customers c join Orders o on c.CustomerID=o.CustomerID
				 join [Order Details] od on o.OrderID=od.OrderID
group by c.CompanyName, c.Country
having COUNT(o.OrderID)>13 and 
	   SUM(od.Quantity*od.UnitPrice*(1-od.Discount))>30000
order by c.Country desc, 4 asc

/*
  1--- FROM (JOIN)
  2--- WHERE (FILTRA FILAS)
  3--- SELECT (FILTRA COLUMNAS)
		+ FA (MAX, MIN, AGV, COUNT, SUM)
			--GROUP BY --como MINIMO todo lo que est� en el select menos la FA
  4--- HAVING -- tratar FA
  5---ORDER BY --unica clausula que acepta renombramientos
  */

  
 /*6.Mostar la lista de productos descontinuados 
(nombre y precio) cuyo precio es menor al precio promedio.*/

--DISCONTINUED: 1 SI EST� DESCONTINUADO
			--  0 NO DESCONTINUADO

select *
from Products p 
where p.Discontinued=1 and p.UnitPrice<(select AVG(p.UnitPrice) --28.8663
										from Products p)

select AVG(p.UnitPrice) --28.8663
from Products p


/*7.	Listar aquellas �rdenes cuya diferencia entre la 
 fecha de la orden y la fecha de despacho es mayor que: 
a.	El promedio en d�as de  dicha diferencia en todas 
las �rdenes.	
*/
--+ FA (MAX, MIN, AGV, COUNT, SUM)
-- No existe: AVG (MAX())
-- S� existe: MIN (YEAR())

select *
from Orders o 
where DATEDIFF(D,o.OrderDate,o.ShippedDate)> (select AVG( DATEDIFF(D,o.OrderDate,o.ShippedDate))
												from Orders o)

select AVG( DATEDIFF(D,o.OrderDate,o.ShippedDate))
from Orders o


/*8.Mostrar los productos no descontinuados
 (c�digo, nombre de producto, nombre de categor�a y precio) 
 cuyo precio unitario es mayor al precio promedio de su respectiva 
 categor�a  */

 select *
 from Products p
 where p.Discontinued=0 and p.UnitPrice>( select AVG(p1.UnitPrice)
										from Products p1
										where p1.CategoryID=p.CategoryID)

 select p1.CategoryID, AVG(p1.UnitPrice)
 from Products p1
 group by p1.CategoryID

 --6	Grandma's Boysenberry Spread	3	2	12 - 8 oz jars	25.00

/*9. Mostrar la relaci�n de productos (Nombre) 
 no descontinuados de la categor�a 8 
 que NO HAN TENIDO VENTA entre el 1� y el 15 de Agosto de 2016. */

 --TAREA: EXISTS / NOT EXISTS
 select *
 from Products p
 where p.CategoryID=8 and p.Discontinued=0
		and p.ProductID NOT IN ( select od.ProductID
								 from Orders o join [Order Details] od on o.OrderID=od.OrderID
								 where o.OrderDate between '20160801' and '20160815')

 --18	Carnarvon Tigers	
 
 /*10.	Encontrar la categor�a a la que pertenece la mayor 
 cantidad de productos. Mostrar el nombre de la categor�a y 
 la cantidad de productos que comprende*/

 --3	Confections	13

 --TAREA: RESOLVERLO DE OTRA FORMA

 select p1.CategoryID,c.CategoryName, COUNT(p1.ProductID) 'QProductos'
 from Products p1 join Categories c on p1.CategoryID=c.CategoryID
 group by p1.CategoryID,c.CategoryName
 having COUNT(p1.ProductID) >= ALL ( select  COUNT(p.ProductID)
									from Products p
									group by  p.CategoryID)

 select  COUNT(p.ProductID)
 from Products p
 group by  p.CategoryID

  /*11.	Encontrar el producto de cada categor�a que tuvo 
 la mayor venta (en unidades) durante el a�o 2017, liste la categor�a,
  el c�digo de producto, nombre del producto, y la cantidad vendida.*/

  --ProductID, Nombre del producto, CategoriaID, Nombre de la Categoria, 
  -- SUM(Q)

  /*VISTAS
   1) no existe orden ni de filas ni de columnas
   2) todas las columnas/atributos deben tener nombre
  */

  create view vw_prod_cat as
  select p.ProductID,p.ProductName,c.CategoryID,c.CategoryName,
		SUm(od.Quantity) 'QVendida'
  from Categories c join Products p on c.CategoryID=p.CategoryID
					join [Order Details] od on p.ProductID=od.ProductID
					join Orders o on od.OrderID=o.OrderID
  where YEAR(o.OrderDate)=2017
  group by p.ProductID,p.ProductName,c.CategoryID,c.CategoryName
  --order by 3 asc, 5 desc

  --TAREA: terminar el ejercicio

  --1 Forma

  select vw1.ProductID,vw1.ProductName,vw1.CategoryID,vw1.CategoryName,vw1.QVendida
  from vw_prod_cat vw1
  where vw1.QVendida = (  select MAX(vw.QVendida)
						  from vw_prod_cat vw
						  where vw.CategoryID=vw1.CategoryID)
  order by 3 asc

  select vw.CategoryID,MAX(vw.QVendida)
  from vw_prod_cat vw
  group by vw.CategoryID

  --75	Rh�nbr�u Klosterbier	1	Beverages	630
  --65	Louisiana Fiery Hot Pepper Sauce	2	Condiments	490
  --21	Sir Rodney's Scones	3	Confections	610
  --40	Boston Crab Meat	8	Seafood	596

  --2 forma

  create view vw_max_cat as
  select vw.CategoryID,MAX(vw.QVendida) 'Maximo'
  from vw_prod_cat vw
  group by vw.CategoryID

  select *
  from vw_prod_cat

  select *
  from vw_max_cat

  select vw1.CategoryID,vw1.CategoryName,vw1.ProductID,vw1.ProductName,vw2.Maximo
  from vw_prod_cat vw1 join vw_max_cat vw2 on vw1.CategoryID=vw2.CategoryID
  where vw1.QVendida=vw2.Maximo
  order by 1 asc

 /*12.	Encontrar el pedido (OID) de mayor importe (S(Q*U*-d)) 
 por pa�s al cual se despach�  (Shipcountry).  
 Mostrar el pa�s, el orderID y el monto del pedido,  
 ordenado por monto de mayor a menor.*/

 --OrderID, Shipcountry, Monto
 
alter view vw_monto_pais as
select  o.ShipCountry,o.OrderID,
		Monto=SUM(od.quantity*od.unitprice*(1-od.discount))
from Orders o join [Order Details] od on o.OrderID=od.OrderID
group by o.OrderID, o.ShipCountry
order by 1 asc, 3 desc

--Argentina	10986	2220
--Austria	10514	8623.45001220703
--Spain	10801	3026.85009765625

select vw1.ShipCountry,vw1.OrderID,vw1.Monto
from vw_monto_pais vw1
where vw1.Monto = ( select Max(vw.Monto)
					from vw_monto_pais vw
					where vw.ShipCountry=vw1.ShipCountry)
order by 1 asc

select vw.ShipCountry,Max(vw.Monto)
from vw_monto_pais vw
group by vw.ShipCountry


-- + 0.5 PC2
  /*Mostrar la lista de proveedores (Suppliers) cuyos productos son 
  los m�s vendidos (Quantity) durante el a�o 2017 y de los proveedores 
  cuyos productos han sido los menos vendidos durante ese mismo a�o. 
  Se debe mostrar el proveedor (codigo y nombre)
   y la cantidad de productos vendidos y 
  una marca que indique si es m�nimo o m�ximo.*/

  --2 Queries: 1 maximo, 1 minimo
  -- supplierID,companyname, QVendida

  

  /*VISTAS
   1) no existe orden ni de filas ni de columnas
   2) todas las columnas/atributos deben tener nombre
  */

  create view vw_venta_supplier as
  select s.SupplierID,s.CompanyName, SUM(od.Quantity) QVendida
  from Suppliers s join Products p on s.SupplierID=p.SupplierID
				  join [Order Details] od on p.ProductID=od.ProductID
				  join Orders o on o.OrderID=od.OrderID
  where YEAR(o.OrderDate)=2017 --NO COMILLAS, REVISAR SIEMPRE EL TIPO DE DATO
  group by s.SupplierID,s.CompanyName
  order by 3 desc
  --12	Plutzer Lebensmittelgro�m�rkte AG	1992
  --27	Escargots Nouveaux	177

  select vw.SupplierID,vw.CompanyName, vw.QVendida, 'Maximo' as Tipo
  from vw_venta_supplier vw
  where vw.QVendida= (  select MAX(QVendida)
						from vw_venta_supplier)



  UNION
  select vw.SupplierID,vw.CompanyName, vw.QVendida, 'Minimo'
  from vw_venta_supplier vw
  where vw.QVendida= (  select MIN(QVendida)
						from vw_venta_supplier)
  order by 3 asc

/*UNION
1) misma cantidad de columnas
2) columnas del mismo tipo de dato
*/

  /*
  1--- FROM (JOIN)
  2--- WHERE (FILTRA FILAS)
  3--- SELECT (FILTRA COLUMNAS)
		+ FA (MAX, MIN, AGV, COUNT, SUM)
			--GROUP BY --como MINIMO todo lo que est� en el select menos la FA
  4--- HAVING -- tratar FA
  5---ORDER BY --unica clausula que acepta renombramientos
  */



 /*5.	Seleccionar por pa�s el cliente a quien m�s se le ha vendido 
y el n�mero de �rdenes que se emitieron para ese cliente, solo de las 
ventas del 2017 y el pa�s de env�o sea el mismo del cliente, 
ordenado por pa�s y nombre cliente. Se debe mostrar pa�s, 
id cliente, nombre cliente, numero ordenes, importe vendido*/
-- eliminar 
drop view  vw_orders_by_customers_v2

--modificar
alter view vw_monto_pais as

CREATE VIEW vw_orders_by_customers_v2 AS

select c.CustomerID, c.Country, c.CompanyName,  count(o.OrderID)'cantidad', SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) 'monto'
from  Customers  c  join Orders o on c.CustomerID=o.CustomerID
join [Order Details] od on o.OrderID=od.OrderID
where year(o.OrderDate)= 2017
group by  c.Country, c.CompanyName, c.CustomerID
order by 3 asc


CREATE VIEW vw_orders_by_customers_v AS
select vw.Country, max(vw.monto)'maximo'
from vw_orders_by_customers_v2 vw
group by vw.Country

SELECT
	vw.Country,
	vw.CustomerID,
	vw.CompanyName,
	vw.Cantidad,
	vw.Monto
FROM vw_orders_by_customers_v2 vw join  vw_orders_by_customers_v vw1 ON vw1.Country = vw.Country
WHERE vw.Monto = vw1.maximo
order by 1 asc

 
  /* Liste los productos que se quedar�an desabastecidos 
 si la venta en unidades se multiplica por 2. 
 Muestre el c�digo del producto, 
 su stock actual, la venta en unidades actual y 
 la que ser�a si se multiplica por 2.*/

 select p.ProductID, p.UnitsInStock, cant_ventas=sum(od.Quantity), cant_ventas_X_dos=sum(od.Quantity*2)
 from Products p join [Order Details] od on p.ProductID=od.ProductID
 group by  p.ProductID, p.UnitsInStock
 having  sum(od.Quantity*2) > p.UnitsInStock 

 /* Mostrar el proveedor que
 tuvo la menor venta (MONTO) de productos en un a�o 2017
*/
CREATE VIEW vw_ventas_by_supplier AS
select s.SupplierID, s.CompanyName, year(o.ShippedDate)'a�o', SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) 'monto'
from Suppliers s join Products p on s.SupplierID=p.SupplierID
join [Order Details] od on p.ProductID= od.ProductID
join Orders o on od.OrderID=o.OrderID
where year(o.ShippedDate)=2017
group by s.SupplierID, s.CompanyName, year(o.ShippedDate)


select min(vw1.monto) 
From  vw_ventas_by_supplier vw1

select vw.SupplierID, vw.CompanyName, vw.a�o
from  vw_ventas_by_supplier vw 
where vw.monto=(select min(vw1.monto) 
				From  vw_ventas_by_supplier vw1
				)


 /* Muestre el territorio y nombre de los jefes cuyos empleados han superado dos �rdenes vendidas y m�s de 
1000 en monto vendido. Estos jefes ser�n acreedores de un premio siempre y cuando
 la diferencia en d�as entre la fecha de la orden y la fecha de despacho no sea mayor a 7.*/



--JEFE Y EMPLEADOS
 select j.EmployeeID, j.FirstName, t.TerritoryDescription,SUM(od.UnitPrice*od.Quantity*(1-od.Discount)) 'monto_total'
 from Employees e  join Employees j on e.ReportsTo=j.EmployeeID
join EmployeeTerritories et on j.EmployeeID=et.EmployeeID 
join Territories t on et.TerritoryID=t.TerritoryID
join Orders o on e.EmployeeID=o.EmployeeID
join [Order Details] od on o.OrderID=od.OrderID
where datediff(d, o.OrderDate, o.ShippedDate) < 7
group by j.EmployeeID, j.FirstName, t.TerritoryDescription
having SUM(od.UnitPrice*od.Quantity*(1-od.Discount)) > 1000 and count(o.OrderID)>2 


/*Northwind debe premiar a los clientes cuya cantidad de �rdenes compradas y
cantidad de monto acumulado haya superado el promedio de �rdenes compradas y monto comprado de
su mismo pa�s en un determinado a�o. Debe mostrar el cliente, monto de venta acumulado, cantidad de
�rdenes compradas y pa�s*/
 
create view vw_monto_od_cliente as
select c.CustomerID, c.CompanyName, c.Country, 
		monto=sum(od.Quantity*od.UnitPrice*(1-od.Discount)), cantidad_ordenes=count(o.OrderID)
from Customers c join Orders o on c.CustomerID=o.CustomerID
				join [Order Details] od on o.OrderID=od.OrderID
where year(o.OrderDate)=2017
group by c.CustomerID, c.CompanyName, c.Country


select vw1.Country, avg(vw1.monto)
from vw_monto_od_cliente vw1
group by vw1.Country 


--RPTA:
select *
from vw_monto_od_cliente vw
where vw.monto> ( select avg(vw1.monto)
					from vw_monto_od_cliente vw1
					where vw1.Country=vw.Country) 
and vw.cantidad_ordenes>(select avg(vw1.cantidad_ordenes)
							from vw_monto_od_cliente vw1
							where vw1.Country=vw.Country
					)
order by CustomerID

/*Se quiere otorgar un incentivo a los empleados en su onom�stico, para lo cual en el mes de
su cumplea�os se le entregar� un bono equivalente al 5% del monto de la venta efectuada por el durante el mes.
Obtener la relaci�n de empleados que se har�n acreedores a dicho bono, mostrando: ID empleado, apellido, nombre,
fecha de nacimiento e importe a entregar.*/

--where month(Odate)=month(birthdate )

select e.BirthDate, e.EmployeeID, e.LastName, e.FirstName, o.OrderDate, o.OrderID, monto=sum(od.Quantity*od.UnitPrice*(1-od.Discount))*0.5
from Employees e join Orders o on e.EmployeeID=o.EmployeeID 
join [Order Details] od on o.OrderID=od.OrderID
where month(o.OrderDate)=month(e.BirthDate )
group by  e.BirthDate, e.EmployeeID, e.LastName, e.FirstName, o.OrderDate, o.OrderID


/*Pregunta 1 (5 puntos) Actualiza el precio de los productos con el 10% de su valor, 
de aquellos productos de categor�a3 y que alguna vez fueron vendidos a Francia*/

update Products
set UnitPrice= UnitPrice + UnitPrice*10/10
from --tablas, vistas, funciones, etc etc , join join
where CategoryID=3 and shipcountry='Francia'


/*
Pregunta 1 (4 puntos)
El gerente de ventas de Northwind quiere saber 
qui�nes son los clientes que NO han comprado durante el a�o 2018. 
A estos clientes Northwind los contactar� para ofrecerles un 
descuento en la siguiente compra. Deber� presentarle al gerente de 
ventas el c�digo y nombre de los clientes, adem�s de la fecha de su 
�ltima compra. Se deber� mostrar solo un registro por cliente.
 */
  create view vw_cust_fechas as 
 select c.CustomerID, c.CompanyName, o.OrderDate
 from Orders o join Customers c on o.CustomerID=c.CustomerID
 where year(o.OrderDate)=2018

 
  select vw.CustomerID
  from vw_cust_fechas  vw

 --rpta
  select  c.CompanyName, max(o.OrderDate),c.CustomerID
 from Orders o  right join Customers c on o.CustomerID=c.CustomerID
 where c.CustomerID!=all (  select vw.CustomerID
									 from vw_cust_fechas  vw)
 group by  c.CompanyName,c.CustomerID



 /*Pregunta 2 (4 puntos)
 Northwind desea saber cu�les son los pa�ses destino (ShipCountry)
  m�s populares de env�o y el producto m�s enviado a ese destino cada a�o.
   Tomar en cuenta lo siguiente:
�	El pa�s de destino m�s popular por a�o es el que tuvo m�s ventas en
 unidades (Quantity) en general incluyendo todos los productos vendidos.
�	Se debe elegir el producto m�s enviado a ese destino en ese a�o 
por venta de unidades (quantity) 

�	Se debe mostrar el a�o, pa�s de destino (ShipCountry), 
el producto m�s enviado a ese pa�s de destino y la cantidad 
enviada de ese producto (Quantity)*/

select o.ShipCountry, sum( od.Quantity), o.ShippedDate
from  Orders o join [Order Details] od on o.OrderID=od.OrderID
				join Products p on od.ProductID=p.ProductID 			
group by o.ShipCountry, o.ShippedDate



--Germany 2016 1910
--Germany 2017 4756
--USA	  2018 3152


 

 -- eliminar 
drop view  vw_cust_ord

----REPASO
/*Listar los empleados y el producto que m�s vendi� en
cantidad de �rdenes realizado en un determinado a�o 2017. Tome como base
la fecha de la orden (orderdate)*/
/*Empleado, el producto, la cantidad*/
create view vw_table_qordenes as
select e.EmployeeID, e.FirstName, p.ProductID, p.ProductName, Qordenes=count(o.OrderID)
from Products p join [Order Details] od on p.ProductID=od.ProductID
join Orders o on od.OrderID=o.OrderID 
join Employees e on o.EmployeeID=e.EmployeeID
where year(o.OrderDate)=2017
group by e.EmployeeID, e.FirstName, p.ProductID, p.ProductName

select vw.EmployeeID, vw.FirstName, vw.ProductID, vw.ProductName, max(vw.Qordenes)
from vw_table_qordenes vw
group by vw.EmployeeID, vw.FirstName, vw.ProductID, vw.ProductName
having max(vw.Qordenes)=(
						select max(vw1.Qordenes)
						from vw_table_qordenes vw1
						where vw.EmployeeID=vw1.EmployeeID	)

select max(vw1.Qordenes), vw1.FirstName
from vw_table_qordenes vw1
group by vw1.FirstName

/*Mostrar los empleados que tuvieron la mayor cantidad de ordenesvendidas en el a�o 2017Mostrar
el empleado, producto vendido y la cantidad de ordenes vendidas*/

select vw.EmployeeID, vw.FirstName, vw.ProductID, vw.ProductName, max(vw.Qordenes)
from vw_table_qordenes vw
group by vw.EmployeeID, vw.FirstName, vw.ProductID, vw.ProductName
having max(vw.Qordenes)=(
						select max(vw1.Qordenes)
						from vw_table_qordenes vw1
							)
/*Northwind desea saber si sus ventas est�n incrementando de a�o a a�o por lo tanto debe crear un 
procedimiento almacenado que muestre las ventas en monto y en cantidad de un a�o elegido y las ventas
en monto y en cantidad de a�o anterior al elegido.*/

select count(o.OrderID), Monto=SUM(od.quantity*od.unitprice*(1-od.discount)), '2017'
from [Order Details] od join Orders o
			on od.OrderID=o.OrderID
			where year(o.OrderDate)=2017
			
		union all
		
select count(o.OrderID), Monto=SUM(od.quantity*od.unitprice*(1-od.discount)), '2016'
from [Order Details] od join Orders o
			on od.OrderID=o.OrderID
			where year(o.OrderDate)=2016

