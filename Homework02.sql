
--Homework query
USE SEDCHome
GO

--Find all Students with FirstName = Antonio
--Find all Students with DateOfBirth greater than '01.01.1999'
--Find all Male students
--Find all Students with LastName starting with 'T'
--Find all Students Enrolled in January/1988
--Find all Students with LastName starting with 'J' enrolled in January/1988


select *from Student
where FirstName = 'Antonio'

select *from Student
where DateOfBirth > '01.01.1999'

select *from Student
where Gender = 'M'

select *from Student
where LastName like 'T%'

select *from Student
where MONTH(EnrolledDate) = 01 and YEAR(EnrolledDate) = 1998

select *from Student 
where LastName like 'J%' and 
MONTH(EnrolledDate) = 01 and YEAR(EnrolledDate) = 1998 


--Find all Students with FirstName = Antonio oredered by LastName
--List all Students ordered by FirstName
--Find all Male Students ordered by EnrolledDate,starting from the last enrolled

select *from Student
where FirstName = 'Antonio'
order by LastName asc

select *from Student
order by FirstName asc

select *from Student
where Gender = 'M'
order by EnrolledDate desc


--List all Teacher First Names and Student First Names in single result set with duplicates
--List all Teacher Last Names and Student Last Names in single result set. Remove duplicates
--List all common First Names for Teacher and Students

select FirstName
from Teacher
union all
select FirstName
from Student

select LastName 
from Teacher
union
select LastName 
from Student

select FirstName  
from Teacher
intersect
select FirstName
from Student


--Change GradeDetails table always to insert value 100 in AchievementMaxPoints column if no value is provided on insert
--Change GradeDetails table to prevent inserting AchievementPoints that will more than AchievementMaxPoints
--Change AchievementType table to guarantee unique names across the Achievement types

alter table GradeDetails
add constraint DF_GradeDetails_AchievementMaxPoints 
default 100 for AchievementMaxPoints
GO

alter table GradeDetails with check
add constraint CHK_GradeDetails_AchievementPoints
CHECK (AchievementPoints <= AchievementMaxPoints);
GO

alter table AchievementType with check
add constraint UC_AchievementType unique (Name)
GO

--Create Foreign key constraints from diagram or with script

--Drop constraints if exists 

ALTER TABLE [dbo].[GradeDetails] DROP CONSTRAINT [FK_GradeDetails];
ALTER TABLE [dbo].[Grade] DROP CONSTRAINT [FK_Grade];

--Creating constraints 	

ALTER TABLE dbo.GradeDetails 
ADD CONSTRAINT FK_GradeDetails 
FOREIGN KEY (GradeId) 
REFERENCES dbo.Grade(Id)
go

ALTER TABLE dbo.Grade
ADD CONSTRAINT FK_Grade
FOREIGN KEY (CourseID) 
REFERENCES dbo.Course(Id)
go

--TO DO more foreign keys...................


--List all possible combinations of Courses names and AchievementType names that can be passed by student
--List all Teachers that has any exam Grade
--List all Teachers without exam Grade
--List all Students without exam Grade (using Right Join)

select c.Name as CoursesName, a.Name as AchievementTypeName
from dbo.Course c
cross join dbo.AchievementType a
go

select DISTINCT t.FirstName,t.LastName
from dbo.Teacher t
inner join dbo.Grade g
on t.id = g.TeacherID
go


select DISTINCT t.FirstName,t.LastName
from dbo.Teacher t
left join dbo.Grade g
on t.Id = g.TeacherID
where g.TeacherID is null
go


select s.FirstName,s.LastName
from dbo.Grade g
right join dbo.Student s on g.StudentID = s.Id
where g.Grade is null
go
