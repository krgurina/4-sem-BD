use G_MyBase;
--1
select ������.��������_������,
max(������.����)[MAX ����],
min(������.����)[MIN ����],
avg(������.����)[AVG ����]
from ������ inner join ������
on ������.ID_������=������.ID_������
group by  ������.��������_������
--2
select ������.��������_������,
max(������.����)[MAX ����],
min(������.����)[MIN ����],
avg(������.����)[AVG ����],
sum(������.����)[SUM ����],
count(*)[���-��]
from ������ inner join ������
on ������.ID_������=������.ID_������
group by  ������.��������_������
--3
select *
from (select Case 
	when ������.���� <100 then '������'
	when ������.���� between 100 and 200 then '���������'
	when ������.���� >200 then '������'
	end [����], count(*)[����������]
from ������ group by Case
when ������.���� <100 then '������'
	when ������.���� between 100 and 200 then '���������'
	when ������.���� >200 then '������'
end) as T
order by Case [����]
	when '������' then 3
	when '���������' then 2
	when '������' then 1
	else 0
end
--4
select ������.��������_������, round(avg(cast(������.���� as float(4))),2)[������� ����]
from ������ inner join ������
on ������.ID_������=������.ID_������
where ������.���_����������  like '%111%'
group by  ������.��������_������

--5
select ������.��������_������, round(avg(cast(������.���� as float(4))),2)[������� ����]
from ������ inner join ������
on ������.ID_������=������.ID_������
where ������.��������_������  like '%���������%'
group by  ������.��������_������

--7

select p1.��������_������, p1.����,
(select count(*) from ������ p2
where p1.��������_������=p2.��������_������) [����������]
from ������ p1
group by p1.��������_������, p1.����
having ����=144 or ����=220
order by ���� desc