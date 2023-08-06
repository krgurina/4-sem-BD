use UNIVER;
/*1. �� ������ ������ AUDITORIUM � AUDITORIUM_TYPE ����������� ������, ����������� ��� ������� ���� ��������� ������������, �����������, 
������� ����������� ���������, ��������� ����������� ���� ��������� � ����� ���������� ��������� ������� ����. 
�������������� ����� ������ ��������� ������� � ������������� ���� ��������� � ������� � ������������ ����������. 
*/
select AUDITORIUM.AUDITORIUM_TYPE,
max(AUDITORIUM.AUDITORIUM_CAPACITY)[MAX �����������],
min(AUDITORIUM.AUDITORIUM_CAPACITY)[MIN �����������],
avg(AUDITORIUM.AUDITORIUM_CAPACITY)[AVG �����������]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE 
group by AUDITORIUM.AUDITORIUM_TYPE

/*2. �� ������ ������ AUDITORIUM � AUDITORIUM_TYPE ����������� ������, ����������� ��� ������� ���� ��������� ������������, �����������, 
������� ����������� ���������, ��������� ����������� ���� ��������� � ����� ���������� ��������� ������� ����. 
�������������� ����� ������ ��������� ������� � ������������� ���� ��������� � ������� � ������������ ����������. 
*/
select AUDITORIUM.AUDITORIUM_TYPE,
max(AUDITORIUM.AUDITORIUM_CAPACITY)[MAX �����������],
min(AUDITORIUM.AUDITORIUM_CAPACITY)[MIN �����������],
avg(AUDITORIUM.AUDITORIUM_CAPACITY)[AVG �����������],
sum(AUDITORIUM.AUDITORIUM_CAPACITY)[SUM �����������],
count(*)[���-��]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE 
group by AUDITORIUM.AUDITORIUM_TYPE

/*3. ����������� ������ �� ������ ������� PROGRESS, ������� ����� ��������� �������� ���������������
������ � �� ���������� � �������� ���������. 
���������� ����� ������ �������������� � �������, �������� �������� ������.
*/
select *
from (select Case 
	when PROGRESS.NOTE between 1 and 3 then '�� �����'
	when PROGRESS.NOTE between 4 and 7 then '�����������������'
	when PROGRESS.NOTE between 8 and 10 then '�������'
	end [������], count(*)[����������]
from PROGRESS group by Case
when PROGRESS.NOTE between 1 and 3 then '�� �����'
when PROGRESS.NOTE between 4 and 7 then '�����������������'
when PROGRESS.NOTE between 8 and 10 then '�������'
end) as T
order by Case [������]
	when '�� �����' then 3
	when '�����������������' then 2
	when '�������' then 1
	else 0
end

/*4. ����������� SELECT-������� �� ������ ������ FACULTY, GROUPS, STUDENT � PROGRESS, ������� �������� ������� ��������������� 
������ ��� ������� ����� ������ ������������� � ����������. 
������ ������������� � ������� �������� ������� ������.
������� ������ ������ �������������� � ��������� �� ���� ������ ����� �������.
*/
select h.FACULTY, g.YEAR_FIRST, g.PROFESSION, round(avg(cast(f.NOTE as float(4))),2)[������� ������]
from PROGRESS f inner join SUBJECT c
on c.SUBJECT=f.SUBJECT
inner join STUDENT s
on f.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP=g.IDGROUP
inner join FACULTY h
on g.FACULTY=h.FACULTY
group by h.FACULTY, g.YEAR_FIRST, g.PROFESSION
order by [������� ������] desc

/*5. ���������� SELECT-������, ������������� � ������� 4, ��� ����� � ������� �������� �������� ������ 
�������������� ������ ������ �� ����������� � ������ �� � ����.*/
select h.FACULTY, g.YEAR_FIRST, g.PROFESSION, c.SUBJECT, round(avg(cast(f.NOTE as float(4))),2)[������� ������]
from PROGRESS f inner join SUBJECT c
on c.SUBJECT=f.SUBJECT
inner join STUDENT s
on f.IDSTUDENT=s.IDSTUDENT
inner join GROUPS g
on s.IDGROUP=g.IDGROUP
inner join FACULTY h
on g.FACULTY=h.FACULTY
where c.SUBJECT like '%��%' or c.SUBJECT like '%����%'
group by h.FACULTY, g.YEAR_FIRST, g.PROFESSION,c.SUBJECT
order by [������� ������] desc

/*6. �� ������ ������ FACULTY, GROUPS, STUDENT � PROGRESS ����������� ������, � ������� ��������� �������������, ���������� � 
������� ������ ��� ����� ��������� �� ���������� ���. */
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
order by [������� ������] desc

--7
select p1.SUBJECT, p1.NOTE,
(select count(*) from PROGRESS p2
where p1.SUBJECT=p2.SUBJECT and p1.NOTE = p2.NOTE) [����������]
from PROGRESS p1
group by p1.SUBJECT, p1.NOTE
having NOTE=8 or NOTE=9
order by NOTE desc