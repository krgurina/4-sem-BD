
-- B
select * into ##student from STUDENT;
--неподтвержденное чтение
---1
set transaction isolation level READ COMMITTED
begin transaction
	insert ##student (IDGROUP, NAME, BDAY) values(4,'Гурина Кристина Сергеевна', '2003-09-28');
	update ##student set IDGROUP = 99 where IDGROUP = 4;
	select * from ##student;
---3
	rollback;
	select * from ##student;

--неповторяющееся чтение
--2
set transaction isolation level READ COMMITTED
begin transaction
	update ##student set IDGROUP = 99 where NAME like '%Хартанович%';
--4
	rollback;

--фантомное чтение
--2
set transaction isolation level READ COMMITTED
begin transaction
	insert ##student (NAME) values('Силюк');
	select * from ##student;
--4
	rollback;

drop table ##student;