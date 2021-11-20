/*

La empresa Phantom desea entregar un cupón de descuento para
los clientes que cuentan con más compras en el mes que se seleccione. 
Desea saber cual fue el producto que más compró el cliente y en base al que 
más se compró se le asignará el cupón de descuento del 5% de su producto más 
cpmrado. Cabe destacar que los encargados de esas ventas recibirán un bono
del 5% del total de ventas de su clientes 

*/

create function  fn_ClienteMes (@Mes int)
returns table
as
return (
				select c.CCliente, c.NCliente, dv.CProducto, dv.QProducto, p.MPrecio
				from Venta v join Cliente c on v.CCliente = c.CCliente
							join Detalle_venta dv on v.CVenta = dv.CVenta
							join Producto p on dv.CProducto = p.CProducto
				where MONTH(v.DVenta) = 8
		)

create function  fn_ClienteDesc (@Mes int)
returns table
as
return (
			select a.CCliente, a.NCliente, a.CProducto, a.QProducto, a.MPrecio, (a.MPrecio * 0.05) 'Descuento'
			from fn_ClienteMes(@Mes) a
			where a.QProducto = (
									select MAX(QProducto) 'MaxProduct'
									from fn_ClienteMes(@Mes) b
									where b.CCliente = a.CCliente
								)
		)

select a.CCliente, Sum(v.Monto_total)*0.05 'Monto', v.CVendedor 
from fn_ClienteDesc(8) a join Venta v on a.CCliente = v.CCliente
where v.CVendedor is not null
group by a.CCliente, v.CVendedor
