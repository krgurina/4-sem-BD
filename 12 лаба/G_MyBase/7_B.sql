
select * into ##delail from ������;

--���������������� ������
set transaction isolation level READ COMMITTED
begin transaction
	 insert #delail (ID_������, ��������_������) values(24, '������1');
	update ##delail set ��������_������ = 'vfnjkvnj' where ID_������ = 24;
	select * from ##delail;

rollback;

--��������������� ������
set transaction isolation level READ COMMITTED
begin transaction
	update ##delail set ��������_������ = 'qqqqqq' where ID_������ = 24;
commit;
select * from ##delail;

--��������� ������
set transaction isolation level READ COMMITTED
begin transaction
	insert #delail (ID_������, ��������_������) values(25, 'www');
select * from ##delail;

drop table ##delail;