use UNIVER;
/*
1. �� ������ ������ FACULTY, PULPIT � PROFESSION ������������ ������ ������������ ������, ������� ��������� �� ����������, 
�������������� ���������� �� �������������, � ������������ �������� ���������� ����� ���������� ��� ����������. 
������������ � ������ WHERE �������� IN c ����������������� ����������� � ������� PROFESSION. 
*/
select FACULTY.FACULTY, PULPIT.PULPIT_NAME
from FACULTY, PULPIT
where FACULTY.FACULTY=PULPIT.FACULTY and FACULTY.FACULTY in (select PROFESSION.FACULTY from PROFESSION where (PROFESSION_NAME like '%����������%' or PROFESSION_NAME like '%����������%'))/*

2. ���������� ������ ������ 1 ����� �������, ����� ��� �� ��������� ��� ������� � ����������� INNER JOIN ������ FROM �������� �������. 
��� ���� ��������� ���������� ������� ������ ���� ����������� ���������� ��������� �������. */
select FACULTY.FACULTY, PULPIT.PULPIT_NAME
from FACULTY inner join PULPIT
on FACULTY.FACULTY=PULPIT.FACULTY
where FACULTY.FACULTY in (select PROFESSION.FACULTY from PROFESSION where (PROFESSION_NAME like '%����������%' or PROFESSION_NAME like '%����������%'))

/*
3. ���������� ������, ����������� 1 ����� ��� ������������� ����������. ����������: ������������ ���������� INNER JOIN ���� ������. */
select distinct FACULTY.FACULTY, PULPIT.PULPIT_NAME
from FACULTY inner join PULPIT
on FACULTY.FACULTY=PULPIT.FACULTY
inner join PROFESSION 
on FACULTY.FACULTY=PROFESSION.FACULTY
where PROFESSION_NAME like '%����������%' or PROFESSION_NAME like '%����������%'

/*4. �� ������ ������� AUDITORIUM ������������ ������ ��������� ����� ������� ������������ ��� ������� ���� ���������. 
��� ���� ��������� ������� ������������� � ������� �������� �����������. ����������: ������������ ������������� ��������� c �������� TOP � ORDER BY. */
select AUDITORIUM_NAME, AUDITORIUM_TYPE,AUDITORIUM_CAPACITY
from AUDITORIUM a
where AUDITORIUM_CAPACITY=(
select top(1) AUDITORIUM_CAPACITY 
from AUDITORIUM aa
where aa.AUDITORIUM_TYPE=a.AUDITORIUM_TYPE
order by AUDITORIUM_CAPACITY desc)

/*5. �� ������ ������ FACULTY � PULPIT ������������ ������ ������������ ����������� �� ������� ��� �� ����� ������� (������� PULPIT). 
������������ �������� EXISTS � ��������������� ���������. */
select FACULTY_NAME[���������� ��� ������]
from FACULTY
where not exists (select PULPIT.PULPIT from PULPIT
where FACULTY.FACULTY=PULPIT.FACULTY)

/*6. �� ������ ������� PROGRESS ������������ ������, ���������� ������� �������� ������ (������� NOTE) 
�� �����������, ������� ��������� ����: ����, �� � ����. ����������: ������������ ��� ����������������� ���������� 
� ������ SELECT; � ����������� ��������� ���������� ������� AVG. */
select top 1
(select avg(PROGRESS.NOTE)from PROGRESS
	where PROGRESS.SUBJECT like '����')[����],
(select avg(PROGRESS.NOTE)from PROGRESS
	where PROGRESS.SUBJECT like '����')[����],
(select avg(PROGRESS.NOTE)from PROGRESS
	where PROGRESS.SUBJECT like '��')[��]
from PROGRESS

/*7. ����������� SELECT-������, ��������������� ������ ���������� ALL ��������� � �����������.*/
SELECT NAME, SUBJECT, NOTE
FROM STUDENT, PROGRESS
WHERE  PROGRESS.SUBJECT like '����' and NOTE>=all (SELECT PROGRESS.NOTE FROM PROGRESS
	WHERE PROGRESS.NOTE<=5)

/*8. ����������� SELECT-������, ��������������� ������� ���������� ANY ��������� � �����������.*/
SELECT * FROM AUDITORIUM
WHERE AUDITORIUM_CAPACITY > ANY(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM
			WHERE AUDITORIUM_TYPE LIKE '%��%')
ORDER BY AUDITORIUM_CAPACITY asc

/*10. ����� � ������� STUDENT ���������, � ������� ���� �������� � ���� ����. ��������� �������.*/
SELECT distinct s1.IDSTUDENT, s1.NAME, s1.BDAY 
FROM STUDENT s1 inner join STUDENT s2
	ON (s1.BDAY = s2.BDAY and s1.IDSTUDENT != s2.IDSTUDENT)
ORDER BY s1.BDAY desc

