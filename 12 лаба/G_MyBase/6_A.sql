--A--
--���������������� ������
set transaction isolation level REPEATABLE READ 
begin transaction
	select  * from ##delail;
commit;

--��������������� ������
set transaction isolation level REPEATABLE READ 
begin transaction
	select * from ##delail where ��������_������ like '%qqqqqq%'
	select * from ##delail where ��������_������ like '%qqqqqq%'
commit;

--��������� ������
set transaction isolation level REPEATABLE READ 
begin transaction
	select * from ##delail where ��������_������ like '%www%'
	select * from ##delail where ��������_������ like '%www%'
commit;

