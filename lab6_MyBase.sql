use G_MyBase;
--1
select ДЕТАЛИ.Название_детали,
max(ДЕТАЛИ.Цена)[MAX Цена],
min(ДЕТАЛИ.Цена)[MIN Цена],
avg(ДЕТАЛИ.Цена)[AVG Цена]
from ДЕТАЛИ inner join ЗАКАЗЫ
on ДЕТАЛИ.ID_детали=ЗАКАЗЫ.ID_детали
group by  ДЕТАЛИ.Название_детали
--2
select ДЕТАЛИ.Название_детали,
max(ДЕТАЛИ.Цена)[MAX Цена],
min(ДЕТАЛИ.Цена)[MIN Цена],
avg(ДЕТАЛИ.Цена)[AVG Цена],
sum(ДЕТАЛИ.Цена)[SUM Цена],
count(*)[Кол-во]
from ДЕТАЛИ inner join ЗАКАЗЫ
on ДЕТАЛИ.ID_детали=ЗАКАЗЫ.ID_детали
group by  ДЕТАЛИ.Название_детали
--3
select *
from (select Case 
	when ДЕТАЛИ.Цена <100 then 'дешево'
	when ДЕТАЛИ.Цена between 100 and 200 then 'нормально'
	when ДЕТАЛИ.Цена >200 then 'дорого'
	end [цена], count(*)[Количество]
from ДЕТАЛИ group by Case
when ДЕТАЛИ.Цена <100 then 'дешево'
	when ДЕТАЛИ.Цена between 100 and 200 then 'нормально'
	when ДЕТАЛИ.Цена >200 then 'дорого'
end) as T
order by Case [цена]
	when 'дешево' then 3
	when 'нормально' then 2
	when 'дорого' then 1
	else 0
end
--4
select ДЕТАЛИ.Название_детали, round(avg(cast(ДЕТАЛИ.Цена as float(4))),2)[средняя цена]
from ДЕТАЛИ inner join ЗАКАЗЫ
on ДЕТАЛИ.ID_детали=ЗАКАЗЫ.ID_детали
where ДЕТАЛИ.Код_поставщика  like '%111%'
group by  ДЕТАЛИ.Название_детали

--5
select ДЕТАЛИ.Название_детали, round(avg(cast(ДЕТАЛИ.Цена as float(4))),2)[средняя цена]
from ДЕТАЛИ inner join ЗАКАЗЫ
on ДЕТАЛИ.ID_детали=ЗАКАЗЫ.ID_детали
where ДЕТАЛИ.Название_детали  like '%Двигатель%'
group by  ДЕТАЛИ.Название_детали

--7

select p1.Название_детали, p1.Цена,
(select count(*) from ДЕТАЛИ p2
where p1.Название_детали=p2.Название_детали) [количество]
from ДЕТАЛИ p1
group by p1.Название_детали, p1.Цена
having Цена=144 or Цена=220
order by Цена desc