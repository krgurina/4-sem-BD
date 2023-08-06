--A--
--неподтвержденное чтение
set transaction isolation level READ COMMITTED
begin transaction
	select  * from ##student;
commit;

--неповтор€ющеес€ чтение
--1
set transaction isolation level READ COMMITTED
begin transaction
	select * from ##student where NAME like '%’артанович%'
	select  * from ##student where NAME like '%’артанович%'
commit;

--фантомное чтение
set transaction isolation level READ COMMITTED
begin transaction
	select * from ##student where NAME like '%—илюк%'
	select  * from ##student where NAME like '%—илюк%'
commit;
