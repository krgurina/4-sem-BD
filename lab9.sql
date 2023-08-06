use UNIVER;

--1
declare @a int =1,
		@b char='q',
		@c varchar(10), 
		@d datetime,
		@e time,
		@f smallint,
		@g tinyint,
		@h numeric(12,5);
		
set @c ='hello';
set @d = getdate();
select @e='22:12:33';
select @f = 12;
select @g = COUNT(*) from STUDENT;
select @h = convert(numeric(12, 5), 12345.6789);

select @a a, @b b, @c c, @d d;
print 'time = ' + cast(@e as varchar(10));
print 'smallint = ' + cast(@f as varchar(10));
print 'tinyint = ' + cast(@g as varchar(10));
print 'numeric = ' + CONVERT(CHAR, @h);

--2
/*����������� ������, � ������� ������������ ����� ����������� ���������.
���� ����� ����������� ��������� 200, �� ������� ���������� ���������, 
������� ����������� ���������, ���������� ���������, ����������� ������� ������ �������, � ������� ����� ���������. 
���� ����� ����������� ��������� ������ 200, �� ������� ��������� � ������� ����� �����������.
*/

declare @sumCapacity int = (select (sum(AUDITORIUM.AUDITORIUM_CAPACITY)) from AUDITORIUM),
		@count int,
		@avgCapacity real,
		@countLess int,
		@procent real;
print 'sumCapacity = ' + cast(@sumCapacity as varchar(10));

if @sumCapacity>200
begin 
	set @count = (select count(AUDITORIUM) from AUDITORIUM);
	set @avgCapacity = (select avg(AUDITORIUM_CAPACITY) from AUDITORIUM);
	set @countLess = (select count(AUDITORIUM) from AUDITORIUM where AUDITORIUM.AUDITORIUM_CAPACITY < @avgCapacity);
	set @procent = 100*(cast(@countLess as float) /cast(@count as float));
	select @count '���������� ���������', @avgCapacity '������� ����������� ', @countLess '���������� � �������� ����� �������', cast(@procent as numeric(8, 2)) '������� ��������� � �������� ����� �������';
end
else
	print 'sumCapacity = ' + cast(@sumCapacity as varchar(10));

--3
/*����������� T-SQL-������, ������� ������� �� ������ ���������� ����������: */
print '����� ������������ �����: ' + cast(@@rowcount as varchar(10));
print '������ SQL Server: ' + cast(@@version as varchar(10));
print '��������� ������������� ��������, ����������� �������� �������� �����������: ' + cast(@@spid as varchar(10));
print '��� ��������� ������: ' + cast(@@error as varchar(10));
print '��� �������: ' + cast(@@servername as varchar(10));
print '������� ����������� ����������: ' + cast(@@trancount as varchar(10));
print 'print: ' + cast(@@fetch_status as varchar(10));
print '������� ����������� ������� ���������: ' + cast(@@nestlevel as varchar(10));

--4
-- ���������� �������� ���������� z 
declare @z float,
		@t float = 3.2,
		@x int = 13;
if @t>@x
	set @z=POWER(sin(@t),2);
else if @t<@x
	set @z=4*(@t+@x)
else
	set @z=1-exp(@x-2);
print 'z=' + cast(@z as varchar(10));

-- �������������� ������� ��� �������� � ����������� (��������, �������� ������� ���������� � �������� �. �.);
declare @name varchar(30) = '������ �������� ���������', @shortName varchar(30);
set @shortName = (select SUBSTRING(@name, 1, charindex(' ', @name)+1)+'. ' + substring(@name, charindex(' ', @name, charindex(' ', @name)+1)+1, 1) + '. ');
print '��� = ' + @shortName;

----
--����� ���������, � ������� ���� �������� � ��������� ������, � ����������� �� ��������
select NAME[��� ��������], datediff(yy, bday,getdate())[�������]
from STUDENT
where MONTH(bday)=MONTH(getdate())+1

--����� ��� ������, � ������� �������� ��������� ������ ������� ������� �� ��.
select DATENAME(weekday, PDATE) [���� ������], PDATE[����] from PROGRESS
where SUBJECT like '%��%'

--5
/*������������������ ����������� IF� ELSE �� ������� ������� ������ ������ ���� ������ �_UNIVER.*/
if ((select count(*) from STUDENT)>100)
	begin 
		print '��������� ������ 100'
	end
else
	begin 
		print '��������� ������ 100'
	end

--6
/*6. ����������� ��������, � ������� � ������� CASE ������������� ������, ���������� ���������� ���������� ���������� ��� ����� ���������.*/
select PROGRESS.IDSTUDENT[��� ��������],
	case 
		when PROGRESS.NOTE = 10 then '����� ������'
		when PROGRESS.NOTE between 7 and 9 then '������'
		when PROGRESS.NOTE between 4 and 6 then  '�� �����'
		else '���������'
		end [������]
from PROGRESS
group by PROGRESS.IDSTUDENT, case
		when PROGRESS.NOTE = 10 then '����� ������'
		when PROGRESS.NOTE between 7 and 9 then '������'
		when PROGRESS.NOTE between 4 and 6 then  '�� �����'
		else '���������'
		end

--7
/*������� ��������� ��������� ������� �� ���� �������� � 10 �����, ��������� �� � ������� ����������. 
������������ �������� WHILE.*/

create table #local
(
	number int,
	name varchar(15),
	age int
)
set nocount on;
declare @i int = 1;
while @i<10
	begin
		insert #local(number,age, name)
			values(@i,@i+20,'name')
			set @i=@i+1;
	end
select * from #local

--8
declare @r int = 1;
while @r<10
	begin
		print 'r = ' + cast(@r as varchar(10));
		if(@r=5) return
		set @r=@r+1;
	end

--9
begin try
	UPdate FACULTY set FACULTY = '����' where FACULTY='���'
end try
begin catch
	print ERROR_NUMBER()
	print ERROR_MESSAGE()
	print ERROR_LINE()
	print ERROR_PROCEDURE()
	print ERROR_SEVERITY()
	print ERROR_STATE()
end catch