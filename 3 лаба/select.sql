use G_MyBase;
SELECT ID_детали, Количество_на_складе from ДЕТАЛИ;
SELECT COUNT (*)[Количество строк] from ДЕТАЛИ;
UPDATE ДЕТАЛИ set Количество_на_складе = 1007 Where ID_детали =11;
SELECT ID_детали, Количество_на_складе from ДЕТАЛИ;

