/*La empresa tiene dos opciones de compra, de manera física y online.
Phantom quiere saber por cual de los dos medios es más rentable
la venta de productos por X año.
Phantom desea saber cual de los dos medios de compra es más rentable para la empresa. 
Por ello necesita saber el monto total de ventas por un año seleccionado, si esta es online o física y 
la cantidad de clientes que realizan la venta. 
*/
create view vs_montoanio as  
select DATEPART(YEAR, v.DVenta)'fecha', sum(v.Monto_total)'total', v.Fventa_online, count(v.CCliente)'Qclientes'
from venta v 
group by DATEPART(year, v.DVenta) ,v.Fventa_online
order by  1 asc


select vs1.Fventa_online, vs1.total, vs1.fecha
from vs_montoanio vs1
where vs1.total=(select max(vs.total)
				from vs_montoanio vs)


create function fn_cantidad_monto (@fecha int)
returns table 
as
return 
(select vs1.Fventa_online, vs1.total, vs1.fecha, vs1.Qclientes
from vs_montoanio vs1
where vs1.total=(select max(vs.total)
				from vs_montoanio vs
				where vs.fecha=@fecha)
)

select *
from dbo.fn_cantidad_monto (2020)

--0 = presencial 
--1 = online

/*La empresa Phantom desea otorgar un cupón a sus clientes por la compra de un producto. Sin embargo,  un cliente puede realizar 
varias compras en un mismo mes. Es por ello que la empresa otorgará el descuento en base a la compra más alta que realice el cliente en el mes
que desee seleccionar la empresa. Además el encargado recibirá el 15% del monto de la venta. El cupón de descuento será el 5% del producto que compró.
La empresa desea conocer el código del cliente, nombre del cliente, año que seleccione, código del producto, descuento, monto, código del vendedor y el bono que se le otorga.

*/

drop view vw_cantidad_ventas_anio

create view vw_ventas_anio as
select c.NCliente, (v.CVenta), month(v.DVenta)'mes', year(v.DVenta)'anio',dv.MPrecio_QProducto, v.CVendedor, dv.CProducto, cg.MSueldo, dv.QProducto, cp.DCambio, c.CCliente
from Cliente c join Venta v on c.CCliente=v.CCliente
				join Detalle_venta dv on v.CVenta=dv.CVenta
				join Personal p on v.CVendedor=p.CPersonal
				join Cargo_personal cp on p.CPersonal=cp.CPersonal
				join Cargo cg on cp.CCargo=cg.CCargo
			
alter view vw_cantidad_ventas_anio as
 select   vw.CCLiente, vw.NCliente,  vw.MPrecio_QProducto, vw.anio, vw.mes, vw.CProducto, vw.CVendedor,vw.MSueldo, vw.CVenta, vw.QProducto,vw.DCambio
from vw_ventas_anio vw 
where vw.MPrecio_QProducto=(select  max(vw1.MPrecio_QProducto)
							from vw_ventas_anio vw1 
							where vw.NCliente=vw1.NCliente)


alter view vw_maximo_producto as

 select  vw1.CCLiente, vw1.NCliente,max(vw1.MPrecio_QProducto)'monto' , vw1.mes, vw1.anio, sum(0.05 * vw1.MPrecio_QProducto)'Descuento', vw1.CProducto, vw1.CVendedor, vw1.MSueldo
from vw_cantidad_ventas_anio vw1 
where vw1.DCambio =(select max(crg.DCambio)
					from Cargo_personal crg
					where vw1.CVendedor=crg.CPersonal )
group by vw1.NCliente, vw1.CCLiente, vw1.mes, vw1.anio, vw1.CProducto, vw1.CVendedor, vw1.MSueldo

