--A--
--неподтвержденное чтение

set transaction isolation level READ UNCOMMITTED
begin transaction
	select  * from ##delail;
commit;

--неповторяющееся чтение
--1
set transaction isolation level READ UNCOMMITTED
begin transaction
	select * from ##delail where Название_детали like '%qqqqqq%'
	select * from ##delail where Название_детали like '%qqqqqq%'
commit;


--фантомное чтение
--1
set transaction isolation level READ UNCOMMITTED
begin transaction
	select * from ##delail where Название_детали like '%www%'
	select * from ##delail where Название_детали like '%www%'
commit;
