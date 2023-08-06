use UNIVER;
/*
1. На основе таблиц FACULTY, PULPIT и PROFESSION сформировать список наименований кафедр, которые находятся на факультете, 
обеспечивающем подготовку по специальности, в наименовании которого содержится слово технология или технологии. 
Использовать в секции WHERE предикат IN c некоррелированным подзапросом к таблице PROFESSION. 
*/
select FACULTY.FACULTY, PULPIT.PULPIT_NAME
from FACULTY, PULPIT
where FACULTY.FACULTY=PULPIT.FACULTY and FACULTY.FACULTY in (select PROFESSION.FACULTY from PROFESSION where (PROFESSION_NAME like '%технологии%' or PROFESSION_NAME like '%технология%'))/*

2. Переписать запрос пункта 1 таким образом, чтобы тот же подзапрос был записан в конструкции INNER JOIN секции FROM внешнего запроса. 
При этом результат выполнения запроса должен быть аналогичным результату исходного запроса. */
select FACULTY.FACULTY, PULPIT.PULPIT_NAME
from FACULTY inner join PULPIT
on FACULTY.FACULTY=PULPIT.FACULTY
where FACULTY.FACULTY in (select PROFESSION.FACULTY from PROFESSION where (PROFESSION_NAME like '%технологии%' or PROFESSION_NAME like '%технология%'))

/*
3. Переписать запрос, реализующий 1 пункт без использования подзапроса. Примечание: использовать соединение INNER JOIN трех таблиц. */
select distinct FACULTY.FACULTY, PULPIT.PULPIT_NAME
from FACULTY inner join PULPIT
on FACULTY.FACULTY=PULPIT.FACULTY
inner join PROFESSION 
on FACULTY.FACULTY=PROFESSION.FACULTY
where PROFESSION_NAME like '%технологии%' or PROFESSION_NAME like '%технология%'

/*4. На основе таблицы AUDITORIUM сформировать список аудиторий самых больших вместимостей для каждого типа аудитории. 
При этом результат следует отсортировать в порядке убывания вместимости. Примечание: использовать коррелируемый подзапрос c секциями TOP и ORDER BY. */
select AUDITORIUM_NAME, AUDITORIUM_TYPE,AUDITORIUM_CAPACITY
from AUDITORIUM a
where AUDITORIUM_CAPACITY=(
select top(1) AUDITORIUM_CAPACITY 
from AUDITORIUM aa
where aa.AUDITORIUM_TYPE=a.AUDITORIUM_TYPE
order by AUDITORIUM_CAPACITY desc)

/*5. На основе таблиц FACULTY и PULPIT сформировать список наименований факультетов на котором нет ни одной кафедры (таблица PULPIT). 
Использовать предикат EXISTS и коррелированный подзапрос. */
select FACULTY_NAME[Факультеты без кафедр]
from FACULTY
where not exists (select PULPIT.PULPIT from PULPIT
where FACULTY.FACULTY=PULPIT.FACULTY)

/*6. На основе таблицы PROGRESS сформировать строку, содержащую средние значения оценок (столбец NOTE) 
по дисциплинам, имеющим следующие коды: ОАиП, БД и СУБД. Примечание: использовать три некоррелированных подзапроса 
в списке SELECT; в подзапросах применить агрегатные функции AVG. */
select top 1
(select avg(PROGRESS.NOTE)from PROGRESS
	where PROGRESS.SUBJECT like 'ОАиП')[ОАиП],
(select avg(PROGRESS.NOTE)from PROGRESS
	where PROGRESS.SUBJECT like 'СУБД')[СУБД],
(select avg(PROGRESS.NOTE)from PROGRESS
	where PROGRESS.SUBJECT like 'БД')[БД]
from PROGRESS

/*7. Разработать SELECT-запрос, демонстрирующий способ применения ALL совместно с подзапросом.*/
SELECT NAME, SUBJECT, NOTE
FROM STUDENT, PROGRESS
WHERE  PROGRESS.SUBJECT like 'ОАиП' and NOTE>=all (SELECT PROGRESS.NOTE FROM PROGRESS
	WHERE PROGRESS.NOTE<=5)

/*8. Разработать SELECT-запрос, демонстрирующий принцип применения ANY совместно с подзапросом.*/
SELECT * FROM AUDITORIUM
WHERE AUDITORIUM_CAPACITY > ANY(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM
			WHERE AUDITORIUM_TYPE LIKE '%ЛК%')
ORDER BY AUDITORIUM_CAPACITY asc

/*10. Найти в таблице STUDENT студентов, у которых день рождения в один день. Объяснить решение.*/
SELECT distinct s1.IDSTUDENT, s1.NAME, s1.BDAY 
FROM STUDENT s1 inner join STUDENT s2
	ON (s1.BDAY = s2.BDAY and s1.IDSTUDENT != s2.IDSTUDENT)
ORDER BY s1.BDAY desc

