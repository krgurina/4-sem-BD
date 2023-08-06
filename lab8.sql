use UNIVER;
go
--1 ����������� ������������� � ������ �������������. 
create view [�������������]
as select 
TEACHER.TEACHER[���],
TEACHER.TEACHER_NAME[��� �������������], 
TEACHER.GENDER[���],
TEACHER.PULPIT[�������]
from TEACHER;
go
select * from [�������������]

drop view [�������������]

/*2. ����������� � ������� ������������� � ������ ���������� ������. ������������� ������ ���� ��������� 
�� ������ SELECT-������� � �������� FACULTY � PULPIT.������������� ������ ��������� ��������� �������: 
���������, ���������� ������ (����������� �� ������ ����� ������� PULPIT). 
*/
go
create view [���������� ������]
as select 
f.FACULTY[���������], COUNT(p.PULPIT)[���������� ������]
from FACULTY f inner join PULPIT p
on f.FACULTY=p.FACULTY
group by f.FACULTY
go
select * from [���������� ������] order by [���������� ������]
go 
drop view [���������� ������]

/*3. ����������� � ������� ������������� � ������ ���������. ������������� ������ ���� ��������� �� ������ ������� AUDITORIUM 
� ��������� �������: ���, ������������ ���������. 
������������� ������ ���������� ������ ���������� ��������� (� ������� AUDITORIUM_ TYPE ������, ������������ � ������� ��)
� ��������� ���������� ��������� INSERT, UPDATE � DELETE.
*/
create view ���������(���, [������������ ���������])
as select AUDITORIUM, AUDITORIUM_TYPE from AUDITORIUM
where AUDITORIUM_TYPE like '%��%'
go

insert ��������� values('530-3�','��')

select * from ���������
go
alter view ���������
	as select AUDITORIUM.AUDITORIUM [���],
				AUDITORIUM.AUDITORIUM_NAME [������������ ���������],
				AUDITORIUM.AUDITORIUM_TYPE [��� ���������]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like '��%';
go
select * from ���������
insert ��������� values('300-3�','300-3�','��')
--insert ��������� values('132-4','��')
--insert ��������� values('100-3�','��')
--select * from ���������

update ���������
set [������������ ���������]=���
where ([������������ ���������]is null)
select * from ���������
go
delete  ���������
where [������������ ���������]='300-3�'
select * from ���������
go
drop view ���������

--4
create view ����������_���������(���, [������������ ���������])
as select AUDITORIUM, AUDITORIUM_TYPE from AUDITORIUM
where AUDITORIUM_TYPE like '%��%' with check option
go
select * from ����������_���������

insert ����������_��������� values('500-1','��')
select * from ����������_���������
drop view ����������_���������

/*5. ����������� ������������� � ������ ����������. ������������� ������ ���� ��������� �� ������ 
SELECT-������� � ������� SUBJECT, ���������� ��� ���������� � ���������� ������� � ��������� ��������� 
�������: ���, ������������ ���������� � ��� �������*/
create view ����������(���, [������������ ����������], [��� �������])
as select top 100 SUBJECT, SUBJECT_NAME, PULPIT from SUBJECT
order by SUBJECT_NAME
go
select * from ����������
drop view ����������

--
-- �� 2 �������
create view [���������� ������]
as select 
	f.FACULTY[���������], 
	COUNT(p.PULPIT)[���������� ������]
from FACULTY f inner join PULPIT p
	on f.FACULTY=p.FACULTY
group by f.FACULTY
--6
go
alter view [���������� ������] with schemabinding
as select 
	f.FACULTY[���������], 
	COUNT(p.PULPIT)[����������]
from dbo.FACULTY f inner join dbo.PULPIT p
	on f.FACULTY=p.FACULTY
group by f.FACULTY
go

select * from [���������� ������] order by [����������]

drop view [���������� ������]


