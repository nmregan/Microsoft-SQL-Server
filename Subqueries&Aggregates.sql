-- --------------------------------------------------------------------------------
-- Name: Nicholas Regan
-- Class: IT-112-401
-- Abstract: Homework 2
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL2     -- Get out of the master database
SET NOCOUNT ON -- Report only errors

-- --------------------------------------------------------------------------------
-- Step #0.0: Drop Tables
-- --------------------------------------------------------------------------------

IF OBJECT_ID('TTeamPlayers') IS NOT NULL DROP TABLE TTeamPlayers
IF OBJECT_ID('TTeams') IS NOT NULL DROP TABLE TTeams
IF OBJECT_ID('TPlayers') IS NOT NULL DROP TABLE TPlayers

IF OBJECT_ID('TUserFavoriteSongs') IS NOT NULL DROP TABLE TUserFavoriteSongs
IF OBJECT_ID('TSongs') IS NOT NULL DROP TABLE TSongs
IF OBJECT_ID('TUsers') IS NOT NULL DROP TABLE TUsers

IF OBJECT_ID('TCourseStudents') IS NOT NULL DROP TABLE TCourseStudents
IF OBJECT_ID('TCourseBooks') IS NOT NULL DROP TABLE TCourseBooks
IF OBJECT_ID('TCourses') IS NOT NULL DROP TABLE TCourses
IF OBJECT_ID('TInstructors') IS NOT NULL DROP TABLE TInstructors
IF OBJECT_ID('TRooms') IS NOT NULL DROP TABLE TRooms
IF OBJECT_ID('TStudents') IS NOT NULL DROP TABLE TStudents
IF OBJECT_ID('TGrades') IS NOT NULL DROP TABLE TGrades
IF OBJECT_ID('TBooks') IS NOT NULL DROP TABLE TBooks

IF OBJECT_ID('TCustomerOrderItems') IS NOT NULL DROP TABLE TCustomerOrderItems
IF OBJECT_ID('TCustomerOrders') IS NOT NULL DROP TABLE TCustomerOrders
IF OBJECT_ID('TCustomers') IS NOT NULL DROP TABLE TCustomers
IF OBJECT_ID('TSalesRepresentatives') IS NOT NULL DROP TABLE TSalesRepresentatives
IF OBJECT_ID('TItems') IS NOT NULL DROP TABLE TItems

-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
-- --------------------------------------------------------------------------------
Create Table TTeams
(
		intTeamID			Integer				Not Null,
		strTeam				Varchar(50)			Not Null,
		strMascot			Varchar(50)			Not Null,
		CONSTRAINT TTeams_PK PRIMARY KEY( intTeamID )
)

Create Table TPlayers
(
		intPlayerID			Integer				Not Null,
		strFirstName		Varchar(50)			Not Null,
		strLastName			Varchar(50)			Not Null,
		CONSTRAINT TPlayers_PK PRIMARY KEY( intPlayerID )
)

Create Table TTeamPlayers
(
		intTeamID			Integer				Not Null,
		intPlayerID			Integer				Not Null,
		CONSTRAINT TTeamPlayers_PK PRIMARY KEY( intTeamID, intPlayerID )
)

-- --------------------------------------------------------------------------------
-- Step #1.2: Identify and create all the foreign keys.  - ORDER BY CHILD THEN PARENT
-- --------------------------------------------------------------------------------
--		Child						Parent					Column(s)
--		------						------					------
-- 1	TTeamPlayers				TTeams					intTeamID
-- 2	TTeamPlayers				TPlayers				intPlayerID

-- 1
ALTER TABLE TTeamPlayers ADD CONSTRAINT TTeamPlayers_TTeams_FK1
FOREIGN KEY ( intTeamID ) REFERENCES TTeams( intTeamID )

-- 2
ALTER TABLE TTeamPlayers ADD CONSTRAINT TTeamPlayers_TPlayers_FK1
FOREIGN KEY ( intPlayerID ) REFERENCES TPlayers( intPlayerID )

