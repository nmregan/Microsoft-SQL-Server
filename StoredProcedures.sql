-- --------------------------------------------------------------------------------
-- Name: Nicholas Regan
-- Class: IT-112-401
-- Abstract: Homework 3 - Stored Procedures
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL2     -- Get out of the master database
SET NOCOUNT ON -- Report only errors

IF OBJECT_ID('uspAdd2Numbers') IS NOT NULL DROP PROCEDURE uspAdd2Numbers
IF OBJECT_ID('uspMultiply2Numbers') IS NOT NULL DROP PROCEDURE uspMultiply2Numbers
IF OBJECT_ID('uspDivide2Numbers') IS NOT NULL DROP PROCEDURE uspDivide2Numbers
IF OBJECT_ID('uspCallAnotherStoredProcedure') IS NOT NULL DROP PROCEDURE uspCallAnotherStoredProcedure

IF OBJECT_ID('TTeamPlayers') IS NOT NULL DROP TABLE TTeamPlayers
IF OBJECT_ID('TTeams') IS NOT NULL DROP TABLE TTeams
IF OBJECT_ID('TPlayers') IS NOT NULL DROP TABLE TPlayers
IF OBJECT_ID('TCoaches') IS NOT NULL DROP TABLE TCoaches

IF OBJECT_ID('uspAddCoach') IS NOT NULL DROP PROCEDURE uspAddCoach
IF OBJECT_ID('uspAddTeam') IS NOT NULL DROP PROCEDURE uspAddTeam
IF OBJECT_ID('uspAddPlayer') IS NOT NULL DROP PROCEDURE uspAddPlayer
IF OBJECT_ID('uspAddTeamCoachAndPlayer') IS NOT NULL DROP PROCEDURE uspAddTeamCoachAndPlayer

-- --------------------------------------------------------------------------------
-- Step #1.1: uspAdd2Numbers
-- --------------------------------------------------------------------------------
Go

Create Procedure uspAdd2Numbers
		@intValue1 As Integer,
		@intValue2 As Integer
As
Set NoCount On		-- Report only errors

Declare @intResult As Integer = 0

-- Do calculations
Select @intResult = @intValue1 + @intValue2

-- Display Results
Select @intResult As intResult

Go

uspAdd2Numbers 5, 10

-- --------------------------------------------------------------------------------
-- Step #1.2: uspMultiply2Numbers
-- --------------------------------------------------------------------------------
Go

Create Procedure uspMultiply2Numbers
		@intValue1 As Integer,
		@intValue2 As Integer
As
Set NoCount On		-- Report only errors

Declare @intResult As Integer = 0

-- Do calculations
Select @intResult = @intValue1 * @intValue2

-- Display Results
Select @intResult As intResult

Go

uspMultiply2Numbers 5, 10

-- --------------------------------------------------------------------------------
-- Step #1.3: uspDivide2Numbers and call from another stored procedure
-- --------------------------------------------------------------------------------
Go
Create Procedure uspDivide2Numbers
		@decValue1 As Decimal,
		@decValue2 As Decimal,
		@decResult As Decimal Output
As
Set NoCount On		-- Report only errors

Go

Create Procedure uspCallAnotherStoredProcedure
As
Set NoCount On		-- Report only errors

Declare @decResult As Decimal

-- Call another stored procedure that returns a value
Execute uspDivide2Numbers 5.0, 10.0, @decResult Output

-- Display results
Select @decResult As decResult

Go

uspCallAnotherStoredProcedure

-- --------------------------------------------------------------------------------
-- Step #2.1: Create Tables
-- --------------------------------------------------------------------------------
Create Table TCoaches
(
		intCoachID				Integer				Not Null,
		strFirstName			Varchar(50)			Not Null,
		strLastName				Varchar(50)			Not Null,
		strPhoneNumber			Varchar(50)			Not Null,
		CONSTRAINT TCoaches_PK PRIMARY KEY( intCoachID )
)

Create Table TTeams
(
		intTeamID				Integer				Not Null,
		strTeam					Varchar(50)			Not Null,
		strMascot				Varchar(50)			Not Null,
		intCoachID				Integer				Not Null,
		CONSTRAINT TTeams_PK PRIMARY KEY( intTeamID )
)

Create Table TPlayers
(
		intPlayerID			Integer				Not Null,
		strFirstName		Varchar(50)			Not Null,
		strLastName			Varchar(50)			Not Null,
		strPhoneNumber		Varchar(50)			Not Null,
		CONSTRAINT TPlayers_PK PRIMARY KEY( intPlayerID )
)

Create Table TTeamPlayers
(
		intTeamID			Integer				Not Null,
		intPlayerID			Integer				Not Null,
		CONSTRAINT TTeamPlayers_PK PRIMARY KEY( intTeamID, intPlayerID )
)

-- --------------------------------------------------------------------------------
-- Step #2.2: Identify and create all the foreign keys.  - ORDER BY CHILD THEN PARENT
-- --------------------------------------------------------------------------------
--		Child						Parent					Column(s)
--		------						------					------
-- 1	TTeams						TCoaches				intCoachID
-- 2	TTeamPlayers				TTeams					intTeamID
-- 3	TTeamPlayers				TPlayers				intPlayerID

-- 1
ALTER TABLE TTeams ADD CONSTRAINT TTeams_TCoaches_FK1
FOREIGN KEY ( intCoachID ) REFERENCES TCoaches( intCoachID )

