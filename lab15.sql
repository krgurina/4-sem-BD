--1
--AFTER-триггер с именем TR_TEACHER_INS для таблицы TEACHER, реагирующий на событие INSERT.
create table TR_AUDIT
(
	ID int identity(1, 1),										-- ID
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),		-- DML operator name
	TRNAME varchar(50),											-- trigger name
	CC varchar(300)												-- comment
)
drop table TR_AUDIT

create trigger TR_TEACHER_INS on TEACHER after insert
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'Операция вставки INSERT'
set @TEACHER = (select TEACHER from INSERTED)
set @TEACHER_NAME = (select TEACHER_NAME from INSERTED)
set @GENDER = (select GENDER from INSERTED)
set @PULPIT = (select PULPIT from INSERTED)
set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
		  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))
insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @IN)
return;
--------------------------------------------------
insert into TEACHER values ('ГКС', 'Гурина Кристина Сергеевна', 'ж', 'ИСиТ')
insert into TEACHER values ('ВКС', 'Вилкина Катя Сергеевна', 'ж', 'ИСиТ')
select * from TR_AUDIT order by ID

drop trigger TR_TEACHER_INS 
--2
-- Создать AFTER-триггер с именем TR_TEACHER_DEL для таблицы TEA-CHER, реагирующий на событие DELETE
create trigger TR_TEACHER_DEL on TEACHER after DELETE
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'DELETE'
set @TEACHER = (select TEACHER from deleted)
set @TEACHER_NAME = (select TEACHER_NAME from deleted)
set @GENDER = (select GENDER from deleted)
set @PULPIT = (select PULPIT from deleted)
set @IN = @TEACHER + ' ' + @TEACHER_NAME + 
		  ' ' + @GENDER + ' ' + @PULPIT
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @IN)
return;
---------------------------------------------
insert into TEACHER values ('ГКС', 'Гурина Кристина Сергеевна', 'ж', 'ИСиТ')
delete from TEACHER where TEACHER = 'ГКС'
select * from TR_AUDIT order by ID

drop trigger TR_TEACHER_DEL

--3
-- Создать AFTER-триггер с именем TR_TEACHER_UPD для таблицы TEA-CHER, реагирующий на событие UPDATE
drop trigger TR_TEACHER_UPD

create trigger TR_TEACHER_UPD on TEACHER after update
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print'UPDATE'
set @TEACHER = (select TEACHER from DELETED where TEACHER is not null)
	set @TEACHER_NAME = (select TEACHER_NAME from DELETED where TEACHER_NAME is not null)
	set @GENDER = (select GENDER from DELETED where GENDER is not null)
	set @PULPIT = (select PULPIT from DELETED where PULPIT is not null)
	set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT)) + ' -> '

	set @TEACHER = (select TEACHER from INSERTED where TEACHER is not null)
	set @TEACHER_NAME = (select TEACHER_NAME from INSERTED where TEACHER_NAME is not null)
	set @GENDER = (select GENDER from INSERTED where GENDER is not null)
	set @PULPIT = (select PULPIT from INSERTED where PULPIT is not null)
	set @IN = @IN + ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))

insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @IN)
return;
--------------------------------------------------
update TEACHER set TEACHER.GENDER='ж' where TEACHER = 'ВКС'
select * from TR_AUDIT order by ID

--4
-- Создать AFTER-триггер с именем TR_TEACHER для таблицы TEACHER, реагирующий на события INSERT, DELETE, UPDATE. 
create trigger TR_TEACHER  on TEACHER after INSERT, DELETE, UPDATE  
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)

if (select count(*) from INSERTED) > 0 and (select count(*) from DELETED) > 0
begin
	print 'операция UPDATE'
	set @TEACHER = (select TEACHER from DELETED where TEACHER is not null)
	set @TEACHER_NAME = (select TEACHER_NAME from DELETED where TEACHER_NAME is not null)
	set @GENDER = (select GENDER from DELETED where GENDER is not null)
	set @PULPIT = (select PULPIT from DELETED where PULPIT is not null)
	set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT)) + ' -> '

	set @TEACHER = (select TEACHER from INSERTED where TEACHER is not null)
	set @TEACHER_NAME = (select TEACHER_NAME from INSERTED where TEACHER_NAME is not null)
	set @GENDER = (select GENDER from INSERTED where GENDER is not null)
	set @PULPIT = (select PULPIT from INSERTED where PULPIT is not null)
	set @IN = @IN + ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))

	insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER', @IN)
end

if (select count(*) from INSERTED) > 0 and (select count(*) from DELETED) = 0
begin
	print 'операция INSERT'
	set @TEACHER = (select TEACHER from INSERTED)
	set @TEACHER_NAME = (select TEACHER_NAME from INSERTED)
	set @GENDER = (select GENDER from INSERTED)
	set @PULPIT = (select PULPIT from INSERTED)
	set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER', @IN)
end

if (select count(*) from INSERTED) = 0 and (select count(*) from DELETED) > 0
begin
	print 'операция DELETE'
	set @TEACHER = (select TEACHER from DELETED)
	set @TEACHER_NAME = (select TEACHER_NAME from DELETED)
	set @GENDER = (select GENDER from DELETED)
	set @PULPIT = (select PULPIT from DELETED)
	set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER', @IN)
end
return;
---------------------------------------
insert into TEACHER values ('ГКС', 'Гурина Кристина Сергеевна', 'ж', 'ИСиТ')
update TEACHER set TEACHER_NAME = 'Гурина Марина Сергеевна' where TEACHER = 'ГКС'
delete from TEACHER where TEACHER = 'ГКС'

