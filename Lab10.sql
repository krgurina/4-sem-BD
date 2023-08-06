--1. ���������� ��� �������, ������� ������� � �� UNIVER. 
use UNIVER
exec sp_helpindex 'AUDITORIUM';
exec sp_helpindex 'AUDITORIUM_TYPE';
exec sp_helpindex 'FACULTY';
exec sp_helpindex 'GROUPS';
exec sp_helpindex 'PROFESSION';
exec sp_helpindex 'PROGRESS';
exec sp_helpindex 'PULPIT';
exec sp_helpindex 'SUBJECT';
exec sp_helpindex 'TEACHER';
exec sp_helpindex 'STUDENT';

--������� ��������� ��������� �������. ��������� �� ������� (�� ����� 1000 �����). 
--����������� � ������������ �� ���������� ������������� ��������
--����������� SELECT-������. �������� ���� ������� � ���������� ��� ���������. 
--������� ���������������� ������, ����������� ��������� SELECT-�������.

create table #temp_table
(number int,
string varchar(100));
 
set nocount on;
declare @i int = 0;
while @i < 3000
begin 
  insert #temp_table values(floor(3000*rand()), replicate('������',10));
  set @i = @i + 1;
end

select #temp_table.number
from #temp_table
where number between 1000 and 2000 order by number;

checkpoint;  --�������� ��
DBCC DROPCLEANBUFFERS;  --�������� �������� ���

Create clustered index #temp_CL on #temp_table(number asc);

select #temp_table.number
from #temp_table
where number between 1000 and 2000 order by number;

drop table #temp_table;

--2 ����������� SELECT-������. �������� ���� ������� � ���������� ��� ���������. 
--������� ������������������ ������������ ��������� ������.�� ������ �� ���������� ������� ����� 
--������� ��������� ������ ��-��������.�� ���������� �������� 

CREATE table #EX
(TKEY int, 
CC int identity(1, 1),
TF varchar(100));

set nocount on;
declare @i1 int = 0; 
while   @i1 < 20000       -- ���������� � ������� 20000 �����
begin
  INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('������ ', 10));
  set @i1 = @i1 + 1; 
end;

SELECT count(*)[���������� �����] from #EX;
SELECT * from #EX
SELECT * from  #EX where  TKEY > 1500 and  CC < 4500;  
SELECT * from  #EX order by  TKEY, CC
SELECT * from  #EX where  TKEY = 556 and  CC > 3

CREATE index #EX_NONCLU on #EX(TKEY, CC)

drop index #EX_NONCLU on #EX

--drop table #EX

-- 3 ����������� SELECT-������. �������� ���� ������� � ���������� ��� ���������. 
--������� ������������������ ������ ��������, ����������� ���-������ SELECT-�������. 
--��������� �������� � ������ ��������� ������ �������� ������ ��� ���������� ��������������� ��������

SELECT CC from #EX where TKEY>15000 

CREATE  index #EX_TKEY_X on #EX(TKEY) INCLUDE (CC)

drop index #EX_TKEY_X on #EX

-- 4 ����������� SELECT-������, �������� ���� ������� � ���������� ��� ���������. 
--������� ������������������ ����������� ������, ������ ����� SELECT-�������.�
--����� �� WHERE-���������� �����

SELECT TKEY from  #EX where TKEY between 5000 and 19999
SELECT TKEY from  #EX where TKEY>15000 and  TKEY < 20000  
SELECT TKEY from  #EX where TKEY=17000

CREATE  index #EX_WHERE on #EX(TKEY)where (TKEY>=15000 and TKEY < 20000);  

drop index #EX_WHERE on #EX

-- 5 ������� ������������������ ������. ������� ������� ������������ �������.
--����������� �������������� ���������� � ������� ������ �������
--����� ��� ������������ ����� ������ ������ �� ����� ������ ������.0
--����������� �������� �� T-SQL, ���������� �������� �������� � ������ ������������ ������� ���� 90%. 

CREATE   index #EX_TKEY ON #EX(TKEY); 

SELECT name [������], avg_fragmentation_in_percent [������������ (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss  JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
WHERE name is not null;
 
INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX;
 
ALTER index #EX_TKEY on #EX reorganize;

ALTER index #EX_TKEY on #EX rebuild with (online = off);

drop index #EX_TKEY ON #EX

----task 6 ����������� ������, �����������-���� ���������� ��������� FILL-FACTOR
--��� �������� ����������-��������� �������.���� ������� ����� ��������� ������� ������� ������
CREATE index #EX_TKEY on #EX(TKEY) with (fillfactor = 65);
                      
INSERT top(50)percent INTO #EX(TKEY, TF) SELECT TKEY, TF  FROM #EX;
                                              
SELECT name [������], avg_fragmentation_in_percent [������������ (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),    
OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss  JOIN sys.indexes ii 
ON ss.object_id = ii.object_id and ss.index_id = ii.index_id  WHERE name is not null

drop table #EX