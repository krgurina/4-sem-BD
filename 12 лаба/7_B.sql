
	select * into ##student from UNIVER.dbo.STUDENT;

--неподтвержденное чтение
set transaction isolation level READ COMMITTED
begin transaction
	insert ##student (IDGROUP, NAME, BDAY) values(4,'Гурина Кристина Сергеевна', '2003-09-28');
	update ##student set IDGROUP = 99 where IDGROUP = 4;
	select * from ##student;

rollback;

--неповторяющееся чтение
set transaction isolation level READ COMMITTED
begin transaction
	update ##student set IDGROUP = 99 where NAME like '%Хартанович%';
	select * from ##student;
commit;
select * from ##student;

--фантомное чтение
set transaction isolation level READ COMMITTED
begin transaction
	insert ##student (NAME) values('Силюк');
commit;
select * from ##student;

drop table ##student;