-- 2
ALTER TABLE TTeamPlayers ADD CONSTRAINT TTeamPlayers_TTeams_FK1
FOREIGN KEY ( intTeamID ) REFERENCES TTeams( intTeamID )

-- 3
ALTER TABLE TTeamPlayers ADD CONSTRAINT TTeamPlayers_TPlayers_FK1
FOREIGN KEY ( intPlayerID ) REFERENCES TPlayers( intPlayerID )

-- --------------------------------------------------------------------------------
-- Step #2.3: uspAddCoach
-- --------------------------------------------------------------------------------
Go

CREATE PROCEDURE uspAddCoach
	 @intCoachID		AS INTEGER OUTPUT
	,@strFirstName		AS VARCHAR( 50 )
	,@strLastName		AS VARCHAR( 50 )
	,@strPhoneNumber	AS VARCHAR( 50 )
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	SELECT @intCoachID  = MAX( intCoachID ) + 1
	FROM TCoaches (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intCoachID  = COALESCE( @intCoachID , 1 )

	INSERT INTO TCoaches( intCoachID, strFirstName, strLastName, strPhoneNumber )
	VALUES( @intCoachID , @strFirstName, @strLastName, @strPhoneNumber )

COMMIT TRANSACTION

GO

DECLARE @intCoachID AS INTEGER = 0;
EXECUTE uspAddCoach @intCoachID OUTPUT, 'Coach', 'Z', '555-1212'
PRINT 'intCoachID = ' + CONVERT( VARCHAR, @intCoachID )

-- --------------------------------------------------------------------------------
-- Step #2.4: uspAddTeam
-- --------------------------------------------------------------------------------
Go

CREATE PROCEDURE uspAddTeam
	 @intTeamID			AS INTEGER OUTPUT
	,@strTeam			AS VARCHAR( 50 )
	,@strMascot			AS VARCHAR( 50 )
	,@intCoachID		AS INTEGER
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	SELECT @intTeamID  = MAX( intTeamID ) + 1
	FROM TTeams (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intTeamID  = COALESCE( @intTeamID , 1 )

	INSERT INTO TTeams( intTeamID, strTeam, strMascot, intCoachID )
	VALUES( @intTeamID , @strTeam, @strMascot, @intCoachID )

COMMIT TRANSACTION

GO

DECLARE @intTeamID AS INTEGER = 0;
EXECUTE uspAddTeam @intTeamID OUTPUT, 'Bengals', 'Tiger', 1
PRINT 'intTeamID = ' + CONVERT( VARCHAR, @intTeamID )

-- --------------------------------------------------------------------------------
-- Step #2.5: uspAddPlayer
-- --------------------------------------------------------------------------------
Go

CREATE PROCEDURE uspAddPlayer
	 @intPlayerID			AS INTEGER OUTPUT
	,@strFirstName			AS VARCHAR( 50 )
	,@strLastName			AS VARCHAR( 50 )
	,@strPhoneNumber		AS VARCHAR( 50 )
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	SELECT @intPlayerID  = MAX( intPlayerID ) + 1
	FROM TPlayers (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intPlayerID  = COALESCE( @intPlayerID , 1 )

	INSERT INTO TPlayers( intPlayerID, strFirstName, strLastName, strPhoneNumber )
	VALUES( @intPlayerID , @strFirstName, @strLastName, @strPhoneNumber )

COMMIT TRANSACTION

GO

DECLARE @intPlayerID AS INTEGER = 0;
EXECUTE uspAddPlayer @intPlayerID OUTPUT, 'Guy', 'Richie', '666-1234'
PRINT 'intPlayerID = ' + CONVERT( VARCHAR, @intPlayerID )

-- --------------------------------------------------------------------------------
-- Step #2.6: uspAddTeamCoachAndPlayer
-- --------------------------------------------------------------------------------
Go

CREATE PROCEDURE uspAddTeamCoachAndPlayer
	 @strTeam						AS VARCHAR( 50 )
	,@strMascot						AS VARCHAR( 50 )
	,@strCoachFirstName				AS VARCHAR( 50 )
	,@strCoachLastName				AS VARCHAR( 50 )
	,@strCoachPhoneNumber			AS VARCHAR( 50 )
	,@strPlayerFirstName			AS VARCHAR( 50 )
	,@strPlayerLastName				AS VARCHAR( 50 )
	,@strPlayerPhoneNumber			AS VARCHAR( 50 )
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	DECLARE	@intCoachID As Integer = 0
	EXECUTE uspAddCoach @intCoachID OUTPUT, @strCoachFirstName, @strCoachLastName, @strCoachPhoneNumber

	DECLARE @intTeamID AS INTEGER = 0;
	EXECUTE uspAddTeam @intTeamID OUTPUT, @strTeam, @strMascot, @intCoachID

	DECLARE @intPlayerID AS INTEGER = 0;
	EXECUTE uspAddPlayer @intPlayerID OUTPUT, @strPlayerFirstName, @strPlayerLastName, @strPlayerPhoneNumber

	INSERT INTO TTeamPlayers ( intTeamID, intPlayerID )
	VALUES	( @intTeamID, @intPlayerID )

COMMIT TRANSACTION

GO

uspAddTeamCoachAndPlayer 'Curling', 'Yeti', 'Coach', 'Z', '555-1212', 'Luke', 'Skywalker', '347-1111'