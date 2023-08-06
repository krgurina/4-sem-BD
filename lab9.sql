use UNIVER;

--1
declare @a int =1,
		@b char='q',
		@c varchar(10), 
		@d datetime,
		@e time,
		@f smallint,
		@g tinyint,
		@h numeric(12,5);
		
set @c ='hello';
set @d = getdate();
select @e='22:12:33';
select @f = 12;
select @g = COUNT(*) from STUDENT;
select @h = convert(numeric(12, 5), 12345.6789);

select @a a, @b b, @c c, @d d;
print 'time = ' + cast(@e as varchar(10));
print 'smallint = ' + cast(@f as varchar(10));
print 'tinyint = ' + cast(@g as varchar(10));
print 'numeric = ' + CONVERT(CHAR, @h);

--2
/*Разработать скрипт, в котором определяется общая вместимость аудиторий.
Если общая вместимость превышает 200, то вывести количество аудиторий, 
среднюю вместимость аудиторий, количество аудиторий, вместимость которых меньше средней, и процент таких аудиторий. 
Если общая вместимость аудиторий меньше 200, то вывести сообщение о размере общей вместимости.
*/

declare @sumCapacity int = (select (sum(AUDITORIUM.AUDITORIUM_CAPACITY)) from AUDITORIUM),
		@count int,
		@avgCapacity real,
		@countLess int,
		@procent real;
print 'sumCapacity = ' + cast(@sumCapacity as varchar(10));

if @sumCapacity>200
begin 
	set @count = (select count(AUDITORIUM) from AUDITORIUM);
	set @avgCapacity = (select avg(AUDITORIUM_CAPACITY) from AUDITORIUM);
	set @countLess = (select count(AUDITORIUM) from AUDITORIUM where AUDITORIUM.AUDITORIUM_CAPACITY < @avgCapacity);
	set @procent = 100*(cast(@countLess as float) /cast(@count as float));
	select @count 'Количество аудиторий', @avgCapacity 'Средняя вместимость ', @countLess 'Количество с площадью менее средней', cast(@procent as numeric(8, 2)) 'Процент аудиторий с площадью менее средней';
end
else
	print 'sumCapacity = ' + cast(@sumCapacity as varchar(10));

--3
/*Разработать T-SQL-скрипт, который выводит на печать глобальные переменные: */
print 'число обработанных строк: ' + cast(@@rowcount as varchar(10));
print 'версия SQL Server: ' + cast(@@version as varchar(10));
print 'системный идентификатор процесса, назначенный сервером текущему подключению: ' + cast(@@spid as varchar(10));
print 'код последней ошибки: ' + cast(@@error as varchar(10));
print 'имя сервера: ' + cast(@@servername as varchar(10));
print 'уровень вложенности транзакции: ' + cast(@@trancount as varchar(10));
print 'print: ' + cast(@@fetch_status as varchar(10));
print 'уровень вложенности текущей процедуры: ' + cast(@@nestlevel as varchar(10));

--4
-- вычисление значений переменной z 
declare @z float,
		@t float = 3.2,
		@x int = 13;
if @t>@x
	set @z=POWER(sin(@t),2);
else if @t<@x
	set @z=4*(@t+@x)
else
	set @z=1-exp(@x-2);
print 'z=' + cast(@z as varchar(10));

-- преобразование полного ФИО студента в сокращенное (например, Макейчик Татьяна Леонидовна в Макейчик Т. Л.);
declare @name varchar(30) = 'Гурина Кристина Сергеевна', @shortName varchar(30);
set @shortName = (select SUBSTRING(@name, 1, charindex(' ', @name)+1)+'. ' + substring(@name, charindex(' ', @name, charindex(' ', @name)+1)+1, 1) + '. ');
print 'ФИО = ' + @shortName;

----
--поиск студентов, у которых день рождения в следующем месяце, и определение их возраста
select NAME[имя студента], datediff(yy, bday,getdate())[возраст]
from STUDENT
where MONTH(bday)=MONTH(getdate())+1

--поиск дня недели, в который студенты некоторой группы сдавали экзамен по БД.
select DATENAME(weekday, PDATE) [день недели], PDATE[дата] from PROGRESS
where SUBJECT like '%БД%'

--5
/*Продемонстрировать конструкцию IF… ELSE на примере анализа данных таблиц базы данных Х_UNIVER.*/
if ((select count(*) from STUDENT)>100)
	begin 
		print 'Студентов больше 100'
	end
else
	begin 
		print 'Студентов меньше 100'
	end

--6
/*6. Разработать сценарий, в котором с помощью CASE анализируются оценки, полученные студентами некоторого факультета при сдаче экзаменов.*/
select PROGRESS.IDSTUDENT[код студента],
	case 
		when PROGRESS.NOTE = 10 then 'очень хорошо'
		when PROGRESS.NOTE between 7 and 9 then 'хорошо'
		when PROGRESS.NOTE between 4 and 6 then  'не плохо'
		else 'пересдача'
		end [оценка]
from PROGRESS
group by PROGRESS.IDSTUDENT, case
		when PROGRESS.NOTE = 10 then 'очень хорошо'
		when PROGRESS.NOTE between 7 and 9 then 'хорошо'
		when PROGRESS.NOTE between 4 and 6 then  'не плохо'
		else 'пересдача'
		end

--7
/*Создать временную локальную таблицу из трех столбцов и 10 строк, заполнить ее и вывести содержимое. 
Использовать оператор WHILE.*/

create table #local
(
	number int,
	name varchar(15),
	age int
)
set nocount on;
declare @i int = 1;
while @i<10
	begin
		insert #local(number,age, name)
			values(@i,@i+20,'name')
			set @i=@i+1;
	end
select * from #local

--8
declare @r int = 1;
while @r<10
	begin
		print 'r = ' + cast(@r as varchar(10));
		if(@r=5) return
		set @r=@r+1;
	end

--9
begin try
	UPdate FACULTY set FACULTY = 'ХТиТ' where FACULTY='ЛХФ'
end try
begin catch
	print ERROR_NUMBER()
	print ERROR_MESSAGE()
	print ERROR_LINE()
	print ERROR_PROCEDURE()
	print ERROR_SEVERITY()
	print ERROR_STATE()
end catch