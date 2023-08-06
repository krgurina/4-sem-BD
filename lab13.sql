use UNIVER
--1
go
create procedure PSUBJECT
as
begin
	declare @k int = (select count(*) from SUBJECT);
	select SUBJECT[код], SUBJECT_NAME[дисциплина], PULPIT[кафедра] from SUBJECT;
	return @k;
end

declare @k int = 0;
exec @k = PSUBJECT;
print 'Количество строк ' + cast(@k as varchar(3))

--drop procedure PSUBJECT

--2
declare @k int = 0, @r int = 0, @p varchar(20);
exec @k = PSUBJECT @p='ИСиТ' ,@c =@r output;
print 'Количество строк ' + cast(@k as varchar(3))
print 'Количество строк ИСиТ' + cast(@r as varchar(3))

--3 Создать временную локальную таблицу с именем #SUBJECT. Наименование и тип столбцов таблицы должны соответствовать 
--столбцам результирующего набора процедуры PSUBJECT, разработанной в задании 2. 
--Изменить процедуру PSUBJECT таким образом, чтобы она не содержала выходного параметра.
--Применив конструкцию INSERT… EXECUTE с модифицированной процедурой PSUBJECT, добавить строки в таблицу #SUBJECT. 
go
create table #SUBJECT
(
  SUBJECT char(10) primary key,
  SUBJECT_NAME varchar(100),
  PULPIT char(20)
);

go

ALTER procedure [dbo].[PSUBJECT] @p varchar(20)
as
begin
	declare @k int = (select count(*) from SUBJECT);
		print 'Параметр: @p=' + @p
		select SUBJECT[код], SUBJECT_NAME[дисциплина], PULPIT[кафедра] from SUBJECT where PULPIT=@p;
	return @k;
end
go

insert #SUBJECT exec PSUBJECT @p = 'ИСиТ'  
insert #SUBJECT exec PSUBJECT @p = 'ОХ'  

select * from #SUBJECT
drop table #SUBJECT

--4 Разработать процедуру с именем PAUDITORIUM_INSERT. Процедура принимает четыре входных параметра: @a, @n, @c и @t. 
--Параметр @a имеет тип CHAR(20), параметр @n имеет тип VARCHAR(50), параметр @c имеет тип INT и значение по умолчанию 0, параметр @t имеет тип CHAR(10).
--Процедура добавляет строку в таблицу AUDITORIUM. Значения столбцов AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY и AUDITORIUM_TYPE добавляемой строки 
--задаются соответственно параметрами @a, @n, @c и @t.

go
create procedure PAUDITORIUM_INSERT @a char(20), @n varchar(50), @c int = 0, @t char(10)
as 
begin try
  insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
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
exec @rc=PAUDITORIUM_INSERT @a='227-4',@n='227-3',@c=60,@t='ЛК-К';
print'код ошибки '+cast(@rc as varchar(3));


--5 Разработать процедуру с именем SUBJECT_REPORT, формирующую в стандартный выходной поток отчет со списком дисциплин на кон-кретной кафедре. В отчет должны 
--быть выведены краткие названия (поле SUBJECT) из таблицы SUBJECT в одну строку через запятую (использовать встроенную функцию RTRIM). Процедура имеет входной 
--параметр с именем @p типа CHAR(10), кото-рый предназначен для указания кода кафедры.
--В том случае, если по заданному значению @p не-возможно определить код кафедры, процедура должна генерировать ошибку с сообщением ошибка в пара-метрах. 
go
create procedure [SUBJECT REPORT] @p char(10)
as declare @rc int = 0
begin try
	declare @subjectName nvarchar(15) = '', @subjectline nvarchar(150) = '';
	declare Subj CURSOR for
	select SUBJECT from SUBJECT
		where PULPIT = @p;
	if not exists(select SUBJECT from SUBJECT where SUBJECT.PULPIT = @p)
	begin
		raiserror('Нет ни одного предмета на этой кафедре', 11, 1)
		return 0
	end
	else
	begin
		open Subj;
		fetch Subj into @subjectName;
		print 'Дисциплины с конкретной кафедры';
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
exec @rc = [SUBJECT REPORT] @p = 'ИСиТ';
print 'количество дисциплин = ' + cast(@rc as varchar(3));

drop procedure [SUBJECT REPORT]
go

