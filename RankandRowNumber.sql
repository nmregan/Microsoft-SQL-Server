-- --------------------------------------------------------------------------------
-- Name: Nicholas Regan
-- Class: IT-112-401
-- Abstract: Homework 9 - Rank and Row_Number
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

IF OBJECT_ID('TGameTeamPlayerPoints') IS NOT NULL DROP TABLE TGameTeamPlayerPoints
IF OBJECT_ID('TTeamPlayers') IS NOT NULL DROP TABLE TTeamPlayers
IF OBJECT_ID('TGameTeams') IS NOT NULL DROP TABLE TGameTeams
IF OBJECT_ID('TTeams') IS NOT NULL DROP TABLE TTeams
IF OBJECT_ID('TDivisions') IS NOT NULL DROP TABLE TDivisions
IF OBJECT_ID('TPlayers') IS NOT NULL DROP TABLE TPlayers
IF OBJECT_ID('TGames') IS NOT NULL DROP TABLE TGames
IF OBJECT_ID('TTeamRoles') IS NOT NULL DROP TABLE TTeamRoles

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
-- Step #1.4: List top two songs per genre
-- --------------------------------------------------------------------------------
SELECT
	TSongWeightedCountByGenre.*
FROM
(
	SELECT
		TG.intGenreID,
		TG.strGenre,
		TS.intSongID,
		TS.strSong,
		SUM(CASE TUFS.intSortOrder
					WHEN 1 THEN 5
					WHEN 2 THEN 3
					WHEN 3 THEN 1
					ELSE 0.5
			END) AS intWeightedCount,
		RANK ( ) OVER
		(
			PARTITION BY 
				TG.intGenreID
			ORDER BY
				SUM(CASE TUFS.intSortOrder
						WHEN 1 THEN 5
						WHEN 2 THEN 3
						WHEN 3 THEN 1
						ELSE 0.5
					END) DESC
		) AS intGenreRankOrder

	FROM
		TSongs AS TS
			LEFT OUTER JOIN TUserFavoriteSongs AS TUFS
			ON(TS.intSongID = TUFS.intSongID)

			LEFT OUTER JOIN TGenres AS TG
			ON(TS.intGenreID = TG.intGenreID)
	GROUP BY
		TG.intGenreID,
		TG.strGenre,
		TS.intSongID,
		TS.strSong
) AS TSongWeightedCountByGenre
WHERE
	intGenreRankOrder <= 2
ORDER BY
	strGenre,
	intGenreRankOrder

-- --------------------------------------------------------------------------------
-- Step #1.5: Show the 3rd – 5th most popular songs
-- --------------------------------------------------------------------------------
SELECT
	TSongsByPopularity.*
FROM
(
	SELECT
		TG.intGenreID,
		TG.strGenre,
		TS.intSongID,
		TS.strSong,
		SUM(CASE TUFS.intSortOrder
					WHEN 1 THEN 5
					WHEN 2 THEN 3
					WHEN 3 THEN 1
					ELSE 0.5
			END) AS intWeightedCount,
		ROW_NUMBER ( ) OVER
		(
			ORDER BY
				SUM(CASE TUFS.intSortOrder
							WHEN 1 THEN 5
							WHEN 2 THEN 3
							WHEN 3 THEN 1
							ELSE 0.5
					END) DESC
		) AS intPopularityOrder

	FROM
		TSongs AS TS
		LEFT OUTER JOIN TUserFavoriteSongs AS TUFS
		ON(TS.intSongID = TUFS.intSongID)

		LEFT OUTER JOIN TGenres AS TG
		ON(TS.intGenreID = TG.intGenreID)
	GROUP BY
		TG.intGenreID,
		TG.strGenre,
		TS.intSongID,
		TS.strSong
) AS TSongsByPopularity
WHERE
		intPopularityOrder >= 3
	AND intPopularityOrder <= 5
ORDER BY
	intPopularityOrder

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
-- Step #2.4: Show top two students in each major with highest GPA
-- --------------------------------------------------------------------------------
SELECT
	TStudentGPAByMajor.*
