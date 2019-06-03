USE SEDCHome
GO
Drop procedure if exists dbo.CreateGrade
drop procedure if exists dbo.CreateGradeDetail

--Create new procedure called CreateGrade
--Procedure should create only Grade header info (not Grade Details) 
--Procedure should return the total number of grades in the system for the Student on input (from the CreateGrade)
--Procedure should return second resultset with the MAX Grade of all grades for the Student and Teacher on input (regardless the Course)


create procedure dbo.CreateGrade ( @studentID int,@courseID int , @teacherId int ,@Grade int,@comment nvarchar(100),@createdDate datetime) 
as
begin

	insert into dbo.Grade(StudentID, CourseID, TeacherID,Grade,Comment,CreatedDate)
	values (@studentID ,@courseID  , @teacherId  ,@Grade ,@comment,@createdDate )

	select count(*) as TotalNumberOfGrades 
	from dbo.Grade g 
	where g.StudentID = @studentID

	select max(g.Grade) as MaxGrade 
	from dbo.Grade g
	where g.StudentID = @studentID
	and g.TeacherID = @teacherId

end
-- test 

EXEC dbo.CreateGrade @studentID = 5 ,@courseID  =5 , @teacherId  =5,@Grade = 9,@comment='Redoven', @createdDate ='1999-02-05 00:00:00.000'


--Create new procedure called CreateGradeDetail
--Procedure should add details for specific Grade (new record for new AchievementTypeID, Points, MaxPoints, Date for specific Grade)
--Output from this procedure should be resultset with SUM of GradePoints calculated with formula AchievementPoints/AchievementMaxPoints*ParticipationRate for specific Grade


Create procedure dbo.CreateGradeDetail(@AchievementTypeID int,@Points int ,@MaxPoints int ,@Date date)
as
begin 

declare @GradePoints decimal(18,9)
declare @ParticipationRate int

select @ParticipationRate = a.ParticipationRate
from dbo.AchievementType a

insert into GradeDetails(AchievementTypeID, AchievementPoints, AchievementMaxPoints,AchievementDate)
	values (@AchievementTypeID ,@Points  , @MaxPoints  ,@Date  )


	set @GradePoints =(
	select sum (g.AchievementPoints/g.AchievementPoints)*@ParticipationRate
	from dbo.GradeDetails g	
	where g.AchievementTypeID = @AchievementTypeID
	)
end



--Add error handling on CreateGradeDetail procedure
--Test the error handling by inserting not-existing values for AchievementTypeID

Create or alter procedure dbo.CreateGradeDetail(@AchievementTypeID int,@Points int ,@MaxPoints int ,@Date date)
as
begin 

declare @GradePointss decimal(18,9)
declare @ParticipationRatee int

select @ParticipationRatee = a.ParticipationRate
from dbo.AchievementType a

begin try

insert into GradeDetails(AchievementTypeID, AchievementPoints, AchievementMaxPoints,AchievementDate)
	values (@AchievementTypeID ,@Points  , @MaxPoints  ,@Date  )

end try

begin catch
SELECT  

    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;  

end catch;

	set @GradePointss =(
	select sum (g.AchievementPoints/g.AchievementPoints)*@ParticipationRatee
	from dbo.GradeDetails g	
	where g.AchievementTypeID = @AchievementTypeID
	)
end

EXEC dbo.CreateGradeDetail @AchievementTypeID =14,@Points =57,@MaxPoints = 100,@Date ='2001-05-08'


