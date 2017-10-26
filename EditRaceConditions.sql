-- --------------------------------------------------------------------------------
-- Name: Nicholas Regan
-- Class: IT-112-401
-- Abstract: Homework 5 - Edit Race Conditions
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL2     -- Get out of the master database
SET NOCOUNT ON -- Report only errors

IF OBJECT_ID('TScheduleRouteDrivers') IS NOT NULL DROP TABLE TScheduleRouteDrivers
IF OBJECT_ID('TDriverRoles') IS NOT NULL DROP TABLE TDriverRoles
IF OBJECT_ID('TScheduledRoutes') IS NOT NULL DROP TABLE TScheduledRoutes
IF OBJECT_ID('TScheduledTimes') IS NOT NULL DROP TABLE TScheduledTimes
IF OBJECT_ID('TDrivers') IS NOT NULL DROP TABLE TDrivers
IF OBJECT_ID('TBuses') IS NOT NULL DROP TABLE TBuses
IF OBJECT_ID('TRoutes') IS NOT NULL DROP TABLE TRoutes

IF OBJECT_ID('uspEditRoute') IS NOT NULL DROP PROCEDURE uspEditRoute
IF OBJECT_ID('uspEditDriver') IS NOT NULL DROP PROCEDURE uspEditDriver
IF OBJECT_ID('uspEditScheduledRoute') IS NOT NULL DROP PROCEDURE uspEditScheduledRoute
IF OBJECT_ID('uspMoveScheduledRoute') IS NOT NULL DROP PROCEDURE uspMoveScheduledRoute
IF OBJECT_ID('uspSuperEditScheduledRoute') IS NOT NULL DROP PROCEDURE uspSuperEditScheduledRoute

-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
-- --------------------------------------------------------------------------------
Create Table TRoutes
(
		intRouteID				Integer				Not Null,
		strRoute				Varchar(50)			Not Null,
		strRouteDescription		Varchar(50)			Not Null,
		tspLastUpdated			Timestamp			Not Null,
		CONSTRAINT TRoutes_PK PRIMARY KEY( intRouteID )
)

Create Table TBuses
(
		intBusID				Integer				Not Null,
		strBus					Varchar(50)			Not Null,
		intCapacity				Integer				Not Null,
		CONSTRAINT TBuses_PK PRIMARY KEY( intBusID )
)

Create Table TDrivers
(
		intDriverID				Integer				Not Null,
		strFirstName			Varchar(50)			Not Null,
		strLastName				Varchar(50)			Not Null,
		strPhoneNumber			Varchar(50)			Not Null,
		tspLastUpdated			Timestamp			Not Null,
		CONSTRAINT TDrivers_PK PRIMARY KEY( intDriverID )
)

Create Table TScheduledTimes
(
		intScheduledTimeID		Integer				Not Null,
		strScheduledTime		Varchar(50)			Not Null,
		CONSTRAINT TScheduledTimes_PK PRIMARY KEY( intScheduledTimeID )
)

Create Table TScheduledRoutes
(
		intScheduledTimeID		Integer				Not Null,
		intRouteID				Integer				Not Null,
		intBusID				Integer				Not Null,
		tspLastUpdated			Timestamp			Not Null,
		CONSTRAINT TScheduledRoutes_PK PRIMARY KEY( intScheduledTimeID, intRouteID )
)

Create Table TScheduleRouteDrivers
(
		intScheduledTimeID		Integer				Not Null,
		intRouteID				Integer				Not Null,
		intDriverID				Integer				Not Null,
		intDriverRoleID			Integer				Not Null,
		CONSTRAINT TScheduleRouteDrivers_PK PRIMARY KEY( intScheduledTimeID, intRouteID, intDriverID )
)

Create Table TDriverRoles
(
		intDriverRoleID			Integer				Not Null,
		strDriverRole			Varchar(50)			Not Null,
		intSortOrder			Integer				Not Null,
		CONSTRAINT TDriverRoles_PK PRIMARY KEY( intDriverRoleID )
)

-- --------------------------------------------------------------------------------
-- Step #1.2: Identify and create all the foreign keys.  - ORDER BY CHILD THEN PARENT
-- --------------------------------------------------------------------------------
--		Child						Parent					Column(s)
--		------						------					------
-- 1	TScheduledRoutes			TScheduledTimes			intScheduledTimeID
-- 2	TScheduledRoutes			TRoutes					intRouteID
-- 3	TScheduledRoutes			TBuses					intBusID
-- 4	TScheduleRouteDrivers		TScheduledRoutes		intScheduledTimeID, intRouteID
-- 5	TScheduleRouteDrivers		TDrivers				intDriverID
-- 6	TScheduleRouteDrivers		TDriverRoles			intDriverRoleID