--6 Разработать процедуру с именем PAUDITORI-UM_INSERTX. Процедура принимает пять входных параметров: @a, @n, @c, @t и @tn. 
--Параметры @a, @n, @c, @t аналогичны парамет-рам процедуры PAUDITORIUM_INSERT. Параметр @tn является входным, имеет тип VARCHAR(50), предназначен для ввода значения в столбец AUDITO-RIUM_TYPE.AUDITORIUM_TYPENAME.
--Процедура добавляет две строки. Первая строка добавляется в таблицу AUDITORIUM_TYPE. Значе-ния столбцов AUDITORIUM_TYPE и AUDITORI-UM_ TYPENAME задаются соответственно парамет-рами @t и @tn.
--Вторая строка добавляется путем вы-зова процедуры PAUDITORIUM_INSERT.
use UNIVER
go
create proc PAUDITORIUM_INSERTX 
@a char(20), @n varchar(50), @c int = 0, @t char(10), @tn varchar(70)
as 
begin try
	set transaction isolation level SERIALIZABLE
	begin tran
		insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
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


exec PAUDITORIUM_INSERTX @a = '323-1', @n = '323-1', @c = 50, @t = 'ЛК-Л', @tn = 'typename'

drop procedure PAUDITORIUM_INSERTX
drop procedure PAUDITORIUM_INSERT

--8

drop procedure PRINT_REPORT;
go
create procedure PRINT_REPORT
	@fac char(10) = null, @pul char(10) = null
	as declare @faculty char(50), @pulpit char(10), @subject char(10), @cnt_teacher int;
		declare @temp_fac char(50), @temp_pul char(10), @list varchar(100), 
			@DISCIPLINES char(12) = 'Дисциплины: ', @DISCIPLINES_NONE char(16) = 'Дисциплины: нет.';
	begin try
		if (@pul is not null 
			and not exists (select FACULTY from PULPIT where PULPIT = @pul))
			raiserror('Ошибка в параметрах', 11, 1);

		declare @count int = 0;

		declare EX8 cursor local static 
			for select FACULTY.FACULTY, PULPIT.PULPIT, SUBJECT.SUBJECT, count(TEACHER.TEACHER)
			from FACULTY 
				inner join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
				left outer join SUBJECT on PULPIT.PULPIT = SUBJECT.PULPIT
				left outer join TEACHER on PULPIT.PULPIT = TEACHER.PULPIT
			where FACULTY.FACULTY = isnull(@fac, FACULTY.FACULTY)
				and PULPIT.PULPIT = isnull(@pul, PULPIT.PULPIT)
			group by FACULTY.FACULTY, PULPIT.PULPIT, SUBJECT.SUBJECT
			order by FACULTY asc, PULPIT asc, SUBJECT asc;

		open EX8;
			fetch EX8 into @faculty, @pulpit, @subject, @cnt_teacher;
			while @@FETCH_STATUS = 0
				begin 
					print 'Факультет ' + rtrim(@faculty) + ': ';
					set @temp_fac = @faculty;
					while (@faculty = @temp_fac)
						begin
							print char(9) + 'Кафедра ' + rtrim(@pulpit) + ': ';
							set @count += 1;
							print char(9) + char(9) + 'Количество преподавателей: ' + rtrim(@cnt_teacher) + '.';
							set @list = @DISCIPLINES;

							if(@subject is not null)
								begin
									if(@list = @DISCIPLINES)
										set @list += rtrim(@subject);
									else
										set @list += ', ' + rtrim(@subject);
								end;
							if (@subject is null) set @list = @DISCIPLINES_NONE;

							set @temp_pul = @pulpit;
							fetch EX8 into @faculty, @pulpit, @subject, @cnt_teacher;
							while (@pulpit = @temp_pul)
								begin
									if(@subject is not null)
										begin
											if(@list = @DISCIPLINES)
												set @list += rtrim(@subject);
											else
												set @list += ', ' + rtrim(@subject);
										end;
									fetch EX8 into @faculty, @pulpit, @subject, @cnt_teacher;
									if(@@FETCH_STATUS != 0) break;
								end;
							if(@list != @DISCIPLINES_NONE)
								set @list += '.';
							print char(9) + char(9) + @list;
							if(@@FETCH_STATUS != 0) break;
						end;
				end;
		close EX8;
		deallocate EX8;
		return @count;
	end try
	begin catch
		print 'Номер ошибки: ' + convert(varchar, error_number());
		print 'Сообщение: ' + error_message();
		print 'Уровень: ' + convert(varchar, error_severity());
		print 'Метка: ' + convert(varchar, error_state());
		print 'Номер строки: ' + convert(varchar, error_line());
		if error_procedure() is not null
			print 'Имя процедуры: ' + error_procedure();
		return -1;
	end catch;
go

declare @temp_8_1 int;
exec @temp_8_1 = PRINT_REPORT null, null;
select @temp_8_1;

declare @temp_8_2 int;
exec @temp_8_2 = PRINT_REPORT 'ИТ', null;
select @temp_8_2;

declare @temp_8_3 int;
exec @temp_8_3 = PRINT_REPORT null, 'ПОиСОИ';
select @temp_8_3;

declare @temp_8_4 int;
exec @temp_8_4 = PRINT_REPORT null, 'testing';
select @temp_8_4;