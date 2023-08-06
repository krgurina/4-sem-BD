use G_MyBase
--1
go
create procedure PSUBJECT
as
begin
	declare @k int = (select count(*) from ������);
	select ������.ID_������[���], ������.��������_������ [��������], ������.���� [����] from ������;
	return @k;
end

declare @k int = 0;
exec @k = PSUBJECT;
print '���������� ����� ' + cast(@k as varchar(3))

--drop procedure PSUBJECT

--2
declare @k int = 0, @r int = 0, @p varchar(20);
exec @k = PSUBJECT @p='ak111' ,@c =@r output;
print '���������� ����� ' + cast(@k as varchar(3))
print '���������� ����� ak111' + cast(@r as varchar(3))

--3 ������� ��������� ��������� ������� � ������ #SUBJECT. ������������ � ��� �������� ������� ������ ��������������� 
--�������� ��������������� ������ ��������� PSUBJECT, ������������� � ������� 2. 
--�������� ��������� PSUBJECT ����� �������, ����� ��� �� ��������� ��������� ���������.
--�������� ����������� INSERT� EXECUTE � ���������������� ���������� PSUBJECT, �������� ������ � ������� #SUBJECT. 
go
create table #SUBJECT
(
  ID_������ int primary key,
  ��������_������ varchar(100),
  ���� int
);

go

ALTER procedure [dbo].[PSUBJECT] @p varchar(20)
as
begin
	declare @k int = (select count(*) from ������);
		print '��������: @p=' + @p
	select ID_������[���], ��������_������ [��������], ���� [����] from ������ 
	where ��������_������ = @p
	return @k;
end
go

insert #SUBJECT exec PSUBJECT @p = '���������'  
insert #SUBJECT exec PSUBJECT @p = '�����������'  

select * from #SUBJECT
drop table #SUBJECT

--4 ����������� ��������� � ������ PAUDITORIUM_INSERT. ��������� ��������� ������ ������� ���������: @a, @n, @c � @t. 
--�������� @a ����� ��� CHAR(20), �������� @n ����� ��� VARCHAR(50), �������� @c ����� ��� INT � �������� �� ��������� 0, �������� @t ����� ��� CHAR(10).
--��������� ��������� ������ � ������� AUDITORIUM. �������� �������� AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY � AUDITORIUM_TYPE ����������� ������ 
--�������� �������������� ����������� @a, @n, @c � @t.

go
create procedure PAUDITORIUM_INSERT @a int, @n varchar(50), @c int = 0, @t int
as 
begin try
  insert into ������(ID_������, ��������_������, ����, ���_����������)
    values(@a, @n, @c, @t)
  return 1
end try
begin catch
	print '����� ������  : ' + cast(error_number() as varchar(6));
    print '���������     : ' + error_message();
    print '�������       : ' + cast(error_severity()  as varchar(6));
    print '�����         : ' + cast(error_state()   as varchar(8));
    print '����� ������  : ' + cast(error_line()  as varchar(8));
	if ERROR_PROCEDURE() is not null
	print '��� ��������� : ' + error_procedure();
    return -1;    
end catch;


declare @rc int;
exec @rc=PAUDITORIUM_INSERT @a=24,@n='����� ������',@c=60,@t=111;
print'��� ������ '+cast(@rc as varchar(3));
select * from ������


--5 ����������� ��������� � ������ SUBJECT_REPORT, ����������� � ����������� �������� ����� ����� �� ������� ��������� �� ���-������� �������. � ����� ������ 
--���� �������� ������� �������� (���� SUBJECT) �� ������� SUBJECT � ���� ������ ����� ������� (������������ ���������� ������� RTRIM). ��������� ����� ������� 
--�������� � ������ @p ���� CHAR(10), ����-��� ������������ ��� �������� ���� �������.
--� ��� ������, ���� �� ��������� �������� @p ��-�������� ���������� ��� �������, ��������� ������ ������������ ������ � ���������� ������ � ����-������. 
go
create procedure [SUBJECT REPORT] @p int
as declare @rc int = 0
begin try
	declare @subjectName nvarchar(15) = '', @subjectline nvarchar(150) = '';
	declare Subj CURSOR for
	select ��������_������ from ������
		where ���_���������� = @p;
	if not exists(select ��������_������ from ������ where ���_���������� = @p)
	begin
		raiserror('��� �� ����� ������ � ����� ����������', 11, 1)
		return 0
	end
	else
	begin
		open Subj;
		fetch Subj into @subjectName;
		print '������ ����������� ����������';
		while @@FETCH_STATUS = 0
			begin
				set @subjectline = rtrim(@subjectName) + ', ' + @subjectline;
				set @rc = @rc + 1;
				fetch Subj into @subjectName;
			end;
		print @subjectline;
		close Subj;
		deallocate Subj;
		return @rc;
	end;
end try
begin catch
	close Subj;
	deallocate Subj;
	print '������ � ����������'
	if ERROR_PROCEDURE() is not null
		print '��� ���������: ' + cast (error_procedure() as varchar(20)); 
		print '����� ������: ' + cast(error_line() as varchar(8));
		print '���������: ' + error_message(); 
		if ERROR_PROCEDURE() is not null
		print '��� ��������� : ' + error_procedure();
		return @rc;
end catch;
go


declare @rc int;
exec @rc = [SUBJECT REPORT] @p = 111;
print '���������� ��������� = ' + cast(@rc as varchar(3));

drop procedure [SUBJECT REPORT]
go

--6 ����������� ��������� � ������ PAUDITORI-UM_INSERTX. ��������� ��������� ���� ������� ����������: @a, @n, @c, @t � @tn. 
--��������� @a, @n, @c, @t ���������� �������-��� ��������� PAUDITORIUM_INSERT. �������� @tn �������� �������, ����� ��� VARCHAR(50), ������������ ��� ����� �������� � ������� AUDITO-RIUM_TYPE.AUDITORIUM_TYPENAME.
--��������� ��������� ��� ������. ������ ������ ����������� � ������� AUDITORIUM_TYPE. �����-��� �������� AUDITORIUM_TYPE � AUDITORI-UM_ TYPENAME �������� �������������� �������-���� @t � @tn.
--������ ������ ����������� ����� ��-���� ��������� PAUDITORIUM_INSERT.

go
create proc PAUDITORIUM_INSERTX 
@a int, @n varchar(50), @c int = 0, @t int, @tn varchar(70)
as 
begin try
	set transaction isolation level SERIALIZABLE
	begin tran
		insert into ���������� (���_����������, ��������)
		values (@t, @tn)
		exec PAUDITORIUM_INSERT @a, @n, @c, @t
	commit tran
end try
begin catch
	print '����� ������ :  ' + cast(ERROR_NUMBER() as varchar)
	print '��������� : ' + error_message();
    print '������� : ' + cast(error_severity()  as varchar(6));
	print '����� ������: ' + cast(error_line() as varchar(8));
	if ERROR_PROCEDURE() is not null
	print '��� ��������� : ' + error_procedure();
	if @@TRANCOUNT > 0 
		rollback tran
	return -1
end catch


exec PAUDITORIUM_INSERTX @a = 30, @n = '���� 6 ������', @c = 507, @t = 444, @tn = '����� ���������'
select * from ����������
drop procedure PAUDITORIUM_INSERTX
drop procedure PAUDITORIUM_INSERT