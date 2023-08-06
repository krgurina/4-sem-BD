USE G_MyBase;
go
CREATE function COUNT_STUDENTS(@faculty varchar(20)) returns int
as begin 
	declare @rc int = 0;
	set @rc = (select count(*) 
		from ������
		Join ������ ON ������.ID_������=������.ID_������
		where ���_���������� = @faculty);
	return @rc;
end;
go
--------------------------------------------
declare @f int = dbo.COUNT_STUDENTS(111);
print '���������� ��������� �� ����������: ' + cast(@f as varchar(4));

go
ALTER function dbo.COUNT_STUDENTS(@faculty varchar(20) = null, @prof varchar(20) = null) returns int
as begin 
	declare @rc int = 0;
	set @rc = (select count(*) 
		from ������
		Join ������ ON ������.ID_������=������.ID_������
		where ���_���������� = @faculty and �������=@prof);
	return @rc;
end;
go

print dbo.COUNT_STUDENTS(111, 'ak111')

drop function COUNT_STUDENTS

--2
create function FSUBJECTS(@pulpit varchar(20)) returns varchar(300)
as begin 
	declare @disc char(20);
	declare @line varchar(300) = '������: ';
	declare Subj CURSOR LOCAL
	for	select ��������_������ from ������ 
		where ���_���������� = @pulpit;
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
select ���_����������, dbo.FSUBJECTS(111) from ������

drop function FSUBJECTS;

--3

create function FFACPUL(@f varchar(20), @p varchar(20)) returns table
as return
	select f.�����_������, p.��������_������
	from ������ f left outer join ������ p
	on f.ID_������ = p.ID_������
	where f.�����_������ = isnull(@f, f.�����_������)
	and p.��������_������ = isnull(@p, p.��������_������)
go

-----------------------------------
select * from dbo.FFACPUL(null, null);
select * from dbo.FFACPUL(2, null);
select * from dbo.FFACPUL(null, '���������');
select * from dbo.FFACPUL(2, '���������');

drop function FFACPUL

--4
create function FCTEACHER(@p varchar(20)) returns int
as begin
	declare @rc int = (select count(*) from ������ p
	where p.���_���������� = isnull(@p,p.���_����������));
	return @rc;
end;
go

----------------------------
select ���_����������, dbo.FCTEACHER(PULPIT) from ������
select dbo.FCTEACHER(null);

drop function FCTEACHER
