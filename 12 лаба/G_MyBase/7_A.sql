--A--
--���������������� ������
set transaction isolation level SERIALIZABLE 
begin transaction
	select  * from ##delail;
commit;

--��������������� ������

set transaction isolation level SERIALIZABLE
begin transaction
	select * from ##delail where ��������_������ like '%qqqqqq%'
	select * from ##delail where ��������_������ like '%qqqqqq%'
commit;

--��������� ������

set transaction isolation level SERIALIZABLE 
begin transaction
	select * from ##delail where ��������_������ like '%www%'
	select * from ##delail where ��������_������ like '%www%'
commit;
