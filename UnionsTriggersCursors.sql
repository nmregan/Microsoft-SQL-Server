-- --------------------------------------------------------------------------------
-- Name: Nicholas Regan
-- Class: IT-112-401
-- Abstract: Homework 10 - Unions, Triggers and Cursors
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------

USE dbSQL2     -- Get out of the master database
SET NOCOUNT ON -- Report only errors

IF OBJECT_ID('TUserFavoriteSongs') IS NOT NULL DROP TABLE TUserFavoriteSongs
IF OBJECT_ID('TSongs') IS NOT NULL DROP TABLE TSongs
IF OBJECT_ID('TUsers') IS NOT NULL DROP TABLE TUsers
IF OBJECT_ID('TGenres') IS NOT NULL DROP TABLE TGenres

IF OBJECT_ID('TCourseStudents') IS NOT NULL DROP TABLE TCourseStudents
IF OBJECT_ID('TCourses') IS NOT NULL DROP TABLE TCourses
IF OBJECT_ID('TInstructors') IS NOT NULL DROP TABLE TInstructors
IF OBJECT_ID('TRooms') IS NOT NULL DROP TABLE TRooms
IF OBJECT_ID('TStudents') IS NOT NULL DROP TABLE TStudents
IF OBJECT_ID('TGrades') IS NOT NULL DROP TABLE TGrades
IF OBJECT_ID('TMajors') IS NOT NULL DROP TABLE TMajors
IF OBJECT_ID('TCourseStudentChangeLogs') IS NOT NULL DROP TABLE TCourseStudentChangeLogs

IF OBJECT_ID('tgrTCourseStudentChangeLogs_Update') IS NOT NULL DROP TRIGGER tgrTCourseStudentChangeLogs_Update


-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
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
		intGenreID			Integer				Not Null,
		CONSTRAINT TSongs_PK PRIMARY KEY( intSongID )
)

Create Table TUserFavoriteSongs
(
		intUserID			Integer				Not Null,
		intSongID			Integer				Not Null,
		intSortOrder		Integer				Not Null,
		CONSTRAINT TUserFavoriteSongs_PK PRIMARY KEY( intUserID, intSongID )
)

Create Table TGenres
(
		intGenreID			Integer				Not Null,
		strGenre			Varchar(50)			Not Null,
		CONSTRAINT TGenres_PK PRIMARY KEY( intGenreID )
)

-- --------------------------------------------------------------------------------
-- Step #1.2: Identify and create all the foreign keys.  - ORDER BY CHILD THEN PARENT
-- --------------------------------------------------------------------------------
--		Child						Parent					Column(s)
--		------						------					------
-- 1	TUserFavoriteSongs			TUsers					intUserID
-- 2	TUserFavoriteSongs			TSongs					intSongID
-- 3	TSongs						TGenres					intGenreID

-- 1
ALTER TABLE TUserFavoriteSongs ADD CONSTRAINT TUserFavoriteSongs_TUsers_FK1
FOREIGN KEY ( intUserID ) REFERENCES TUsers( intUserID )

-- 2
ALTER TABLE TUserFavoriteSongs ADD CONSTRAINT TUserFavoriteSongs_TSongs_FK1
FOREIGN KEY ( intSongID ) REFERENCES TSongs( intSongID )

-- 3
ALTER TABLE TSongs ADD CONSTRAINT TSongs_TGenres_FK1
FOREIGN KEY ( intGenreID ) REFERENCES TGenres( intGenreID )

-- --------------------------------------------------------------------------------
-- Step #1.3: Add Sample Data
-- --------------------------------------------------------------------------------
Insert Into TUsers ( intUserID, strFirstName, strLastName)
Values	(1, 'Dennis', 'Reynolds'),
		(2, 'Charlie', 'Kelly'),
		(3, 'Mac', 'Donald'),
		(4, 'Frank', 'Underwood')

Insert Into TGenres ( intGenreID, strGenre)
Values	(1, 'Reggae'),
		(2, 'Rock and Roll'),
		(3, '80s Pop'),
		(4, 'Hip Hop'),
		(5, 'Metal')

Insert Into TSongs ( intSongID, strSong, strArtist, intGenreID)
Values	(1, 'Stir It Up', 'Bob Marley', 1),
		(2, 'Get Up, Stand Up', 'Bob Marley', 1),
		(3, 'I Shot The Sheriff', 'Bob Marley', 1),
		(4, '409', 'Beach Boys', 2),
		(5, 'Surfer Girl', 'Beach Boys', 2),
		(6, 'Barbara Ann', 'Beach Boys', 2),
		(7, 'Peek a Boo', 'Devo', 3),
		(8, 'Big Mess', 'Devo', 3),
		(9, 'Satisfaction', 'Devo', 3),
		(10, 'Best I Ever Had', 'Drake', 4)

