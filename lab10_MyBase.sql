-- 1
use G_MyBase
exec sp_helpindex '������'
exec sp_helpindex '������'
exec sp_helpindex '����������'

-- ����������������� �� �����

-- ������������������ ������������ ��������� ������
select * from ������;
CREATE index #NONCLU on ������(ID_������, ����)
drop index #NONCLU on ������

-- ������������������ ������ �������� 
select * from ������;
CREATE index #NONCLU_POKR on ������(ID_������, ����) include(����������_��_������, �������)
drop index #NONCLU_POKR on ������

-- ������������������ ����������� ������
select * from ������ where ���� > 200
select * from ������ where ���� < 190
select * from ������ where ���� = 220

CREATE  index #INDX_WHERE on ������(����)where ���� > 200;  
drop index #INDX_WHERE on ������




