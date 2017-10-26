-- ---------------------------------------------------------------
-- Name: Nick Regan
-- Class: IT-111-200
-- Abstract: Homework 7 Problems 1 - 5
-- ---------------------------------------------------------------


use dbsql1


drop table TCustomerOrders
drop table TOrders
drop table TItems
drop table TCustomers

drop table TPassengers
drop table TFlightAttendants
drop table TPilots
drop table TFlights

drop table TCourseStudents
drop table TStudents
drop table TBooks
drop table TRooms
drop table TCourses

drop table TUserFavoriteSongs
drop table TSongs
drop table TUsers

drop table TTeamPlayers
drop table TPlayers
drop table TTeams




-- ---------------------------------------------------------------
-- Step #1.1:	Create Tables
-- ---------------------------------------------------------------

Create table TTeams
(
		intTeamID			int				not null,
		strTeam				varchar(50)		not null, 
		strMascot			varchar(50)		not null,
		constraint TTeams_PK Primary key (intTeamID)
)

Create table TPlayers
(
		intPlayerID			int				not null,
		strPlayer			varchar(50)		not null,
		constraint TPlayers_PK Primary Key (intPlayerID)
)

Create table TTeamPlayers
(
		intTeamID			int				not null,
		intPlayerID			int				not null,
		constraint TTeamPlayers_PK Primary Key (intTeamID, intPlayerID)
)

-- ---------------------------------------------------------------
-- Step #1.2:	Identify and Create Foreign Keys
-- ---------------------------------------------------------------

Alter Table TTeamPlayers Add Constraint TTeamPlayers_TTeams_FK 
Foreign Key (intTeamID) References TTeams (intTeamID)

Alter Table TTeamPlayers Add Constraint TTeamPlayers_TPlayers_FK 
Foreign Key (intPlayerID) References TPlayers (intPlayerID)


-- ---------------------------------------------------------------
-- Step #1.3:	Add 3 Teams
-- ---------------------------------------------------------------

insert into TTeams (intTeamID, strTeam, strMascot)
Values	(1, 'Bengals', 'Tiger'),
		(2, 'Browns', 'dog'),
		(3, 'Packers', 'Pacman')

-- ---------------------------------------------------------------
-- Step #1.4:	Add 3 Players
-- ---------------------------------------------------------------

insert into TPlayers (intPlayerID, strPlayer)
Values  (1, 'Nick'),
		(2, 'Hailey'),
		(3, 'Dan')

-- ---------------------------------------------------------------
-- Step #1.5:	Add 6 team-player assignments
-- ---------------------------------------------------------------

insert into TTeamPlayers (intTeamID, intPlayerID)
Values	(1, 1),
		(1, 2),
		(2, 1),
		(2, 3),
		(3, 2),
		(3, 3)




-- ---------------------------------------------------------------
-- Step #2.1:	Create Tables
-- ---------------------------------------------------------------

Create Table TUsers
(
		intUserID			int				not null,
		strUserName			varchar(50)		not null,
		strEmailAddress		varchar(50)		not null,
		constraint TUsers_PK Primary Key (intUserID)
)

Create Table TSongs
(
		intSongID			int				not null,
		strName				varchar(50)		not null,
		strArtist			varchar(50)		not null,
		constraint TSongs_PK Primary Key (intSongID)
)			

Create Table TUserFavoriteSongs
(
		intUserID			int				not null,
		intSongID			int				not null,
		constraint TUserFavoriteSongs_PK Primary Key (intUserID, intSongID)
)

-- ---------------------------------------------------------------
-- Step #2.2:	Identify and Create Foreign Keys
-- ---------------------------------------------------------------

Alter Table TUserFavoriteSongs Add Constraint TUserFavoriteSongs_TUsers_FK 
Foreign Key (intUserID) References TUsers (intUserID)

Alter Table TUserFavoriteSongs Add Constraint TUserFavoriteSongs_TSongs_FK 
Foreign Key (intSongID) References TSongs (intSongID)

-- ---------------------------------------------------------------
-- Step #2.3:	Add 3 Users
-- ---------------------------------------------------------------

insert into TUsers (intUserID, strUserName, strEmailAddress)
Values	(1, 'nmregan', 'reganquin@gmail.com'),
		(2, 'hbollinger', 'HaileyBEE@gmail.com'),
		(3, 'dougFunny', 'dingdong@gmail.com')

-- ---------------------------------------------------------------
-- Step #2.4:	Add 3 Songs
-- ---------------------------------------------------------------

insert into TSongs (intSongID, strName, strArtist)
Values	(1, 'Beat It', 'Micheal Jackson'),
		(2, 'Badfish', 'Sublime'),
		(3, 'Wicked', 'Future')

