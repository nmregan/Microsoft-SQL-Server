-- ---------------------------------------------------------------
-- Name: Nick Regan
-- Class: IT-111-200
-- Abstract: Homework 5 - Problems 3 & 4
-- ---------------------------------------------------------------


use dbsql1
drop table TOrderItems
drop table TOrders
drop table TCustomers

drop table TFlightAttendants
drop table TPassengers
drop table TFlights

-- ---------------------------------------------------------------
-- Step #3.1:	Create Tables
-- ---------------------------------------------------------------

create table TFlights
(
		intFlightID					int					not null,
		strFlight					Varchar(50)			not null,
		strDescription				Varchar(50)			not null,
		strPilotName				Varchar(50)			not null,
		strPilotPhoneNumber			Varchar(50)			not null,
		strCoPilotName				Varchar(50)			not null,
		strCoPilotPhoneNumber		Varchar(50)			not null,
		strAirplaneNumber			Varchar(50)			not null,
		strAirplaneType				Varchar(50)			not null,
		intAirplaneCapacity			int					not null,
		constraint	TFlights_PK Primary Key (intFlightID)
)

create table TPassengers
(
		intFlightID					int					not null,
		intPassengerIndex			int					not null,
		strName						Varchar(50)			not null,
		strPhoneNumber				Varchar(50)			not null,
		strSeatNumber				Varchar(50)			not null,
		constraint	TPassengers_PK Primary Key (intFlightID, intPassengerIndex)
)

create table TFlightAttendants
(
		intFlightID					int					not null,
		intFlightAttendantIndex		int					not null,
		strName						Varchar(50)			not null,
		strPhoneNumber				Varchar(50)			not null,
		constraint	TFlightAttendants_PK Primary Key (intFlightID, intFlightAttendantIndex)
)


-- ---------------------------------------------------------------
-- Step #3.2:	Identify and Create Foreign Keys
-- ---------------------------------------------------------------

Alter Table TPassengers
Add Constraint TPassengers_TFlights_FK 
Foreign Key (intFlightID)
References TFlights (intFlightID)

Alter Table TFlightAttendants
Add Constraint TFlightAttendants_TFlights_FK 
Foreign Key (intFlightID)
References TFlights (intFlightID)



-- ---------------------------------------------------------------
-- Step #4.1:	Create Tables
-- ---------------------------------------------------------------

create table TCustomers
(
		intCustomerID				int					not null,
		strFirstName				Varchar(50)			not null,
		strLastName					Varchar(50)			not null,
		constraint	TCustomers_PK Primary Key (intCustomerID)
)

create table TOrders
(
		intCustomerID				int					not null,
		intOrderIndex				int					not null,
		dtmOrder					datetime			not null,
		constraint	TOrders_PK Primary Key (intCustomerID, intOrderIndex)
)

create table TOrderItems
(
		intCustomerID				int					not null,
		intOrderIndex				int					not null,
		intOrderItemIndex			int					not null,
		strItem						Varchar(50)			not null,
		intQuantity					int					not null,
		monPrice					money				not null,
		constraint	TOrderItems_PK Primary Key (intCustomerID, intOrderIndex, intOrderItemIndex)
)

-- ---------------------------------------------------------------
-- Step #4.2:	Identify and Create Foreign Keys
-- ---------------------------------------------------------------

Alter Table TOrders
Add Constraint TOrders_TCustomers_FK 
Foreign Key (intCustomerID)
References TCustomers (intCustomerID)

Alter Table TOrderItems
Add Constraint TOrderItems_TOrders_FK 
Foreign Key (intCustomerID, intOrderIndex)
References TOrders (intCustomerID, intOrderIndex)