FROM
(
	SELECT
		TM.intMajorID,
		TM.strMajor,
		TS.intStudentID,
		TS.strLastName + ', ' + TS.strFirstName AS strStudent,
		SUM(TG.decGradePointValue * TC.decCreditHours) /
		SUM(TC.decCreditHours) AS decGradePointAverage,
		RANK ( ) OVER
		(
			PARTITION BY
				TM.intMajorID
			ORDER BY
				SUM(TG.decGradePointValue * TC.decCreditHours) /
				SUM(TC.decCreditHours) DESC
		) AS intGPA_RankOrder

	FROM
		TStudents AS TS

			INNER JOIN TCourseStudents AS TCS
					
					INNER JOIN TCourses AS TC
					ON(TCS.intCourseID = TC.intCourseID)

					INNER JOIN TGrades AS TG
					ON(		TCS.intGradeID = TG.intGradeID
						AND	TG.intGradeID NOT IN (8,9))

			ON(TS.intStudentID = TCS.intStudentID)

			INNER JOIN TMajors AS TM
			ON(TS.intMajorID = TM.intMajorID)

	GROUP BY
		TM.intMajorID,
		TM.strMajor,
		TS.intStudentID,
		TS.strLastName,
		TS.strFirstName
) AS TStudentGPAByMajor
WHERE
	intGPA_RankOrder <= 2
ORDER BY
	strMajor,
	intGPA_RankOrder,
	strStudent

-- --------------------------------------------------------------------------------
-- Step #2.5: Show the 3rd – 5th best students based on their GPA
-- --------------------------------------------------------------------------------
SELECT
	TStudentGPAs.*
FROM
(
	SELECT
		TM.intMajorID,
		TM.strMajor,
		TS.intStudentID,
		TS.strLastName + ', ' + TS.strFirstName AS strStudent,
		SUM(TG.decGradePointValue * TC.decCreditHours) /
		SUM(TC.decCreditHours) AS decGradePointAverage,
		ROW_NUMBER ( ) OVER
		(
			ORDER BY
				SUM(TG.decGradePointValue * TC.decCreditHours) /
				SUM(TC.decCreditHours) DESC
		) AS intGPA_RankOrder

	FROM
		TStudents AS TS

			INNER JOIN TCourseStudents AS TCS
					
					INNER JOIN TCourses AS TC
					ON(TCS.intCourseID = TC.intCourseID)

					INNER JOIN TGrades AS TG
					ON(		TCS.intGradeID = TG.intGradeID
						AND	TG.intGradeID NOT IN (8,9))

			ON(TS.intStudentID = TCS.intStudentID)

			INNER JOIN TMajors AS TM
			ON(TS.intMajorID = TM.intMajorID)

	GROUP BY
		TM.intMajorID,
		TM.strMajor,
		TS.intStudentID,
		TS.strLastName,
		TS.strFirstName
) AS TStudentGPAs
WHERE
		intGPA_RankOrder >= 3
	AND intGPA_RankOrder <= 5
ORDER BY
	intGPA_RankOrder,
	strStudent

-- --------------------------------------------------------------------------------
-- Step #3.1: Create Tables
-- --------------------------------------------------------------------------------
CREATE TABLE TDivisions
(
		intDivisionID				INTEGER				NOT NULL,
		strDivision					VARCHAR(50)			NOT NULL,
		CONSTRAINT TDivisions_PK PRIMARY KEY( intDivisionID )
)

CREATE TABLE TTeams
(
		intTeamID 					INTEGER				NOT NULL,
		strTeam						VARCHAR(50)			NOT NULL,
		strMascot					VARCHAR(50)			NOT NULL,	
		intDivisionID				INTEGER				NOT NULL,
		CONSTRAINT TTeams_PK PRIMARY KEY( intTeamID )
)

Create Table TPlayers
(
		intPlayerID					Integer				Not Null,
		strFirstName				Varchar(50)			Not Null,
		strLastName					Varchar(50)			Not Null,
		CONSTRAINT TPlayers_PK PRIMARY KEY( intPlayerID )
)

