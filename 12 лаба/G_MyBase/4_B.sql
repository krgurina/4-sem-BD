
-- B
select * into ##delail from ������;
--���������������� ������
---1
set transaction isolation level READ COMMITTED
begin transaction
	     insert #delail (ID_������, ��������_������) values(24, '������1');
	update ##delail set ��������_������ = 'vfnjkvnj' where ID_������ = 24;
	select * from ##delail;
---3
	rollback;
	select * from ##delail;

--��������������� ������
--2
set transaction isolation level READ COMMITTED
begin transaction
	update ##delail set ��������_������ = 'qqqqqq' where ID_������ = 24;
--4
	rollback;

--��������� ������
--2
set transaction isolation level READ COMMITTED
begin transaction
	insert #delail (ID_������, ��������_������) values(25, 'www');

	select * from ##delail;
--4
	rollback;

drop table ##delail;