-- 1
ALTER TABLE TScheduledRoutes ADD CONSTRAINT TScheduledRoutes_TScheduledTimes_FK1
FOREIGN KEY ( intScheduledTimeID ) REFERENCES TScheduledTimes( intScheduledTimeID )

-- 2
ALTER TABLE TScheduledRoutes ADD CONSTRAINT TScheduledRoutes_TRoutes_FK1
FOREIGN KEY ( intRouteID ) REFERENCES TRoutes( intRouteID )

-- 3
ALTER TABLE TScheduledRoutes ADD CONSTRAINT TScheduledRoutes_TBuses_FK1
FOREIGN KEY ( intBusID ) REFERENCES TBuses( intBusID )

-- 4
ALTER TABLE TScheduleRouteDrivers ADD CONSTRAINT TScheduleRouteDrivers_TScheduledRoutes_FK1
FOREIGN KEY ( intScheduledTimeID, intRouteID ) REFERENCES TScheduledRoutes( intScheduledTimeID, intRouteID )

-- 5
ALTER TABLE TScheduleRouteDrivers ADD CONSTRAINT TScheduleRouteDrivers_TDrivers_FK1
FOREIGN KEY ( intDriverID ) REFERENCES TDrivers( intDriverID )

-- 6
ALTER TABLE TScheduleRouteDrivers ADD CONSTRAINT TScheduleRouteDrivers_TDriverRoles_FK1
FOREIGN KEY ( intDriverRoleID ) REFERENCES TDriverRoles( intDriverRoleID )

-- --------------------------------------------------------------------------------
-- Step #1.2.5: Unique constraints
-- --------------------------------------------------------------------------------
ALTER TABLE TScheduledRoutes ADD CONSTRAINT TScheduledRoutes_intScheduledTimeID_intBusID
UNIQUE ( intScheduledTimeID, intBusID)

ALTER TABLE TScheduleRouteDrivers ADD CONSTRAINT TScheduleRouteDrivers_intScheduledTimeID_intDriverID
UNIQUE ( intScheduledTimeID, intDriverID)

-- --------------------------------------------------------------------------------
-- Step #1.3: Add sample data
-- --------------------------------------------------------------------------------
Insert Into TRoutes (intRouteID, strRoute, strRouteDescription)
Values	( 1, 'RT-1', 'Broadway to 8th Street' ),
		( 2, 'RT-2', 'Central to 7th Street' ),
		( 3, 'RT-3', 'Race to 6th Street' ),
		( 4, 'RT-4', 'Main to 5th Street' ),
		( 5, 'RT-5', 'Walnut to 4th Street' )

Insert Into TBuses (intBusID, strBus, intCapacity)
Values	( 1, 'Bus A', 50 ),
		( 2, 'Bus B', 50 ),
		( 3, 'Bus C', 50 ),
		( 4, 'Bus D', 50 ),
		( 5, 'Bus E', 50 )

Insert Into TDrivers ( intDriverID, strFirstName, strLastName, strPhoneNumber)
Values	( 1, 'Charlie', 'Kelly', '111-1111'),
		( 2, 'Rob', 'McElhenney', '222-2222'),
		( 3, 'Kaitlin', 'Olson', '333-3333'),
		( 4, 'Glen', 'Howerton', '444-4444'),
		( 5, 'Danny', 'DeVito', '555-5555')

Insert Into TScheduledTimes ( intScheduledTimeID, strScheduledTime)
Values	( 1, '1am'),
		( 2, '2am'),
		( 3, '3am'),
		( 4, '4am'),
		( 5, '5am')

Insert Into TScheduledRoutes ( intScheduledTimeID, intRouteID, intBusID)
Values	(1, 1, 1),
		(2, 2, 2),
		(3, 3, 3),
		(4, 4, 4),
		(5, 5, 5)

Insert Into TDriverRoles ( intDriverRoleID, strDriverRole, intSortOrder)
Values	(1, 'Primary Driver', 1),
		(2, 'Backup Driver 1', 2),
		(3, 'Backup Driver 2', 3)

Insert Into TScheduleRouteDrivers ( intScheduledTimeID, intRouteID, intDriverID, intDriverRoleID)
Values	(1, 1, 1, 1),
		(2, 2, 2, 2),
		(3, 3, 3, 3),
		(4, 4, 4, 1),
		(5, 5, 5, 2)

