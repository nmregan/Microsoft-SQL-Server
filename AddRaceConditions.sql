-- --------------------------------------------------------------------------------
-- Name: Nicholas Regan
-- Class: IT-112-401
-- Abstract: Homework 4 - Add Race Conditions
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

IF OBJECT_ID('uspAddRoute') IS NOT NULL DROP PROCEDURE uspAddRoute
IF OBJECT_ID('uspAddBus') IS NOT NULL DROP PROCEDURE uspAddBus
IF OBJECT_ID('uspAddDriver') IS NOT NULL DROP PROCEDURE uspAddDriver
IF OBJECT_ID('uspAddScheduledTime') IS NOT NULL DROP PROCEDURE uspAddScheduledTime
IF OBJECT_ID('uspAddDriverRole') IS NOT NULL DROP PROCEDURE uspAddDriverRole
IF OBJECT_ID('uspAddScheduledRoute') IS NOT NULL DROP PROCEDURE uspAddScheduledRoute
IF OBJECT_ID('uspAddScheduledRouteDriver') IS NOT NULL DROP PROCEDURE uspAddScheduledRouteDriver

-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
-- --------------------------------------------------------------------------------
Create Table TRoutes
(
		intRouteID				Integer				Not Null,
		strRoute				Varchar(50)			Not Null,
		strRouteDescription		Varchar(50)		Not Null,
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
-- Step #1.3: uspAddRoute
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspAddRoute
	 @strRoute				AS VARCHAR( 50 )
	,@strRouteDescription	AS VARCHAR( 50 )
AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

DECLARE @intRouteID AS INTEGER

BEGIN TRANSACTION

	SELECT @intRouteID = MAX( intRouteID ) + 1
	FROM TRoutes (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intRouteID  = COALESCE( @intRouteID , 1 )

	INSERT INTO TRoutes( intRouteID, strRoute, strRouteDescription )
	VALUES( @intRouteID , @strRoute, @strRouteDescription )

	-- Return value to caller
	SELECT @intRouteID AS intRouteID 

COMMIT TRANSACTION

GO

uspAddRoute 'R1', '8th St. to Broadway'
GO

uspAddRoute 'R2', '12th St. to Main'
GO

-- --------------------------------------------------------------------------------
-- Step #1.4: uspAddBus
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspAddBus
	 @strBus				AS VARCHAR( 50 )
	,@intCapacity			AS INTEGER
AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

DECLARE @intBusID AS INTEGER

BEGIN TRANSACTION

	SELECT @intBusID = MAX( intBusID ) + 1
	FROM TBuses (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intBusID  = COALESCE( @intBusID , 1 )

	INSERT INTO TBuses( intBusID, strBus, intCapacity )
	VALUES( @intBusID , @strBus, @intCapacity )

	-- Return value to caller
	SELECT @intBusID AS intBusID 

COMMIT TRANSACTION

GO

uspAddBus 'Bus1', 20
GO

uspAddBus 'Bus2', 30
GO

-- --------------------------------------------------------------------------------
-- Step #1.5: uspAddDriver
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspAddDriver
	 @strFirstName			AS VARCHAR( 50 )
	,@strLastName			AS VARCHAR( 50 )
	,@strPhoneNumber		AS VARCHAR( 50 )
AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

DECLARE @intDriverID AS INTEGER

BEGIN TRANSACTION

	SELECT @intDriverID = MAX( intDriverID ) + 1
	FROM TDrivers (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intDriverID  = COALESCE( @intDriverID , 1 )

	INSERT INTO TDrivers( intDriverID, strFirstName, strLastName, strPhoneNumber )
	VALUES( @intDriverID , @strFirstName, @strLastName, @strPhoneNumber )

	-- Return value to caller
	SELECT @intDriverID AS intDriverID 

COMMIT TRANSACTION

GO

uspAddDriver 'Bill', 'Hicks', '523-9900'
GO

uspAddDriver 'Dick', 'Dale', '619-2233'
GO

-- --------------------------------------------------------------------------------
-- Step #1.6: uspAddScheduledTime
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspAddScheduledTime
	 @strScheduledTime		AS VARCHAR( 50 )
AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

DECLARE @intScheduledTimeID AS INTEGER

BEGIN TRANSACTION

	SELECT @intScheduledTimeID = MAX( intScheduledTimeID ) + 1
	FROM TScheduledTimes (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intScheduledTimeID  = COALESCE( @intScheduledTimeID , 1 )

	INSERT INTO TScheduledTimes( intScheduledTimeID, strScheduledTime )
	VALUES( @intScheduledTimeID , @strScheduledTime )

	-- Return value to caller
	SELECT @intScheduledTimeID AS intScheduledTimeID 

COMMIT TRANSACTION

GO

uspAddScheduledTime '8am'
GO

uspAddScheduledTime '9am'
GO


-- --------------------------------------------------------------------------------
-- Step #1.7: uspAddDriverRole
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspAddDriverRole
	 @strDriverRole			AS VARCHAR( 50 )
	,@intSortOrder			AS INTEGER
AS
SET NOCOUNT ON	-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

DECLARE @intDriverRoleID AS INTEGER

BEGIN TRANSACTION

	SELECT @intDriverRoleID = MAX( intDriverRoleID ) + 1
	FROM TDriverRoles (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intDriverRoleID  = COALESCE( @intDriverRoleID , 1 )

	INSERT INTO TDriverRoles( intDriverRoleID, strDriverRole, intSortOrder )
	VALUES( @intDriverRoleID , @strDriverRole, @intSortOrder )

	-- Return value to caller
	SELECT @intDriverRoleID AS intDriverRoleID 

COMMIT TRANSACTION

GO

uspAddDriverRole 'Primary', 1
GO

uspAddDriverRole 'Backup', 2
GO

-- --------------------------------------------------------------------------------
-- Step #1.8: uspAddScheduledRoute
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspAddScheduledRoute
	 @intScheduledTimeID		AS INTEGER
	,@intRouteID				AS INTEGER
	,@intBusID					AS INTEGER
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error
 
DECLARE @blnAlreadyExists AS BIT = 0	-- False, does not exist
 
BEGIN TRANSACTION
 
	SELECT
		@blnAlreadyExists = 1
	FROM
		TScheduledRoutes (TABLOCKX) -- Lock table until end of transaction
	WHERE 	intScheduledTimeID	=	@intScheduledTimeID
		AND	intRouteID			=	@intRouteID
 
	IF @blnAlreadyExists = 0 
	BEGIN
 
		INSERT INTO TScheduledRoutes( intScheduledTimeID, intRouteID, intBusID )
		VALUES( @intScheduledTimeID, @intRouteID, @intBusID )
 
	END
 
COMMIT TRANSACTION

GO

uspAddScheduledRoute 1, 1, 1
GO

uspAddScheduledRoute 2, 2, 2
GO

-- --------------------------------------------------------------------------------
-- Step #1.9: uspAddScheduledRouteDriver
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspAddScheduledRouteDriver
	 @intScheduledTimeID		AS INTEGER
	,@intRouteID				AS INTEGER
	,@intDriverID				AS INTEGER
	,@intDriverRoleID			AS INTEGER
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error
 
DECLARE @blnAlreadyExists AS BIT = 0	-- False, does not exist
 
BEGIN TRANSACTION
 
	SELECT
		@blnAlreadyExists = 1
	FROM
		TScheduleRouteDrivers (TABLOCKX) -- Lock table until end of transaction
	WHERE 	intScheduledTimeID	=	@intScheduledTimeID
		AND	intRouteID			=	@intRouteID
		AND	intDriverID			=	@intDriverID
 
	IF @blnAlreadyExists = 0 
	BEGIN
 
		INSERT INTO TScheduleRouteDrivers( intScheduledTimeID, intRouteID, intDriverID, intDriverRoleID )
		VALUES( @intScheduledTimeID, @intRouteID, @intDriverID, @intDriverRoleID )
 
	END
 
COMMIT TRANSACTION

GO

uspAddScheduledRouteDriver 1, 1, 1, 1
GO

uspAddScheduledRouteDriver 1, 1, 1, 2
GO

uspAddScheduledRouteDriver 2, 2, 2, 2
GO

uspAddScheduledRouteDriver 2, 2, 2, 1
GO