Create Table TTeamPlayers
(
		intTeamID					Integer				Not Null,
		intPlayerID					Integer				Not Null,
		CONSTRAINT TTeamPlayers_PK PRIMARY KEY( intTeamID, intPlayerID )
)

Create Table TTeamRoles
(
		intTeamRoleID				Integer				Not Null,
		strTeamRole					Varchar(50)			Not Null,
		intSortOrder				Integer				Not Null,
		CONSTRAINT TTeamRoles_PK PRIMARY KEY( intTeamRoleID )
)

Create Table TGames
(		intGameID					Integer				Not Null,
		dtmGamePlayed				Varchar(50)			Not Null,
		strVenue					Varchar(50)			Not Null,
		CONSTRAINT TGames_PK PRIMARY KEY( intGameID )
)

Create Table TGameTeams
(		
		intGameID					Integer				Not Null,
		intTeamID					Integer				Not Null,
		intTeamRoleID				Integer				Not Null,
		CONSTRAINT TGameTeams_PK PRIMARY KEY( intGameID, intTeamID )
)

Create Table TGameTeamPlayerPoints
(
		intGameID					Integer				Not Null,
		intTeamID					Integer				Not Null,
		intPlayerID					Integer				Not Null,
		intPoints					Integer				Not Null,
		CONSTRAINT TGameTeamPlayerPoints_PK PRIMARY KEY( intGameID, intTeamID, intPlayerID )
)

-- --------------------------------------------------------------------------------
-- Step #3.2: Identify and create all the foreign keys.  - ORDER BY CHILD THEN PARENT
-- --------------------------------------------------------------------------------
--		Child						Parent				Column(s)
--		------						------				------
--	1	TTeams						TDivisions			intDivisionID
--	2	TTeamPlayers				TTeams				intTeamID
--	3	TTeamPlayers				TPlayers			intPlayerID
--	4	TGameTeams					TGames				intGameID
--	5	TGameTeams					TTeams				intTeamID
--	6	TGameTeams					TTeamRoles			intTeamRoleID
--	7	TGameTeamPlayerPoints		TGameTeams			intGameID, intTeamID
--	8	TGameTeamPlayerPoints		TTeamPlayers		intTeamID, intPlayerID


--	1
ALTER TABLE TTeams ADD CONSTRAINT TTeams_TDivisions_FK
FOREIGN KEY (intDivisionID) REFERENCES TDivisions (intDivisionID)

--	2
ALTER TABLE TTeamPlayers ADD CONSTRAINT TTeamPlayers_TTeams_FK
FOREIGN KEY (intTeamID) REFERENCES TTeams (intTeamID)

--	3
ALTER TABLE TTeamPlayers ADD CONSTRAINT TTeamPlayers_TPlayers_FK
FOREIGN KEY (intPlayerID) REFERENCES TPlayers (intPlayerID)

--	4
ALTER TABLE TGameTeams ADD CONSTRAINT TGameTeams_TGames_FK
FOREIGN KEY (intGameID) REFERENCES TGames (intGameID)

--	5
ALTER TABLE TGameTeams ADD CONSTRAINT TGameTeams_TTeams_FK
FOREIGN KEY (intTeamID) REFERENCES TTeams (intTeamID)

--	6
ALTER TABLE TGameTeams ADD CONSTRAINT TGameTeams_TTeamRoles_FK
FOREIGN KEY (intTeamRoleID) REFERENCES TTeamRoles (intTeamRoleID)

--	7
ALTER TABLE TGameTeamPlayerPoints ADD CONSTRAINT TGameTeamPlayerPoints_TGameTeams_FK
FOREIGN KEY (intGameID, intTeamID) REFERENCES TGameTeams (intGameID, intTeamID)

--	8
ALTER TABLE TGameTeamPlayerPoints ADD CONSTRAINT TGameTeamPlayerPoints_TTeamPlayers_FK
FOREIGN KEY (intTeamID, intPlayerID) REFERENCES TTeamPlayers (intTeamID, intPlayerID)

-- --------------------------------------------------------------------------------
-- Step #3.3: Add a constraint that prevents more than one team from having the same role on a particular game
-- --------------------------------------------------------------------------------
ALTER TABLE TGameTeams ADD CONSTRAINT TGameTeams_OneHomeAndOneAwayTeam_UN
UNIQUE (intGameID, intTeamRoleID)