drop function  fn_mes_maxMonto

 create function fn_mes_maxMonto (@mess int )
 returns table 
 as 
 return 
 (
 select vw.CCLiente, vw.NCliente, vw.mes, vw.anio, vw.CProducto, vw.Descuento,vw.monto,vw.CVendedor,(vw.monto*0.15)'bono'
 from vw_maximo_producto vw
 where vw.mes=@mess
 )

 select* 
 from dbo.fn_mes_maxMonto(10)




-- borrador 
 select distinct vw1.CCLiente, vw1.NCliente,max(vw1.MPrecio_QProducto)'monto' , vw1.mes, vw1.anio, sum(0.05 * vw1.MPrecio_QProducto)'Descuento', vw1.CProducto
from vw_ventas_anio vw1 
where vw1.DCambio =(select max(crg.DCambio)
					from Cargo_personal crg
					where vw1.CVendedor=crg.CPersonal ) and 
					vw1.MPrecio_QProducto=(select  max(vw2.MPrecio_QProducto)
							from vw_ventas_anio vw2 
							where vw1.NCliente=vw2.NCliente)

group by vw1.NCliente, vw1.CCLiente, vw1.mes, vw1.anio, vw1.CProducto

				
/*La empresa Phantom considera que las horas de trabajo de sus encargados 
deben ser de 8 horas diarias. La empresa quiere saber si las horas que están laborando sus trabajadores
genera algún beneficio como mayor cantidad de ventas.
Por lo que debe mostrar el código del personal, nombre del personal, las horas extras que trabaja, cantidad de ventas y el 
mes que se seleccione.
No se les pagará por sus horas extras*/
drop  view vw_promedio_horas as
select*
from Venta
create view vw_cantmeses as
select   p.CPersonal,p.Npersonal,  month(v.DVenta)'mes', year(v.DVenta)'anio',count( v.CVenta)'ventas'
from Venta v join Personal p on v.CVendedor=p.CPersonal
	join Horario h on p.CPersonal=h.CPersonal
	where v.Fventa_online is NOT NULL
group by  p.CPersonal,p.Npersonal,  month(v.DVenta),year(v.DVenta)

create view vw_cantVentas as

select vw.CPersonal, vw.Npersonal, vw.mes ,sum(vw.ventas)'ventas'
from vw_cantmeses vw 
group by vw.CPersonal, vw.Npersonal, vw.mes

-------------------
------




alter view vw_promedio_horass as

select h.CPersonal,p.Npersonal, h.CDia, h.CTienda_o_local, DATEDIFF(HOUR, h.HInicio, h.HFin)'Htrbajo', crg.MSueldo, CP.DCambio
from Personal p join Horario h on p.CPersonal=h.CPersonal
     join Cargo_personal cp on p.CPersonal=cp.CPersonal 
	 join Cargo crg on cp.CCargo=crg.CCargo


alter view vw_promedio_Htrabajo as
select   vw.CPersonal,vw.Npersonal, avg(Htrbajo)-8'promedioH', vw.MSueldo
from vw_promedio_horass vw
where vw.DCambio = (select max(crg.DCambio)
					from Cargo_personal crg
					where vw.CPersonal=crg.CPersonal)
group by vw.CPersonal, vw.Npersonal, vw.MSueldo

--------

alter function fn_mes_htrabajador (@mess int )
returns table 
as 
return
(
select  vw.CPersonal, vw.Npersonal, vw.promedioH, vw1.ventas, vw1.mes
from vw_promedio_Htrabajo vw join vw_cantVentas vw1 on vw.CPersonal=vw1.CPersonal
where vw1.ventas= (select max (vw3.ventas) 
		from vw_promedio_Htrabajo vw join vw_cantVentas vw3 on vw.CPersonal=vw3.CPersonal
		 where vw1.mes= vw3.mes ) and vw1.mes=@mess
)

select* 
from dbo.fn_mes_htrabajador(08)


-------

select   max(vw1.ventas)'maxventas', vw1.mes
from vw_promedio_Htrabajo vw join vw_cantVentas vw1 on vw.CPersonal=vw1.CPersonal
group by vw1.mes



