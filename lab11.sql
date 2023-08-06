use UNIVER
--1. Разработать сценарий, формирующий список дисциплин на кафедре ИСиТ.
--В отчет должны быть выведены краткие названия дисциплин из таблицы SUBJECT в одну строку через запятую. 
declare @subj char(20), @s char(300)='';
declare curSubj cursor for select SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT = 'ИСиТ'
open curSubj;
	fetch curSubj into @subj --данные перемещаются из курсора в переменную @subj.
	print 'краткие названия дисциплин '
	while @@FETCH_STATUS = 0
		begin
		set @s = RTRIM(@subj) + ',' + @s;
		fetch curSubj into @subj
	end;
	print @s;
Close curSubj;
deallocate curSubj;

-- 2. Разработать сценарий, демонстрирующий отличие глобального курсора 
--от локального на примере базы данных UNIVER.
declare Puls cursor local for select PULPIT, FACULTY from PULPIT;
declare @pul nvarchar(10), @fac nvarchar(4);
open Puls;
	fetch Puls into @pul, @fac;
    print '1. '+ rtrim(@pul)+' факультет: '+ @fac;
	go

	declare @pul nvarchar(10), @fac nvarchar(4);     	
	fetch Puls into @pul, @fac; 	
    print '2. '+ rtrim(@pul)+' факультет: '+ @fac;
	go

-- глобальный
declare Puls cursor for select PULPIT, FACULTY from PULPIT;
declare @pul nvarchar(10), @fac nvarchar(4);

open Puls;
	fetch Puls into @pul, @fac;
    print '1. '+ rtrim(@pul)+' факультет: '+ @fac;
	go

	declare @pul nvarchar(10), @fac nvarchar(4);     	
	fetch Puls into @pul, @fac; 	
    print '2. '+ rtrim(@pul)+' факультет: '+ @fac;
	go
 close Puls;
deallocate Puls;

-- 3. Разработать сценарий, демонстрирующий отличие статических 
--курсоров от динамических на примере базы данных UNIVER.
declare cur cursor local static for (select AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY from AUDITORIUM)
declare @name varchar(10)
declare @type varchar(5)
declare @cap int

open cur
print 'строк в курсоре: ' + cast(@@cursor_rows as char)
update AUDITORIUM set AUDITORIUM_TYPE = 'ЛК' where AUDITORIUM = '100-3а'		
fetch cur into @name, @type, @cap
while @@FETCH_STATUS = 0
begin
	print @name + ' ' + @type + ' ' + cast(@cap as char) 
	fetch cur into @name, @type, @cap
end
close cur


go
-- динамический
declare cur cursor local dynamic for (select AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY from AUDITORIUM)
declare @name varchar(10)
declare @type varchar(5)
declare @cap int

open cur
print 'строк в курсоре: ' + cast(@@cursor_rows as char)
update AUDITORIUM set AUDITORIUM_TYPE = 'ЛБ-К' where AUDITORIUM = '100-3а'		
fetch cur into @name, @type, @cap
while @@FETCH_STATUS = 0
begin
	print @name + ' ' + @type + ' ' + cast(@cap as char) 
	fetch cur into @name, @type, @cap
end
close cur
deallocate cur
--select * from AUDITORIUM

-- 4. Разработать сценарий, демонстрирующий свойства навигации в результирующем наборе 
--курсора с атрибутом SCROLL на примере базы данных UNIVER.
--Использовать все известные ключевые слова в операторе fetch.

declare cur cursor local dynamic scroll for 
	select row_number() over (order by SUBJECT), IDSTUDENT, SUBJECT, NOTE from PROGRESS
declare @rn int, @id varchar(10), @sub varchar(15), @nt int
open cur

fetch cur into @rn, @id, @sub, @nt
print 'First:		' + cast(@rn as varchar) + '. ID студента: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' оценка: ' + cast(@nt as varchar)

fetch next from cur into @rn, @id, @sub, @nt
print 'Next:		' + cast(@rn as varchar) + '. ID студента: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' оценка: ' + cast(@nt as varchar)

fetch prior from cur into @rn, @id, @sub, @nt
print 'Prior:		' + cast(@rn as varchar) + '. ID студента: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' оценка: ' + cast(@nt as varchar)

fetch absolute 3 from cur into @rn, @id, @sub, @nt
print 'absolute 3:	' + cast(@rn as varchar) + '. ID студента: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' оценка: ' + cast(@nt as varchar)

fetch absolute -3 from cur into @rn, @id, @sub, @nt
print 'absolute -3:' + cast(@rn as varchar) + '. ID студента: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' оценка: ' + cast(@nt as varchar)

fetch relative 2 from cur into @rn, @id, @sub, @nt
print 'relative 2:	' + cast(@rn as varchar) + '. ID студента: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' оценка: ' + cast(@nt as varchar)

fetch relative -2 from cur into @rn, @id, @sub, @nt
print 'relative -2:' + cast(@rn as varchar) + '. ID студента: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' оценка: ' + cast(@nt as varchar)

fetch last from cur into @rn, @id, @sub, @nt
print 'Last:		' + cast(@rn as varchar) + '. ID студента: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' оценка: ' + cast(@nt as varchar)

close cur

-- 5. Создать курсор, демонстрирующий применение конструкции CURRENT OF 
--в секции WHERE с использованием операторов UPDATE и DELETE.

declare cur cursor local dynamic for 
	select IDSTUDENT, SUBJECT, NOTE from PROGRESS FOR UPDATE
declare @id varchar(10), @sub varchar(15), @nt int

