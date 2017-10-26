-- --------------------------------------------------------------------------------
-- Name: Nicholas Regan
-- Class: SQL #2
-- Abstract: Review
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL2     -- Get out of the master database
SET NOCOUNT ON -- Report only errors

DROP VIEW  VTeamPlayers
DROP TABLE TTeamPlayers
DROP TABLE TTeams
DROP TABLE TPlayers


-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
-- --------------------------------------------------------------------------------
CREATE TABLE TTeams
(
	intTeamID 			INTEGER				NOT NULL,
	strTeam				VARCHAR(50)			NOT NULL,
	strMascot			VARCHAR(50)			NOT NULL,	
	CONSTRAINT TTeams_PK PRIMARY KEY( intTeamID )
)

Create Table TTeamPlayers
(
	intTeamID			Integer				Not Null,
	intPlayerID			Integer				Not Null,
	CONSTRAINT TTeamPlayers_PK PRIMARY KEY( intTeamID, intPlayerID )
)
-- Dual Primay keys, not two primary keys

Create Table TPlayers
(
	intPlayerID			Integer				Not Null,
	strFirstName		Varchar(50)			Not Null,
	strLastName			Varchar(50)			Not Null,
	strPhoneNumber		Varchar(50)			Not Null,
	CONSTRAINT TPlayers_PK PRIMARY KEY( intPlayerID )
)

-- --------------------------------------------------------------------------------
-- Step #1.2: Identify and create all the foreign keys.  - ORDER BY CHILD THEN PARENT
-- --------------------------------------------------------------------------------
--		Child				Parent				Column(s)
--		------				------				------
--	1	TTeamPlayers		TTeams				intTeamID
--	2	TTeamPlayers		TPlayers			intPlayerID

-- 1
ALTER TABLE TTeamPlayers ADD CONSTRAINT TTeamPlayers_TTeams_FK
FOREIGN KEY (intTeamID) REFERENCES TTeams (intTeamID)

-- 2
ALTER TABLE TTeamPlayers ADD CONSTRAINT TTeamPlayers_TPlayers_FK
FOREIGN KEY (intPlayerID) REFERENCES TPlayers (intPlayerID)

-- --------------------------------------------------------------------------------
-- Step #1.3: Write the SQL that will add 5 teams
-- --------------------------------------------------------------------------------
-- Why aren't we using the GUI?
--Reasons for script files:
--1) Forces us to plan what we are going to do!
--2) Allows someone to double check your work.
--3) Consistent repeatable results
--4) It's faster if we make the same changes on more than one machine
--5) We can comment what we did, when we did it and WHY we did it.
--6) Copy/Paste
--7) When used with transactions we can UNDO

Insert Into TTeams ( intTeamID, strTeam, strMascot)
Values	(1, 'Curling', 'Yeti'),
		(2, 'Soccer', 'Squirrel'),
		(3, 'Football', 'Lion'),
		(4, 'Baseball', 'Elephant'),
		(5, 'Track', 'Tiger')

-- --------------------------------------------------------------------------------
-- Step #1.4: Add 5 Players
-- --------------------------------------------------------------------------------
Insert Into TPlayers ( intPlayerID, strFirstName, strLastName, strPhoneNumber)
Values	(1, 'Pete', 'Abred', '555-1000'),
		(2, 'Doug', 'Out', '555-2000'),
		(3, 'Sue', 'Flay', '555-3000'),
		(4, 'Adam', 'Baum', '555-4000'),
		(5, 'Joe', 'King', '555-5000')

-- --------------------------------------------------------------------------------
-- Step #1.5: Add 5 Players to Teams
-- --------------------------------------------------------------------------------
Insert Into TTeamPlayers ( intTeamID, intPlayerID)
Values	(1, 1),
		(1, 2),
		(1, 3),
		(2, 2),
		(2, 3),
		(3, 4)

-- --------------------------------------------------------------------------------
-- Step #1.6: Write SQL for the view VTeamPlayers
-- Attack Plan: TTeams -> TTeamPlayers -> TPlayers
-- --------------------------------------------------------------------------------
-- ALWAYS TRY to get the ID and name from the same table.
-- The order of your columns in the SELECT clause determine the order of the tables in the FROM clause.
-- AND the order of the tables in the FROM clause determines the order of the joins in the WHERE clause.

Go
Create View VTeamPlayers
As


Select
	TT.intTeamID,
	TT.strTeam,
	TP.intPlayerID,
	TP.strLastName + ', ' + TP.strFirstName As strFullName
From
	TTeams				As TT,		-- A
	TTeamPlayers		As TTP,		-- B
	TPlayers			As TP		-- C
Where
		TT.intTeamID = TTP.intTeamID		-- A to B
	AND	TTP.intPlayerID = TP.intPlayerID	-- B to C
Go

Select
	*
FROM
	VTeamPlayers
Order By
	strTeam,
	strFullName

-- NEVER ORDER BY IDs!!!!  Why?  Because the user should never see the IDs


/*
What is the purpose of writing views?

We are talented and capable programmers and we ALWAYS use the first 3 rules of normalization.

Why do we normalize?
1st Rule - execution, speed and scalability
2nd Rule - data integrity - goal: replace multiple copies of the same data with multiple references to a single copy of the data.
3rd Rule - organization/simplicity. goal: one entity or relationship per table.

The process of normalization breaks up the data into many, many, many tables.

So we MUST be able to join to put the data back together.  
Remember when you join you ALWAYS want the ID/index and NAME columns from EVERY TABLE in the join.

Writing joins is very hard! So we want to write out joins just once if possible.
By making views out of our joins we can re-use the same code more than once.
Another benefit of views is that it gets much of the SQL out of our program and into the database.

Why make views?
The process of normalization requires us to make joins to put the data back together.
Making views allows us to re-use the join code and it gets much of the SQL out of our programs.

The name of the view should tell you everything you need to know about the tables involved.

VTeamPlayers

We know we'll have teams information (ID, name)
We also know we'll have player information (ID and name)

We want the information for the teams and players to be sychronized 
and there is only one place where that information on how to sychronize is stored
and that is in TTeamPlayers

Two options:
ATL				CVG
TTeamPlayers -> TTeams
ATL				FLA
			 -> TPlayers
Joining in parallel

CFG			ATL				FLA
TTeams -> TTeamPlayers -> TPlayers
Joining in serial

ALWAYS PLAN WHAT YOU ARE GOING TO DO BEFORE YOU START WRITING CODE
WHY?  Otherwise you will get emotionally invested in your code and you'll be unwilling to throw it out.
*/