Insert Into TUserFavoriteSongs ( intUserID, intSongID, intSortOrder)
Values	(1, 1, 1),
		(1, 2, 2),
		(1, 3, 3),
		(1, 7, 4),
		(1, 8, 5),
		(2, 4, 1),
		(2, 5, 2),
		(2, 6, 3),
		(2, 1, 4),
		(2, 2, 5),
		(3, 7, 1),
		(3, 8, 2),
		(3, 9, 3),
		(3, 4, 4),
		(3, 6, 5)

-- --------------------------------------------------------------------------------
-- Step #1.4: Write a SELECT statement with at least two conditions linked with the 
--			logical OR operator
-- --------------------------------------------------------------------------------
SELECT
	TG.intGenreID,
	TG.strGenre,
	TS.intSongID,
	TS.strSong,
	TS.strArtist

FROM
	TGenres AS TG
		JOIN TSongs AS TS
		ON(TG.intGenreID = TS.intGenreID)

WHERE
	strGenre = '80s Pop' OR strGenre = 'Hip Hop'

ORDER BY
	strGenre

-- --------------------------------------------------------------------------------
-- Step #1.5: Split the single SELECT statement from the previous step at the 
--			OR operator into two separate SELECT statements and 
--			combine with the UNION operator
-- --------------------------------------------------------------------------------
SELECT
	TG.intGenreID,
	TG.strGenre,
	TS.intSongID,
	TS.strSong,
	TS.strArtist

FROM
	TGenres AS TG
		JOIN TSongs AS TS
		ON(TG.intGenreID = TS.intGenreID)

WHERE
	strGenre = '80s Pop'

UNION

SELECT
	TG.intGenreID,
	TG.strGenre,
	TS.intSongID,
	TS.strSong,
	TS.strArtist

FROM
	TGenres AS TG
		JOIN TSongs AS TS
		ON(TG.intGenreID = TS.intGenreID)

WHERE
	strGenre = 'Hip Hop'

ORDER BY
	strGenre

-- --------------------------------------------------------------------------------
-- Step #2.1: Create Tables
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
		intMajorID				Integer				Not Null,
		CONSTRAINT TStudents_PK PRIMARY KEY( intStudentID )
)

Create Table TMajors
(
		intMajorID				Integer				Not Null,
		strMajor				Varchar(50)			Not Null,
		CONSTRAINT TMajors_PK PRIMARY KEY( intMajorID )
)

Create Table TGrades
(
		intGradeID				Integer				Not Null,
		strGradeLetter			Varchar(50)			Not Null,
		decGradePointValue		Decimal				Not Null,
		CONSTRAINT TGrades_PK PRIMARY KEY( intGradeID )
)

-- --------------------------------------------------------------------------------
-- Step #2.2: Identify and create all the foreign keys.  - ORDER BY CHILD THEN PARENT
-- --------------------------------------------------------------------------------
--		Child						Parent					Column(s)
--		------						------					------
-- 1	TCourses					TInstructors			intInstructorID
-- 2	TCourses					TRooms					intRoomID
-- 3	TCourseStudents				TCourses				intCourseID	
-- 4	TCourseStudents				TStudents				intStudentID
-- 5	TCourseStudents				TGrades					intGradeID
-- 6	TStudents					TMajors					intMajorID

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
ALTER TABLE TStudents ADD CONSTRAINT TStudents_TMajors_FK1
FOREIGN KEY ( intMajorID ) REFERENCES TMajors( intMajorID )

-- --------------------------------------------------------------------------------
-- Step #2.3: Add Sample Data
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

Insert Into TMajors ( intMajorID, strMajor)
Values	(1, 'Computer Programming and Database Management'),
		(2, 'Software Engineering'),
		(3, 'Business Programming and Systems Analysis')

Insert Into TStudents ( intStudentID, strFirstName, strLastName, intMajorID)
Values	(1, 'Morty', 'Smith', 1),
		(2, 'Summer', 'Smith', 1),
		(3, 'Beth', 'Smith', 1),
		(4, 'Rick', 'Sanchez', 2),
		(5, 'Jerry', 'Smith', 3),
		(6, 'Justin', 'Roiland', 2)

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

-- --------------------------------------------------------------------------------
-- Step #2.4: Create a history/log table for TCourseStudents
-- --------------------------------------------------------------------------------
CREATE TABLE TCourseStudentChangeLogs
(
		intCourseID				Integer				Not Null,
		intStudentID			Integer				Not Null,
		intChangeIndex			Integer				Not Null,
		dtmChangedDate			DateTime			Not Null,
		strChangedBy			Varchar(50)			Not Null,
		intGradeID				Integer				Not Null,
		CONSTRAINT TCourseStudentChangeLogs_PK PRIMARY KEY( intCourseID, intStudentID,intChangeIndex )
)

