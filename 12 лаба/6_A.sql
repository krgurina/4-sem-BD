--A--
--���������������� ������
set transaction isolation level REPEATABLE READ 
begin transaction
	select  * from ##student;
commit;

--��������������� ������
set transaction isolation level REPEATABLE READ 
begin transaction
	select * from ##student where NAME like '%����������%'
	select  * from ##student where NAME like '%����������%'
commit;

--��������� ������
set transaction isolation level REPEATABLE READ 
begin transaction
	select * from ##student where NAME like '%�����%'
	select  * from ##student where NAME like '%�����%'
commit;

