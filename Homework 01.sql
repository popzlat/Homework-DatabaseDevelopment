--Creating database 
Create database SEDCHome
GO

USE SEDCHome
GO

DROP TABLE IF EXISTS [dbo].Teacher;
DROP TABLE IF EXISTS [dbo].Student;
DROP TABLE IF EXISTS [dbo].Grade;
DROP TABLE IF EXISTS [dbo].GradeDetails;
DROP TABLE IF EXISTS [dbo].AchievementType;
DROP TABLE IF EXISTS [dbo].Course;
GO

--Create table for Teacher

create table [dbo].Teacher(
	Id smallint IDENTITY(1,1) not null,
	FirstName nvarchar(50) not null,
	LastName nvarchar (50) not null,
	DateOfBirth date not null,
	AcademicRank nvarchar (50),
	HireDate date ,
 CONSTRAINT [PK_Teacher] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
))
GO
--Create table for Student

create table [dbo].Student(
	Id smallint IDENTITY(1,1) not null,
	FirstName nvarchar(50) not null,
	LastName nvarchar (50) not null,
	DateOfBirth date not null,
	EnrolledDate date not null,
	Gender nvarchar (10) not null,
	NationalIDNumber nvarchar (20) not null,
	StudentCardNumber nvarchar (20) not null,
	CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED(
	[Id] ASC
	))
	GO

--Create table for Course

create table [dbo].Course(
	Id smallint IDENTITY(1,1) not null,
	Name nvarchar (50) not null,
	Credit smallint not null,
	AcademicYear nvarchar (10) not null,
	Semester smallint not null,
	CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED(
	[Id] ASC
	))
	GO

--Create table for Achievment Type

create table [dbo].AchievementType(
	Id smallint IDENTITY(1,1) not null,
	[Name] nvarchar (50) not null,
	[Description] nvarchar (100) null,
	ParticipationRate decimal(5,2) not null,
	CONSTRAINT [PK_AchievementType] PRIMARY KEY CLUSTERED(
	[Id] ASC
	))
	GO

-- Create table for Grade

create table [dbo].Grade(
	Id int IDENTITY(1,1) not null,
	StudentID smallint not null,
	CourseID smallint not null,
	TeacherID smallint not null,
	Grade tinyint  not null,
	Comment nvarchar(100) null,
	CreatedDate datetime null,
	CONSTRAINT [PK_Grade] PRIMARY KEY CLUSTERED(
	[Id] ASC
	))
	GO

	--Create table for Grade Details

create table [dbo].GradeDetails(
	Id int IDENTITY(1,1) not null,
	GradeID int not null,
	AchievementTypeID int not null,
	AchievementPoints int not null,
	AchievementMaxPoints int not null,
	AchievementDate date not null,
	CONSTRAINT [PK_GradeDetails] PRIMARY KEY CLUSTERED(
	[Id] ASC
	))
	GO