-- ---------------------------------------------------------------
-- Step #2.5:	Add 2 songs for each user
-- ---------------------------------------------------------------

insert into TUserFavoriteSongs (intUserID, intSongID)
Values	(1, 1),
		(1, 2),
		(1, 3),
		(2, 1),
		(2, 2),
		(3, 3),
		(3, 2)



---- ---------------------------------------------------------------
---- Step #3.1:	Create Tables
---- ---------------------------------------------------------------
Create Table TCourses
(
		intCourseID					int				not null,
		strCourse					varchar(50)		not null,
		strDescription				varchar(50)		not null,
		strInstructorFirstName		Varchar(50)		not null,
		strInstructorLastName		Varchar(50)		not null,
		strInstructorPhoneNumber	Varchar(50)		not null,
		constraint TCourses_PK Primary Key (intCourseID)
)

Create Table TRooms
(
		intRoomID					int				not null,
		strRoomNumber				varchar(50)		not null,
		intCapacity					int				not null,
		strMeetingTimes				varchar(50)		not null,
		constraint TRooms_PK Primary Key (intRoomID)
)

Create Table TBooks
(
		intBookID					int				not null,
		strName						varchar(50)		not null,
		strAuthor					varchar(50)		not null,
		strISBN						varchar(50)		not null,
		constraint TBooks_PK Primary Key (intBookID)
)

Create Table TStudents
(
		intStudentID				int				not null,
		strFirstName				varchar(50)		not null,
		strLastName					varchar(50)		not null,
		strStudentNumber			varchar(50)		not null,
		strPhoneNumber				varchar(50)		not null,
		constraint TStudents_PK Primary Key (intStudentID)
)

Create Table TCourseStudents
(
		intCourseID					int				not null,
		intStudentID				int				not null,
		intRoomID					int				not null,
		intBookID					int				not null,
		constraint TCourseStudents_PK Primary Key (intCourseID, intStudentID)
)

------ ---------------------------------------------------------------
------ Step #3.2:	Identify and Create Foreign Keys
------ ---------------------------------------------------------------

Alter Table TCourseStudents Add Constraint TCourseStudents_TRooms_FK 
Foreign Key (intRoomID) References TRooms (intRoomID)

Alter Table TCourseStudents Add Constraint TCourseStudents_TBooks_FK 
Foreign Key (intBookID) References TBooks (intBookID)

Alter Table TCourseStudents Add Constraint TCourseStudents_TCourses_FK 
Foreign Key (intCourseID) References TCourses (intCourseID)

Alter Table TCourseStudents Add Constraint TCourseStudents_TStudents_FK 
Foreign Key (intStudentID) References TStudents (intStudentID)


---- ---------------------------------------------------------------
---- Step #3.3:	Add 3 Courses
---- ---------------------------------------------------------------

Insert Into TCourses (intCourseID, strCourse, strDescription, strInstructorFirstName, strInstructorLastName, strInstructorPhoneNumber)
Values	(1, 'IT-100', 'PF', 'Ray', 'Harmin', '513-828-9090'),
		(2, 'IT-101', '.NET', 'Rob', 'Hammil', '513-202-2020'),
		(3, 'IT-111', 'SQL', 'Keith', 'Krammer', '513-456-7890')

---- ---------------------------------------------------------------
---- Step #3.3:	Add 3 Rooms
---- ---------------------------------------------------------------

Insert Into TRooms (intRoomID, strRoomNumber, intCapacity, strMeetingTimes)
Values	(1, '410', 30, 'W 6pm'),
		(2, '414', 25, 'TH 5pm'),
		(3, '412', 35, 'M T 4pm')

---- ---------------------------------------------------------------
---- Step #3.3:	Add 3 Books
---- ---------------------------------------------------------------

Insert Into TBooks (intBookID, strName, strAuthor, strISBN)
Values	(1, 'Intro IT 1', 'Bill Bob', '111111'),
		(2, 'Intro SQL 1', 'Jon Boy', '222222'),
		(3, 'Intro .NET 1', 'Derek Fureal', '333333')

---- ---------------------------------------------------------------
---- Step #3.3:	Add 3 Students
---- ---------------------------------------------------------------

Insert Into TStudents (intStudentID, strFirstName, strLastName, strStudentNumber, strPhoneNumber)
Values	(1, 'Nick', 'Regan', '8943', '513-290-0390'),
		(2, 'Hailey', 'Bollinger', '9768', '513-312-0000'),
		(3, 'Dan', 'Christman', '6666', '513-280-0456')






---- ---------------------------------------------------------------
---- Step #4.1:	Create Tables
---- ---------------------------------------------------------------

