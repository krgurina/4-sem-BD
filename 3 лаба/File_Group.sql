use master
go
create database File_Group on primary
(
	name = N'filegroup_mdf',
	filename = N'F:\лабы\БД\3 лаба\filegroup_mdf.mdf', 
	size = 10240 kb,
	maxsize = unlimited,
	filegrowth = 1024 kb
),
(
	name = N'filegroup_ndf',
	filename = N'F:\лабы\БД\3 лаба\filegroup_ndf.ndf', 
	size = 10240 kb,
	maxsize = 1 gb,
	filegrowth = 25%
),


filegroup FG1
(
	name = N'filegroup_fg1_mdf',
	filename = N'F:\лабы\БД\3 лаба\filegroup_fg1_mdf.mdf', 
	size = 10240 kb,
	maxsize = 1 gb,
	filegrowth = 25%
),
(
	name = N'filegroup_fg1_ndf',
	filename = N'F:\лабы\БД\3 лаба\filegroup_fg1_ndf.ndf', 
	size = 10240 kb,
	maxsize = 1 gb,
	filegrowth = 25%
)



log on
(
	name = N'filegroup_log',
	filename = N'F:\лабы\БД\3 лаба\filegroup_log.ldf', 
	size = 10240 kb,
	maxsize = 2048 gb,
	filegrowth = 10%
)