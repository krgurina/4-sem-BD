use G_MyBase
--1
declare @subj char(20), @s char(300)='';
declare cur cursor for select Название_детали from ДЕТАЛИ where Код_поставщика = 111
open cur;
	fetch cur into @subj 
	print 'краткие названия дисциплин '
	while @@FETCH_STATUS = 0
		begin
		set @s = RTRIM(@subj) + ',' + @s;
		fetch cur into @subj
	end;
	print @s;
Close cur;
deallocate cur;

--2
declare Puls cursor LOCAL for select Название_детали, Код_поставщика from ДЕТАЛИ;
declare @pul nvarchar(10), @fac nvarchar(4);
open Puls;
	fetch Puls into @pul, @fac;
    print '1. '+ rtrim(@pul)+' поставщик: '+ @fac;
	go

	DECLARE @pul nvarchar(10), @fac nvarchar(4);     	
	fetch Puls into @pul, @fac; 	
    print '2. '+ rtrim(@pul)+' поставщик: '+ @fac;
	go

	-- глобальный
declare Puls cursor for select Название_детали, Код_поставщика from ДЕТАЛИ;
declare @pul nvarchar(10), @fac nvarchar(4);

open Puls;
	fetch Puls into @pul, @fac;
    print '1. '+ rtrim(@pul)+' поставщик: '+ @fac;
	go

	DECLARE @pul nvarchar(10), @fac nvarchar(4);     	
	fetch Puls into @pul, @fac; 	
    print '2. '+ rtrim(@pul)+' поставщик: '+ @fac;
	go
 close Puls;

 --3
 declare cur cursor local static for (select Название_детали, Артикул, Цена from ДЕТАЛИ)
declare @name varchar(10)
declare @type varchar(5)
declare @cap int

open cur
print 'строк в курсоре: ' + cast(@@cursor_rows as char)
update ДЕТАЛИ set Цена = 111 where Артикул = 'ak111'		
fetch cur into @name, @type, @cap
while @@FETCH_STATUS = 0
begin
	print @name + ' ' + @type + ' ' + cast(@cap as char) 
	fetch cur into @name, @type, @cap
end
close cur
deallocate cur

go
-- динамический
 declare cur cursor local dynamic for (select Название_детали, Артикул, Цена from ДЕТАЛИ)
declare @name varchar(10)
declare @type varchar(5)
declare @cap int

open cur
print 'строк в курсоре: ' + cast(@@cursor_rows as char)
update ДЕТАЛИ set Цена = 111 where Артикул = 'ak111'		
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
	select row_number() over (order by ID_детали), ID_детали, Название_детали, Цена from ДЕТАЛИ
declare @rn int, @id varchar(10), @sub varchar(15), @nt int
open cur

fetch cur into @rn, @id, @sub, @nt
print 'First:		' + cast(@rn as varchar) + '. ID: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' Цена: ' + cast(@nt as varchar)

fetch next from cur into @rn, @id, @sub, @nt
print 'Next:		' + cast(@rn as varchar) + '. ID: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' Цена: ' + cast(@nt as varchar)

fetch prior from cur into @rn, @id, @sub, @nt
print 'Prior:		' + cast(@rn as varchar) + '. ID: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' Цена: ' + cast(@nt as varchar)

fetch absolute 3 from cur into @rn, @id, @sub, @nt
print 'absolute 3:	' + cast(@rn as varchar) + '. ID: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' Цена: ' + cast(@nt as varchar)

fetch absolute -3 from cur into @rn, @id, @sub, @nt
print 'absolute -3:' + cast(@rn as varchar) + '. ID: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' Цена: ' + cast(@nt as varchar)

fetch relative 2 from cur into @rn, @id, @sub, @nt
print 'relative 2:	' + cast(@rn as varchar) + '. ID: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' Цена: ' + cast(@nt as varchar)

fetch relative -2 from cur into @rn, @id, @sub, @nt
print 'relative -2:' + cast(@rn as varchar) + '. ID: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' Цена: ' + cast(@nt as varchar)

fetch last from cur into @rn, @id, @sub, @nt
print 'Last:		' + cast(@rn as varchar) + '. ID: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' Цена: ' + cast(@nt as varchar)

close cur

--5
declare cur cursor local dynamic for 
	select ID_детали, Название_детали, Цена from ДЕТАЛИ FOR UPDATE
declare @id varchar(10), @sub varchar(15), @nt int

open cur
fetch cur into @id, @sub, @nt
while @@FETCH_STATUS = 0
begin
	if @nt = 111 update ДЕТАЛИ set Цена = 222 where CURRENT OF cur
	if @id = 25 delete ДЕТАЛИ where CURRENT OF cur

	print 'ID: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' Цена: ' + cast(@nt as varchar)
	fetch cur into @id, @sub, @nt
end
close cur

--6(1)
declare cur cursor local dynamic for 
	select z.Номер_заказа, d.Название_детали, d.Цена from ДЕТАЛИ d 
	join  ЗАКАЗЫ z on d.ID_детали = z.ID_детали
	where d.Цена < 100
		FOR UPDATE
declare @gr varchar(5), @nm varchar(50), @nt int
open cur
fetch cur into @gr, @nm, @nt
while @@FETCH_STATUS = 0
	begin
		print @gr + ': ' + @nm + ' Цена: ' + cast(@nt as varchar)
		delete ЗАКАЗЫ where CURRENT OF cur	
		delete ДЕТАЛИ where CURRENT OF cur
		fetch cur into @gr, @nm, @nt

	end
close cur

--6(2)
declare cur cursor local dynamic for 
	select ID_детали, Название_детали, Цена from ДЕТАЛИ FOR UPDATE
declare @id varchar(10), @sub varchar(15), @nt int

open cur
fetch cur into @id, @sub, @nt
while @@FETCH_STATUS = 0
begin
	if @nt = 111 update ДЕТАЛИ set Цена = Цена + 1 where CURRENT OF cur
	if @id = 25 delete ДЕТАЛИ where CURRENT OF cur

	print 'ID: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' Цена: ' + cast(@nt as varchar)
	fetch cur into @id, @sub, @nt
end
close cur
