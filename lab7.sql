use UNIVER;
/*1. �� ������ ������ FACULTY, GROUPS, STUDENT � PROGRESS ����������� SELECT-������, � ������� ��������� �������������, ���������� � 
������� ������ ��� ����� ��������� �� ���������� ���. 
������������ ����������� �� ����� FACULTY, PROFESSION, SUBJECT.
*/
select h.FACULTY, f.SUBJECT, g.PROFESSION, round(avg(cast(f.NOTE as float(4))),2)[������� ������] 
from PROGRESS f inner join SUBJECT c
on c.SUBJECT=f.SUBJECT
inner join STUDENT s
on f.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP=g.IDGROUP
inner join FACULTY h
on g.FACULTY=h.FACULTY
where h.FACULTY like '%����%'
group by h.FACULTY, f.SUBJECT, g.PROFESSION
--order by [������� ������] desc

/*�������� � ������ ����������� ROLLUP � ���������������� ���������. */
select h.FACULTY, f.SUBJECT, g.PROFESSION, round(avg(cast(f.NOTE as float(4))),2)[������� ������]
from PROGRESS f inner join SUBJECT c
on c.SUBJECT=f.SUBJECT
inner join STUDENT s
on f.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP=g.IDGROUP
inner join FACULTY h
on g.FACULTY=h.FACULTY
where h.FACULTY like '%����%'
group by rollup(h.FACULTY, f.SUBJECT, g.PROFESSION)
--order by [������� ������] desc

/*2. ��������� SELECT-������ �� �. 1 � �������������� CUBE-�����������. */
select h.FACULTY, f.SUBJECT, g.PROFESSION, round(avg(cast(f.NOTE as float(4))),2)[������� ������]
from PROGRESS f inner join SUBJECT c
on c.SUBJECT=f.SUBJECT
inner join STUDENT s
on f.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP=g.IDGROUP
inner join FACULTY h
on g.FACULTY=h.FACULTY
where h.FACULTY like '%����%'
group by cube(h.FACULTY, f.SUBJECT, g.PROFESSION)
order by [������� ������] desc

/*3. �� ������ ������ GROUPS, STUDENT � PROGRESS ����������� SELECT-������, � ������� ������������ ���������� ����� ���������.
� ������� ������ ���������� �������������, ����������, ������� ������ ��������� �� ���������� ���.
�������� ����������� ������, � ������� ������������ ���������� ����� ��������� �� ���������� ����.
���������� ���������� ���� �������� � �������������� ���������� UNION � UNION ALL. ��������� ����������. 
*/
select g.FACULTY, p.SUBJECT,g.PROFESSION, round(avg(cast(p.NOTE as float(4))),2)[������� ������]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%���%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
UNION
select g.FACULTY, p.SUBJECT, g.PROFESSION,  round(avg(cast(p.NOTE as float(4))),2)[������� ������]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%����%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
order by [������� ������] desc


--3/2
select g.FACULTY, p.SUBJECT,g.PROFESSION, round(avg(cast(p.NOTE as float(4))),2)[������� ������]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%���%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
UNION ALL
select g.FACULTY, p.SUBJECT, g.PROFESSION,  round(avg(cast(p.NOTE as float(4))),2)[������� ������]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%����%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
order by [������� ������] desc

/*4. �������� ����������� ���� �������� �����, ��������� � ���������� ���������� �������� ������ 3. ��������� ���������.
������������ �������� INTERSECT.
*/
select g.FACULTY, p.SUBJECT,g.PROFESSION, round(avg(cast(p.NOTE as float(4))),2)[������� ������]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%����%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
INTERSECT
select g.FACULTY, p.SUBJECT, g.PROFESSION,  round(avg(cast(p.NOTE as float(4))),2)[������� ������]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%���%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT

/*5. �������� ������� ����� ���������� �����, ��������� � ���������� �������� ������ 3. ��������� ���������. 
������������ �������� EXCEPT.*/
select g.FACULTY, p.SUBJECT,g.PROFESSION, round(avg(cast(p.NOTE as float(4))),2)[������� ������]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%���%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT
 EXCEPT
select g.FACULTY, p.SUBJECT, g.PROFESSION,  round(avg(cast(p.NOTE as float(4))),2)[������� ������]
from PROGRESS p inner join STUDENT s
on p.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP = g.IDGROUP
where g.FACULTY like '%����%'
group by g.FACULTY, g.PROFESSION, p.SUBJECT

--7 ���������� ���������� ��������� � ������ ������, �� ������ ���������� � ����� � ������������ ����� ��������. 
select GROUPS.FACULTY as '���������', 
	STUDENT.IDGROUP as '������',
	count(STUDENT.IDSTUDENT) as '���������� ���������'
from STUDENT, GROUPS
where GROUPS.IDGROUP = STUDENT.IDGROUP
group by rollup (GROUPS.FACULTY, STUDENT.IDGROUP)

