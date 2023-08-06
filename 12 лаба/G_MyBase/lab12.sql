go
	set nocount on
		if  exists (select * from  SYS.OBJECTS        -- таблица A есть?
			        where OBJECT_ID= object_id(N'DBO.A') )	            
		drop table A;           
		declare @c int, @flag char = 'c';           -- commit или rollback?
		SET IMPLICIT_TRANSACTIONS  ON   -- включ. режим неявной транзакции
		CREATE table A(K int );                         -- начало транзакции 
			INSERT A values (1),(2),(3);
			set @c = (select count(*) from A);
			print 'количество строк в таблице A: ' + cast( @c as varchar(2));
			if @flag = 'c'  commit;                   -- завершение транзакции: фиксация 
				  else   rollback;                                 -- завершение транзакции: откат  
		  SET IMPLICIT_TRANSACTIONS  OFF   -- выключ. режим неявной транзакции
	
		if  exists (select * from  SYS.OBJECTS       -- таблица A есть?
	            where OBJECT_ID= object_id(N'DBO.A') )
		print 'таблица A есть';  
		else print 'таблицы A нет'
go

--2
go
	select * into #delail from ДЕТАЛИ;

	begin try
		begin tran
			if(not exists (select * from tempdb.sys.tables where name like N'#delail%'))
				throw 50000, 'Таблицы #delail не существует', 1;
			else begin
				if  not exists (select* from #delail s where s.Название_детали = 'деталь1' )
				begin
					insert #delail (ID_детали, Название_детали) values(24, 'деталь1');
					--insert #delail (ID_детали, Название_детали) values(25, 'деталь2');
				end
				else
					throw 50001, 'Дублирование строки', 1;
				if  not exists (select* from #delail s where s.Название_детали = 'деталь2')
				begin
					insert #delail (ID_детали, Название_детали) values(26,'деталь1');
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

	select * from #delail;	
	
	drop table #delail;

	--3
	go
	select * into #delail from ДЕТАЛИ;
		declare @point varchar(32);

	begin try
		begin tran
			if(not exists (select * from tempdb.sys.tables where name like N'#delail%'))
				throw 50000, 'Таблицы #delail не существует', 1;
			else begin
				if  not exists (select* from #delail s where s.Название_детали = 'деталь1' )
				begin
					insert #delail (ID_детали, Название_детали) values(24, 'деталь1');
					--insert #delail (ID_детали, Название_детали) values(25, 'деталь2');
				set @point = 'p1';
					save tran @point;	
				end
				else
					throw 50001, 'Дублирование строки', 1;
				if  not exists (select* from #delail s where s.Название_детали = 'деталь2')
				begin
					insert #delail (ID_детали, Название_детали) values(26,'деталь1');
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

	select * from #delail;	
	
	drop table #delail;

	

	--8 свойства вложенных транзакций

	select * into #delail from ДЕТАЛИ;

	begin tran
		insert #delail (ID_детали, Название_детали) values(24, 'деталь1');
		begin tran
			insert #delail (ID_детали, Название_детали) values(25, 'деталь2');
			if @@TRANCOUNT>0 Print 'внешняя транзакция'
			select * from #delail;
		commit;
	rollback;	
	select * from #delail;

	begin tran
		insert #delail (ID_детали, Название_детали) values(29, 'деталь1');
		begin tran
			insert #delail (ID_детали, Название_детали) values(30, 'деталь2');
			if @@TRANCOUNT>0 Print 'внешняя транзакция'
			select * from #delail;
		rollback;
	commit
		
	select * from #delail;



	drop table #delail;
	