	select * into ##student from UNIVER.dbo.STUDENT;
--B
--���������������� ������
set transaction isolation level READ COMMITTED
begin transaction
	insert ##student (IDGROUP, NAME, BDAY) values(4,'������ �������� ���������', '2003-09-28');
	update ##student set IDGROUP = 99 where IDGROUP = 4;
	select * from ##student;
----
	rollback;
select * from ##student;

--��������������� ������
set transaction isolation level READ COMMITTED
	begin transaction
		update ##student set IDGROUP = 99 where NAME like '%����������%';
		select * from ##student;
	commit;

--��������� ������
	set transaction isolation level READ COMMITTED
	begin transaction
		insert ##student (NAME) values('�����');
		select * from ##student;
	commit;

	drop table ##student;