-- --------------------------------------------------------------------------------
-- Step #1.3: Add Sample Data
-- --------------------------------------------------------------------------------
Insert Into TTeams ( intTeamID, strTeam, strMascot)
Values	(1, 'Bengals', 'Tiger'),
		(2, 'Browns', 'Dog')

Insert Into TPlayers ( intPlayerID, strFirstName, strLastName)
Values	(1, 'Buck', 'Rodgers'),
		(2, 'Johnny', 'Quest'),
		(3, 'Ryan', 'Dunn'),
		(4, 'Dick', 'Dale'),
		(5, 'Debbie', 'Downer')

Insert Into TTeamPlayers ( intTeamID, intPlayerID)
Values	(1, 1),
		(1, 2),
		(2, 3),
		(2, 4)

-- --------------------------------------------------------------------------------
-- Step #1.4: Write the query that will show the ID 
--	and name for every team along with a count of how many players are on each team.
-- --------------------------------------------------------------------------------
Select
	TT.intTeamID,
	TT.strTeam,
	Count(*)		As intPlayerCount
From 
	TTeams			As TT
		Inner Join TTeamPlayers As TTP
		On(TT.intTeamID = TTP.intTeamID)
Group By			
	TT.intTeamID,
	TT.strTeam
Order By
	TT.strTeam

-- --------------------------------------------------------------------------------
-- Step #1.5: Write the query that will show all the players ON the Bengals
-- --------------------------------------------------------------------------------
Select
	TP.intPlayerID,		
	TP.strLastName + ', ' + strFirstName	As strPlayer
From
	TPlayers			As TP
Where
	TP.intPlayerID In
	(
		Select
			TTP.intPlayerID
		From
			TTeamPlayers	As TTP
		Where
			TTP.intTeamID = 1
	)
Order By
	TP.strLastName,
	TP.strFirstName

-- --------------------------------------------------------------------------------
-- Step #1.6: Write the query that will show all the players NOT ON the Bengals
-- --------------------------------------------------------------------------------
Select
	TP.intPlayerID,		
	TP.strLastName + ', ' + strFirstName	As strPlayer
From
	TPlayers			As TP
Where
	TP.intPlayerID Not In
	(
		Select
			TTP.intPlayerID
		From
			TTeamPlayers	As TTP
		Where
			TTP.intTeamID = 1
	)
Order By
	TP.strLastName,
	TP.strFirstName

-- --------------------------------------------------------------------------------
-- Step #2.1: Create Tables
-- --------------------------------------------------------------------------------
Create Table TUsers
(
		intUserID			Integer				Not Null,
		strFirstName		Varchar(50)			Not Null,
		strLastName			Varchar(50)			Not Null,
		CONSTRAINT TUsers_PK PRIMARY KEY( intUserID )
)

Create Table TSongs
(		
		intSongID			Integer				Not Null,
		strSong				Varchar(50)			Not Null,
		strArtist			Varchar(50)			Not Null,
		CONSTRAINT TSongs_PK PRIMARY KEY( intSongID )
)

Create Table TUserFavoriteSongs
(
		intUserID			Integer				Not Null,
		intSongID			Integer				Not Null,
		intSortOrder		Integer				Not Null,
		CONSTRAINT TUserFavoriteSongs_PK PRIMARY KEY( intUserID, intSongID )
)

-- --------------------------------------------------------------------------------
-- Step #2.2: Identify and create all the foreign keys.  - ORDER BY CHILD THEN PARENT
-- --------------------------------------------------------------------------------
--		Child						Parent					Column(s)
--		------						------					------
-- 1	TUserFavoriteSongs			TUsers					intUserID
-- 2	TUserFavoriteSongs			TSongs					intSongID

-- 1
ALTER TABLE TUserFavoriteSongs ADD CONSTRAINT TUserFavoriteSongs_TUsers_FK1
FOREIGN KEY ( intUserID ) REFERENCES TUsers( intUserID )

-- 2
ALTER TABLE TUserFavoriteSongs ADD CONSTRAINT TUserFavoriteSongs_TSongs_FK1
FOREIGN KEY ( intSongID ) REFERENCES TSongs( intSongID )

