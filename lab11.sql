use UNIVER
--1. ����������� ��������, ����������� ������ ��������� �� ������� ����.
--� ����� ������ ���� �������� ������� �������� ��������� �� ������� SUBJECT � ���� ������ ����� �������. 
declare @subj char(20), @s char(300)='';
declare curSubj cursor for select SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT = '����'
open curSubj;
	fetch curSubj into @subj --������ ������������ �� ������� � ���������� @subj.
	print '������� �������� ��������� '
	while @@FETCH_STATUS = 0
		begin
		set @s = RTRIM(@subj) + ',' + @s;
		fetch curSubj into @subj
	end;
	print @s;
Close curSubj;
deallocate curSubj;

-- 2. ����������� ��������, ��������������� ������� ����������� ������� 
--�� ���������� �� ������� ���� ������ UNIVER.
declare Puls cursor local for select PULPIT, FACULTY from PULPIT;
declare @pul nvarchar(10), @fac nvarchar(4);
open Puls;
	fetch Puls into @pul, @fac;
    print '1. '+ rtrim(@pul)+' ���������: '+ @fac;
	go

	declare @pul nvarchar(10), @fac nvarchar(4);     	
	fetch Puls into @pul, @fac; 	
    print '2. '+ rtrim(@pul)+' ���������: '+ @fac;
	go

-- ����������
declare Puls cursor for select PULPIT, FACULTY from PULPIT;
declare @pul nvarchar(10), @fac nvarchar(4);

open Puls;
	fetch Puls into @pul, @fac;
    print '1. '+ rtrim(@pul)+' ���������: '+ @fac;
	go

	declare @pul nvarchar(10), @fac nvarchar(4);     	
	fetch Puls into @pul, @fac; 	
    print '2. '+ rtrim(@pul)+' ���������: '+ @fac;
	go
 close Puls;
deallocate Puls;

-- 3. ����������� ��������, ��������������� ������� ����������� 
--�������� �� ������������ �� ������� ���� ������ UNIVER.
declare cur cursor local static for (select AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY from AUDITORIUM)
declare @name varchar(10)
declare @type varchar(5)
declare @cap int

open cur
print '����� � �������: ' + cast(@@cursor_rows as char)
update AUDITORIUM set AUDITORIUM_TYPE = '��' where AUDITORIUM = '100-3�'		
fetch cur into @name, @type, @cap
while @@FETCH_STATUS = 0
begin
	print @name + ' ' + @type + ' ' + cast(@cap as char) 
	fetch cur into @name, @type, @cap
end
close cur


go
-- ������������
declare cur cursor local dynamic for (select AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY from AUDITORIUM)
declare @name varchar(10)
declare @type varchar(5)
declare @cap int

open cur
print '����� � �������: ' + cast(@@cursor_rows as char)
update AUDITORIUM set AUDITORIUM_TYPE = '��-�' where AUDITORIUM = '100-3�'		
fetch cur into @name, @type, @cap
while @@FETCH_STATUS = 0
begin
	print @name + ' ' + @type + ' ' + cast(@cap as char) 
	fetch cur into @name, @type, @cap
end
close cur
deallocate cur
--select * from AUDITORIUM

-- 4. ����������� ��������, ��������������� �������� ��������� � �������������� ������ 
--������� � ��������� SCROLL �� ������� ���� ������ UNIVER.
--������������ ��� ��������� �������� ����� � ��������� fetch.

declare cur cursor local dynamic scroll for 
	select row_number() over (order by SUBJECT), IDSTUDENT, SUBJECT, NOTE from PROGRESS
declare @rn int, @id varchar(10), @sub varchar(15), @nt int
open cur

fetch cur into @rn, @id, @sub, @nt
print 'First:		' + cast(@rn as varchar) + '. ID ��������: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ������: ' + cast(@nt as varchar)

fetch next from cur into @rn, @id, @sub, @nt
print 'Next:		' + cast(@rn as varchar) + '. ID ��������: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ������: ' + cast(@nt as varchar)

fetch prior from cur into @rn, @id, @sub, @nt
print 'Prior:		' + cast(@rn as varchar) + '. ID ��������: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ������: ' + cast(@nt as varchar)

fetch absolute 3 from cur into @rn, @id, @sub, @nt
print 'absolute 3:	' + cast(@rn as varchar) + '. ID ��������: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ������: ' + cast(@nt as varchar)

fetch absolute -3 from cur into @rn, @id, @sub, @nt
print 'absolute -3:' + cast(@rn as varchar) + '. ID ��������: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ������: ' + cast(@nt as varchar)

fetch relative 2 from cur into @rn, @id, @sub, @nt
print 'relative 2:	' + cast(@rn as varchar) + '. ID ��������: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ������: ' + cast(@nt as varchar)

fetch relative -2 from cur into @rn, @id, @sub, @nt
print 'relative -2:' + cast(@rn as varchar) + '. ID ��������: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ������: ' + cast(@nt as varchar)

fetch last from cur into @rn, @id, @sub, @nt
print 'Last:		' + cast(@rn as varchar) + '. ID ��������: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ������: ' + cast(@nt as varchar)

close cur

-- 5. ������� ������, ��������������� ���������� ����������� CURRENT OF 
--� ������ WHERE � �������������� ���������� UPDATE � DELETE.

declare cur cursor local dynamic for 
	select IDSTUDENT, SUBJECT, NOTE from PROGRESS FOR UPDATE
declare @id varchar(10), @sub varchar(15), @nt int

