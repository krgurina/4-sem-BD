USE File_Group
CREATE table ����������
(	���_���������� int primary key,
	�������� nvarchar(50),
	����� nvarchar(50),
	������� nvarchar(15)
)on FG1;
CREATE table ������
(	ID_������ nvarchar(15) primary key,
	��������_������ nvarchar(50),
	����������_��_������ int,
	������� nvarchar(20),
	���� int,
	���_���������� int foreign key references ����������(���_����������)
)on FG1;
CREATE table ������
(	�����_������ int primary key,	
	ID_������ nvarchar(15) foreign key references ������(ID_������),
	����������_����������_������� int,
	����_������ date,
	���������� nvarchar(50)
)on FG1;