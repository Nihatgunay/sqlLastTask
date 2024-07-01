create database TaskAcademy
use TaskAcademy

create table Academies(
	Id int identity(1,1) primary key,
	Name nvarchar(50)
)
create table Groups(
	Id int identity(1,1) primary key,
	Name nvarchar(50),
	IsDeleted bit,
	AcademyId int foreign key references Academies(Id)
)
create table Students(
	Id int identity(1,1) primary key,
	Name nvarchar(50),
	Surname nvarchar(50),
	Age int,
	Adulthood bit,
	GroupId int foreign key references Groups(Id)
)
create table DeletedStudents(
	Id int identity(1,1) primary key,
	Name nvarchar(50),
	Surname nvarchar(50),
	GroupId int
)
create table DeletedGroups(
	Id int identity(1,1) primary key,
	Name nvarchar(50),
	AcademyId int
)
create view Get_Academies as
select * from Academies

create view Get_Groups as
select * from Groups

create view Get_Students as
select * from Students

create procedure GetGroupByName @name nvarchar(50) as
select * from Groups
where Name = @name

create procedure GetStudentsGreaterThanAge @age1 int as
select * from Students
where Age > @age1 

create procedure GetStudentsSmallerThanAge @age2 int as
select * from Students
where Age < @age2

create trigger TR_deletedStudent on Students
after delete as
begin
insert into DeletedStudents select Name, Surname, GroupId from deleted
end

create trigger TR_deletedgroup1 on Groups
after delete as
begin
insert into DeletedGroups select Name, AcademyId from deleted
update Groups
set IsDeleted = 1
from Groups join deleted on Groups.Id = deleted.Id
end

create trigger UpdatedStudent on Students
after update as
begin 
update Students
set Adulthood = 1
from Students join inserted on inserted.Id = Students.Id
where inserted.Age  >= 18
end

create trigger InsertStudent on Students
after insert as
begin
update Students
set Adulthood = 1
from Students join inserted on inserted.Id = Students.Id
where inserted.Age  >= 18
end

create function GetStudentsWithGroupId (@groupid int)
returns table as
return(
	select * from Students
	where Students.GroupId = @groupid
)
select * from GetStudentsWithGroupId(1)

create function GetGroupsByAcademyId (@academyid int)
returns table as
return(
	select * from Groups
	where Groups.AcademyId = @academyid
)
select * from GetGroupsByAcademyId(1)
