use G_MyBase;
--1
select ������.�����_������, ������.ID_������
from ������, ������
where ������.ID_������=������.ID_������ and ������.ID_������ in (select ������.ID_������ from ������ where (������.��������_������ like '%���������%' ))

--2
select ������.�����_������, ������.ID_������
from ������ inner join ������
on ������.ID_������=������.ID_������
where ������.ID_������ in (select ������.ID_������ from ������ where (������.��������_������ like '%���������%' ))

--3
select distinct ������.�����_������, ������.ID_������
from ������ inner join ������
on ������.ID_������=������.ID_������
where ������.��������_������ like '%���������%'

--4
select ID_������, �������, ����
from ������ a
where ����=(
select top (1) ����
from ������ aa
where aa.�������=a.�������
order by ���� desc)

--5
select ������.ID_������
from ������
where not exists (select ������.ID_������ from ������
where ������.ID_������=������.ID_������)

--6
select top 1
(select avg(������.����)from ������
	where ������.������� like 'dv111')[dv111],
(select avg(������.����)from ������
	where ������.������� like 'ak111')[dv111]
from ������

--7
SELECT �������, ��������_������, ����
FROM ������
WHERE ������.����>150 and ������.�������=all (SELECT ������.������� FROM ������
	WHERE ������.�������  like 'dv111')

--8
SELECT �������, ��������_������, ����
FROM ������
WHERE ������.�������  like 'dv111' and ������.����=any (SELECT ������.���� FROM ������
	WHERE ����>150)