/* La empresa Phantom desea conocer los X productos más vendidos en una promoción
cuya duración es menor a X días.
De esa manera la empresa quiere conocer el precio del productos con y sin el
descuento. 
Dependiendo de la cantidad que se adquiera rl producto, desea saber
si su venta es más rentable con promoción o precio normal. cuantas ventas 
-productos en promocion - cantidad de ventas
- productos sin promocion - cantidad de ventas 
- qur producto es mpas rentable 
donde compran más 
*/
select  v.CVenta,dv.CProducto, pr.NProducto, prcm.CPromocion, month(v.DVenta)'mes',  day(v.DVenta)'dia'
from  venta v join Detalle_venta dv on v.CVenta=dv.CVenta
					  join Producto pr on dv.CProducto=pr.CProducto 
					  join Productos_en_promocion prcm on pr.CProducto=prcm.CProducto 
					  join Promocion pm on prcm.CPromocion=pm.CPromocion
--ventas


alter view vw_ventas_mes as
select  v.CVenta,dv.CProducto,month(v.DVenta)'mes',  day(v.DVenta)'dia', pr.MPrecio
from  venta v join Detalle_venta dv on v.CVenta=dv.CVenta
					  join Producto pr on dv.CProducto=pr.CProducto 

--productos en promocion

alter view vw_prod_promcs as 
select prcm.CProducto, prcm.CPromocion,  prcm.PerDescuento'descuento', month(pm.DInicio)'mes', day(pm.DInicio)'Dinicio', day(pm.DFin)'DFin'
from	Producto p join Productos_en_promocion prcm on p.CProducto=prcm.CProducto
		join Promocion pm on prcm.CPromocion=pm.CPromocion


select vw.CVenta, vw.CProducto, vw.MPrecio - vw1.descuento'MontoTtotal', vw.mes
from  vw_ventas_mes vw join vw_prod_promcs vw1 on vw.CProducto = vw1.CProducto
where vw.mes = vw1.mes and ( vw.dia between vw1.DInicio  and vw1.DFin) 



/*
fecha de cambio para agregar al carrito 
cuantos productos se compran 
La empresa desea saebr cuál fue el último producto que agregó a su carrito el cliente. 
Además asegurarse si es que el carrito de compras fue usado en la venta. 
contar cuantos compran enc arrito y cuantos de frente 
*/

create view vw_agrg_carrito as 
select pec.CCarrito, sum(pec.MPrecio_QProducto)'Tcarrito'
from Productos_en_carrito  pec
group by pec.CCarrito

alter view vw_prodc_descuentos as
select ccpra.CCarrito,ccpra.CCliente, (vd.PerDescuento/100)'descuento'
from Carrito_compras ccpra left join Vales_Descuento vd on ccpra.CDescuento=vd.CDescuento

create view vw_carritototal as
select vw.CCarrito, vw.Tcarrito, vw1.CCliente, vw1.descuento, vw.Tcarrito -(vw.Tcarrito*vw1.descuento)'TOTAL'
from vw_agrg_carrito vw  join vw_prodc_descuentos vw1 on 
						vw.CCarrito=vw1.CCarrito

-------------------------
create view vw_montototal as
select vta.CCliente, cle.NCliente, sum( vta.Monto_total)'Mtotal'
from cliente cle join Venta vta on cle.CCliente=vta.CCliente 
group by vta.CCliente, cle.NCliente
order by 1,3 asc  


select  vw.CCarrito, vw.CCliente, vw1.NCliente, vw1.Mtotal'Mventa' , vw.TOTAL 'Msicompracarrito', vw1.Mtotal- vw.TOTAL 'Diferencia', vw.Tcarrito
from vw_carritototal vw join vw_montototal vw1 on vw.CCliente=vw1.CCliente
where vw.TOTAL is not null
