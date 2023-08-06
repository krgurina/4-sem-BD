--A--
--неподтвержденное чтение
set transaction isolation level SERIALIZABLE 
begin transaction
	select  * from ##delail;
commit;

--неповторяющееся чтение

set transaction isolation level SERIALIZABLE
begin transaction
	select * from ##delail where Название_детали like '%qqqqqq%'
	select * from ##delail where Название_детали like '%qqqqqq%'
commit;

--фантомное чтение

set transaction isolation level SERIALIZABLE 
begin transaction
	select * from ##delail where Название_детали like '%www%'
	select * from ##delail where Название_детали like '%www%'
commit;
