
	select * into ##student from UNIVER.dbo.STUDENT;

--���������������� ������
set transaction isolation level READ COMMITTED
begin transaction
	insert ##student (IDGROUP, NAME, BDAY) values(4,'������ �������� ���������', '2003-09-28');
	update ##student set IDGROUP = 99 where IDGROUP = 4;
	select * from ##student;

rollback;

--��������������� ������
set transaction isolation level READ COMMITTED
begin transaction
	update ##student set IDGROUP = 99 where NAME like '%����������%';
	select * from ##student;
commit;
select * from ##student;

--��������� ������
set transaction isolation level READ COMMITTED
begin transaction
	insert ##student (NAME) values('�����');
commit;
select * from ##student;

drop table ##student;