-- --------------------------------------------------------------------------------
-- Step #3.4: Add Sample Data
-- --------------------------------------------------------------------------------
INSERT INTO TDivisions(intDivisionID, strDivision)
VALUES	(1, 'North'),
		(2, 'East'),
		(3, 'South'),
		(4, 'West')

Insert Into TTeams ( intTeamID, strTeam, strMascot, intDivisionID)
Values	(1, 'Curling', 'Yeti', 1),
		(2, 'Soccer', 'Squirrel', 1),
		(3, 'Football', 'Lion', 2),
		(4, 'Baseball', 'Elephant', 2),
		(5, 'Track', 'Tiger', 3)

Insert Into TPlayers ( intPlayerID, strFirstName, strLastName)
Values	(1, 'Pete', 'Abred'),
		(2, 'Doug', 'Out'),
		(3, 'Sue', 'Flay'),
		(4, 'Adam', 'Baum'),
		(5, 'Joe', 'King')

Insert Into TTeamPlayers ( intTeamID, intPlayerID)
Values	(1, 1),
		(1, 2),
		(1, 3),
		(2, 2),
		(2, 3),
		(3, 4),
		(3, 3),
		(4, 1),
		(4, 2)

Insert Into TGames(intGameID, dtmGamePlayed, strVenue)
Values	(1, '2016/12/01', 'US Bank Arena'),
		(2, '2017/01/01', 'My Back Yard'),
		(3, '2017/02/01', 'Purple People Bridge'),
		(4, '2017/03/01', 'Washington Park')

Insert Into TTeamRoles(intTeamRoleID, strTeamRole, intSortOrder)
Values	(1, 'Home', 1),
		(2, 'Away', 2)

Insert Into TGameTeams(intGameID, intTeamID, intTeamRoleID)
Values	(1, 1, 1),
		(1, 4, 2),
		(2, 2, 1),
		(2, 3, 2),
		(3, 2, 1),
		(3, 4, 2),
		(4, 3, 1),
		(4, 1, 2)

Insert Into TGameTeamPlayerPoints (intGameID, intTeamID, intPlayerID, intPoints)
Values	(1, 1, 1, 5),
		(1, 4, 2, 7),
		(2, 2, 2, 3),
		(2, 3, 4, 6),
		(3, 2, 3, 0),
		(3, 4, 1, 1),
		(4, 3, 4, 2),
		(4, 1, 2, 0)

-- --------------------------------------------------------------------------------
-- Step #3.5: Show for each division the top two players with most points scored
-- --------------------------------------------------------------------------------
SELECT
	TPlayerTotalPoints.*
FROM
(
	SELECT
		TD.intDivisionID,
		TD.strDivision,
		TP.intPlayerID,
		TP.strLastName + ', ' + TP.strFirstName AS strPlayer,
		ISNULL(SUM(TGTPP.intPoints), 0) AS intTotalPointsScored,
		RANK( ) OVER
		(
			PARTITION BY
				TD.intDivisionID
			ORDER BY
				ISNULL(SUM(TGTPP.intPoints), 0) DESC
		) AS intTotalPointsRank
	FROM
		TPlayers AS TP

			INNER JOIN TTeamPlayers AS TTP

				LEFT OUTER JOIN TGameTeamPlayerPoints AS TGTPP
				ON(TTP.intPlayerID = TGTPP.intPlayerID)

				INNER JOIN TTeams AS TT

					INNER JOIN TDivisions AS TD
					ON(TT.intDivisionID = TD.intDivisionID)

				ON(TTP.intTeamID = TT.intTeamID)

			ON(TP.intPlayerID = TTP.intPlayerID)

	GROUP BY
		TD.intDivisionID,
		TD.strDivision,
		TP.intPlayerID,
		TP.strLastName,
		TP.strFirstName
) AS TPlayerTotalPoints
WHERE
	intTotalPointsRank <= 2
ORDER BY
	strDivision,
	intTotalPointsRank


