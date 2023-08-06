--1 ����������� ��������� ������� � ������ COUNT_STUDENTS, ������� ��������� ���������� ���-������ �� ����������, ��� 
--�������� �������� ���������� ���� varchar(20) � ������ @faculty. ������������ ����-������ ���������� ������ FACULTY, GROUPS, STUDENT. ���������� ������ �������.
--������ ��������� � ����� ������� � ������� ��������� ALTER � ���, ����� ������� ��������� ������ �������� @prof ���� varchar(20), 
--������������ ������������� ���-������. ��� ���������� ���������� �������� �� ��������� NULL. ���������� ������ ������� � ������� SELECT-��������.
USE UNIVER;
go
CREATE function COUNT_STUDENTS(@faculty varchar(20)) returns int
as begin 
	declare @rc int = 0;
	set @rc = (select count(*) 
		from STUDENT
		Join GROUPS ON STUDENT.IDGROUP = GROUPS.IDGROUP
		Join FACULTY ON GROUPS.FACULTY = FACULTY.FACULTY
		where FACULTY.FACULTY = @faculty);
	return @rc;
end;
go
--------------------------------------------
declare @f int = dbo.COUNT_STUDENTS('����');
print '���������� ��������� �� ����������: ' + cast(@f as varchar(4));

go
ALTER function dbo.COUNT_STUDENTS(@faculty varchar(20) = null, @prof varchar(20) = null) returns int
as begin 
	declare @rc int = 0;
	set @rc = (select count(*) 
		from STUDENT
		Join GROUPS ON STUDENT.IDGROUP = GROUPS.IDGROUP
		Join FACULTY ON GROUPS.FACULTY = FACULTY.FACULTY
		where FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = @prof);
	return @rc;
end;
go

print dbo.COUNT_STUDENTS('����', '1-36 07 01')

drop function COUNT_STUDENTS

--2 ����������� ��������� ������� � ������ FSUBJECTS, ����������� �������� @p ���� varchar(20), 
--�������� ��-������ ������ ��� ������� (������� SUBJECT.PULPIT). 
--������� ������ ���������� ������ ���� varchar(300) � �������� ��������� � ������. 
create function FSUBJECTS(@pulpit varchar(20)) returns varchar(300)
as begin 
	declare @disc char(20);
	declare @line varchar(300) = '����������: ';
	declare Subj CURSOR LOCAL
	for	select SUBJECT.SUBJECT from SUBJECT 
		where SUBJECT.PULPIT = @pulpit;
	open Subj;
	fetch Subj into @disc;
	while @@FETCH_STATUS = 0
	begin
		set @line += rtrim(@disc) + ', ';
		FETCH Subj into @disc;
	end;
	return @line;
end;
go
------------------------------
select PULPIT, dbo.FSUBJECTS(PULPIT) from PULPIT

drop function FSUBJECTS;

--3. ����������� ��������� ������� FFACPUL, ���������� ������ ������� ������������������ �� ������� ����. 
--������� ��������� ��� ���������, �������� ��� ��-�������� (������� FACULTY.FACULTY) � ��� ������� (������� PULPIT.PULPIT). ���������� SELECT-������ c ����� ������� ����������� ����� ��������� FACULTY � PULPIT. 
--���� ��� ��������� ������� ����� NULL, �� ��� ���-������� ������ ���� ������ �� ���� �����������. 
--���� ����� ������ �������� (������ ����� NULL), ����-��� ���������� ������ ���� ������ ��������� ����������. 

create function FFACPUL(@f varchar(20), @p varchar(20)) returns table
as return
	select f.FACULTY, p.PULPIT
	from FACULTY f left outer join PULPIT p
	on f.FACULTY = p.FACULTY
	where f.FACULTY = isnull(@f, f.FACULTY)
	and p.PULPIT = isnull(@p, p.PULPIT)
go

-----------------------------------
select * from dbo.FFACPUL(null, null);
select * from dbo.FFACPUL('����', null);
select * from dbo.FFACPUL(null, '�����');
select * from dbo.FFACPUL('����', '�����');

drop function FFACPUL

--4 �� ������� ���� ������� ��������, ��������������� ��-���� ��������� ������� FCTEACHER. ������� �������-�� ���� ��������, �������� ��� �������. 
--������� ������-���� ���������� �������������� �� �������� ���������� �������. ���� �������� ����� NULL, ��
--������������ ��-��� ���������� ��������������. 
create function FCTEACHER(@p varchar(20)) returns int
as begin
	declare @rc int = (select count(*) from TEACHER p
	where p.PULPIT = isnull(@p,p.PULPIT));
	return @rc;
end;
go

----------------------------
select PULPIT, dbo.FCTEACHER(PULPIT) from TEACHER
select dbo.FCTEACHER(null);

drop function FCTEACHER

--6
go
create function PulpitCount(@faculty varchar(50)) returns int
as
begin
	 declare @pulpitCount int = 0
	 set @pulpitCount = (select count(*)
							from PULPIT
								where PULPIT.FACULTY = @faculty)
	return @pulpitCount
end
go
go
create function GroupCount(@faculty varchar(50)) returns int
as
begin
	 declare @groupCount int = 0
	 set @groupCount = (select count(*)
							from GROUPS
								where GROUPS.FACULTY = @faculty)
	return @groupCount
end
go
go
create function StudentCount(@faculty varchar(50)) returns int
as
begin
	declare @studentCount int = 0
	set @studentCount = (select count(*) 
							from STUDENT 
							Inner Join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
							Inner Join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY
								where FACULTY.FACULTY = @faculty)
	return @studentCount
end
go
go
create function ProfessionCount(@faculty varchar(50)) returns int
as
begin
	 declare @professionCount int = 0
	 set @professionCount = (select count(*)
							from PROFESSION
								where PROFESSION.FACULTY = @faculty)
	return @professionCount
end
go

go
create function FacultyReport(@studentCount int) returns  @result table
(
	faculty varchar(50),
	pulpitCount int, 
	groupCount int, 
	professionCount int
)
as begin
	declare FacultyCursor cursor local for
		select FACULTY from FACULTY where dbo.StudentCount(FACULTY) > @studentCount
	declare @faculty varchar(50)
	open FacultyCursor
		fetch FacultyCursor into @faculty
		while @@FETCH_STATUS = 0
		begin
			insert into @result values
			(@faculty, dbo.PulpitCount(@faculty), dbo.GroupCount(@faculty), dbo.ProfessionCount(@faculty))

			fetch FacultyCursor into @faculty
		end
	close FacultyCursor
	return
end
go

select FACULTY, dbo.StudentCount(FACULTY)[student count] from FACULTY
select * from dbo.FacultyReport(10)

drop function FacultyReport