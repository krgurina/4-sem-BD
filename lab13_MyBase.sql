use G_MyBase
--1
go
create procedure PSUBJECT
as
begin
	declare @k int = (select count(*) from ДЕТАЛИ);
	select ДЕТАЛИ.ID_детали[код], ДЕТАЛИ.Название_детали [Название], ДЕТАЛИ.Цена [цена] from ДЕТАЛИ;
	return @k;
end

declare @k int = 0;
exec @k = PSUBJECT;
print 'Количество строк ' + cast(@k as varchar(3))

--drop procedure PSUBJECT

--2
declare @k int = 0, @r int = 0, @p varchar(20);
exec @k = PSUBJECT @p='ak111' ,@c =@r output;
print 'Количество строк ' + cast(@k as varchar(3))
print 'Количество строк ak111' + cast(@r as varchar(3))

--3 Создать временную локальную таблицу с именем #SUBJECT. Наименование и тип столбцов таблицы должны соответствовать 
--столбцам результирующего набора процедуры PSUBJECT, разработанной в задании 2. 
--Изменить процедуру PSUBJECT таким образом, чтобы она не содержала выходного параметра.
--Применив конструкцию INSERT… EXECUTE с модифицированной процедурой PSUBJECT, добавить строки в таблицу #SUBJECT. 
go
create table #SUBJECT
(
  ID_детали int primary key,
  Название_детали varchar(100),
  Цена int
);

go

ALTER procedure [dbo].[PSUBJECT] @p varchar(20)
as
begin
	declare @k int = (select count(*) from ДЕТАЛИ);
		print 'Параметр: @p=' + @p
	select ID_детали[код], Название_детали [Название], Цена [цена] from ДЕТАЛИ 
	where Название_детали = @p
	return @k;
end
go

insert #SUBJECT exec PSUBJECT @p = 'Двигатель'  
insert #SUBJECT exec PSUBJECT @p = 'Аккумулятор'  

select * from #SUBJECT
drop table #SUBJECT

--4 Разработать процедуру с именем PAUDITORIUM_INSERT. Процедура принимает четыре входных параметра: @a, @n, @c и @t. 
--Параметр @a имеет тип CHAR(20), параметр @n имеет тип VARCHAR(50), параметр @c имеет тип INT и значение по умолчанию 0, параметр @t имеет тип CHAR(10).
--Процедура добавляет строку в таблицу AUDITORIUM. Значения столбцов AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY и AUDITORIUM_TYPE добавляемой строки 
--задаются соответственно параметрами @a, @n, @c и @t.

go
create procedure PAUDITORIUM_INSERT @a int, @n varchar(50), @c int = 0, @t int
as 
begin try
  insert into ДЕТАЛИ(ID_детали, Название_детали, Цена, Код_поставщика)
    values(@a, @n, @c, @t)
  return 1
end try
begin catch
	print 'номер ошибки  : ' + cast(error_number() as varchar(6));
    print 'сообщение     : ' + error_message();
    print 'уровень       : ' + cast(error_severity()  as varchar(6));
    print 'метка         : ' + cast(error_state()   as varchar(8));
    print 'номер строки  : ' + cast(error_line()  as varchar(8));
	if ERROR_PROCEDURE() is not null
	print 'имя процедуры : ' + error_procedure();
    return -1;    
end catch;


declare @rc int;
exec @rc=PAUDITORIUM_INSERT @a=24,@n='Новая деталь',@c=60,@t=111;
print'код ошибки '+cast(@rc as varchar(3));
select * from ДЕТАЛИ


