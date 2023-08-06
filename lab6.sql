use UNIVER;
/*1. На основе таблиц AUDITORIUM и AUDITORIUM_TYPE разработать запрос, вычисляющий для каждого типа аудиторий максимальную, минимальную, 
среднюю вместимость аудиторий, суммарную вместимость всех аудиторий и общее количество аудиторий данного типа. 
Результирующий набор должен содержать столбец с наименованием типа аудиторий и столбцы с вычисленными величинами. 
*/
select AUDITORIUM.AUDITORIUM_TYPE,
max(AUDITORIUM.AUDITORIUM_CAPACITY)[MAX вместимость],
min(AUDITORIUM.AUDITORIUM_CAPACITY)[MIN вместимость],
avg(AUDITORIUM.AUDITORIUM_CAPACITY)[AVG вместимость]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE 
group by AUDITORIUM.AUDITORIUM_TYPE

/*2. На основе таблиц AUDITORIUM и AUDITORIUM_TYPE разработать запрос, вычисляющий для каждого типа аудиторий максимальную, минимальную, 
среднюю вместимость аудиторий, суммарную вместимость всех аудиторий и общее количество аудиторий данного типа. 
Результирующий набор должен содержать столбец с наименованием типа аудиторий и столбцы с вычисленными величинами. 
*/
select AUDITORIUM.AUDITORIUM_TYPE,
max(AUDITORIUM.AUDITORIUM_CAPACITY)[MAX вместимость],
min(AUDITORIUM.AUDITORIUM_CAPACITY)[MIN вместимость],
avg(AUDITORIUM.AUDITORIUM_CAPACITY)[AVG вместимость],
sum(AUDITORIUM.AUDITORIUM_CAPACITY)[SUM вместимость],
count(*)[Кол-во]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE 
group by AUDITORIUM.AUDITORIUM_TYPE

/*3. Разработать запрос на основе таблицы PROGRESS, который будет содержать значения экзаменационных
оценок и их количество в заданном интервале. 
Сортировка строк должна осуществляться в порядке, обратном величине оценки.
*/
select *
from (select Case 
	when PROGRESS.NOTE between 1 and 3 then 'не сдали'
	when PROGRESS.NOTE between 4 and 7 then 'удовлетворительно'
	when PROGRESS.NOTE between 8 and 10 then 'отлично'
	end [оценка], count(*)[Количество]
from PROGRESS group by Case
when PROGRESS.NOTE between 1 and 3 then 'не сдали'
when PROGRESS.NOTE between 4 and 7 then 'удовлетворительно'
when PROGRESS.NOTE between 8 and 10 then 'отлично'
end) as T
order by Case [оценка]
	when 'не сдали' then 3
	when 'удовлетворительно' then 2
	when 'отлично' then 1
	else 0
end

/*4. Разработать SELECT-запроса на основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS, который содержит среднюю экзаменационную 
оценку для каждого курса каждой специальности и факультета. 
Строки отсортировать в порядке убывания средней оценки.
Средняя оценка должна рассчитываться с точностью до двух знаков после запятой.
*/
select h.FACULTY, g.YEAR_FIRST, g.PROFESSION, round(avg(cast(f.NOTE as float(4))),2)[средняя оценка]
from PROGRESS f inner join SUBJECT c
on c.SUBJECT=f.SUBJECT
inner join STUDENT s
on f.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP=g.IDGROUP
inner join FACULTY h
on g.FACULTY=h.FACULTY
group by h.FACULTY, g.YEAR_FIRST, g.PROFESSION
order by [средняя оценка] desc

/*5. Переписать SELECT-запрос, разработанный в задании 4, так чтобы в расчете среднего значения оценок 
использовались оценки только по дисциплинам с кодами БД и ОАиП.*/
select h.FACULTY, g.YEAR_FIRST, g.PROFESSION, c.SUBJECT, round(avg(cast(f.NOTE as float(4))),2)[средняя оценка]
from PROGRESS f inner join SUBJECT c
on c.SUBJECT=f.SUBJECT
inner join STUDENT s
on f.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP=g.IDGROUP
inner join FACULTY h
on g.FACULTY=h.FACULTY
where c.SUBJECT like '%БД%' or c.SUBJECT like '%ОАиП%'
group by h.FACULTY, g.YEAR_FIRST, g.PROFESSION,c.SUBJECT
order by [средняя оценка] desc

/*6. На основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS разработать запрос, в котором выводятся специальность, дисциплины и 
средние оценки при сдаче экзаменов на факультете ТОВ. */
select h.FACULTY, f.SUBJECT, g.PROFESSION, round(avg(cast(f.NOTE as float(4))),2)[средняя оценка]
from PROGRESS f inner join SUBJECT c
on c.SUBJECT=f.SUBJECT
inner join STUDENT s
on f.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP=g.IDGROUP
inner join FACULTY h
on g.FACULTY=h.FACULTY
where h.FACULTY like '%ИДиП%'
group by h.FACULTY, f.SUBJECT, g.PROFESSION
order by [средняя оценка] desc

--7
select p1.SUBJECT, p1.NOTE,
(select count(*) from PROGRESS p2
where p1.SUBJECT=p2.SUBJECT and p1.NOTE = p2.NOTE) [количество]
from PROGRESS p1
group by p1.SUBJECT, p1.NOTE
having NOTE=8 or NOTE=9
order by NOTE desc