-- --------------------------------------------------------------------------------
-- Step #1.4: uspEditRoute
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspEditRoute
	 @intRouteID			AS INTEGER
	,@strRoute				AS VARCHAR(50)
	,@strRouteDescription	AS VARCHAR(50)
	,@tspLastUpdated		AS TIMESTAMP
AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error
 
DECLARE @blnRaceConditionExists AS BIT = 1 -- Assume there is a race condition
 
-- Update the record but ...
UPDATE
	TRoutes
SET
	 strRoute = @strRoute
	,strRouteDescription = @strRouteDescription
WHERE
		intRouteID	= @intRouteID
	AND	tspLastUpdated	= @tspLastUpdated -- ... only if it hasn't changed
 
-- Was the row updated?
IF @@ROWCOUNT = 1
 
	-- Yes, the row has not been changed so no edit race condition exists
	SET @blnRaceConditionExists = 0
 
-- Let the caller know if there was a race condition or not
SELECT @blnRaceConditionExists AS blnRaceConditionExists

GO

-- --------------------------------------------------------------------------------
-- Step #1.5: Call and test uspEditRoute 
-- --------------------------------------------------------------------------------
DECLARE @strRoute				AS VARCHAR( 50 )
DECLARE @strRouteDescription	AS VARCHAR( 50 )
DECLARE @tspLastUpdated			AS TIMESTAMP

-- Simulate loading data from database onto form
SELECT
	 @strRoute	= strRoute
	,@strRouteDescription	= strRouteDescription
	,@tspLastUpdated	= tspLastUpdated
FROM
	TRoutes
WHERE
	intRouteID	= 1	-- Hard code for curling/whatever Route

-- Simulate a delay during which the user would change the fields on the form
WAITFOR DELAY '00:00:03'	-- hh:mm:ss – change to whatever you need
SELECT @strRouteDescription = 'Broadway to East 8th Street'

-- Simulate clicking OK on the edit form and attempt to save data by calling USP
EXECUTE uspEditRoute 1, @strRoute, @strRouteDescription, @tspLastUpdated

-- It should return 0 for blnRaceConditionExists and you should see that the record was updated
SELECT * FROM TRoutes WHERE intRouteID = 1	-- Verify change.

-- --------------------------------------------------------------------------------
-- Step #1.6: Call and test uspEditRoute with another copy of SSMS
-- --------------------------------------------------------------------------------
GO

DECLARE @strRoute				AS VARCHAR( 50 )
DECLARE @strRouteDescription	AS VARCHAR( 50 )
DECLARE @tspLastUpdated			AS TIMESTAMP

-- Simulate loading data from database onto form
SELECT
	 @strRoute	= strRoute
	,@strRouteDescription	= strRouteDescription
	,@tspLastUpdated	= tspLastUpdated
FROM
	TRoutes
WHERE
	intRouteID	= 1	-- Hard code for curling/whatever Route

-- Simulate a delay during which the user would change the fields on the form
WAITFOR DELAY '00:00:05'	-- hh:mm:ss – change to whatever you need
SELECT @strRouteDescription = 'Broadway to West 8th Street'

-- Simulate clicking OK on the edit form and attempt to save data by calling USP
EXECUTE uspEditRoute 1, @strRoute, @strRouteDescription, @tspLastUpdated

-- It should return 0 for blnRaceConditionExists and you should see that the record was updated
SELECT * FROM TRoutes WHERE intRouteID = 1	-- Verify change.

GO

-- --------------------------------------------------------------------------------
-- Step #1.7: uspEditDriver
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspEditDriver
	 @intDriverID			AS INTEGER
	,@strFirstName			AS VARCHAR(50)
	,@strLastName			AS VARCHAR(50)
	,@strPhoneNumber		AS VARCHAR(50)	
	,@tspLastUpdated		AS TIMESTAMP
AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error
 
DECLARE @blnRaceConditionExists AS BIT = 1 -- Assume there is a race condition
 
-- Update the record but ...
UPDATE
	TDrivers
SET
	 strFirstName = @strFirstName,
	 strLastName = @strLastName,
	 strPhoneNumber = @strPhoneNumber
WHERE
		intDriverID	= @intDriverID
	AND	tspLastUpdated	= @tspLastUpdated -- ... only if it hasn't changed
 
-- Was the row updated?
IF @@ROWCOUNT = 1
 
	-- Yes, the row has not been changed so no edit race condition exists
	SET @blnRaceConditionExists = 0
 
-- Let the caller know if there was a race condition or not
SELECT @blnRaceConditionExists AS blnRaceConditionExists

GO

