use G_MyBase
--1
declare @subj char(20), @s char(300)='';
declare cur cursor for select ��������_������ from ������ where ���_���������� = 111
open cur;
	fetch cur into @subj 
	print '������� �������� ��������� '
	while @@FETCH_STATUS = 0
		begin
		set @s = RTRIM(@subj) + ',' + @s;
		fetch cur into @subj
	end;
	print @s;
Close cur;
deallocate cur;

--2
declare Puls cursor LOCAL for select ��������_������, ���_���������� from ������;
declare @pul nvarchar(10), @fac nvarchar(4);
open Puls;
	fetch Puls into @pul, @fac;
    print '1. '+ rtrim(@pul)+' ���������: '+ @fac;
	go

	DECLARE @pul nvarchar(10), @fac nvarchar(4);     	
	fetch Puls into @pul, @fac; 	
    print '2. '+ rtrim(@pul)+' ���������: '+ @fac;
	go

	-- ����������
declare Puls cursor for select ��������_������, ���_���������� from ������;
declare @pul nvarchar(10), @fac nvarchar(4);

open Puls;
	fetch Puls into @pul, @fac;
    print '1. '+ rtrim(@pul)+' ���������: '+ @fac;
	go

	DECLARE @pul nvarchar(10), @fac nvarchar(4);     	
	fetch Puls into @pul, @fac; 	
    print '2. '+ rtrim(@pul)+' ���������: '+ @fac;
	go
 close Puls;

 --3
 declare cur cursor local static for (select ��������_������, �������, ���� from ������)
declare @name varchar(10)
declare @type varchar(5)
declare @cap int

open cur
print '����� � �������: ' + cast(@@cursor_rows as char)
update ������ set ���� = 111 where ������� = 'ak111'		
fetch cur into @name, @type, @cap
while @@FETCH_STATUS = 0
begin
	print @name + ' ' + @type + ' ' + cast(@cap as char) 
	fetch cur into @name, @type, @cap
end
close cur
deallocate cur

go
-- ������������
 declare cur cursor local dynamic for (select ��������_������, �������, ���� from ������)
declare @name varchar(10)
declare @type varchar(5)
declare @cap int

open cur
print '����� � �������: ' + cast(@@cursor_rows as char)
update ������ set ���� = 111 where ������� = 'ak111'		
fetch cur into @name, @type, @cap
while @@FETCH_STATUS = 0
begin
	print @name + ' ' + @type + ' ' + cast(@cap as char) 
	fetch cur into @name, @type, @cap
end
close cur
deallocate cur

--4
declare cur cursor local dynamic scroll for 
	select row_number() over (order by ID_������), ID_������, ��������_������, ���� from ������
declare @rn int, @id varchar(10), @sub varchar(15), @nt int
open cur

fetch cur into @rn, @id, @sub, @nt
print 'First:		' + cast(@rn as varchar) + '. ID: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ����: ' + cast(@nt as varchar)

fetch next from cur into @rn, @id, @sub, @nt
print 'Next:		' + cast(@rn as varchar) + '. ID: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ����: ' + cast(@nt as varchar)

fetch prior from cur into @rn, @id, @sub, @nt
print 'Prior:		' + cast(@rn as varchar) + '. ID: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ����: ' + cast(@nt as varchar)

fetch absolute 3 from cur into @rn, @id, @sub, @nt
print 'absolute 3:	' + cast(@rn as varchar) + '. ID: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ����: ' + cast(@nt as varchar)

fetch absolute -3 from cur into @rn, @id, @sub, @nt
print 'absolute -3:' + cast(@rn as varchar) + '. ID: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ����: ' + cast(@nt as varchar)

fetch relative 2 from cur into @rn, @id, @sub, @nt
print 'relative 2:	' + cast(@rn as varchar) + '. ID: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ����: ' + cast(@nt as varchar)

fetch relative -2 from cur into @rn, @id, @sub, @nt
print 'relative -2:' + cast(@rn as varchar) + '. ID: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ����: ' + cast(@nt as varchar)

fetch last from cur into @rn, @id, @sub, @nt
print 'Last:		' + cast(@rn as varchar) + '. ID: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ����: ' + cast(@nt as varchar)

close cur

--5
declare cur cursor local dynamic for 
	select ID_������, ��������_������, ���� from ������ FOR UPDATE
declare @id varchar(10), @sub varchar(15), @nt int

open cur
fetch cur into @id, @sub, @nt
while @@FETCH_STATUS = 0
begin
	if @nt = 111 update ������ set ���� = 222 where CURRENT OF cur
	if @id = 25 delete ������ where CURRENT OF cur

	print 'ID: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ����: ' + cast(@nt as varchar)
	fetch cur into @id, @sub, @nt
end
close cur

--6(1)
declare cur cursor local dynamic for 
	select z.�����_������, d.��������_������, d.���� from ������ d 
	join  ������ z on d.ID_������ = z.ID_������
	where d.���� < 100
		FOR UPDATE
declare @gr varchar(5), @nm varchar(50), @nt int
open cur
fetch cur into @gr, @nm, @nt
while @@FETCH_STATUS = 0
	begin
		print @gr + ': ' + @nm + ' ����: ' + cast(@nt as varchar)
		delete ������ where CURRENT OF cur	
		delete ������ where CURRENT OF cur
		fetch cur into @gr, @nm, @nt

	end
close cur

--6(2)
declare cur cursor local dynamic for 
	select ID_������, ��������_������, ���� from ������ FOR UPDATE
declare @id varchar(10), @sub varchar(15), @nt int

open cur
fetch cur into @id, @sub, @nt
while @@FETCH_STATUS = 0
begin
	if @nt = 111 update ������ set ���� = ���� + 1 where CURRENT OF cur
	if @id = 25 delete ������ where CURRENT OF cur

	print 'ID: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ����: ' + cast(@nt as varchar)
	fetch cur into @id, @sub, @nt
end
close cur
