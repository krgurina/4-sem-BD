use UNIVER;
--1
/*�� ������ ������ AUDITORIUM_ TYPE � AUDITORIUM ������������ �������� ����� ��������� � ��������������� �� ������������ ����� ���������. 
������������ ���������� ������ INNER JOIN. 
*/
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE
from AUDITORIUM_TYPE Inner Join AUDITORIUM
on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE;
--2
/*�� ������ ������ AUDITORIUM_TYPE � AUDITORIUM ������������ �������� ����� ��������� � ��������������� �� ������������ 
����� ���������, ������ ������ �� ���������, � ������������ ������� ������������ ��������� ���������. 
������������ ���������� ������ INNER JOIN � �������� LIKE. */
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from AUDITORIUM_TYPE Inner Join AUDITORIUM
on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME Like '%���������%'
--3
/*�� ������ ������ PRORGESS, STUDENT, GROUPS, SUBJECT, PULPIT � FACULTY ������������ �������� ���������, ���������� ��������������� ������ �� 6 �� 8. 
�������������� ����� ������ ��������� �������: ���������, �������, �������������, ����������, ��� ��������, ������. 
� ������� ������ ������ ���� �������� ��������������� ������ ��������: �����, ����, ������. 
��������� ������������� � ������� �������� �� ������� PROGRESS.NOTE.
������������ ���������� INNER JOIN, �������� BETWEEN � ��������� CASE.*/
select FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION_NAME, SUBJECT.SUBJECT_NAME, STUDENT.NAME,
case
	when (PROGRESS.NOTE=6) then '�����'
	when (PROGRESS.NOTE=7) then '����'
	when (PROGRESS.NOTE=8) then '������'
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
/*�� ������ ������ PULPIT � TEACHER �������� ������ �������� ������ � �������������� �� ���� ��������. 
�������������� ����� ������ ��������� ��� �������: ������� � �������������. ���� �� ������� ��� ��������������, �� � ������� 
������������� ������ ���� �������� ������ ***. 
����������: ������������ ���������� ������ LEFT OUTER JOIN � ������� isnull.*/
select PULPIT.PULPIT,isnull(TEACHER.TEACHER_NAME,'***')[�������������]
from PULPIT left outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT
--5(1)
/*������, ��������� �������� �������� ������ ����� (� �������� FULL OUTER JOIN) ������� � �� �������� ������ ������*/
select PULPIT.FACULTY, PULPIT.PULPIT, PULPIT.PULPIT_NAME
from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT
where TEACHER.TEACHER is null
--5(2)
/*������, ��������� �������� �������� ������ ������ ������� � �� ���������� ������ �����; */
select TEACHER.TEACHER_NAME, TEACHER.TEACHER, TEACHER.PULPIT, TEACHER.GENDER
from PULPIT full outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT
where TEACHER.TEACHER is not null
--5(3)
/*������, ��������� �������� �������� ������ ������ ������� � ����� ������;*/
select * from TEACHER full outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT
--6
/*����������� SELECT-������ �� ������ CROSS JOIN-���������� ������ AUDITORIUM_TYPE � AUDITORIUM, ������������ ���������, 
����������� ���������� ������� � ������� 1*/
select AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM.AUDITORIUM
from AUDITORIUM_TYPE cross join AUDITORIUM
where AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE
