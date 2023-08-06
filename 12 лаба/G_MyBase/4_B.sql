
-- B
select * into ##delail from ДЕТАЛИ;
--неподтвержденное чтение
---1
set transaction isolation level READ COMMITTED
begin transaction
	     insert #delail (ID_детали, Название_детали) values(24, 'деталь1');
	update ##delail set Название_детали = 'vfnjkvnj' where ID_детали = 24;
	select * from ##delail;
---3
	rollback;
	select * from ##delail;

--неповторяющееся чтение
--2
set transaction isolation level READ COMMITTED
begin transaction
	update ##delail set Название_детали = 'qqqqqq' where ID_детали = 24;
--4
	rollback;

--фантомное чтение
--2
set transaction isolation level READ COMMITTED
begin transaction
	insert #delail (ID_детали, Название_детали) values(25, 'www');

	select * from ##delail;
--4
	rollback;

drop table ##delail;