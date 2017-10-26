-- --------------------------------------------------------------------------------
-- Name: Nicholas Regan
-- Class: IT-112-401
-- Abstract: Homework 6 - Delete Race Conditions and Status Flags
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL2     -- Get out of the master database
SET NOCOUNT ON -- Report only errors

IF OBJECT_ID('TTeamPlayers') IS NOT NULL DROP TABLE TTeamPlayers
IF OBJECT_ID('TTeams') IS NOT NULL DROP TABLE TTeams
IF OBJECT_ID('TPlayers') IS NOT NULL DROP TABLE TPlayers

IF OBJECT_ID('uspSetTeamStatus') IS NOT NULL DROP PROCEDURE uspSetTeamStatus
IF OBJECT_ID('uspSetPlayerStatus') IS NOT NULL DROP PROCEDURE uspSetPlayerStatus
IF OBJECT_ID('uspSetTeamPlayerStatus') IS NOT NULL DROP PROCEDURE uspSetTeamPlayerStatus
IF OBJECT_ID('uspNewAddTeam') IS NOT NULL DROP PROCEDURE uspNewAddTeam
IF OBJECT_ID('uspNewAddPlayer') IS NOT NULL DROP PROCEDURE uspNewAddPlayer
IF OBJECT_ID('uspNewAddTeamPlayer') IS NOT NULL DROP PROCEDURE uspNewAddTeamPlayer

IF OBJECT_ID('VActiveTeams') IS NOT NULL DROP VIEW VActiveTeams
IF OBJECT_ID('VActivePlayers') IS NOT NULL DROP VIEW VActivePlayers
IF OBJECT_ID('VInActiveTeams') IS NOT NULL DROP VIEW VInActiveTeams
IF OBJECT_ID('VInActivePlayers') IS NOT NULL DROP VIEW VInActivePlayers

-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
-- --------------------------------------------------------------------------------
CREATE TABLE TTeams
(
	intTeamID 			INTEGER				NOT NULL,
	strTeam				VARCHAR(50)			NOT NULL,
	strMascot			VARCHAR(50)			NOT NULL,
	blnIsActive			BIT					NOT NULL,	
	CONSTRAINT TTeams_PK PRIMARY KEY( intTeamID )
)

Create Table TTeamPlayers
(
	intTeamID			INTEGER				NOT NULL,
	intPlayerID			INTEGER				NOT NULL,
	blnIsActive			BIT					NOT NULL,
	CONSTRAINT TTeamPlayers_PK PRIMARY KEY( intTeamID, intPlayerID )
)

