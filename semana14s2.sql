
create table t_Departamento
(
CDepartamento int  ,
NDepartamento varchar(255),
NLocalidad varchar(255),
QEmpleados int,
constraint PK_Departamento PRIMARY KEY (CDepartamento)
)
insert into t_Departamento
values
(1,'Finanzas','Lima',0+1+1),
(2,'Sistemas','Lima',0+1)
select * from t_Departamento

Create table t_Empleado
(
CEmpleado int ,
NEmpleado Varchar(255),
CDepartamento int,
constraint PK_Empleado PRIMARY KEY (Cempleado),
constraint FK_Departamento FOREIGN KEY (CDepartamento)
				REFERENCES t_Departamento (CDepartamento)
)

select * from t_Departamento
select * from t_Empleado

insert into t_Empleado
values 
(1, 'Jorge Sanchez', 1),
(2,'Rodrigo Sabino',1),
(3, 'Fiorella Matta',2)

create trigger tg_empleado
on t_Empleado
for Insert
as
begin
		update t_Departamento
		set QEmpleados = QEmpleados+1
		from inserted
		where t_Departamento.CDepartamento=inserted.CDepartamento
end

select * from t_Departamento
select * from t_Empleado

insert into t_Empleado
values (4,'Antonio Campos',2)

insert into t_Empleado
values (5,'Maria Sabino',1)

----------------------------
drop trigger tg_departamento
drop trigger tg_Empleado

create trigger tg_departamento
on t_Empleado
for delete
as
begin
		update t_Departamento
		set QEmpleados = QEmpleados-1
		from deleted
		where t_Departamento.CDepartamento=deleted.CDepartamento
end
select * from t_Departamento
select * from t_Empleado

delete from t_Empleado
where CEmpleado=3


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
