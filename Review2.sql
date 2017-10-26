-- --------------------------------------------------------------------------------
-- Name: Nicholas Regan
-- Class: IT-112-401
-- Abstract: Homework 1
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL2     -- Get out of the master database
SET NOCOUNT ON -- Report only errors

DROP VIEW VScheduledRoutes

IF OBJECT_ID('TScheduleRouteDrivers') IS NOT NULL DROP TABLE TScheduleRouteDrivers
IF OBJECT_ID('TDriverRoles') IS NOT NULL DROP TABLE TDriverRoles
IF OBJECT_ID('TScheduledRoutes') IS NOT NULL DROP TABLE TScheduledRoutes
IF OBJECT_ID('TScheduledTimes') IS NOT NULL DROP TABLE TScheduledTimes
IF OBJECT_ID('TDrivers') IS NOT NULL DROP TABLE TDrivers
IF OBJECT_ID('TBuses') IS NOT NULL DROP TABLE TBuses
IF OBJECT_ID('TRoutes') IS NOT NULL DROP TABLE TRoutes



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
		strMiddleName			Varchar(50)			Not Null,
		strLastName				Varchar(50)			Not Null,
		strAddress				Varchar(50)			Not Null,
		strCity					Varchar(50)			Not Null,
		strState				Varchar(50)			Not Null,
		strZipcode				Varchar(50)			Not Null,
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
		intDriverID				Integer				Not Null,
		intAlternateDriverID	Integer				Not Null,
		CONSTRAINT TScheduledRoutes_PK PRIMARY KEY( intScheduledTimeID, intRouteID )
)

