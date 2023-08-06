use G_MyBase
CREATE table ПОСТАВЩИКИ
(	Код_поставщика int primary key,
	Название nvarchar(50),
	Адрес nvarchar(50),
	Телефон nvarchar(15)
);
CREATE table ДЕТАЛИ
(	ID_детали nvarchar(15) primary key,
	Название_детали nvarchar(50),
	Количество_на_складе int,
	Артикул nvarchar(20),
	Цена int,
	Код_поставщика int foreign key references ПОСТАВЩИКИ(Код_поставщика)
);
CREATE table ЗАКАЗЫ
(	Номер_заказа int primary key,	
	ID_детали nvarchar(15) foreign key references ДЕТАЛИ(ID_детали),
	Количество_заказанных_деталей int,
	Дата_заказа nvarchar(15),
	Примечание nvarchar(50)
);
ALTER Table ЗАКАЗЫ ADD Дата_Доставки date;