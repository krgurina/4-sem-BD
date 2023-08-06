-- 1
use G_MyBase
exec sp_helpindex 'ДЕТАЛИ'
exec sp_helpindex 'ЗАКАЗЫ'
exec sp_helpindex 'ПОСТАВЩИКИ'

-- кластеризованного не будет

-- некластеризованный неуникальный составной индекс
select * from ДЕТАЛИ;
CREATE index #NONCLU on ДЕТАЛИ(ID_ДЕТАЛИ, ЦЕНА)
drop index #NONCLU on ДЕТАЛИ

-- Некластеризованный индекс покрытия 
select * from ДЕТАЛИ;
CREATE index #NONCLU_POKR on ДЕТАЛИ(ID_ДЕТАЛИ, ЦЕНА) include(Количество_на_складе, Артикул)
drop index #NONCLU_POKR on ДЕТАЛИ

-- некластеризованный фильтруемый индекс
select * from ДЕТАЛИ where Цена > 200
select * from ДЕТАЛИ where Цена < 190
select * from ДЕТАЛИ where Цена = 220

CREATE  index #INDX_WHERE on ДЕТАЛИ(Цена)where Цена > 200;  
drop index #INDX_WHERE on ДЕТАЛИ