-- --------------------------------------------------------------------------------
-- Step #1.8: Call and test uspEditDriver 
-- --------------------------------------------------------------------------------
	DECLARE @strFirstName			AS VARCHAR(50)
	DECLARE	@strLastName			AS VARCHAR(50)
	DECLARE	@strPhoneNumber			AS VARCHAR(50)	
	DECLARE	@tspLastUpdated			AS TIMESTAMP

-- Simulate loading data from database onto form
SELECT
	 @strFirstName		= strFirstName,
	 @strLastName		= strLastName,
	 @strPhoneNumber	= strPhoneNumber,
	 @tspLastUpdated	= tspLastUpdated

FROM
	TDrivers
WHERE
	intDriverID	= 1	-- Hard code for curling/whatever Driver

-- Simulate a delay during which the user would change the fields on the form
WAITFOR DELAY '00:00:03'	-- hh:mm:ss – change to whatever you need
SELECT @strFirstName = 'Benson'

-- Simulate clicking OK on the edit form and attempt to save data by calling USP
EXECUTE uspEditDriver 1, @strFirstName, @strLastName, @strPhoneNumber, @tspLastUpdated

-- It should return 0 for blnRaceConditionExists and you should see that the record was updated
SELECT * FROM TDrivers WHERE intDriverID = 1	-- Verify change.


-- --------------------------------------------------------------------------------
-- Step #1.9: Call and test uspEditDriver with another copy of SSMS
-- --------------------------------------------------------------------------------
GO

	DECLARE @strFirstName			AS VARCHAR(50)
	DECLARE	@strLastName			AS VARCHAR(50)
	DECLARE	@strPhoneNumber			AS VARCHAR(50)	
	DECLARE	@tspLastUpdated			AS TIMESTAMP

-- Simulate loading data from database onto form
SELECT
	 @strFirstName		= strFirstName,
	 @strLastName		= strLastName,
	 @strPhoneNumber	= strPhoneNumber,
	 @tspLastUpdated	= tspLastUpdated
FROM
	TDrivers
WHERE
	intDriverID	= 1	-- Hard code for curling/whatever Driver

-- Simulate a delay during which the user would change the fields on the form
WAITFOR DELAY '00:00:05'	-- hh:mm:ss – change to whatever you need
SELECT @strFirstName = 'Big Benson'

-- Simulate clicking OK on the edit form and attempt to save data by calling USP
EXECUTE uspEditDriver 1, @strFirstName, @strLastName, @strPhoneNumber, @tspLastUpdated

-- It should return 0 for blnRaceConditionExists and you should see that the record was updated
SELECT * FROM TDrivers WHERE intDriverID = 1	-- Verify change.

GO

-- --------------------------------------------------------------------------------
-- Step #1.10: uspEditScheduledRoute
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspEditScheduledRoute
	 @intOldScheduledTimeID				AS INTEGER
	,@intOldRouteID						AS INTEGER
	,@intNewScheduledTimeID				AS INTEGER
	,@intNewRouteID						AS INTEGER
	,@intNewBusID						AS INTEGER
	,@tspLastUpdated					AS TIMESTAMP
AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error
 
DECLARE @blnRaceConditionExists AS BIT = 1 -- Assume there is a race condition
 
-- Update the record but ...
UPDATE
	TScheduledRoutes
SET
	 intScheduledTimeID	= @intNewScheduledTimeID,
	 intRouteID			= @intNewRouteID,
	 intBusID			= @intNewBusID
WHERE
		intScheduledTimeID	= @intOldScheduledTimeID
	AND intRouteID			= @intOldRouteID
	AND	tspLastUpdated		= @tspLastUpdated -- ... only if it hasn't changed
 
-- Was the row updated?
IF @@ROWCOUNT = 1
 
	-- Yes, the row has not been changed so no edit race condition exists
	SET @blnRaceConditionExists = 0
 
-- Let the caller know if there was a race condition or not
SELECT @blnRaceConditionExists AS blnRaceConditionExists

GO

-- --------------------------------------------------------------------------------
-- Step #1.11: Call and test uspEditScheduledRoute
-- --------------------------------------------------------------------------------
-- Make local variable for ROWVERSION so we don't have to type in the value every time we run.
--GO

--DECLARE @tspLastUpdated AS TIMESTAMP
--SELECT
--	@tspLastUpdated = tspLastUpdated
--FROM
--	TScheduledRoutes
--WHERE
--		intScheduledTimeID = 1
--	AND	intRouteID = 1

--EXECUTE uspEditScheduledRoute 1, 1, 2, 1, 1, @tspLastUpdated	-- Change from 8am to 10am

--GO