open cur
fetch cur into @id, @sub, @nt
while @@FETCH_STATUS = 0
begin
	if @nt = 9 update PROGRESS set NOTE = 10 where CURRENT OF cur
	if @id = 1083 delete PROGRESS where CURRENT OF cur

	print 'ID студента: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' оценка: ' + cast(@nt as varchar)
	fetch cur into @id, @sub, @nt
end
close cur

-- 6. Разработать select-запрос, с помощью которого из таблицы PROGRESS удаляются строки, 
--содержащие информацию о студентах, получивших оценки ниже 4 (использовать объединение таблиц 
--PROGRESS, STUDENT, GROUPS). 
declare cur cursor local dynamic for 
	select g.IDGROUP, s.NAME, p.NOTE from PROGRESS p
	join STUDENT s on s.IDSTUDENT = p.IDSTUDENT
	join GROUPS g on s.IDGROUP = g.IDGROUP
	where p.NOTE < 4
		FOR UPDATE
declare @gr varchar(5), @nm varchar(50), @nt int
open cur
fetch cur into @gr, @nm, @nt
while @@FETCH_STATUS = 0
	begin
		print @gr + ': ' + @nm + ' оценка: ' + cast(@nt as varchar)
		delete PROGRESS where CURRENT OF cur	
		delete STUDENT where CURRENT OF cur
		fetch cur into @gr, @nm, @nt

	end
close cur

--Разработать select-запрос, с помощью которого в таблице PROGRESS для студента с конкретным 
--номером IDSTUDENT корректируется оценка (увеличивается на единицу).
declare cur cursor local dynamic for 
	select IDSTUDENT, SUBJECT, NOTE from PROGRESS FOR UPDATE
declare @id varchar(10), @sub varchar(15), @nt int

open cur
fetch cur into @id, @sub, @nt
while @@FETCH_STATUS = 0
	begin
		if @id = 1003 update PROGRESS set NOTE = NOTE+1 where CURRENT OF cur
		print 'ID студента: ' + @id + ' предмет: ' + rtrim(cast(@sub as varchar)) + ' оценка: ' + cast(@nt as varchar)
		fetch cur into @id, @sub, @nt
	end
close cur

--8 пофиксить 
declare cur cursor local static for
  select f.FACULTY, p.PULPIT, count(t.TEACHER_NAME), string_agg(RTRIM(s.SUBJECT), ', ')
  from FACULTY f 
  join PULPIT p on p.FACULTY = f.FACULTY
  join SUBJECT s on s.PULPIT = p.PULPIT
  join TEACHER t on t.PULPIT = p.PULPIT
  group by f.FACULTY, p.PULPIT

declare @fc varchar(10), @pl varchar(10), @cn int, @sb varchar(200)

open cur
fetch cur into @fc, @pl, @cn, @sb
while @@FETCH_STATUS = 0
  begin
    print 'Факультет: ' + RTRIM(@fc) + char(13) + char(9) + 'Кафедра: ' +  RTRIM(@pl) + char(13) + char(9) + char(9) + 'Количество преподавателей: ' + cast(@cn as varchar) + char(13) + char(9) + char(9) + 'Дисциплины: ' + @sb
    fetch cur into @fc, @pl, @cn, @sb
  end
close cur



--8 
declare @faculty nvarchar(10), @pulpitcount int, 
		@pulpitn nvarchar(10), @teachercount int, 
		@subjectn nvarchar(15), @subjectPulpit nvarchar(50), @subjectarray nvarchar(300) = ''

declare @i int

declare Faculty cursor local dynamic
	for select FACULTY.FACULTY, COUNT(*) 
	from FACULTY
	Inner Join PULPIT ON PULPIT.FACULTY = FACULTY.FACULTY
	GROUP BY FACULTY.FACULTY 
	ORDER BY FACULTY.FACULTY

declare Pulpit cursor local dynamic
	for select PULPIT.PULPIT, COUNT(*) 
	from PULPIT
	Left Outer Join TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT
	GROUP BY FACULTY, PULPIT.PULPIT
	ORDER BY FACULTY

declare Subjectt cursor local dynamic
	for select SUBJECT.SUBJECT, SUBJECT.PULPIT
	from SUBJECT

open Faculty
open Pulpit 
	fetch from Faculty into @faculty, @pulpitcount
	print 'Факультет: ' + @faculty
	while @@FETCH_STATUS = 0
	begin
		SET @i = 0
		while @i < @pulpitcount
			begin
				SET @subjectarray = ''
				fetch from Pulpit into @pulpitn, @teachercount
				print char(9) + 'Кафедра: ' + @pulpitn
				print char(9) + char(9) + 'Количество преподавателей: ' + cast(@teachercount as nvarchar(10))

				open Subjectt
					fetch from Subjectt into @subjectn, @subjectPulpit
					IF (@subjectPulpit = @pulpitn)
						SET @subjectarray = trim(@subjectn) + ', ' + @subjectarray

						while @@FETCH_STATUS = 0
							begin 
								fetch from Subjectt into @subjectn, @subjectPulpit
								IF (@subjectPulpit = @pulpitn)
									SET @subjectarray = trim(@subjectn) + ', ' + @subjectarray
							end
				close Subjectt

				IF len(@subjectarray) > 0
					SET @subjectarray = left(@subjectarray, len(@subjectarray)-1)
				ELSE
					SET @subjectarray = 'нет'
					print char(9) + char(9) + 'Дисциплины: ' + @subjectarray
					SET @i = @i+1
				end

			fetch from Faculty into @faculty, @pulpitcount
			IF (@@fetch_status = 0) print 'Факультет: ' + @faculty
		end

close Faculty
close Pulpit
go
