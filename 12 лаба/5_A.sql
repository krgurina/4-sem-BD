--A--
--���������������� ������
set transaction isolation level READ COMMITTED
begin transaction
	select  * from ##student;
commit;

--��������������� ������
--1
set transaction isolation level READ COMMITTED
begin transaction
	select * from ##student where NAME like '%����������%'
	select  * from ##student where NAME like '%����������%'
commit;

--��������� ������
set transaction isolation level READ COMMITTED
begin transaction
	select * from ##student where NAME like '%�����%'
	select  * from ##student where NAME like '%�����%'
commit;