-- --------------------------------------------------------------------------------
-- Step #2.3: Add Sample Data
-- --------------------------------------------------------------------------------
Insert Into TUsers ( intUserID, strFirstName, strLastName)
Values	(1, 'Dennis', 'Reynolds'),
		(2, 'Charlie', 'Kelly'),
		(3, 'Mac', 'Donald'),
		(4, 'Frank', 'Underwood')

Insert Into TSongs ( intSongID, strSong, strArtist)
Values	(1, 'Stir It Up', 'Bob Marley'),
		(2, 'Get Up, Stand Up', 'Bob Marley'),
		(3, 'I Shot The Sheriff', 'Bob Marley'),
		(4, '409', 'Beach Boys'),
		(5, 'Surfer Girl', 'Beach Boys'),
		(6, 'Barbara Ann', 'Beach Boys'),
		(7, 'Peek a Boo', 'Devo'),
		(8, 'Big Mess', 'Devo'),
		(9, 'Satisfaction', 'Devo'),
		(10, 'Best I Ever Had', 'Drake')

Insert Into TUserFavoriteSongs ( intUserID, intSongID, intSortOrder)
Values	(1, 1, 1),
		(1, 2, 2),
		(1, 3, 3),
		(2, 4, 1),
		(2, 5, 2),
		(2, 6, 3),
		(3, 7, 1),
		(3, 8, 2),
		(3, 9, 3)

-- --------------------------------------------------------------------------------
-- Step #2.4: Write the query that will show the ID and 
--	name for every user along with a count of how many favorite songs each user has.
-- --------------------------------------------------------------------------------
Select
	TU.intUserID,
	TU.strLastName + ', ' + TU.strLastName	As strUser,
	Count(*)								As intUserFavoriteSongCount						
From
	TUsers				As TU,
	TUserFavoriteSongs	As TUFS
Where
	TU.intUserID = TUFS.intUserID
Group By
	TU.intUserID,
	TU.strFirstName,
	TU.strLastName
Order By
	TU.strLastName,
	TU.strFirstName

-- --------------------------------------------------------------------------------
-- Step #2.5: Write the query that will show all the users (ID and name ALWAYS) 
--	that have at least three favorite songs by The Beach Boys
-- --------------------------------------------------------------------------------
Select
	TU.intUserID,
	TU.strLastName + ', ' + TU.strLastName	As strUser,
	Count(*)								As intFavoriteBandSongCount
From
	TUsers				As TU,
	TUserFavoriteSongs	As TUFS,
	TSongs				As TS
Where
		TU.intUserID = TUFS.intUserID
	And	TUFS.intSongID = TS.intSongID
	And TS.strArtist = 'Beach Boys'
Group By
	TU.intUserID,
	TU.strLastName,
	TU.strFirstName
Having
	Count(*) >= 3
Order By
	TU.strLastName,
	TU.strFirstName

-- --------------------------------------------------------------------------------
-- Step #3.1: Create Tables
-- --------------------------------------------------------------------------------
Create Table TCourses
(
		intCourseID				Integer				Not Null,
		strCourse				Varchar(50)			Not Null,
		strDescription			Varchar(50)			Not Null,
		intInstructorID			Integer				Not Null,
		intRoomID				Integer				Not Null,
		strMeetingTimes			Varchar(50)			Not Null,
		decCreditHours			Decimal(38,0)		Not Null,
		CONSTRAINT TCourses_PK PRIMARY KEY( intCourseID )
)

Create Table TInstructors
(
		intInstructorID			Integer				Not Null,
		strFirstName			Varchar(50)			Not Null,
		strLastName				Varchar(50)			Not Null,
		CONSTRAINT TInstructors_PK PRIMARY KEY( intInstructorID )
)

Create Table TRooms
(
		intRoomID				Integer				Not Null,
		strRoomNumber			Varchar(50)			Not Null,
		intCapacity				Integer				Not Null,
		CONSTRAINT TRooms_PK PRIMARY KEY( intRoomID )
)

