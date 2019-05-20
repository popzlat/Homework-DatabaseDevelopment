USE SEDCHome
GO

--Calculate the count of all grades in the system
--Calculate the count of all grades per Teacher in the system
--Calculate the count of all grades per Teacher in the system for first 100 Students (ID < 100)
--Find the Maximal Grade, and the Average Grade per Student on all grades in the system

select count(Grade) as totalCount
 from Grade


 select TeacherID ,count(Grade) as totalCountPerTeacher
 from Grade
 group by TeacherID


 select TeacherID ,count(Grade) as totalCountPerTeacher
 from Grade
 where StudentID < 100
 group by TeacherID


 select StudentID ,MAX(Grade) as MaximalGrade,AVG(Grade) as AverageGrade
 from Grade
 group by StudentID
 order by StudentID


--Calculate the count of all grades per Teacher in the system and filter only grade count greater then 200
--Calculate the count of all grades per Teacher in the system for first 100 Students (ID < 100) and filter teachers with more than 50 Grade count
--Find the Grade Count, Maximal Grade, and the Average Grade per Student on all grades in the system. Filter only records where Maximal Grade is equal to Average Grade
--List Student First Name and Last Name next to the other details from previous query

select TeacherID,count(Grade) as totalCount
 from Grade
 group by TeacherID
 HAVING COUNT(Grade) > 200

select TeacherID,count(Grade) as totalCount
 from Grade
 where StudentID < 100
 group by TeacherID
HAVING COUNT(Grade) > 50

select StudentID ,count(Grade) TotalCount ,max(Grade) as Maximal ,AVG(Grade) as Average
from Grade
group by StudentID
HAVING MAX(Grade) = AVG(Grade)


select s.FirstName,s.LastName,count(Grade) TotalCount ,max(Grade) as Maximal ,AVG(Grade) as Average
from Grade g
inner join dbo.Student s on s.Id = g.StudentID 
group by s.FirstName,s.LastName
HAVING MAX(Grade) = AVG(Grade)


--Create new view (vv_StudentGrades) that will List all StudentIds and count of Grades per student
--Change the view to show Student First and Last Names instead of StudentID
--List all rows from view ordered by biggest Grade Count
--Create new view (vv_StudentGradeDetails) that will List all Students (FirstName and LastName) and Count the courses he passed through the exam(Ispit)

Create view vv_StudentGrades
as
select s.id as StudentID,count(Grade) as TotalCount
from Grade g
inner join Student s on s.Id = g.StudentID
group by s.Id
go

select * from vv_StudentGrades 
go

Alter view vv_StudentGrades
as
select s.FirstName,s.LastName,count(Grade) as TotalCount
from Grade g
inner join dbo.Student s on s.Id = g.StudentID 
group by s.FirstName,s.LastName
go

select * from vv_StudentGrades 
order by TotalCount desc
go

Create view vv_StudentGradeDetails
as
select s.FirstName,s.LastName,count(a.Id) as CoursesPassedWithExam
from AchievementType a
inner join GradeDetails d on d.AchievementTypeID = a.Id
inner join Grade g on g.Id = d.GradeID
inner join Course c on c.Id = g.CourseID
inner join Student s on s.Id = g.StudentID
where d.AchievementTypeID = 5 and g.Id = d.GradeID
group by s.FirstName,s.LastName 	
go

select *from vv_StudentGradeDetails 