-- --------------------------------------------------------------------------------
-- Step #1.12: Explain why the stored procedure call fails
-- --------------------------------------------------------------------------------
/*
You can't change a primary key column value, this conflicts with the foreign keys.
You would need to delete the child tables frist.
This is exactly what a foreign key is supposed to do.  So, this isn't so much a failure
as it is an instance where the foreign key is helping us.
Thank you foreign key!

*/

-- --------------------------------------------------------------------------------
-- Step #1.13: uspMoveScheduledRoute
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspMoveScheduledRoute
	 @intOldScheduledTimeID				AS INTEGER
	,@intOldRouteID						AS INTEGER
	,@intNewScheduledTimeID				AS INTEGER
	,@intNewRouteID						AS INTEGER
	,@intNewBusID						AS INTEGER
	,@blnResult							AS BIT OUTPUT
AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

DECLARE @blnAlreadyExists AS BIT = 0	-- False, does not exist
 
BEGIN TRANSACTION
 
	SELECT
		@blnAlreadyExists = 1
	FROM
		TScheduledRoutes (TABLOCKX) -- Lock table until end of transaction
	WHERE 	intScheduledTimeID = @intNewScheduledTimeID
		AND	intRouteID = @intNewRouteID
 
	IF @blnAlreadyExists = 0 
	BEGIN
 
		INSERT INTO TScheduledRoutes( intScheduledTimeID, intRouteID, intBusID )
		VALUES( @intNewScheduledTimeID, @intNewRouteID, @intNewBusID )

		INSERT INTO TScheduleRouteDrivers( intScheduledTimeID, intRouteID, intDriverID, intDriverRoleID )
		(
			SELECT
				@intNewScheduledTimeID,
				@intNewRouteID,
				intDriverID,
				intDriverRoleID
			FROM
				TScheduleRouteDrivers
			WHERE
					intScheduledTimeID	= @intOldScheduledTimeID
				AND	intRouteID			= @intOldRouteID
		)

		DELETE FROM TScheduleRouteDrivers
		WHERE
				intScheduledTimeID	= @intOldScheduledTimeID
			AND	intRouteID			= @intOldRouteID

		DELETE FROM TScheduledRoutes
		WHERE
				intScheduledTimeID	= @intOldScheduledTimeID
			AND	intRouteID			= @intOldRouteID

		SELECT @blnResult = 1
 
	END
 
COMMIT TRANSACTION

GO

 
-- --------------------------------------------------------------------------------
-- Step #1.14: uspSuperEditScheduledRoute
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspSuperEditScheduledRoute
	 @intOldScheduledTimeID				AS INTEGER
	,@intOldRouteID						AS INTEGER
	,@intNewScheduledTimeID				AS INTEGER
	,@intNewRouteID						AS INTEGER
	,@intNewBusID						AS INTEGER
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error
 
DECLARE @blnResult AS BIT = 0
BEGIN TRANSACTION

	IF @intOldScheduledTimeID	<> @intNewScheduledTimeID
	OR @intOldRouteID			<> @intNewRouteID BEGIN
	 
		EXECUTE uspMoveScheduledRoute @intOldScheduledTimeID, @intOldRouteID,
									@intNewScheduledTimeID, @intNewRouteID,
									@intNewBusID,
									@blnResult	OUTPUT

	END ELSE BEGIN

		UPDATE TScheduledRoutes
		SET intBusID = @intNewBusID
		WHERE
				intScheduledTimeID	= @intOldScheduledTimeID
			AND	intRouteID			= @intOldRouteID

		SELECT @blnResult = 1

	END

		SELECT @blnResult AS blnResult

COMMIT TRANSACTION

GO

-- --------------------------------------------------------------------------------
-- Step #1.15: Call the new edit stored procedure with a different new time and/or route and make sure it works
-- --------------------------------------------------------------------------------
EXECUTE uspSuperEditScheduledRoute 1, 1, 2, 1, 1


-- --------------------------------------------------------------------------------
-- Step #1.16: Call the new edit stored procedure with just a different bus ID and make sure it works
-- --------------------------------------------------------------------------------
EXECUTE uspSuperEditScheduledRoute 2, 1, 2, 1, 3

SELECT * FROM TScheduledRoutes

-- --------------------------------------------------------------------------------
-- Step #1.17: Call the new edit stored procedure with invalid data and watch it fail
-- --------------------------------------------------------------------------------

SP_LOCK

--BEGIN TRANSACTION

--SELECT * FROM TScheduledRoutes (TABLOCKX)

--COMMIT TRANSACTION

GO

EXECUTE uspSuperEditScheduledRoute 2, 1, 200, 100, 3

GO

SP_LOCK