Create Table TCourseStudents
(
		intCourseID				Integer				Not Null,
		intStudentID			Integer				Not Null,
		intGradeID				Integer				Not Null,
		CONSTRAINT TCourseStudents_PK PRIMARY KEY( intCourseID, intStudentID )
)

Create Table TStudents
(
		intStudentID			Integer				Not Null,
		strFirstName			Varchar(50)			Not Null,
		strLastName				Varchar(50)			Not Null,
		CONSTRAINT TStudents_PK PRIMARY KEY( intStudentID )
)

Create Table TGrades
(
		intGradeID				Integer				Not Null,
		strGradeLetter			Varchar(50)			Not Null,
		decGradePointValue		Decimal				Not Null,
		CONSTRAINT TGrades_PK PRIMARY KEY( intGradeID )
)

Create Table TCourseBooks
(
		intCourseID				Integer				Not Null,
		intBookID				Integer				Not Null,
		CONSTRAINT TCourseBooks_PK PRIMARY KEY( intCourseID, intBookID )
)

Create Table TBooks
(
		intBookID				Integer				Not Null,
		strBookName				Varchar(50)			Not Null,
		strAuthor				Varchar(50)			Not Null,
		strISBN					Varchar(50)			Not Null,
		CONSTRAINT TBooks_PK PRIMARY KEY( intBookID )
)

-- --------------------------------------------------------------------------------
-- Step #3.2: Identify and create all the foreign keys.  - ORDER BY CHILD THEN PARENT
-- --------------------------------------------------------------------------------
--		Child						Parent					Column(s)
--		------						------					------
-- 1	TCourses					TInstructors			intInstructorID
-- 2	TCourses					TRooms					intRoomID
-- 3	TCourseStudents				TCourses				intCourseID	
-- 4	TCourseStudents				TStudents				intStudentID
-- 5	TCourseStudents				TGrades					intGradeID
-- 6	TCourseBooks				TCourses				intCourseID
-- 7	TCourseBooks				TBooks					intBookID

-- 1
ALTER TABLE TCourses ADD CONSTRAINT TCourses_TInstructors_FK1
FOREIGN KEY ( intInstructorID ) REFERENCES TInstructors( intInstructorID )

-- 2
ALTER TABLE TCourses ADD CONSTRAINT TCourses_TRooms_FK1
FOREIGN KEY ( intRoomID ) REFERENCES TRooms( intRoomID )

-- 3
ALTER TABLE TCourseStudents ADD CONSTRAINT TCourseStudents_TCourses_FK1
FOREIGN KEY ( intCourseID ) REFERENCES TCourses( intCourseID )

-- 4
ALTER TABLE TCourseStudents ADD CONSTRAINT TCourseStudents_TStudents_FK1
FOREIGN KEY ( intStudentID ) REFERENCES TStudents( intStudentID )

-- 5
ALTER TABLE TCourseStudents ADD CONSTRAINT TCourseStudents_TGrades_FK1
FOREIGN KEY ( intGradeID ) REFERENCES TGrades( intGradeID )

-- 6
ALTER TABLE TCourseBooks ADD CONSTRAINT TCourseBooks_TCourses_FK1
FOREIGN KEY ( intCourseID ) REFERENCES TCourses( intCourseID )

-- 7
ALTER TABLE TCourseBooks ADD CONSTRAINT TCourseBooks_TBooks_FK1
FOREIGN KEY ( intBookID ) REFERENCES TBooks( intBookID )

-- --------------------------------------------------------------------------------
-- Step #3.3: Add Sample Data
-- --------------------------------------------------------------------------------
Insert Into TInstructors ( intInstructorID, strFirstName, strLastName)
Values	(1, 'Ray', 'Harmon'),
		(2, 'Bob', 'Neilds'),
		(3, 'Tommie', 'Garland')

Insert Into TRooms ( intRoomID, strRoomNumber, intCapacity)
Values	(1, '401', 20),
		(2, '402', 30),
		(3, '403', 40)