-- --------------------------------------------------------------------------------
-- Step #2.5: Create a trigger for UPDATE on the TCS table
-- --------------------------------------------------------------------------------
GO

CREATE TRIGGER tgrTCourseStudentChangeLogs_Update
ON TCourseStudents AFTER UPDATE
AS
SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @dtmChangedDate			AS DATETIME
DECLARE @strChangedBy			AS VARCHAR(50)

BEGIN TRANSACTION

SELECT @dtmChangedDate = GETDATE( )

SELECT @strChangedBy = CURRENT_USER

INSERT INTO TCourseStudentChangeLogs
(
		intCourseID,
		intStudentID,
		intChangeIndex,
		dtmChangedDate,
		strChangedBy,
		intGradeID
)
SELECT
		intCourseID,
		intStudentID,
		(
			SELECT ISNULL(MAX(intChangeIndex) + 1, 1)
			FROM TCourseStudentChangeLogs AS TCSCL (TABLOCKX)
			WHERE TCSCL.intCourseID = DELETED.intCourseID
		),
		@dtmChangedDate,
		@strChangedBy,
		intGradeID
FROM 
		DELETED

COMMIT TRANSACTION

GO

-- --------------------------------------------------------------------------------
-- Step #2.6: Update a single record in the TCS table
-- --------------------------------------------------------------------------------
UPDATE
	TCourseStudents
SET
	intGradeID = 1
WHERE
		intCourseID = 1
	AND intStudentID = 1

SELECT
	*
FROM
	TCourseStudentChangeLogs

-- --------------------------------------------------------------------------------
-- Step #2.7: Update at least two records with the same update statement in the TCS 
-- --------------------------------------------------------------------------------
UPDATE
	TCourseStudents
SET
	intGradeID = 1
WHERE
		intCourseID = 2
	AND intStudentID = 6 

UPDATE
	TCourseStudents
SET
	intGradeID = 1
WHERE
		intCourseID = 3
	AND intStudentID = 1

UPDATE
	TCourseStudents
SET
	intGradeID = 1
WHERE
		intCourseID = 2
	AND intStudentID = 5

SELECT
	*
FROM
	TCourseStudentChangeLogs

-- --------------------------------------------------------------------------------
-- Step #3.1: uspDropForeignKeys
-- --------------------------------------------------------------------------------
GO
CREATE PROCEDURE uspDropForeignKeys
AS
SET NOCOUNT ON
DECLARE @strMessage			VARCHAR(250)	
DECLARE	@strForeignKey		VARCHAR(250)
DECLARE	@strChildTable		VARCHAR(250)
DECLARE	@strCommand			VARCHAR(250)
DECLARE	@strTab				CHAR = CHAR(9)

PRINT @strTab + 'DROP ALL USER FOREIGN KEYS...'

DECLARE crsForeignKeys CURSOR FOR
SELECT
	name					AS strForeignKey,
	OBJECT_NAME(parent_obj) AS strChildTable

FROM
	SysObjects
WHERE
		type		= 'F'
	AND	(
				name	LIKE	'%_FK'
			OR	name	LIKE	'%_FK_'
		)
	AND OBJECT_NAME(parent_obj) LIKE 'T%'
ORDER  BY
	name

OPEN crsForeignKeys
FETCH NEXT FROM crsForeignKeys INTO @strForeignKey, @strChildTable

WHILE @@FETCH_STATUS = 0
BEGIN

	SELECT @strMessage = @strTab + '-DROP ' + @strForeignKey
	PRINT @strMessage

	SELECT @strCommand = 'ALTER TABLE ' + @strChildTable + ' DROP CONSTRAINT ' + @strForeignKey

	EXEC(@strCommand)

	FETCH NEXT FROM crsForeignKeys INTO @strForeignKey, @strChildTable

END

CLOSE crsForeignKeys
DEALLOCATE crsForeignKeys

PRINT @strTab + 'DONE'
GO

-- --------------------------------------------------------------------------------
-- Step #3.2: uspDropUserViews 
-- --------------------------------------------------------------------------------





-- --------------------------------------------------------------------------------
-- Step #3.3: uspDropUserTables  
-- --------------------------------------------------------------------------------






-- --------------------------------------------------------------------------------
-- Step #3.6: I promise never, ever to create these stored procedures or anything 
--			like them on a production database unless my boss tells me to. 
--				- Nick Regan
-- --------------------------------------------------------------------------------