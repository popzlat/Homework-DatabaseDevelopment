USE SEDCHome
GO

--Declare scalar variable for storing FirstName values
--Assign value ‘Antonio’ to the FirstName variable
--Find all Students having FirstName same as the variable
--Declare table variable that will contain StudentId, StudentName and DateOfBirth
--Fill the table variable with all Female students
--Declare temp table that will contain LastName and EnrolledDate columns
--Fill the temp table with all Male students having First Name starting with ‘A’
--Retrieve the students from the table which last name is with 7 characters
--Find all teachers whose FirstName length is less than 5 and
--the first 3 characters of their FirstName and LastName are the same

DECLARE @FirstName nvarchar(50)
set @FirstName = 'Antonio'

SELECT * 
FROM dbo.Student
WHERE FirstName = @FirstName
GO
-------------------------------------------
DECLARE @StudentList TABLE
(StudentId int , StudentName nvarchar (50), DateOfBirth date)


INSERT INTO @StudentList
SELECT s.Id,s.FirstName , s.DateOfBirth
FROM dbo.Student s
WHERE s.Gender = 'F'

select *from @StudentList
--------------------------------------------

CREATE TABLE #StudentList
(FirstName nvarchar (50),LastName nvarchar(50),EnrolledDate date)

INSERT INTO #StudentList
SELECT s.FirstName,LastName,s.EnrolledDate
FROM dbo.Student s
WHERE s.Gender = 'M' and s.FirstName like 'A%'


SELECT * 
FROM #StudentList
where Len(LastName) = 7
---------------------------------------------------
Select *
from dbo.Teacher t
where Len (t.FirstName) < 5 and
LEFT(t.FirstName,3) = RIGHT(t.FirstName,3)
---------------------------------------------------

--Declare scalar function (fn_FormatStudentName) for retrieving the Student description for specific StudentId in the following format:
--StudentCardNumber without “sc-”
--“ – “
--First character of student FirstName
--“.”
--Student LastName

CREATE FUNCTION dbo.fn_FormatStudentName (@StudentId int)
RETURNS Nvarchar(100)
AS 
BEGIN
DECLARE @Result nvarchar(50)
select @Result = SUBSTRING(s.StudentCardNumber,4,5) + '-'+ LEFT(s.FirstName,1) + '.'+ s.LastName
from dbo.Student s
RETURN @Result
END

select *,dbo.fn_FormatStudentName (id) as FunctionResult
from dbo.Student
--------------------------------------------------------
Create multi-statement table value function that for specific Teacher and Course will return list of students (FirstName, LastName)
who passed the exam, together with Grade and CreatedDate

CREATE FUNCTION dbo.fn_ListOfStudentsWhoPassedTheExam (@TeacherId int,@CourseId int)
RETURNS @Result TABLE (StudentFirstName nvarchar(100),StudentLastName nvarchar(100), Grade int , CreatedDate datetime)
AS
BEGIN

INSERT INTO @Result
select s.FirstName,s.LastName,g.Grade,g.CreatedDate
from dbo.Teacher t 
inner join dbo.Grade g on g.TeacherID = t.Id
inner join dbo.Student s on s.Id = g.StudentID
where g.TeacherID = @TeacherId and 
g.CourseID = @CourseId and g.Grade >= 6
order by s.FirstName
return
END

declare @TeacherId int = 1
declare @CourseId int = 1

--Testing
select * from dbo.fn_ListOfStudentsWhoPassedTheExam (@TeacherId,@CourseId)
