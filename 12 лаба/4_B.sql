
-- B
select * into ##student from STUDENT;
--���������������� ������
---1
set transaction isolation level READ COMMITTED
begin transaction
	insert ##student (IDGROUP, NAME, BDAY) values(4,'������ �������� ���������', '2003-09-28');
	update ##student set IDGROUP = 99 where IDGROUP = 4;
	select * from ##student;
---3
	rollback;
	select * from ##student;

--��������������� ������
--2
set transaction isolation level READ COMMITTED
begin transaction
	update ##student set IDGROUP = 99 where NAME like '%����������%';
--4
	rollback;

--��������� ������
--2
set transaction isolation level READ COMMITTED
begin transaction
	insert ##student (NAME) values('�����');
	select * from ##student;
--4
	rollback;

drop table ##student;