--5 Разработать процедуру с именем SUBJECT_REPORT, формирующую в стандартный выходной поток отчет со списком дисциплин на кон-кретной кафедре. В отчет должны 
--быть выведены краткие названия (поле SUBJECT) из таблицы SUBJECT в одну строку через запятую (использовать встроенную функцию RTRIM). Процедура имеет входной 
--параметр с именем @p типа CHAR(10), кото-рый предназначен для указания кода кафедры.
--В том случае, если по заданному значению @p не-возможно определить код кафедры, процедура должна генерировать ошибку с сообщением ошибка в пара-метрах. 
go
create procedure [SUBJECT REPORT] @p int
as declare @rc int = 0
begin try
	declare @subjectName nvarchar(15) = '', @subjectline nvarchar(150) = '';
	declare Subj CURSOR for
	select Название_детали from ДЕТАЛИ
		where Код_поставщика = @p;
	if not exists(select Название_детали from ДЕТАЛИ where Код_поставщика = @p)
	begin
		raiserror('Нет ни одной детали у этого поставщика', 11, 1)
		return 0
	end
	else
	begin
		open Subj;
		fetch Subj into @subjectName;
		print 'Детали конкретного поставщика';
		while @@FETCH_STATUS = 0
			begin
				set @subjectline = rtrim(@subjectName) + ', ' + @subjectline;
				set @rc = @rc + 1;
				fetch Subj into @subjectName;
			end;
		print @subjectline;
		close Subj;
		deallocate Subj;
		return @rc;
	end;
end try
begin catch
	close Subj;
	deallocate Subj;
	print 'Ошибка в параметрах'
	if ERROR_PROCEDURE() is not null
		print 'Имя процедуры: ' + cast (error_procedure() as varchar(20)); 
		print 'Номер строки: ' + cast(error_line() as varchar(8));
		print 'Сообщение: ' + error_message(); 
		if ERROR_PROCEDURE() is not null
		print 'имя процедуры : ' + error_procedure();
		return @rc;
end catch;
go


declare @rc int;
exec @rc = [SUBJECT REPORT] @p = 111;
print 'количество дисциплин = ' + cast(@rc as varchar(3));

drop procedure [SUBJECT REPORT]
go

--6 Разработать процедуру с именем PAUDITORI-UM_INSERTX. Процедура принимает пять входных параметров: @a, @n, @c, @t и @tn. 
--Параметры @a, @n, @c, @t аналогичны парамет-рам процедуры PAUDITORIUM_INSERT. Параметр @tn является входным, имеет тип VARCHAR(50), предназначен для ввода значения в столбец AUDITO-RIUM_TYPE.AUDITORIUM_TYPENAME.
--Процедура добавляет две строки. Первая строка добавляется в таблицу AUDITORIUM_TYPE. Значе-ния столбцов AUDITORIUM_TYPE и AUDITORI-UM_ TYPENAME задаются соответственно парамет-рами @t и @tn.
--Вторая строка добавляется путем вы-зова процедуры PAUDITORIUM_INSERT.

go
create proc PAUDITORIUM_INSERTX 
@a int, @n varchar(50), @c int = 0, @t int, @tn varchar(70)
as 
begin try
	set transaction isolation level SERIALIZABLE
	begin tran
		insert into ПОСТАВЩИКИ (Код_поставщика, Название)
		values (@t, @tn)
		exec PAUDITORIUM_INSERT @a, @n, @c, @t
	commit tran
end try
begin catch
	print 'номер ошибки :  ' + cast(ERROR_NUMBER() as varchar)
	print 'сообщение : ' + error_message();
    print 'уровень : ' + cast(error_severity()  as varchar(6));
	print 'Номер строки: ' + cast(error_line() as varchar(8));
	if ERROR_PROCEDURE() is not null
	print 'имя процедуры : ' + error_procedure();
	if @@TRANCOUNT > 0 
		rollback tran
	return -1
end catch


exec PAUDITORIUM_INSERTX @a = 30, @n = 'Тест 6 деталь', @c = 507, @t = 444, @tn = 'новый поставщик'
select * from ПОСТАВЩИКИ
drop procedure PAUDITORIUM_INSERTX
drop procedure PAUDITORIUM_INSERT