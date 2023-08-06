use UNIVER;
go
--1 Разработать представление с именем Преподаватель. 
create view [Преподаватель]
as select 
TEACHER.TEACHER[код],
TEACHER.TEACHER_NAME[имя преподавателя], 
TEACHER.GENDER[пол],
TEACHER.PULPIT[кафедра]
from TEACHER;
go
select * from [Преподаватель]

drop view [Преподаватель]

/*2. Разработать и создать представление с именем Количество кафедр. Представление должно быть построено 
на основе SELECT-запроса к таблицам FACULTY и PULPIT.Представление должно содержать следующие столбцы: 
факультет, количество кафедр (вычисляется на основе строк таблицы PULPIT). 
*/
go
create view [Количество кафедр]
as select 
f.FACULTY[факультет], COUNT(p.PULPIT)[количество кафедр]
from FACULTY f inner join PULPIT p
on f.FACULTY=p.FACULTY
group by f.FACULTY
go
select * from [Количество кафедр] order by [количество кафедр]
go 
drop view [Количество кафедр]

/*3. Разработать и создать представление с именем Аудитории. Представление должно быть построено на основе таблицы AUDITORIUM 
и содержать столбцы: код, наименование аудитории. 
Представление должно отображать только лекционные аудитории (в столбце AUDITORIUM_ TYPE строка, начинающаяся с символа ЛК)
и допускать выполнение оператора INSERT, UPDATE и DELETE.
*/
create view Аудитории(код, [наименование аудитории])
as select AUDITORIUM, AUDITORIUM_TYPE from AUDITORIUM
where AUDITORIUM_TYPE like '%лк%'
go

insert Аудитории values('530-3а','ЛК')

select * from Аудитории
go
alter view Аудитории
	as select AUDITORIUM.AUDITORIUM [Код],
				AUDITORIUM.AUDITORIUM_NAME [Наименование аудитории],
				AUDITORIUM.AUDITORIUM_TYPE [Тип аудитории]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%';
go
select * from Аудитории
insert Аудитории values('300-3а','300-3а','ЛК')
--insert Аудитории values('132-4','ЛК')
--insert Аудитории values('100-3а','ЛК')
--select * from Аудитории

update Аудитории
set [наименование аудитории]=Код
where ([наименование аудитории]is null)
select * from Аудитории
go
delete  Аудитории
where [наименование аудитории]='300-3а'
select * from Аудитории
go
drop view Аудитории

--4
create view Лекционные_аудитории(код, [наименование аудитории])
as select AUDITORIUM, AUDITORIUM_TYPE from AUDITORIUM
where AUDITORIUM_TYPE like '%лк%' with check option
go
select * from Лекционные_аудитории

insert Лекционные_аудитории values('500-1','ЛБ')
select * from Лекционные_аудитории
drop view Лекционные_аудитории

/*5. Разработать представление с именем Дисциплины. Представление должно быть построено на основе 
SELECT-запроса к таблице SUBJECT, отображать все дисциплины в алфавитном порядке и содержать следующие 
столбцы: код, наименование дисциплины и код кафедры*/
create view Дисциплины(код, [наименование дисциплины], [код кафедры])
as select top 100 SUBJECT, SUBJECT_NAME, PULPIT from SUBJECT
order by SUBJECT_NAME
go
select * from Дисциплины
drop view Дисциплины

--
-- из 2 задания
create view [Количество кафедр]
as select 
	f.FACULTY[факультет], 
	COUNT(p.PULPIT)[количество кафедр]
from FACULTY f inner join PULPIT p
	on f.FACULTY=p.FACULTY
group by f.FACULTY
--6
go
alter view [Количество кафедр] with schemabinding
as select 
	f.FACULTY[факультет], 
	COUNT(p.PULPIT)[количество]
from dbo.FACULTY f inner join dbo.PULPIT p
	on f.FACULTY=p.FACULTY
group by f.FACULTY
go

select * from [Количество кафедр] order by [количество]

drop view [Количество кафедр]


