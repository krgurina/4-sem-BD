use UNIVER;
--1
/*На основе таблиц AUDITORIUM_ TYPE и AUDITORIUM сформировать перечень кодов аудиторий и соответствующих им наименований типов аудиторий. 
Использовать соединение таблиц INNER JOIN. 
*/
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE
from AUDITORIUM_TYPE Inner Join AUDITORIUM
on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE;
--2
/*На основе таблиц AUDITORIUM_TYPE и AUDITORIUM сформировать перечень кодов аудиторий и соответствующих им наименований 
типов аудиторий, выбрав только те аудитории, в наименовании которых присутствует подстрока компьютер. 
Использовать соединение таблиц INNER JOIN и предикат LIKE. */
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from AUDITORIUM_TYPE Inner Join AUDITORIUM
on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME Like '%компьютер%'
--3
/*На основе таблиц PRORGESS, STUDENT, GROUPS, SUBJECT, PULPIT и FACULTY сформировать перечень студентов, получивших экзаменационные оценки от 6 до 8. 
Результирующий набор должен содержать столбцы: Факультет, Кафедра, Специальность, Дисциплина, Имя Студента, Оценка. 
В столбце Оценка должны быть записаны экзаменационные оценки прописью: шесть, семь, восемь. 
Результат отсортировать в порядке убывания по столбцу PROGRESS.NOTE.
Использовать соединение INNER JOIN, предикат BETWEEN и выражение CASE.*/
select FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION_NAME, SUBJECT.SUBJECT_NAME, STUDENT.NAME,
case
	when (PROGRESS.NOTE=6) then 'шесть'
	when (PROGRESS.NOTE=7) then 'семь'
	when (PROGRESS.NOTE=8) then 'восемь'
	end [PROGRESS.NOTE]
	from PROGRESS
inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join SUBJECT on SUBJECT.SUBJECT = PROGRESS.SUBJECT
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join PROFESSION on PROFESSION.PROFESSION = GROUPS.PROFESSION
inner join PULPIT on PULPIT.PULPIT=SUBJECT.PULPIT
inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY
	where PROGRESS.NOTE between 6 and 8
order by PROGRESS.NOTE desc
--4
/*На основе таблиц PULPIT и TEACHER получить полный перечень кафедр и преподавателей на этих кафедрах. 
Результирующий набор должен содержать два столбца: Кафедра и Преподаватель. Если на кафедре нет преподавателей, то в столбце 
Преподаватель должна быть выведена строка ***. 
Примечание: использовать соединение таблиц LEFT OUTER JOIN и функцию isnull.*/
select PULPIT.PULPIT,isnull(TEACHER.TEACHER_NAME,'***')[Преподаватель]
from PULPIT left outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT
--5(1)
/*запрос, результат которого содержит данные левой (в операции FULL OUTER JOIN) таблицы и не содержит данные правой*/
select PULPIT.FACULTY, PULPIT.PULPIT, PULPIT.PULPIT_NAME
from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT
where TEACHER.TEACHER is null
--5(2)
/*запрос, результат которого содержит данные правой таблицы и не содержащие данные левой; */
select TEACHER.TEACHER_NAME, TEACHER.TEACHER, TEACHER.PULPIT, TEACHER.GENDER
from PULPIT full outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT
where TEACHER.TEACHER is not null
--5(3)
/*запрос, результат которого содержит данные правой таблицы и левой таблиц;*/
select * from TEACHER full outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT
--6
/*Разработать SELECT-запрос на основе CROSS JOIN-соединения таблиц AUDITORIUM_TYPE и AUDITORIUM, формирующего результат, 
аналогичный результату запроса в задании 1*/
select AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM.AUDITORIUM
from AUDITORIUM_TYPE cross join AUDITORIUM
where AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE
