--1. Определить все индексы, которые имеются в БД UNIVER. 
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

--Создать временную локальную таблицу. Заполнить ее данными (не менее 1000 строк). 
--упорядочены в соответствии со значениями индексируемых столбцов
--Разработать SELECT-запрос. Получить план запроса и определить его стоимость. 
--Создать кластеризованный индекс, уменьшающий стоимость SELECT-запроса.

create table #temp_table
(number int,
string varchar(100));
 
set nocount on;
declare @i int = 0;
while @i < 3000
begin 
  insert #temp_table values(floor(3000*rand()), replicate('строка',10));
  set @i = @i + 1;
end

select #temp_table.number
from #temp_table
where number between 1000 and 2000 order by number;

checkpoint;  --фиксация БД
DBCC DROPCLEANBUFFERS;  --очистить буферный кэш

Create clustered index #temp_CL on #temp_table(number asc);

select #temp_table.number
from #temp_table
where number between 1000 and 2000 order by number;

drop table #temp_table;

--2 Разработать SELECT-запрос. Получить план запроса и определить его стоимость. 
--Создать некластеризованный неуникальный составной индекс.не влияют на физический порядок строк 
--Оценить процедуры поиска ин-формации.по нескольким столбцам 

CREATE table #EX
(TKEY int, 
CC int identity(1, 1),
TF varchar(100));

set nocount on;
declare @i1 int = 0; 
while   @i1 < 20000       -- добавление в таблицу 20000 строк
begin
  INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('строка ', 10));
  set @i1 = @i1 + 1; 
end;

SELECT count(*)[количество строк] from #EX;
SELECT * from #EX
SELECT * from  #EX where  TKEY > 1500 and  CC < 4500;  
SELECT * from  #EX order by  TKEY, CC
SELECT * from  #EX where  TKEY = 556 and  CC > 3

CREATE index #EX_NONCLU on #EX(TKEY, CC)

drop index #EX_NONCLU on #EX

--drop table #EX

-- 3 Разработать SELECT-запрос. Получить план запроса и определить его стоимость. 
--Создать некластеризованный индекс покрытия, уменьшающий сто-имость SELECT-запроса. 
--позволяет включить в состав индексной строки значения одного или нескольких неиндексируемых столбцов

SELECT CC from #EX where TKEY>15000 

CREATE  index #EX_TKEY_X on #EX(TKEY) INCLUDE (CC)

drop index #EX_TKEY_X on #EX

-- 4 Разработать SELECT-запрос, получить план запроса и определить его стоимость. 
--Создать некластеризованный фильтруемый индекс, уменьш стоим SELECT-запроса.з
--основ на WHERE-фильтрации строк

SELECT TKEY from  #EX where TKEY between 5000 and 19999
SELECT TKEY from  #EX where TKEY>15000 and  TKEY < 20000  
SELECT TKEY from  #EX where TKEY=17000

CREATE  index #EX_WHERE on #EX(TKEY)where (TKEY>=15000 and TKEY < 20000);  

drop index #EX_WHERE on #EX

-- 5 Создать некластеризованный индекс. Оценить уровень фрагментации индекса.
--образование неиспользуемых фрагментов в области памяти индекса
--после нее фрагментация будет убрана только на самом нижнем уровне.0
--Разработать сценарий на T-SQL, выполнение которого приводит к уровню фрагментации индекса выше 90%. 

CREATE   index #EX_TKEY ON #EX(TKEY); 

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss  JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
WHERE name is not null;
 
INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX;
 
ALTER index #EX_TKEY on #EX reorganize;

ALTER index #EX_TKEY on #EX rebuild with (online = off);

drop index #EX_TKEY ON #EX

----task 6 Разработать пример, демонстриру-ющий применение параметра FILL-FACTOR
--при создании некластери-зованного индекса.указ процент запол индексных страниц нижнего уровня
CREATE index #EX_TKEY on #EX(TKEY) with (fillfactor = 65);
                      
INSERT top(50)percent INTO #EX(TKEY, TF) SELECT TKEY, TF  FROM #EX;
                                              
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),    
OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss  JOIN sys.indexes ii 
ON ss.object_id = ii.object_id and ss.index_id = ii.index_id  WHERE name is not null

drop table #EX