Create Table TPlayers
(
	intPlayerID			INTEGER				NOT NULL,
	strFirstName		VARCHAR(50)			NOT NULL,
	strLastName			VARCHAR(50)			NOT NULL,
	strPhoneNumber		VARCHAR(50)			NOT NULL,
	blnIsActive			BIT					NOT NULL,
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
-- Step #1.3: Add Sample Data
-- --------------------------------------------------------------------------------
Insert Into TTeams ( intTeamID, strTeam, strMascot, blnIsActive)
Values	(1, 'Curling', 'Yeti', 1),
		(2, 'Soccer', 'Squirrel', 1),
		(3, 'Football', 'Lion', 1),
		(4, 'Baseball', 'Elephant', 1),
		(5, 'Track', 'Tiger', 0)

Insert Into TPlayers ( intPlayerID, strFirstName, strLastName, strPhoneNumber, blnIsActive)
Values	(1, 'Pete', 'Abred', '555-1000', 1),
		(2, 'Doug', 'Out', '555-2000', 1),
		(3, 'Sue', 'Flay', '555-3000', 1),
		(4, 'Adam', 'Baum', '555-4000', 1),
		(5, 'Joe', 'King', '555-5000', 0)

Insert Into TTeamPlayers ( intTeamID, intPlayerID, blnIsActive)
Values	(1, 1, 1),
		(1, 2, 1),
		(1, 3, 1),
		(2, 2, 1),
		(2, 3, 1),
		(3, 4, 1)

-- --------------------------------------------------------------------------------
-- Step #1.4: Create and test uspSetTeamStatus 
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspSetTeamStatus
	 @intTeamID				AS INTEGER
	,@blnIsActive			AS BIT

AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error
 
UPDATE
	TTeams
SET
	 blnIsActive = @blnIsActive
WHERE
		intTeamID = @intTeamID
 
 GO

 uspSetTeamStatus 1, 0

 SELECT * FROM TTeams

-- --------------------------------------------------------------------------------
-- Step #1.5: Create and test uspSetTeamStatus 
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspSetPlayerStatus
	 @intPlayerID			AS INTEGER
	,@blnIsActive			AS BIT

AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error
 
UPDATE
	TPlayers
SET
	 blnIsActive = @blnIsActive
WHERE
		intPlayerID = @intPlayerID
 
 GO

 uspSetPlayerStatus 1, 0

 SELECT * FROM TPlayers

-- --------------------------------------------------------------------------------
-- Step #1.6: Create and test uspSetTeamPlayerStatus 
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspSetTeamPlayerStatus
	 @intTeamID				AS INTEGER
	,@intPlayerID			AS INTEGER
	,@blnIsActive			AS BIT

AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error
 
UPDATE
	TTeamPlayers
SET
	 blnIsActive = @blnIsActive
WHERE
		intTeamID = @intTeamID
	AND	intPlayerID = @intPlayerID
 
 GO

 uspSetTeamPlayerStatus 1, 1, 0

 SELECT * FROM TTeamPlayers

-- --------------------------------------------------------------------------------
-- Step #1.7: Create and test uspNewAddTeam  
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspNewAddTeam
	 @strTeam	AS VARCHAR( 50 )
	,@strMascot	AS VARCHAR( 50 )
AS
DECLARE @intTeamID AS INTEGER
 
BEGIN TRANSACTION

	-- Check to see if team already exists
	SELECT
		@intTeamID = intTeamID
	FROM 
		TTeams (TABLOCKX) -- Lock table until end of transaction
	WHERE
		strTeam = @strTeam

	IF @intTeamID IS NULL BEGIN
 
		SELECT @intTeamID = MAX( intTeamID ) + 1
		FROM TTeams 
 
		-- Default to 1 if table is empty
		SELECT @intTeamID  = COALESCE( @intTeamID , 1 )
 
		INSERT INTO TTeams( intTeamID, strTeam, strMascot, blnIsActive )
		VALUES( @intTeamID , @strTeam, @strMascot, 1 )


	END ELSE BEGIN

		EXECUTE uspSetTeamStatus @intTeamID, 1

	END

			-- Return ID to caller
		SELECT @intTeamID AS intTeamID 
 
COMMIT TRANSACTION

GO

EXECUTE uspNewAddTeam 'Bengals', 'Tiger'
EXECUTE uspNewAddTeam 'Browns', 'Bulldog'

SELECT * FROM TTeams

-- --------------------------------------------------------------------------------
-- Step #1.8: Create and test uspNewAddPlayer  
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspNewAddPlayer
	 @strFirstName		AS VARCHAR( 50 )
	,@strLastName		AS VARCHAR( 50 )
	,@strPhoneNumber	AS VARCHAR( 50 )
AS
DECLARE @intPlayerID AS INTEGER
 
BEGIN TRANSACTION

	-- Check to see if Player already exists
	SELECT
		@intPlayerID = intPlayerID
	FROM 
		TPlayers (TABLOCKX) -- Lock table until end of transaction
	WHERE
		strFirstName = @strFirstName
	AND	strLastName = @strLastName

	IF @intPlayerID IS NULL BEGIN
 
		SELECT @intPlayerID = MAX( intPlayerID ) + 1
		FROM TPlayers 
 
		-- Default to 1 if table is empty
		SELECT @intPlayerID  = COALESCE( @intPlayerID , 1 )
 
		INSERT INTO TPlayers( intPlayerID, strFirstName, strLastName, strPhoneNumber, blnIsActive )
		VALUES( @intPlayerID , @strFirstName, @strLastName, @strPhoneNumber, 1 )


	END ELSE BEGIN

		EXECUTE uspSetPlayerStatus @intPlayerID, 1

	END

			-- Return ID to caller
		SELECT @intPlayerID AS intPlayerID 
 
COMMIT TRANSACTION

GO

EXECUTE uspNewAddPlayer 'Dennis', 'Reynolds', '666-6666'
EXECUTE uspNewAddPlayer 'Charlie', 'Kelly', '777-7777'

SELECT * FROM TPlayers

-- --------------------------------------------------------------------------------
-- Step #1.9: Create and test uspNewAddTeamPlayer  
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspNewAddTeamPlayer
	 @intTeamID			AS INTEGER
	,@intPlayerID		AS INTEGER
AS
DECLARE @blnAlreadyExists	AS BIT = 0
 
BEGIN TRANSACTION

	-- Check to see if TeamPlayer already exists
	SELECT
		@blnAlreadyExists = 1
	FROM 
		TTeamPlayers (TABLOCKX) -- Lock table until end of transaction
	WHERE
		intTeamID = @intTeamID
	AND intPlayerID = @intPlayerID

	IF @blnAlreadyExists = 0 BEGIN
 
		INSERT INTO TTeamPlayers( intTeamID, intPlayerID, blnIsActive )
		VALUES( @intTeamID, @intPlayerID, 1 )


	END ELSE BEGIN

		EXECUTE uspSetTeamPlayerStatus @intTeamID, @intPlayerID, 1

	END
 
COMMIT TRANSACTION

GO

EXECUTE uspNewAddTeamPlayer 3, 2
EXECUTE uspNewAddTeamPlayer 2, 5

SELECT * FROM TTeamPlayers

-- --------------------------------------------------------------------------------
-- Step #1.10: VActiveTeams
-- --------------------------------------------------------------------------------
GO

CREATE VIEW VActiveTeams
AS
SELECT
	intTeamID,
	strTeam,
	strMascot
FROM
	TTeams
WHERE
	blnIsActive = 1

GO

SELECT * FROM VActiveTeams

-- --------------------------------------------------------------------------------
-- Step #1.11: VActivePlayers
-- --------------------------------------------------------------------------------
GO

CREATE VIEW VActivePlayers
AS
SELECT
	intPlayerID,
	strLastName + ', ' + strFirstName AS strPlayer,
	strPhoneNumber
FROM
	TPlayers
WHERE
	blnIsActive = 1

GO

SELECT * FROM VActivePlayers

-- --------------------------------------------------------------------------------
-- Step #1.12: VInActiveTeams
-- --------------------------------------------------------------------------------
GO

CREATE VIEW VInActiveTeams
AS
SELECT
	intTeamID,
	strTeam,
	strMascot
FROM
	TTeams
WHERE
	blnIsActive = 0

GO

SELECT * FROM VInActiveTeams

-- --------------------------------------------------------------------------------
-- Step #1.13: VInActivePlayers
-- --------------------------------------------------------------------------------
GO

CREATE VIEW VInActivePlayers
AS
SELECT
	intPlayerID,
	strLastName + ', ' + strFirstName AS strPlayer,
	strPhoneNumber
FROM
	TPlayers
WHERE
	blnIsActive = 0

GO

SELECT * FROM VInActivePlayers