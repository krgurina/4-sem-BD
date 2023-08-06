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
create trigger TR_TEACHER_INS on ДЕТАЛИ after insert
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'Операция вставки INSERT'
set @TEACHER = (select ID_Детали from INSERTED)
set @TEACHER_NAME = (select Название_детали from INSERTED)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME
insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @IN)
return;

insert into ДЕТАЛИ (ID_детали, Название_детали)values (31, 'тест триггер')
insert into ДЕТАЛИ (ID_детали, Название_детали)values (32, 'тест триггер')
select * from TR_AUDIT order by ID

drop trigger TR_TEACHER_INS 

--2
create trigger TR_TEACHER_DEL on ДЕТАЛИ after DELETE
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'DELETE'
set @TEACHER = (select ID_Детали from deleted)
set @TEACHER_NAME = (select Название_детали from deleted)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @IN)
return;

delete from ДЕТАЛИ where ID_детали = '32'
select * from TR_AUDIT order by ID

drop trigger TR_TEACHER_DEL

--3
create trigger TR_TEACHER_UPD on ДЕТАЛИ after update
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'UPDATE'
set @TEACHER = (select ID_Детали from INSERTED where ID_детали is not null)
set @TEACHER_NAME = (select Название_детали from INSERTED where Название_детали is not null)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME + ' -> '

set @TEACHER = (select ID_Детали from deleted where ID_детали is not null)
set @TEACHER_NAME = (select Название_детали from deleted where Название_детали is not null)
set @IN = @IN + cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME + ' -> '
insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @IN)

return;
insert into ДЕТАЛИ (ID_детали, Название_детали)values (31, 'тест триггер')
update ДЕТАЛИ set Название_детали='новое название' where ID_детали = 31
select * from TR_AUDIT order by ID

drop trigger TR_TEACHER_UPD

--5
go
	ALTER TABLE ПОСТАВЩИКИ ADD CONSTRAINT Код_поставщика1 CHECK (Код_поставщика IN (111, 222,333,444, 555));
	insert into ПОСТАВЩИКИ(Код_поставщика)values (31)	
go
--6
create trigger TR_TEACHER_DEL1 on ДЕТАЛИ after DELETE
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'DELETE'
set @TEACHER = (select ID_Детали from deleted)
set @TEACHER_NAME = (select Название_детали from deleted)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL1', @IN)
return;
go
create trigger TR_TEACHER_DEL2 on ДЕТАЛИ after DELETE
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'DELETE'
set @TEACHER = (select ID_Детали from deleted)
set @TEACHER_NAME = (select Название_детали from deleted)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL2', @IN)
return;
go
create trigger TR_TEACHER_DEL3 on ДЕТАЛИ after DELETE
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'DELETE'
set @TEACHER = (select ID_Детали from deleted)
set @TEACHER_NAME = (select Название_детали from deleted)
set @IN = cast(@TEACHER as varchar(5))+ ' ' +  @TEACHER_NAME
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL3', @IN)
return;


go
exec sp_settriggerorder @triggername  = 'TR_TEACHER_DEL3', @order = 'First', @stmttype = 'DELETE'
exec sp_settriggerorder @triggername  = 'TR_TEACHER_DEL2', @order = 'Last', @stmttype = 'DELETE'

SELECT name  
from sys.triggers t join sys.trigger_events e
on t.object_id = e.object_id
WHERE parent_id = OBJECT_ID('ДЕТАЛИ') 


insert into ДЕТАЛИ (ID_детали, Название_детали)values (32, 'тест триггер')
delete from ДЕТАЛИ where ID_детали = '32'
select * from TR_AUDIT order by ID

drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3

--7
create trigger TR_TEACHER_ROLLBACK on ДЕТАЛИ after delete
as begin
	print 'Операция rollback';
	insert into TR_AUDIT(STMT,TRNAME, CC) values('DEL', 'TR_TEACHER_DEL1', 'Операция rollback');
	select * from TR_AUDIT
	rollback;
return;
end

insert into ДЕТАЛИ (ID_детали, Название_детали)values (32, 'тест триггер')
delete from ДЕТАЛИ where ID_детали = '32'

go
drop trigger TR_TEACHER_ROLLBACK
 --8
 create trigger TR_TEACHER_INSTEAD_OF on ДЕТАЛИ instead of delete
as begin
	raiserror('Удаление запрещено', 10,1);
	insert into TR_AUDIT(STMT,TRNAME, CC) values('DEL', 'TR_TEACHER_INSTEAD_OF', 'Удаление запрещено');
	select * from TR_AUDIT
return
end

insert into ДЕТАЛИ (ID_детали, Название_детали)values (33, 'тест триггер')
delete from ДЕТАЛИ where ID_детали = '33'
drop trigger TR_TEACHER_INSTEAD_OF

