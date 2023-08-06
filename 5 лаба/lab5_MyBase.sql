use G_MyBase;
--1
select ÇÀÊÀÇÛ.Íîìåð_çàêàçà, ÄÅÒÀËÈ.ID_äåòàëè
from ÇÀÊÀÇÛ, ÄÅÒÀËÈ
where ÇÀÊÀÇÛ.ID_äåòàëè=ÄÅÒÀËÈ.ID_äåòàëè and ÇÀÊÀÇÛ.ID_äåòàëè in (select ÄÅÒÀËÈ.ID_äåòàëè from ÄÅÒÀËÈ where (ÄÅÒÀËÈ.Íàçâàíèå_äåòàëè like '%äâèãàòåëü%' ))

--2
select ÇÀÊÀÇÛ.Íîìåð_çàêàçà, ÄÅÒÀËÈ.ID_äåòàëè
from ÇÀÊÀÇÛ inner join ÄÅÒÀËÈ
on ÇÀÊÀÇÛ.ID_äåòàëè=ÄÅÒÀËÈ.ID_äåòàëè
where ÇÀÊÀÇÛ.ID_äåòàëè in (select ÄÅÒÀËÈ.ID_äåòàëè from ÄÅÒÀËÈ where (ÄÅÒÀËÈ.Íàçâàíèå_äåòàëè like '%äâèãàòåëü%' ))

--3
select distinct ÇÀÊÀÇÛ.Íîìåð_çàêàçà, ÄÅÒÀËÈ.ID_äåòàëè
from ÇÀÊÀÇÛ inner join ÄÅÒÀËÈ
on ÇÀÊÀÇÛ.ID_äåòàëè=ÄÅÒÀËÈ.ID_äåòàëè
where ÄÅÒÀËÈ.Íàçâàíèå_äåòàëè like '%äâèãàòåëü%'

--4
select ID_äåòàëè, Àðòèêóë, Öåíà
from ÄÅÒÀËÈ a
where Öåíà=(
select top (1) Öåíà
from ÄÅÒÀËÈ aa
where aa.Àðòèêóë=a.Àðòèêóë
order by Öåíà desc)

--5
select ÄÅÒÀËÈ.ID_äåòàëè
from ÄÅÒÀËÈ
where not exists (select ÇÀÊÀÇÛ.ID_äåòàëè from ÇÀÊÀÇÛ
where ÄÅÒÀËÈ.ID_äåòàëè=ÇÀÊÀÇÛ.ID_äåòàëè)

--6
select top 1
(select avg(ÄÅÒÀËÈ.Öåíà)from ÄÅÒÀËÈ
	where ÄÅÒÀËÈ.Àðòèêóë like 'dv111')[dv111],
(select avg(ÄÅÒÀËÈ.Öåíà)from ÄÅÒÀËÈ
	where ÄÅÒÀËÈ.Àðòèêóë like 'ak111')[dv111]
from ÄÅÒÀËÈ

--7
SELECT Àðòèêóë, Íàçâàíèå_äåòàëè, Öåíà
FROM ÄÅÒÀËÈ
WHERE ÄÅÒÀËÈ.Öåíà>150 and ÄÅÒÀËÈ.Àðòèêóë=all (SELECT ÄÅÒÀËÈ.Àðòèêóë FROM ÄÅÒÀËÈ
	WHERE ÄÅÒÀËÈ.Àðòèêóë  like 'dv111')

--8
SELECT Àðòèêóë, Íàçâàíèå_äåòàëè, Öåíà
FROM ÄÅÒÀËÈ
WHERE ÄÅÒÀËÈ.Àðòèêóë  like 'dv111' and ÄÅÒÀËÈ.Öåíà=any (SELECT ÄÅÒÀËÈ.Öåíà FROM ÄÅÒÀËÈ
	WHERE Öåíà>150)