Insert Into TCourses ( intCourseID, strCourse, strDescription, intInstructorID, intRoomID, strMeetingTimes, decCreditHours)
Values	(1, 'IT100', 'IT Foundations', 1, 1, '7am - 8am', 3),
		(2, 'IT101', 'VB.Net1', 2, 2, '9am - 10am', 3),
		(3, 'IT111', 'JavaScript', 3, 3, '5pm - 10pm', 3)

Insert Into TStudents ( intStudentID, strFirstName, strLastName)
Values	(1, 'Morty', 'Smith'),
		(2, 'Summer', 'Smith'),
		(3, 'Beth', 'Smith'),
		(4, 'Rick', 'Sanchez'),
		(5, 'Jerry', 'Smith'),
		(6, 'Justin', 'Roiland')

Insert Into TGrades ( intGradeID, strGradeLetter, decGradePointValue)
Values	( 1, 'A', 4.0 ),
		( 2, 'B', 3.0 ),
		( 3, 'C', 2.0 ),
		( 4, 'D', 1.0 ),
		( 5, 'F', 0.0 ),
		( 6, 'S', 4.0 ),
		( 7, 'N', 0.0 ),
		( 8, 'I', 0.0 ),
		( 9, 'W', 0.0 )

Insert Into TCourseStudents ( intCourseID, intStudentID, intGradeID)
Values	(1, 1, 3),
		(1, 2, 1),
		(2, 3, 9),
		(2, 6, 4),
		(2, 5, 2),
		(3, 1, 2),
		(3, 5, 9)

Insert Into TBooks ( intBookID, strBookName, strAuthor, strISBN)
Values	(1, 'Programer For Life', 'Dick Dale', '1111'),
		(2, 'SQL For Stangers', 'Abed', '2222'),
		(3, 'VB.Net For Suckers', 'Jerry Springer', '3333'),
		(4, 'Java All Day', 'Larry David', '4444'),
		(5, 'PHP Intro', 'Kevin Spacey', '5555'),
		(6, 'HTML Websites', 'Frank Underwood', '6666')

Insert Into TCourseBooks ( intCourseID, intBookID)
Values	(1, 1),
		(1, 5),
		(2, 3),
		(2, 2),
		(3, 4),
		(3, 6)

-- --------------------------------------------------------------------------------
-- Step #3.4: Write the query that will show the ID and 
--	name for every course along with the room capacity, 
--	a count of how many students are current enrolled and 
--	how many spots are left in the class (room capacity – current enrollment count)
-- --------------------------------------------------------------------------------
Select
	TC.intCourseID,
	TC.strCourse,
	TR.intCapacity,
	Count(*)					As intStudentEnrolledCount,
	TR.intCapacity - Count(*)	As intCourseSpotsAvailableCount
From
	TCourses				As TC,
	TRooms					As TR,
	TCourseStudents			As TCS
Where
		TC.intRoomID = TR.intRoomID
	And	TC.intCourseID = TCS.intCourseID
Group By
	TC.intCourseID,
	TC.strCourse,
	TR.intCapacity

-- --------------------------------------------------------------------------------
-- Step #3.5: Write the query that will show the ID and 
--	name for every student along with each student’s grade point average (GPA).
-- --------------------------------------------------------------------------------
Select
	TS.intStudentID,
	TS.strLastName + ', ' + TS.strFirstName									As strStudentName,
	Sum(TC.decCreditHours * TG.decGradePointValue)/Sum(TC.decCreditHours)	As decGradePointAverage
From
	TStudents				As TS,
	TCourseStudents			As TCS,
	TCourses				As TC,
	TGrades					As TG
Where
		TS.intStudentID = TCS.intStudentID
	And TCS.intCourseID = TC.intCourseID
	And TCS.intGradeID = TG.intGradeID
	And TG.intGradeID <> 8
	And TG.intGradeID <> 9
Group By
	TS.intStudentID,
	TS.strLastName,
	TS.strFirstName
Order By
	TS.strLastName,
	TS.strFirstName

