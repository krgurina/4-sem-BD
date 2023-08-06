--A--
--неподтвержденное чтение
set transaction isolation level REPEATABLE READ 
begin transaction
	select  * from ##student;
commit;

--неповтор€ющеес€ чтение
set transaction isolation level REPEATABLE READ 
begin transaction
	select * from ##student where NAME like '%’артанович%'
	select  * from ##student where NAME like '%’артанович%'
commit;

--фантомное чтение
set transaction isolation level REPEATABLE READ 
begin transaction
	select * from ##student where NAME like '%—илюк%'
	select  * from ##student where NAME like '%—илюк%'
commit;

