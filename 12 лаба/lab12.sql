go
	set nocount on
		if  exists (select * from  SYS.OBJECTS        
			        where OBJECT_ID= object_id(N'DBO.A') )	            
		drop table A;           
		declare @c int, @flag char = 'r';           
		SET IMPLICIT_TRANSACTIONS  ON   -- включ. режим неявной транзакции
		CREATE table A(K int );                          
			INSERT A values (1),(2),(3);
			set @c = (select count(*) from A);
			print 'количество строк в таблице A: ' + cast( @c as varchar(2));
			if @flag = 'c'  commit;                   -- завершение транзакции: фиксация 
				  else   rollback;                                 
		  SET IMPLICIT_TRANSACTIONS  OFF   
	
		if  exists (select * from  SYS.OBJECTS       
	            where OBJECT_ID= object_id(N'DBO.A') )
		print 'таблица A есть';  
		else print 'таблицы A нет'
go

--2
go
	select * into #student from STUDENT;

	begin try
		begin tran
			if(not exists (select * from tempdb.sys.tables where name like N'#student%'))
				throw 50000, 'Таблицы #student не существует', 1;
			else begin
				if  not exists (select* from #student s where s.NAME = 'Гурина Кристина Сергеевна' )
				begin
					insert #student (IDGROUP, NAME, BDAY) values(4,'Гурина Кристина Сергеевна', '2003-09-28');
					insert #student (IDGROUP, NAME, BDAY) values(6,'Авдеева Вера Дмитриевна', '2003-09-23');	-- для ошибки
				end
				else
					throw 50001, 'Дублирование строки', 1;
				if  not exists (select* from #student s where s.NAME = 'Авдеева Вера Дмитриевна' )
				begin
					insert #student (IDGROUP, NAME, BDAY) values(6,'Авдеева Вера Дмитриевна', '2003-09-23');
				end
				else
					throw 50002, 'Дублирование строки', 1;
				
			end
		commit tran
	end try
	begin catch
		print 'Ошибка: ' + convert(varchar, error_number()) + ':' + error_message();
		if @@TRANCOUNT > 0 rollback tran;
	end catch

	select * from #student;	
	
	drop table #student;

	--3
	go
	select * into #student from STUDENT;
	declare @point varchar(32);

	begin try
		begin tran
			if(not exists (select * from tempdb.sys.tables where name like N'#student%'))
				throw 50000, 'Таблицы #student не существует', 1;
			else begin
				if  not exists (select* from #student s where s.NAME = 'Гурина Кристина Сергеевна' )
				begin
					insert #student (IDGROUP, NAME, BDAY) values(4,'Гурина Кристина Сергеевна', '2003-09-28');
					insert #student (IDGROUP, NAME, BDAY) values(6,'Авдеева Вера Дмитриевна', '2003-09-23');	-- для ошибки
					set @point = 'p1';
					save tran @point;				
				end
				else
					throw 50001, 'Дублирование строки', 1;
				if  not exists (select* from #student s where s.NAME = 'Авдеева Вера Дмитриевна' )
				begin
					insert #student (IDGROUP, NAME, BDAY) values(6,'Авдеева Вера Дмитриевна', '2003-09-23');
					insert #student (IDGROUP, NAME, BDAY) values(6,'Коктыш Евгения Сергеевна', '2003-12-26');
					set @point = 'p2';
					save tran @point;
				end
				else
					throw 50002, 'Дублирование строки', 1;
				
			end
		commit tran
	end try
	begin catch
		print 'Ошибка: ' + convert(varchar, error_number()) + ':' + error_message();
		if @@TRANCOUNT > 0 rollback tran @point;
	end catch

	select * from #student;	
	
	drop table #student;


	--8 свойства вложенных транзакций

	select * into #student from STUDENT where IDGROUP=1;

	begin tran
		insert #student (NAME) values ('AAA');
		begin tran
			insert #student (NAME) values ('BBB');
			if @@TRANCOUNT>0 Print 'внешняя транзакция'
			select * from #student;
		commit;
	rollback;	
	select * from #student;

	begin tran
		insert #student (NAME) values ('AAA');
		begin tran
			insert #student (NAME) values ('BBB');
			if @@TRANCOUNT>0 Print 'внешняя транзакция'
			select * from #student;
		rollback;
	commit
		
	select * from #student;



	drop table #student;
	