--A--
--���������������� ������
set transaction isolation level READ COMMITTED
begin transaction
	select * from ##delail
commit;

--��������������� ������
--1
set transaction isolation level READ COMMITTED
begin transaction
		select * from ##delail where ��������_������ like '%qqqqqq%'
	select * from ##delail where ��������_������ like '%qqqqqq%'
commit;

--��������� ������
set transaction isolation level READ COMMITTED
begin transaction
	select * from ##delail where ��������_������ like '%www%'
	select * from ##delail where ��������_������ like '%www%'
commit;