Create Table TScheduleRouteDrivers
(
		intScheduledTimeID		Integer				Not Null,
		intRouteID				Integer				Not Null,
		intDriverID				Integer				Not Null,
		intDriverRoleID			Integer				Not Null,
		CONSTRAINT TScheduleRouteDrivers_PK PRIMARY KEY( intScheduledTimeID )
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
-- 4	TScheduledRoutes			TDrivers				intDriverID
-- 5	TScheduledRoutes			TDrivers				intAlternateDriverID
-- 6	TScheduleRouteDrivers		TScheduledTimes			intScheduledTimeID
-- 7	TScheduleRouteDrivers		TRoutes					intRouteID
-- 8	TScheduleRouteDrivers		TDrivers				intDriverID
-- 9	TScheduleRouteDrivers		TDriverRoles			intDriverRoleID

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
ALTER TABLE TScheduledRoutes ADD CONSTRAINT TScheduledRoutes_TDrivers_FK1
FOREIGN KEY ( intDriverID ) REFERENCES TDrivers( intDriverID )

-- 5
ALTER TABLE TScheduledRoutes ADD CONSTRAINT TScheduledRoutes_TDrivers_FK2
FOREIGN KEY ( intAlternateDriverID ) REFERENCES TDrivers( intDriverID )

-- 6
ALTER TABLE TScheduleRouteDrivers ADD CONSTRAINT TScheduleRouteDrivers_TScheduledTimes_FK1
FOREIGN KEY ( intScheduledTimeID ) REFERENCES TScheduledTimes( intScheduledTimeID )

-- 7
ALTER TABLE TScheduleRouteDrivers ADD CONSTRAINT TScheduleRouteDrivers_TRoutes_FK1
FOREIGN KEY ( intRouteID ) REFERENCES TRoutes( intRouteID )

-- 8
ALTER TABLE TScheduleRouteDrivers ADD CONSTRAINT TScheduleRouteDrivers_TDrivers_FK1
FOREIGN KEY ( intDriverID ) REFERENCES TDrivers( intDriverID )

-- 9
ALTER TABLE TScheduleRouteDrivers ADD CONSTRAINT TScheduleRouteDrivers_TDriverRoles_FK1
FOREIGN KEY ( intDriverRoleID ) REFERENCES TDriverRoles( intDriverRoleID )

-- --------------------------------------------------------------------------------
-- Step #1.3: Write the SQL that will add 5 routes
-- --------------------------------------------------------------------------------
Insert Into TRoutes (intRouteID, strRoute, strRouteDescription)
Values	( 1, 'RT-1', 'Broadway to 8th Street' ),
		( 2, 'RT-2', 'Central to 7th Street' ),
		( 3, 'RT-3', 'Race to 6th Street' ),
		( 4, 'RT-4', 'Main to 5th Street' ),
		( 5, 'RT-5', 'Walnut to 4th Street' )

-- --------------------------------------------------------------------------------
-- Step #1.4: Write the SQL that will add 5 buses
-- --------------------------------------------------------------------------------
Insert Into TBuses (intBusID, strBus, intCapacity)
Values	( 1, 'Bus A', 50 ),
		( 2, 'Bus B', 50 ),
		( 3, 'Bus C', 50 ),
		( 4, 'Bus D', 50 ),
		( 5, 'Bus E', 50 )

-- --------------------------------------------------------------------------------
-- Step #1.5: Write the SQL that will add 5 drivers
-- --------------------------------------------------------------------------------
Insert Into TDrivers ( intDriverID, strFirstName, strMiddleName, strLastName, strAddress, strCity, strState, strZipcode, strPhoneNumber)
Values	( 1, 'Charlie', 'A', 'Kelly', '111 Broadway', 'Cincinnati', 'Ohio', '45202', '111-1111'),
		( 2, 'Rob', 'B', 'McElhenney', '222 Central', 'Cincinnati', 'Ohio', '45202', '222-2222'),
		( 3, 'Kaitlin', 'C', 'Olson', '333 Race', 'Cincinnati', 'Ohio', '45202', '333-3333'),
		( 4, 'Glen', 'D', 'Howerton', '444 Main', 'Cincinnati', 'Ohio', '45202', '444-4444'),
		( 5, 'Danny', 'E', 'DeVito', '555 Walnut', 'Cincinnati', 'Ohio', '45202', '555-5555')

-- --------------------------------------------------------------------------------
-- Step #1.6: Write the SQL that will add 5 schedule times
-- --------------------------------------------------------------------------------
Insert Into TScheduledTimes ( intScheduledTimeID, strScheduledTime)
Values	( 1, '1am'),
		( 2, '2am'),
		( 3, '3am'),
		( 4, '4am'),
		( 5, '5am')

-- --------------------------------------------------------------------------------
-- Step #1.7: Write the SQL that will add 5 scheduled routes
-- --------------------------------------------------------------------------------
Insert Into TScheduledRoutes ( intScheduledTimeID, intRouteID, intBusID, intDriverID, intAlternateDriverID)
Values	(1, 1, 1, 1, 2),
		(2, 2, 2, 2, 1),
		(3, 3, 3, 3, 4),
		(4, 4, 4, 4, 3),
		(5, 5, 5, 5, 1)

-- --------------------------------------------------------------------------------
-- Step #1.7.5: More Sample Data
-- --------------------------------------------------------------------------------
Insert Into TDriverRoles ( intDriverRoleID, strDriverRole, intSortOrder)
Values	(1, 'Primary', 1),
		(2, 'Secondary', 2)

-- --------------------------------------------------------------------------------
-- Step #1.8: Write the SQL for the view VScheduledRoutes.  
-- --------------------------------------------------------------------------------
Go

Create View VScheduledRoutes

As

SELECT
	TST.intScheduledTimeID,
	TST.strScheduledTime,
	TR.intRouteID,
	TR.strRoute,
	TB.intBusID,
	TB.strBus, 
	TD.intDriverID,
	TD.strLastName + ', ' + TD.strFirstName As strDriver

FROM
	TScheduledRoutes As TSR
			
	Inner Join	TScheduledTimes	As TST
	ON	( TSR.intScheduledTimeID = TST.intScheduledTimeID )
				
	Inner Join TRoutes As TR
	ON	( TSR.intRouteID = TR.intRouteID )

	Inner Join TBuses As TB
	ON	( TSR.intBusID = TB.intBusID )
	
	Inner Join TDrivers As TD			
	ON	( TSR.intDriverID = TD.intDriverID)

Go

SELECT * 

FROM VScheduledRoutes

ORDER BY
	strScheduledTime,
	strRoute