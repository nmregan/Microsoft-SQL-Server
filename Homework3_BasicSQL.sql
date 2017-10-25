-- ---------------------------------------------------------------
-- Name: Nick Regan
-- Class: IT-111-200
-- Abstract: Homework 3 - Basic SQL
-- ---------------------------------------------------------------


use dbsql1
drop table TEmployees

-- ---------------------------------------------------------------
-- Step #1:	Create Table
-- ---------------------------------------------------------------

create table TEmployees
(
		intEmployeeID		int				not null,
		strFirstName		Varchar(50)		not null,
		strLastName			Varchar(50)		not null,
		strPhoneNumber		Varchar(50)		not null,
		strAddress			Varchar(50)		not null,
		strZipCode			Varchar(50)		not null,
		dtmHireDate			date			not null,
		monSalary			money			not null,
		constraint TEmployees_PK Primary Key (intEmployeeID)
)

-- ---------------------------------------------------------------
-- Step #2:	Insert Statements
-- ---------------------------------------------------------------

insert into TEmployees (intEmployeeID, strFirstName, strLastName, strPhoneNumber, strAddress, strZipCode, dtmHireDate, monSalary)
Values	( 1, 'Nick', 'Regan', '513-000-9988', '2306 Ohio ave.', '45219', '9/20/2016', 1000000),
		( 2, 'Hailey', 'Bollinger', '513-280-5566', '2456 Central ave.', '45202', '01/01/2016', 2000000),
		( 3, 'Denise', 'Reynolds', '513-888-5678', '1234 Buttcheek ln.', '45056', '03/27/2008', 500000),
		( 4, 'Charlie', 'Kelly', '214-678-9087', '6789 Hornball blvd.', '45670', '04/04/2005', 100000),
		( 5, 'Mac', 'Donalds', '614-789-0043', '8903 Pandamania ave.', '45896', '01/05/2013', 1500000)

-- ---------------------------------------------------------------
-- Step #3:	Select Statements
-- ---------------------------------------------------------------

select
		strFirstName,
		strLastName
From
		TEmployees
Order by
		intEmployeeID


select
		strFirstName,
		strLastName,
		monSalary
From
		TEmployees
Where
		monSalary > 500000
Order by
		strLastName


select
		strFirstName,
		strLastName,
		monSalary
From
		TEmployees
Where
		monSalary != 100000
and		strLastName != 'Regan'
Order by
		intEmployeeID


select
		strFirstName,
		strLastName,
		dtmHireDate,
		monSalary
From
		TEmployees
Where
		dtmHireDate < '09/20/2016'
and		monSalary > 1000000
Order by
		intEmployeeID


select
		strFirstName,
		strLastName,
		strPhoneNumber
From
		TEmployees
Where
		strPhoneNumber like '513%'
and		strLastName like 'R%'
Order by
		intEmployeeID


-- ---------------------------------------------------------------
-- Step #4:	Update Statements
-- ---------------------------------------------------------------

Update
		TEmployees
Set	
		strFirstName = 'Nicholas'
Where
		strFirstName = 'Nick'


Update
		TEmployees
Set
		monSalary = monSalary + (monSalary *0.10)
Where
		strLastName = 'Regan'


Update
		TEmployees
Set
		strAddress = '2306 Ohio ave.',
		strZipCode = '45219'
Where
		strLastName = 'Bollinger'
and		strFirstName = 'Hailey'


Update
		TEmployees
Set
		strAddress = '1612 Broadway st.',
		strZipCode = '45202'
Where
		strAddress = '2306 Ohio ave.'


Update
		TEmployees
Set
		monSalary = monSalary + 10000
Where
		strLastName != 'Regan'


-- ---------------------------------------------------------------
-- Step #5:	Delete Statements
-- ---------------------------------------------------------------
Delete From
		TEmployees
Where
		strLastName = 'Donald'
and		strFirstName = 'Mac'

Delete From
		TEmployees
Where
		dtmHireDate > '01/01/2008'
and		dtmHireDate < '01/01/2009'


Delete From
		TEmployees
Where
		strZipCode = '452%'
and		strLastName != 'Regan'


Delete from 
		TEmployees
Where
		monSalary >= 1000000
and		strLastName != 'Regan'


Delete From
		TEmployees
Where
		strLastName = 'Kelly'