Create Table TFlights
(
		intFlightID					int					not null,
		strFlight					varchar(50)			not null,
		strDescription				varchar(50)			not null,
		strAirplayNumber			varchar(50)			not null,
		strAirplaneType				varchar(50)			not null,
		intAirplaneCapacity			varchar(50)			not null
		constraint TFlights_PK Primary Key (intFlightID)
)

Create Table TPilots
(

		intFlightID					int					not null,
		intPilotID					int					not null,
		strPilotName				varchar(50)			not null,
		strPhoneNumber				varchar(50)			not null,
		strPilotRole				varchar(50)			not null,
		constraint TPilots_PK Primary Key (intFlightID, intPilotID)
)

Create Table TFlightAttendants
(
		intFlightID					int					not null,
		intFlightAttendantID		int					not null,
		strName						varchar(50)			not null,
		strPhoneNumber				varchar(50)			not null,
		constraint TFlightAttendants_PK Primary Key (intFlightID, intFlightAttendantID)
)

Create Table TPassengers
(
		intFlightID					int					not null,
		intPassengerID				int					not null,
		strName						varchar(50)			not null,
		strPhoneNumber				varchar(50)			not null,
		strSeatNumber				varchar(50)			not null,
		constraint TPassengers_PK Primary Key (intFlightID, intPassengerID)
)

------ ---------------------------------------------------------------
------ Step #4.2:	Identify and Create Foreign Keys
------ ---------------------------------------------------------------

Alter Table TPilots Add Constraint TPilots_TFlights_FK 
Foreign Key (intFlightID) References TFlights (intFlightID)

Alter Table TFlightAttendants Add Constraint TFlightAttendants_TFlights_FK 
Foreign Key (intFlightID) References TFlights (intFlightID)

Alter Table TPassengers Add Constraint TPassengers_TFlights_FK 
Foreign Key (intFlightID) References TFlights (intFlightID)


---- ---------------------------------------------------------------
---- Step #4.3:	Add 3 Flights
---- ---------------------------------------------------------------

insert into TFlights (intFlightID, strFlight, strDescription, strAirplayNumber, strAirplaneType, intAirplaneCapacity)
Values	(1, 'Denver', 'DVR', '1234', 'Big', 1000),
		(2, 'Philipines', 'PHL', '8675', 'smallish', 200),
		(3, 'Cleveland', 'CLV', '4141', 'Frickin Huge', 8000)


---- ---------------------------------------------------------------
---- Step #4.4:	Add 3 Pilots
---- ---------------------------------------------------------------

insert into TPilots (intFlightID, intPilotID, strPilotName, strPhoneNumber, strPilotRole)
Values	(1, 1, 'Blake', '420-420-4200', 'Co-Pilot'),
		(1, 2, '""', '""', 'Pilot'),
		(2, 3, 'Adam', '690-690-6969', 'Pilot'),
		(2, 4, 'Glen', '""', 'Co-Pilot'),
		(3, 6, 'Anders', '513-292-0000', 'Pilot'),
		(3, 7, 'Danny', '678-9090', 'Co-Pilot')




---- ---------------------------------------------------------------
---- Step #5.1:	Create Tables
---- ---------------------------------------------------------------

Create table TCustomers
(
		intCustomerID				int					not null,
		strFirstName				varchar(50)			not null,
		strLastName					varchar(50)			not null,
		constraint TCustomers_PK Primary Key (intCustomerID)
)

Create table TItems
(
		intItemID					int					not null,
		strItem						varchar(50)			not null,
		intPrice					int					not null,
		constraint TItems_PK Primary Key (intItemID)
)

Create table TOrders
(
		intOrderID					int					not null,
		intItemID					int					not null,
		intItemQuantity				int					not null,
		constraint TOrders_PK Primary Key (intOrderID, intItemID)
)

Create table TCustomerOrders
(
		intCustomerID				int					not null,
		intOrderID					int					not null,
		constraint TCustomerOrders_PK Primary Key (intCustomerID, intOrderID)
)

------ ---------------------------------------------------------------
------ Step #5.2:	Identify and Create Foreign Keys
------ ---------------------------------------------------------------

Alter Table TOrders Add Constraint TOrders_TItems_FK 
Foreign Key (intItemID) References TItems (intItemID)

Alter Table TCustomerOrders Add Constraint TCustomerOrders_TCustomers_FK 
Foreign Key (intCustomerID) References TCustomers (intCustomerID)

Alter Table TCustomerOrders Add Constraint TCustomerOrders_TOrders_FK 
Foreign Key (intOrderID) References TOrders (intOrderID)