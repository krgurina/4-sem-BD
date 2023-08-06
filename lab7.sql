use UNIVER;
/*1. Ќа основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS разработать SELECT-запрос, в котором вывод€тс€ специальность, дисциплины и 
средние оценки при сдаче экзаменов на факультете “ќ¬. 
»спользовать группировку по пол€м FACULTY, PROFESSION, SUBJECT.
*/
select h.FACULTY, f.SUBJECT, g.PROFESSION, round(avg(cast(f.NOTE as float(4))),2)[средн€€ оценка] 
from PROGRESS f inner join SUBJECT c
on c.SUBJECT=f.SUBJECT
inner join STUDENT s
on f.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP=g.IDGROUP
inner join FACULTY h
on g.FACULTY=h.FACULTY
where h.FACULTY like '%»ƒиѕ%'
group by h.FACULTY, f.SUBJECT, g.PROFESSION
--order by [средн€€ оценка] desc

/*ƒобавить в запрос конструкцию ROLLUP и проанализировать результат. */
select h.FACULTY, f.SUBJECT, g.PROFESSION, round(avg(cast(f.NOTE as float(4))),2)[средн€€ оценка]
from PROGRESS f inner join SUBJECT c
on c.SUBJECT=f.SUBJECT
inner join STUDENT s
on f.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP=g.IDGROUP
inner join FACULTY h
on g.FACULTY=h.FACULTY
where h.FACULTY like '%»ƒиѕ%'
group by rollup(h.FACULTY, f.SUBJECT, g.PROFESSION)
--order by [средн€€ оценка] desc

/*2. ¬ыполнить SELECT-запрос из п. 1 с использованием CUBE-группировки. */
select h.FACULTY, f.SUBJECT, g.PROFESSION, round(avg(cast(f.NOTE as float(4))),2)[средн€€ оценка]
from PROGRESS f inner join SUBJECT c
on c.SUBJECT=f.SUBJECT
inner join STUDENT s
on f.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP=g.IDGROUP
inner join FACULTY h
on g.FACULTY=h.FACULTY
where h.FACULTY like '%»ƒиѕ%'
group by cube(h.FACULTY, f.SUBJECT, g.PROFESSION)
order by [средн€€ оценка] desc

/*3. Ќа основе таблиц GROUPS, STUDENT и PROGRESS разработать SELECT-запрос, в котором определ€ютс€ результаты сдачи экзаменов.
¬ запросе должны отражатьс€ специальности, дисциплины, средние оценки студентов на факультете “ќ¬.
ќтдельно разработать запрос, в котором определ€ютс€ результаты сдачи экзаменов на факультете ’“и“.
ќбъединить результаты двух запросов с использованием операторов UNION и UNION ALL. ќбъ€снить результаты. 
*/
select g.FACULTY, p.SUBJECT,g.PROFESSION, round(avg(cast(p.NOTE as float(4))),2)[средн€€ оценка]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%“ќ¬%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
UNION
select g.FACULTY, p.SUBJECT, g.PROFESSION,  round(avg(cast(p.NOTE as float(4))),2)[средн€€ оценка]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%»ƒиѕ%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
order by [средн€€ оценка] desc


--3/2
select g.FACULTY, p.SUBJECT,g.PROFESSION, round(avg(cast(p.NOTE as float(4))),2)[средн€€ оценка]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%“ќ¬%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
UNION ALL
select g.FACULTY, p.SUBJECT, g.PROFESSION,  round(avg(cast(p.NOTE as float(4))),2)[средн€€ оценка]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%»ƒиѕ%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
order by [средн€€ оценка] desc

/*4. ѕолучить пересечение двух множеств строк, созданных в результате выполнени€ запросов пункта 3. ќбъ€снить результат.
»спользовать оператор INTERSECT.
*/
select g.FACULTY, p.SUBJECT,g.PROFESSION, round(avg(cast(p.NOTE as float(4))),2)[средн€€ оценка]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%»ƒиѕ%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
INTERSECT
select g.FACULTY, p.SUBJECT, g.PROFESSION,  round(avg(cast(p.NOTE as float(4))),2)[средн€€ оценка]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%“ќ¬%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT

/*5. ѕолучить разницу между множеством строк, созданных в результате запросов пункта 3. ќбъ€снить результат. 
»спользовать оператор EXCEPT.*/
select g.FACULTY, p.SUBJECT,g.PROFESSION, round(avg(cast(p.NOTE as float(4))),2)[средн€€ оценка]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%“ќ¬%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
 EXCEPT
select g.FACULTY, p.SUBJECT, g.PROFESSION,  round(avg(cast(p.NOTE as float(4))),2)[средн€€ оценка]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%»ƒиѕ%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT

--7 ѕодсчитать количество студентов в каждой группе, на каждом факультете и всего в университете одним запросом. 
select GROUPS.FACULTY as 'факультет', 
	STUDENT.IDGROUP as 'группа',
	count(STUDENT.IDSTUDENT) as 'количество студентов'
from STUDENT, GROUPS
where GROUPS.IDGROUP = STUDENT.IDGROUP
group by rollup (GROUPS.FACULTY, STUDENT.IDGROUP)

