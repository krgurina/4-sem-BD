use Univer
select * into #student from STUDENT where IDGROUP=1;

--A
set transaction isolation level READ COMMITTED
begin transaction
	select count(*) from  #student

	

--B
begin transaction
insert #student (IDGROUP, NAME, BDAY) values(4,'Гурина Кристина Сергеевна', '2003-09-28');
	select * from #student
	--update  #student set IDGROUP= 1 where IDGROUP= 4
	--	select * from #student


--rollback transaction

	select count(*) from  #student


commit transaction

drop table #student


	--select count(*) from  #student

