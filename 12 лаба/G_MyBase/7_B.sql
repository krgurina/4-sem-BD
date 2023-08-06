
select * into ##delail from ДЕТАЛИ;

--неподтвержденное чтение
set transaction isolation level READ COMMITTED
begin transaction
	 insert #delail (ID_детали, Название_детали) values(24, 'деталь1');
	update ##delail set Название_детали = 'vfnjkvnj' where ID_детали = 24;
	select * from ##delail;

rollback;

--неповторяющееся чтение
set transaction isolation level READ COMMITTED
begin transaction
	update ##delail set Название_детали = 'qqqqqq' where ID_детали = 24;
commit;
select * from ##delail;

--фантомное чтение
set transaction isolation level READ COMMITTED
begin transaction
	insert #delail (ID_детали, Название_детали) values(25, 'www');
select * from ##delail;

drop table ##delail;