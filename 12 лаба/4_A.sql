--A--
--���������������� ������

set transaction isolation level READ UNCOMMITTED
begin transaction
	select  * from ##student;
commit;

--��������������� ������
--1
set transaction isolation level READ UNCOMMITTED
begin transaction
	select * from ##student where NAME like '%����������%'
	select * from ##student where NAME like '%����������%'
commit;


--��������� ������
--1
set transaction isolation level READ UNCOMMITTED
begin transaction
	select * from ##student where NAME like '%�����%'
	select * from ##student where NAME like '%�����%'
commit;
