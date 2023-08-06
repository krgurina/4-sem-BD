go
	set nocount on
		if  exists (select * from  SYS.OBJECTS        -- ������� A ����?
			        where OBJECT_ID= object_id(N'DBO.A') )	            
		drop table A;           
		declare @c int, @flag char = 'c';           -- commit ��� rollback?
		SET IMPLICIT_TRANSACTIONS  ON   -- �����. ����� ������� ����������
		CREATE table A(K int );                         -- ������ ���������� 
			INSERT A values (1),(2),(3);
			set @c = (select count(*) from A);
			print '���������� ����� � ������� A: ' + cast( @c as varchar(2));
			if @flag = 'c'  commit;                   -- ���������� ����������: �������� 
				  else   rollback;                                 -- ���������� ����������: �����  
		  SET IMPLICIT_TRANSACTIONS  OFF   -- ������. ����� ������� ����������
	
		if  exists (select * from  SYS.OBJECTS       -- ������� A ����?
	            where OBJECT_ID= object_id(N'DBO.A') )
		print '������� A ����';  
		else print '������� A ���'
go

--2
go
	select * into #delail from ������;

	begin try
		begin tran
			if(not exists (select * from tempdb.sys.tables where name like N'#delail%'))
				throw 50000, '������� #delail �� ����������', 1;
			else begin
				if  not exists (select* from #delail s where s.��������_������ = '������1' )
				begin
					insert #delail (ID_������, ��������_������) values(24, '������1');
					--insert #delail (ID_������, ��������_������) values(25, '������2');
				end
				else
					throw 50001, '������������ ������', 1;
				if  not exists (select* from #delail s where s.��������_������ = '������2')
				begin
					insert #delail (ID_������, ��������_������) values(26,'������1');
				end
				else
					throw 50002, '������������ ������', 1;
				
			end
		commit tran
	end try
	begin catch
		print '������: ' + convert(varchar, error_number()) + ':' + error_message();
		if @@TRANCOUNT > 0 rollback tran;
	end catch

	select * from #delail;	
	
	drop table #delail;

	--3
	go
	select * into #delail from ������;
		declare @point varchar(32);

	begin try
		begin tran
			if(not exists (select * from tempdb.sys.tables where name like N'#delail%'))
				throw 50000, '������� #delail �� ����������', 1;
			else begin
				if  not exists (select* from #delail s where s.��������_������ = '������1' )
				begin
					insert #delail (ID_������, ��������_������) values(24, '������1');
					--insert #delail (ID_������, ��������_������) values(25, '������2');
				set @point = 'p1';
					save tran @point;	
				end
				else
					throw 50001, '������������ ������', 1;
				if  not exists (select* from #delail s where s.��������_������ = '������2')
				begin
					insert #delail (ID_������, ��������_������) values(26,'������1');
					set @point = 'p2';
					save tran @point;					
				end
				else
					throw 50002, '������������ ������', 1;
				
			end
		commit tran
	end try
	begin catch
		print '������: ' + convert(varchar, error_number()) + ':' + error_message();
		if @@TRANCOUNT > 0 rollback tran @point;
	end catch

	select * from #delail;	
	
	drop table #delail;

	

	--8 �������� ��������� ����������

	select * into #delail from ������;

	begin tran
		insert #delail (ID_������, ��������_������) values(24, '������1');
		begin tran
			insert #delail (ID_������, ��������_������) values(25, '������2');
			if @@TRANCOUNT>0 Print '������� ����������'
			select * from #delail;
		commit;
	rollback;	
	select * from #delail;

	begin tran
		insert #delail (ID_������, ��������_������) values(29, '������1');
		begin tran
			insert #delail (ID_������, ��������_������) values(30, '������2');
			if @@TRANCOUNT>0 Print '������� ����������'
			select * from #delail;
		rollback;
	commit
		
	select * from #delail;



	drop table #delail;
	