use G_MyBase
CREATE table ����������
(	���_���������� int primary key,
	�������� nvarchar(50),
	����� nvarchar(50),
	������� nvarchar(15)
);
CREATE table ������
(	ID_������ nvarchar(15) primary key,
	��������_������ nvarchar(50),
	����������_��_������ int,
	������� nvarchar(20),
	���� int,
	���_���������� int foreign key references ����������(���_����������)
);
CREATE table ������
(	�����_������ int primary key,	
	ID_������ nvarchar(15) foreign key references ������(ID_������),
	����������_����������_������� int,
	����_������ nvarchar(15),
	���������� nvarchar(50)
);
ALTER Table ������ ADD ����_�������� date;