-- --------------------------------------------------------------------------------
-- Step #4.1: Create Tables
-- --------------------------------------------------------------------------------
Create Table TCustomers
(
		intCustomerID				Integer				Not Null,
		strFirstName				Varchar(50)			Not Null,
		strLastName					Varchar(50)			Not Null,
		CONSTRAINT TCustomers_PK PRIMARY KEY( intCustomerID )
)

Create Table TSalesRepresentatives
(
		intSalesRepresentativeID	Integer				Not Null,
		strFirstName				Varchar(50)			Not Null,
		strLastName					Varchar(50)			Not Null,
		CONSTRAINT TSalesRepresentatives_PK PRIMARY KEY( intSalesRepresentativeID )
)

Create Table TCustomerOrders
(
		intCustomerID				Integer				Not Null,
		intOrderIndex				Integer				Not Null,
		dtmOrderDate				DateTime			Not Null,
		intSalesRepresentativeID	Integer				Not Null,
		CONSTRAINT TCustomerOrders_PK PRIMARY KEY( intCustomerID, intOrderIndex )
)

Create Table TItems
(
		intItemID					Integer				Not Null,
		strItem						Varchar(50)			Not Null,
		monPrice					Money				Not Null,
		CONSTRAINT TItems_PK PRIMARY KEY( intItemID )
)

Create Table TCustomerOrderItems
(
		intCustomerID				Integer				Not Null,
		intOrderIndex				Integer				Not Null,
		intItemID					Integer				Not Null,
		intQuantity					Integer				Not Null,
		CONSTRAINT TCustomerOrderItems_PK PRIMARY KEY( intCustomerID, intOrderIndex, intItemID )
)

-- --------------------------------------------------------------------------------
-- Step #4.2: Identify and create all the foreign keys.  - ORDER BY CHILD THEN PARENT
-- --------------------------------------------------------------------------------
--		Child						Parent					Column(s)
--		------						------					------
-- 1	TCustomerOrders				TCustomers				intCustomerID
-- 2	TCustomerOrders				TSalesRepresentatives	intSalesRepresentativeID
-- 3	TCustomerOrderItems			TCustomerOrders			intCustomerID, intOrderIndex
-- 4	TCustomerOrderItems			TItems					intItemID

-- 1
ALTER TABLE TCustomerOrders ADD CONSTRAINT TCustomerOrders_TCustomers_FK1
FOREIGN KEY ( intCustomerID ) REFERENCES TCustomers( intCustomerID )

-- 2
ALTER TABLE TCustomerOrders ADD CONSTRAINT TCustomerOrders_TSalesRepresentatives_FK1
FOREIGN KEY ( intSalesRepresentativeID ) REFERENCES TSalesRepresentatives( intSalesRepresentativeID )

-- 3
ALTER TABLE TCustomerOrderItems ADD CONSTRAINT TCustomerOrderItems_TCustomerOrders_FK1
FOREIGN KEY ( intCustomerID, intOrderIndex ) REFERENCES TCustomerOrders( intCustomerID, intOrderIndex )

-- 4
ALTER TABLE TCustomerOrderItems ADD CONSTRAINT TCustomerOrderItems_TItems_FK1
FOREIGN KEY ( intItemID ) REFERENCES TItems( intItemID )

-- --------------------------------------------------------------------------------
-- Step #4.3: Add Sample Data
-- --------------------------------------------------------------------------------
Insert Into TCustomers (intCustomerID, strFirstName, strLastName)
Values	(1, 'Bill', 'Hicks'),
		(2, 'Silent', 'Bob'),
		(3, 'Dave', 'Chappell')

Insert Into TSalesRepresentatives (intSalesRepresentativeID, strFirstName, strLastName)
Values	(1, 'Dale', 'Denton'),
		(2, 'Saul', 'Goodman'),
		(3, 'Walter', 'White'),
		(4, 'Gus', 'Fring')