select * from TR_AUDIT order by ID

drop trigger TR_TEACHER
--5
-- проверка ограничения целостности
go
	ALTER TABLE TEACHER ADD CONSTRAINT GENDER CHECK (GENDER IN ('м', 'ж'));
	insert into TEACHER(TEACHER,TEACHER_NAME, GENDER, PULPIT) values('ИИИ','Иванов Иван Иванович', 'с','ИСиТ')
	select * from TR_AUDIT order by ID

go
--6
-- Упорядочить выполнение триггеров для таблицы TEACHER, реагирующих на событие DELETE следующим образом: 
--первым должен выполняться триггер с именем TR_TEA-CHER_DEL3, последним – триггер TR_TEACHER_DEL2. 

go
create trigger TR_TEACHER_DEL1 on TEACHER after delete
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'Операция удаления del1';
	set @TEACHER = (select TEACHER from deleted)
	set @TEACHER_NAME = (select TEACHER_NAME from deleted)
	set @GENDER = (select GENDER from deleted)
	set @PULPIT = (select PULPIT from deleted)
	set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL1', @IN)
select * from TR_AUDIT
return;
go
create trigger TR_TEACHER_DEL2 on TEACHER after delete
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)print 'Операция удаления del2';
	set @TEACHER = (select TEACHER from deleted)
	set @TEACHER_NAME = (select TEACHER_NAME from deleted)
	set @GENDER = (select GENDER from deleted)
	set @PULPIT = (select PULPIT from deleted)
	set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))
insert into TR_AUDIT(STMT,TRNAME, CC) values('DEL', 'TR_TEACHER_DEL2', @IN);
select * from TR_AUDIT
return;
go
create trigger TR_TEACHER_DEL3 on TEACHER after delete
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)print 'Операция удаления del3';
	set @TEACHER = (select TEACHER from deleted)
	set @TEACHER_NAME = (select TEACHER_NAME from deleted)
	set @GENDER = (select GENDER from deleted)
	set @PULPIT = (select PULPIT from deleted)
	set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))
insert into TR_AUDIT(STMT,TRNAME, CC) values('DEL', 'TR_TEACHER_DEL3', @IN);
select * from TR_AUDIT
return;
---------------------------------------------------
insert into TEACHER(TEACHER,TEACHER_NAME, GENDER, PULPIT) values('ИИП','Иванов Иван Павлович', 'м','ИСиТ')
delete from TEACHER  where TEACHER_NAME like 'Иванов Иван Павлович';
---------------------------------------------------
go
exec sp_settriggerorder @triggername  = 'TR_TEACHER_DEL3', @order = 'First', @stmttype = 'DELETE'
exec sp_settriggerorder @triggername  = 'TR_TEACHER_DEL2', @order = 'Last', @stmttype = 'DELETE'

--Проверить порядок выполнения триггеров можно следующим запросом
SELECT name  
from sys.triggers t join sys.trigger_events e
on t.object_id = e.object_id
WHERE parent_id = OBJECT_ID('TEACHER') 

drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3

-- 7
-- AFTER-триггер является частью транзакции, в рамках которого выполняется оператор, активизировавший триггер.
go
create trigger TR_TEACHER_ROLLBACK on TEACHER after delete
as begin
	print 'Операция rollback';
	insert into TR_AUDIT(STMT,TRNAME, CC) values('DEL', 'TR_TEACHER_DEL1', 'Операция rollback');
	select * from TR_AUDIT
	rollback;
return;
end

insert into TEACHER(TEACHER,TEACHER_NAME, GENDER, PULPIT) values('ИИП','Иванов Иван Павлович', 'м','ИСиТ')
delete from TEACHER  where TEACHER_NAME like 'Иванов Иван Павлович';

go
drop trigger TR_TEACHER_ROLLBACK

-- 8
-- INSTEAD OF-триггер, запрещающий удаление строк в таблице. 
create trigger TR_TEACHER_INSTEAD_OF on TEACHER instead of delete
as begin
	raiserror('Удаление запрещено', 10,1);
	insert into TR_AUDIT(STMT,TRNAME, CC) values('DEL', 'TR_TEACHER_INSTEAD_OF', 'Удаление запрещено');
	select * from TR_AUDIT
return
end

insert into TEACHER(TEACHER,TEACHER_NAME, GENDER, PULPIT) values('ИИП','Иванов Иван Павлович', 'м','ИСиТ')
delete from TEACHER  where TEACHER_NAME like 'Иванов Иван Павлович';
drop trigger TR_TEACHER_INSTEAD_OF
go  

-- 9
-- Создать DDL-триггер, реагирующий на все DDL-события в БД UNIVER. 
create trigger DDL_UNIVER on database for DDL_DATABASE_LEVEL_EVENTS  
as  
	declare @t varchar(50)= EVENTDATA().value ('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
	declare @t1 varchar(50)=EVENTDATA().value ('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
	declare @t2 varchar(50)=EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'); 
	if @t2 = 'TABLE' 
begin
	print 'Тип события: '+@t;
	print 'Имя объекта: '+@t1;
	print 'Тип объекта: '+@t2;
	raiserror( N'операции с таблицами запрещены', 16, 1);  
	rollback;    
end;
create table a(c int);
go

DISABLE TRIGGER DDL_UNIVER ON DATABASE;
DROP TRIGGER DDL_UNIVER ON DATABASE;