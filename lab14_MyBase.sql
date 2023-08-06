USE G_MyBase;
go
CREATE function COUNT_STUDENTS(@faculty varchar(20)) returns int
as begin 
	declare @rc int = 0;
	set @rc = (select count(*) 
		from ЗАКАЗЫ
		Join ДЕТАЛИ ON ЗАКАЗЫ.ID_детали=ДЕТАЛИ.ID_детали
		where Код_поставщика = @faculty);
	return @rc;
end;
go
--------------------------------------------
declare @f int = dbo.COUNT_STUDENTS(111);
print 'Количество студентов на факультете: ' + cast(@f as varchar(4));

go
ALTER function dbo.COUNT_STUDENTS(@faculty varchar(20) = null, @prof varchar(20) = null) returns int
as begin 
	declare @rc int = 0;
	set @rc = (select count(*) 
		from ЗАКАЗЫ
		Join ДЕТАЛИ ON ЗАКАЗЫ.ID_детали=ДЕТАЛИ.ID_детали
		where Код_поставщика = @faculty and Артикул=@prof);
	return @rc;
end;
go

print dbo.COUNT_STUDENTS(111, 'ak111')

drop function COUNT_STUDENTS

--2
create function FSUBJECTS(@pulpit varchar(20)) returns varchar(300)
as begin 
	declare @disc char(20);
	declare @line varchar(300) = 'Детали: ';
	declare Subj CURSOR LOCAL
	for	select Название_детали from ДЕТАЛИ 
		where Код_поставщика = @pulpit;
	open Subj;
	fetch Subj into @disc;
	while @@FETCH_STATUS = 0
	begin
		set @line += rtrim(@disc) + ', ';
		FETCH Subj into @disc;
	end;
	return @line;
end;
go
------------------------------
select Код_поставщика, dbo.FSUBJECTS(111) from ДЕТАЛИ

drop function FSUBJECTS;

--3

create function FFACPUL(@f varchar(20), @p varchar(20)) returns table
as return
	select f.Номер_заказа, p.Название_детали
	from ЗАКАЗЫ f left outer join ДЕТАЛИ p
	on f.ID_детали = p.ID_детали
	where f.Номер_заказа = isnull(@f, f.Номер_заказа)
	and p.Название_детали = isnull(@p, p.Название_детали)
go

-----------------------------------
select * from dbo.FFACPUL(null, null);
select * from dbo.FFACPUL(2, null);
select * from dbo.FFACPUL(null, 'Двигатель');
select * from dbo.FFACPUL(2, 'Двигатель');

drop function FFACPUL

--4
create function FCTEACHER(@p varchar(20)) returns int
as begin
	declare @rc int = (select count(*) from ДЕТАЛИ p
	where p.Код_поставщика = isnull(@p,p.Код_поставщика));
	return @rc;
end;
go

----------------------------
select Код_поставщика, dbo.FCTEACHER(PULPIT) from ДЕТАЛИ
select dbo.FCTEACHER(null);

drop function FCTEACHER