Insert Into TCustomerOrders (intCustomerID, intOrderIndex, dtmOrderDate, intSalesRepresentativeID)
Values	(1, 1, '2016/01/01 1:00 PM', 1),
		(1, 2, '2014/02/02 2:00 PM', 1),
		(1, 3, '2012/03/03 3:00 PM', 1),
		(2, 1, '2010/04/04 4:00 PM', 2),
		(2, 2, '2011/05/05 5:00 PM', 2),
		(2, 3, '2013/06/06 6:00 PM', 2),
		(3, 1, '2015/07/07 7:00 PM', 3),
		(3, 2, '2017/08/08 8:00 PM', 3),
		(3, 3, '2008/09/09 9:00 PM', 3)

Insert Into TItems (intItemID, strItem, monPrice)
Values	(1, 'Apples', 1.00),
		(2, 'Kale', 2.00),
		(3, 'Squash', 3.00),
		(4, 'Tunip', 4.00),
		(5, 'Gushers', 5.00),
		(6, 'Bananas', 6.00)

Insert Into TCustomerOrderItems (intCustomerID, intOrderIndex, intItemID, intQuantity)
Values	(1, 1, 1, 1),
		(1, 1, 5, 3),
		(1, 2, 6, 1),
		(2, 1, 3, 2),
		(2, 1, 2, 4),
		(2, 2, 4, 2),
		(3, 1, 3, 2),
		(3, 1, 2, 4),
		(3, 2, 6, 1)

-- --------------------------------------------------------------------------------
-- Step #4.4: Write the query that will show the following information for every order: 
--	the customer ID and name, the order index, the order date, the total cost of the order, 
--	the total number of items in the order, the average price of each item in the order.
-- --------------------------------------------------------------------------------
Select
	TC.intCustomerID,
	TC.strLastName + ', ' + TC.strFirstName						As strCustomerName,
	TCO.intOrderIndex,
	Sum(TI.monPrice * TCOI.intQuantity)							As monTotalPrice,
	Sum(TCOI.intQuantity)										As intItemCount,
	Sum(TI.monPrice * TCOI.intQuantity)/Sum(TCOI.intQuantity)	As monAverageItemPrice
From
	TCustomers				As TC,
	TCustomerOrders			As TCO,
	TCustomerOrderItems		As TCOI,
	TItems					As TI
Where
		TC.intCustomerID = TCO.intCustomerID
	And	TCO.intCustomerID = TCOI.intCustomerID
	And TCO.intOrderIndex = TCOI.intOrderIndex
	And	TCOI.intItemID = TI.intItemID
Group By
	TC.intCustomerID,
	TC.strLastName,
	TC.strFirstName,
	TCO.intOrderIndex,
	TCO.dtmOrderDate
Order By
	TC.strLastName,
	TC.strFirstName

-- --------------------------------------------------------------------------------
-- Step #4.5: Write the query that will show the ID and 
--	name for every sales representative and 
--	the total sales for each sales representative for each of the last three years 
-- --------------------------------------------------------------------------------
Select
	TSR.intSalesRepresentativeID,
	TSR.strLastName + ', ' + TSR.strFirstName			As strSalesRepresentative,
	DATEPART(Year, TCO.dtmOrderDate)					As intOrderYear,
	SUM(TCOI.intQuantity * TI.monPrice)					As monTotalPrice
From
	TSalesRepresentatives				As TSR,
	TCustomerOrders						As TCO,
	TCustomerOrderItems					As TCOI,
	TItems								As TI
Where
		TSR.intSalesRepresentativeID = TCO.intSalesRepresentativeID
	And	TCO.intCustomerID = TCOI.intCustomerID
	And TCOI.intOrderIndex = TCOI.intOrderIndex
	And TCOI.intItemID = TI.intItemID
	And DATEPART(Year, TCO.dtmOrderDate) >= Datepart(Year, dateadd( year, -2, getdate()))
Group By
	TSR.intSalesRepresentativeID,
	TSR.strLastName,
	TSR.strFirstName,
	DATEPART(Year, TCO.dtmOrderDate)
Order By
	DATEPART(Year, TCO.dtmOrderDate),
	SUM(TCOI.intQuantity * TI.monPrice),
	TSR.strLastName,
	TSR.strFirstName
