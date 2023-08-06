USE File_Group
CREATE table ПОСТАВЩИКИ
(	Код_поставщика int primary key,
	Название nvarchar(50),
	Адрес nvarchar(50),
	Телефон nvarchar(15)
)on FG1;
CREATE table ДЕТАЛИ
(	ID_детали nvarchar(15) primary key,
	Название_детали nvarchar(50),
	Количество_на_складе int,
	Артикул nvarchar(20),
	Цена int,
	Код_поставщика int foreign key references ПОСТАВЩИКИ(Код_поставщика)
)on FG1;
CREATE table ЗАКАЗЫ
(	Номер_заказа int primary key,	
	ID_детали nvarchar(15) foreign key references ДЕТАЛИ(ID_детали),
	Количество_заказанных_деталей int,
	Дата_заказа date,
	Примечание nvarchar(50)
)on FG1;