open cur
fetch cur into @id, @sub, @nt
while @@FETCH_STATUS = 0
begin
	if @nt = 9 update PROGRESS set NOTE = 10 where CURRENT OF cur
	if @id = 1083 delete PROGRESS where CURRENT OF cur

	print 'ID ��������: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ������: ' + cast(@nt as varchar)
	fetch cur into @id, @sub, @nt
end
close cur

-- 6. ����������� select-������, � ������� �������� �� ������� PROGRESS ��������� ������, 
--���������� ���������� � ���������, ���������� ������ ���� 4 (������������ ����������� ������ 
--PROGRESS, STUDENT, GROUPS). 
declare cur cursor local dynamic for 
	select g.IDGROUP, s.NAME, p.NOTE from PROGRESS p
	join STUDENT s on s.IDSTUDENT = p.IDSTUDENT
	join GROUPS g on s.IDGROUP = g.IDGROUP
	where p.NOTE < 4
		FOR UPDATE
declare @gr varchar(5), @nm varchar(50), @nt int
open cur
fetch cur into @gr, @nm, @nt
while @@FETCH_STATUS = 0
	begin
		print @gr + ': ' + @nm + ' ������: ' + cast(@nt as varchar)
		delete PROGRESS where CURRENT OF cur	
		delete STUDENT where CURRENT OF cur
		fetch cur into @gr, @nm, @nt

	end
close cur

--����������� select-������, � ������� �������� � ������� PROGRESS ��� �������� � ���������� 
--������� IDSTUDENT �������������� ������ (������������� �� �������).
declare cur cursor local dynamic for 
	select IDSTUDENT, SUBJECT, NOTE from PROGRESS FOR UPDATE
declare @id varchar(10), @sub varchar(15), @nt int

open cur
fetch cur into @id, @sub, @nt
while @@FETCH_STATUS = 0
	begin
		if @id = 1003 update PROGRESS set NOTE = NOTE+1 where CURRENT OF cur
		print 'ID ��������: ' + @id + ' �������: ' + rtrim(cast(@sub as varchar)) + ' ������: ' + cast(@nt as varchar)
		fetch cur into @id, @sub, @nt
	end
close cur

--8 ��������� 
declare cur cursor local static for
  select f.FACULTY, p.PULPIT, count(t.TEACHER_NAME), string_agg(RTRIM(s.SUBJECT), ', ')
  from FACULTY f 
  join PULPIT p on p.FACULTY = f.FACULTY
  join SUBJECT s on s.PULPIT = p.PULPIT
  join TEACHER t on t.PULPIT = p.PULPIT
  group by f.FACULTY, p.PULPIT

declare @fc varchar(10), @pl varchar(10), @cn int, @sb varchar(200)

open cur
fetch cur into @fc, @pl, @cn, @sb
while @@FETCH_STATUS = 0
  begin
    print '���������: ' + RTRIM(@fc) + char(13) + char(9) + '�������: ' +  RTRIM(@pl) + char(13) + char(9) + char(9) + '���������� ��������������: ' + cast(@cn as varchar) + char(13) + char(9) + char(9) + '����������: ' + @sb
    fetch cur into @fc, @pl, @cn, @sb
  end
close cur



--8 
declare @faculty nvarchar(10), @pulpitcount int, 
		@pulpitn nvarchar(10), @teachercount int, 
		@subjectn nvarchar(15), @subjectPulpit nvarchar(50), @subjectarray nvarchar(300) = ''

declare @i int

declare Faculty cursor local dynamic
	for select FACULTY.FACULTY, COUNT(*) 
	from FACULTY
	Inner Join PULPIT ON PULPIT.FACULTY = FACULTY.FACULTY
	GROUP BY FACULTY.FACULTY 
	ORDER BY FACULTY.FACULTY

declare Pulpit cursor local dynamic
	for select PULPIT.PULPIT, COUNT(*) 
	from PULPIT
	Left Outer Join TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT
	GROUP BY FACULTY, PULPIT.PULPIT
	ORDER BY FACULTY

declare Subjectt cursor local dynamic
	for select SUBJECT.SUBJECT, SUBJECT.PULPIT
	from SUBJECT

open Faculty
open Pulpit 
	fetch from Faculty into @faculty, @pulpitcount
	print '���������: ' + @faculty
	while @@FETCH_STATUS = 0
	begin
		SET @i = 0
		while @i < @pulpitcount
			begin
				SET @subjectarray = ''
				fetch from Pulpit into @pulpitn, @teachercount
				print char(9) + '�������: ' + @pulpitn
				print char(9) + char(9) + '���������� ��������������: ' + cast(@teachercount as nvarchar(10))

				open Subjectt
					fetch from Subjectt into @subjectn, @subjectPulpit
					IF (@subjectPulpit = @pulpitn)
						SET @subjectarray = trim(@subjectn) + ', ' + @subjectarray

						while @@FETCH_STATUS = 0
							begin 
								fetch from Subjectt into @subjectn, @subjectPulpit
								IF (@subjectPulpit = @pulpitn)
									SET @subjectarray = trim(@subjectn) + ', ' + @subjectarray
							end
				close Subjectt

				IF len(@subjectarray) > 0
					SET @subjectarray = left(@subjectarray, len(@subjectarray)-1)
				ELSE
					SET @subjectarray = '���'
					print char(9) + char(9) + '����������: ' + @subjectarray
					SET @i = @i+1
				end

			fetch from Faculty into @faculty, @pulpitcount
			IF (@@fetch_status = 0) print '���������: ' + @faculty
		end

close Faculty
close Pulpit
go
