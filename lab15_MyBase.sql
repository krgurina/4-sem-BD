--1
use G_MyBase
create table TR_AUDIT
(
	ID int identity(1, 1),										-- ID
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),		-- DML operator name
	TRNAME varchar(50),											-- trigger name
	CC varchar(300)												-- comment
)

go
create trigger TR_TEACHER_INS on ������ after insert
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print '�������� ������� INSERT'
set @TEACHER = (select ID_������ from INSERTED)
set @TEACHER_NAME = (select ��������_������ from INSERTED)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME
insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @IN)
return;

insert into ������ (ID_������, ��������_������)values (31, '���� �������')
insert into ������ (ID_������, ��������_������)values (32, '���� �������')
select * from TR_AUDIT order by ID

drop trigger TR_TEACHER_INS 

--2
create trigger TR_TEACHER_DEL on ������ after DELETE
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'DELETE'
set @TEACHER = (select ID_������ from deleted)
set @TEACHER_NAME = (select ��������_������ from deleted)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @IN)
return;

delete from ������ where ID_������ = '32'
select * from TR_AUDIT order by ID

drop trigger TR_TEACHER_DEL

--3
create trigger TR_TEACHER_UPD on ������ after update
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'UPDATE'
set @TEACHER = (select ID_������ from INSERTED where ID_������ is not null)
set @TEACHER_NAME = (select ��������_������ from INSERTED where ��������_������ is not null)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME + ' -> '

set @TEACHER = (select ID_������ from deleted where ID_������ is not null)
set @TEACHER_NAME = (select ��������_������ from deleted where ��������_������ is not null)
set @IN = @IN + cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME + ' -> '
insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @IN)

return;
insert into ������ (ID_������, ��������_������)values (31, '���� �������')
update ������ set ��������_������='����� ��������' where ID_������ = 31
select * from TR_AUDIT order by ID

drop trigger TR_TEACHER_UPD

--5
go
	ALTER TABLE ���������� ADD CONSTRAINT ���_����������1 CHECK (���_���������� IN (111, 222,333,444, 555));
	insert into ����������(���_����������)values (31)	
go
--6
create trigger TR_TEACHER_DEL1 on ������ after DELETE
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'DELETE'
set @TEACHER = (select ID_������ from deleted)
set @TEACHER_NAME = (select ��������_������ from deleted)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL1', @IN)
return;
go
create trigger TR_TEACHER_DEL2 on ������ after DELETE
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'DELETE'
set @TEACHER = (select ID_������ from deleted)
set @TEACHER_NAME = (select ��������_������ from deleted)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL2', @IN)
return;
go
create trigger TR_TEACHER_DEL3 on ������ after DELETE
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'DELETE'
set @TEACHER = (select ID_������ from deleted)
set @TEACHER_NAME = (select ��������_������ from deleted)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL3', @IN)
return;


go
exec sp_settriggerorder @triggername  = 'TR_TEACHER_DEL3', @order = 'First', @stmttype = 'DELETE'
exec sp_settriggerorder @triggername  = 'TR_TEACHER_DEL2', @order = 'Last', @stmttype = 'DELETE'

SELECT name  
from sys.triggers t join sys.trigger_events e
on t.object_id = e.object_id
WHERE parent_id = OBJECT_ID('������') 


insert into ������ (ID_������, ��������_������)values (32, '���� �������')
delete from ������ where ID_������ = '32'
select * from TR_AUDIT order by ID

drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3

--7
create trigger TR_TEACHER_ROLLBACK on ������ after delete
as begin
	print '�������� rollback';
	insert into TR_AUDIT(STMT,TRNAME, CC) values('DEL', 'TR_TEACHER_DEL1', '�������� rollback');
	select * from TR_AUDIT
	rollback;
return;
end

insert into ������ (ID_������, ��������_������)values (32, '���� �������')
delete from ������ where ID_������ = '32'

go
drop trigger TR_TEACHER_ROLLBACK
 --8
 create trigger TR_TEACHER_INSTEAD_OF on ������ instead of delete
as begin
	raiserror('�������� ���������', 10,1);
	insert into TR_AUDIT(STMT,TRNAME, CC) values('DEL', 'TR_TEACHER_INSTEAD_OF', '�������� ���������');
	select * from TR_AUDIT
return
end

insert into ������ (ID_������, ��������_������)values (33, '���� �������')
delete from ������ where ID_������ = '33'
drop trigger TR_TEACHER_INSTEAD_OF

