--A
use UNIVER
select * into #student from STUDENT where IDGROUP=1;
select @@SPID, * from #student

set transaction isolation level READ UNCOMMITTED
begin transaction
	insert #student (IDGROUP, NAME, BDAY) values(4,'������ �������� ���������', '2003-09-28');
	insert #student (IDGROUP, NAME, BDAY) values(6,'������� ���� ����������', '2003-09-23');	
	select @@SPID, * from #student
commit transaction

--B
begin transaction
	update  #student set IDGROUP= 1 where IDGROUP= 4
	 	select @@SPID, * from #student

 rollback transaction;
 	select * from #student

-- ���������������� ������
--A
set transaction isolation level READ UNCOMMITTED
begin transaction
	update  #student set IDGROUP = 4 where IDGROUP= 1
	select * from #student

--B
	begin transaction
	update  #student set IDGROUP= 6 where IDGROUP= 4
	 	select * from #student
	rollback transaction;
-- ���������������
set transaction isolation level READ UNCOMMITTED
begin transaction
	select * from #student
	insert #student (IDGROUP, NAME, BDAY) values(4,'������ �������� ���������', '2003-09-28');
	commit transaction
--B
	begin transaction
	 	select * from #student
		select * from #student
	--rollback transaction;

-- ��������� ������
set transaction isolation level READ UNCOMMITTED
begin transaction
	insert #student (IDGROUP, NAME, BDAY) values(4,'������ �������� ���������', '2003-09-28');
--B
	begin transaction
	 	select * from #student
		select * from #student
	--rollback transaction;


drop table #student
