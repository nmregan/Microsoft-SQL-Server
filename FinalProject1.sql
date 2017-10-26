-- ---------------------------------------------------------------
-- Name: Nick Regan
-- Class: IT-111-200
-- Abstract: Final Project
-- ---------------------------------------------------------------

use dbsql1


-- ---------------------------------------------------------------
-- Step #0.0:	Drop Tables
-- ---------------------------------------------------------------

Drop Table TCustomerJobs
Drop Table TJobMaterials
Drop Table TVendorMaterials
Drop Table TJobWorkers
Drop Table TWorkerSkills
Drop Table TCustomers
Drop Table TJobs
Drop Table TMaterials
Drop Table TVendors
Drop Table TWorkers
Drop Table TSkills
Drop Table TStates
Drop Table TJobStatuses

-- ---------------------------------------------------------------
-- Step #1.1:	Create Tables
-- ---------------------------------------------------------------

Create Table TCustomerJobs
(
		intCustomerID				integer					not null,
		intJobID					integer					not null,
		Constraint TCustomerJobs_PK Primary Key (intCustomerID, intJobID)
)

Create Table TJobMaterials
(
		intJobID					integer					not null,
		intMaterialID				integer					not null,
		intMaterialQuantity			integer					not null,
		Constraint TJobMaterials_PK Primary Key (intJobID, intMaterialID)
)

Create Table TVendorMaterials
(
		intVendorID					integer					not null,
		intMaterialID				integer					not null,
		Constraint TVendorMaterials_PK Primary Key (intVendorID, intMaterialID)
)

Create Table TJobWorkers
(
		intJobID					integer					not null,
		intWorkerID					integer					not null,
		intHoursWorked				integer					not null,
		Constraint TJobWorkers_PK Primary Key (intJobID, intWorkerID)
)

Create Table TWorkerSkills
(
		intWorkerID					integer					not null,
		intSkillID					integer					not null,
		Constraint TWorkerSkills_PK Primary Key (intWorkerID, intSkillID)
)

Create Table TCustomers
(
		intCustomerID				integer					not null,
		strFirstName				varchar(50)				not null,
		strLastName					varchar(50)				not null,
		strAddress					varchar(100)			not null,
		strCity						varchar(50)				not null,
		intStateID					integer					not null,
		strZipCode					varchar(50)				not null,
		Constraint TCustomers_PK Primary Key (intCustomerID)
)

Create Table TJobs
(
		intJobID					integer					not null,
		strJobDescription			varchar(2000)			not null,
		intJobStatusID				integer					not null,
		dtmStartDate				DateTime				not null,
		dtmEndDate					DateTime				not null,
		Constraint TJobs_PK Primary Key (intJobID)
)

Create Table TMaterials
(
		intMaterialID				integer					not null,
		strMaterial					varchar(100)			not null,
		monMaterialCostPerUnit		Money					not null,
		Constraint TMaterials_PK Primary Key (intMaterialID)
)			

Create Table TVendors
(
		intVendorID					integer					not null,
		strVendorName				varchar(100)			not null,
		strAddress					varchar(100)			not null,
		strCity						varchar(50)				not null,
		intStateID					integer					not null,
		strZipCode					varchar(50)				not null,
		Constraint TVendors_PK Primary Key (intVendorID)
)

Create Table TWorkers
(
		intWorkerID					integer					not null,
		strFirstName				varchar(50)				not null,
		strLastName					varchar(50)				not null,
		strPhoneNumber				varchar(50)				not null,
		dtmHireDate					DateTime				not null,
		monHourlyRate				Money					not null,
		Constraint TWorkers_PK Primary Key (intWorkerID)
)

Create Table TSkills
(
		intSkillID					integer					not null,
		strSkill					varchar(100)			not null,
		Constraint TSkills_PK Primary Key (intSkillID)
)

Create Table TStates
(
		intStateID					integer					not null,
		strState					varchar(50)				not null,
		Constraint TStates_PK Primary Key (intStateID)
)

Create Table TJobStatuses
(
		intJobStatusID				integer					not null,
		strJobStatus				Varchar(50)				not null,
		Constraint TJobStatuses_PK Primary Key (intJobStatusID)
)

-- ---------------------------------------------------------------
-- Step #1.2:	Identify and Create Foreign Keys
-- ---------------------------------------------------------------

Alter Table TCustomerJobs Add Constraint TCustomerJobs_TCustomers_FK 
Foreign Key (intCustomerID) References TCustomers (intCustomerID)

Alter Table TCustomerJobs Add Constraint TCustomerJobs_TJobs_FK 
Foreign Key (intJobID) References TJobs (intJobID)

Alter Table TJobMaterials Add Constraint TJobMaterials_TJobs_FK 
Foreign Key (intJobID) References TJobs (intJobID)

Alter Table TJobMaterials Add Constraint TJobMaterials_TMaterials_FK 
Foreign Key (intMaterialID) References TMaterials (intMaterialID)

Alter Table TVendorMaterials Add Constraint TVendorMaterials_TVendors_FK 
Foreign Key (intVendorID) References TVendors (intVendorID)

Alter Table TVendorMaterials Add Constraint TVendorMaterials_TMaterials_FK 
Foreign Key (intMaterialID) References TMaterials (intMaterialID)

Alter Table TJobWorkers Add Constraint TJobWorkers_TJobs_FK 
Foreign Key (intJobID) References TJobs (intJobID)

Alter Table TJobWorkers Add Constraint TJobWorkers_TWorkers_FK 
Foreign Key (intWorkerID) References TWorkers (intWorkerID)

Alter Table TWorkerSkills Add Constraint TWorkerSkills_TWorkers_FK 
Foreign Key (intWorkerID) References TWorkers (intWorkerID)

Alter Table TWorkerSkills Add Constraint TWorkerSkills_TSkills_FK 
Foreign Key (intSkillID) References TSkills (intSkillID)

Alter Table TCustomers Add Constraint TCustomers_TStates_FK 
Foreign Key (intStateID) References TStates (intStateID)

Alter Table TVendors Add Constraint TVendors_TStates_FK 
Foreign Key (intStateID) References TStates (intStateID)

Alter Table TJobs Add Constraint TJobs_TJobStatuses_FK 
Foreign Key (intJobStatusID) References TJobStatuses (intJobStatusID)

-- ---------------------------------------------------------------
-- Step #2.1:	Insert Test Data
-- ---------------------------------------------------------------

Insert Into TJobStatuses (intJobStatusID, strJobStatus)
Values	(1, 'Open'),
		(2, 'In Process'),
		(3, 'Complete')

Insert Into TSkills (intSkillID, strSkill)
Values	(1, 'Computer Programer'),
		(2, 'Electrician'),
		(3, 'Pulmber'),
		(4, 'Photographer'),
		(5, 'Welder')

Insert Into TWorkers (intWorkerID, strFirstName, strLastName, strPhoneNumber, dtmHireDate, monHourlyRate)
Values	(1, 'George', 'Costanza', '513-898-6677', '2016/12/13', 20.00),
		(2, 'Elaine', 'Benes', '502-789-3344', '2015/11/01', 25.00),
		(3, 'Jerry', 'Seinfeld', '219-302-1234', '2011/08/05', 40.00),
		(4, 'Mitch', 'Kramer', '513-280-0329', '2006/05/10', 45.00),
		(5, 'Ron', 'Slater', '502-654-3456', '2015/12/01', 50.00),
		(6, 'David', 'Wooderson', '219-302-0045', '2016/07/01', 30.00)

Insert Into TStates (intStateID, strState)
Values	(1, 'Ohio'),
		(2, 'Indiana'),
		(3, 'Kentucky'),
		(4, 'Pennsylvania'),
		(5, 'Michigan')

Insert Into TVendors (intVendorID, strVendorName, strAddress, strCity, intStateID, strZipCode)
Values	(1, 'Babes All Purpose Pipes', '123 Central Ave.', 'Cincinnati', 1, '45202'),
		(2, 'Micro Center', '869 Valey Day St.', 'Liberty', 2, '75602'),
		(3, 'Shock it to Me', '789 Broadway St.', 'Detroit', 5, '89010'),
		(4, 'Photo-Bomb.Com', '456 6th St.', 'Covington', 3, '65300'),
		(5, 'Fire Sale Inc.', '321 8th St.', 'Philadelphia', 4, '16701')

Insert Into TMaterials (intMaterialID, strMaterial, monMaterialCostPerUnit)
Values	(1, 'Lead Pipes', 5.00),
		(2, 'External Hard Drives', 100.00),
		(3, 'Rubber Wires', 2.00),
		(4, 'Canon Rebel Cameras', 300.00),
		(5, 'Lighters', 1.00),
		(6, 'Plastic Pipes', 3.00),
		(7, 'Disposable Cameras', 4.00),
		(8, 'Energy Efficient Light Bulbs', 3.00),
		(9, 'Dell Computers', 500.00)

Insert Into TJobs (intJobID, strJobDescription, intJobStatusID, dtmStartDate, dtmEndDate)
Values	(1, 'Replacing bathroom pipes', 1, '2017/01/01', '2017/02/01'),
		(2, 'Update software in office room 100', 2, '2016/12/01', '2017/03/01'),
		(3, 'Fix broken lightbulbs in basement', 2, '2015/10/02', '2017/01/01'),
		(4, 'Take employee of the year 2014 headshots', 3, '2015/01/01', '2015/01/14'),
		(5, 'Fix sink in 5th floor bathroom', 3, '2013/03/27', '2013/06/01'),
		(6, 'Weld metal sign in front of office that says "The World is Yours"', 1, '2017/01/01', '2017/04/01'),
		(7, 'Burn every office wall', 2, '2017/01/01', '2017/02/01'),
		(8, 'Install new computers', 3, '2017/01/01', '2017/02/01'),
		(9, 'Re-Wire office', 3, '2017/01/01', '2017/02/01'),
		(10, 'Build a new office', 3, '2017/01/01', '2017/02/01')

Insert Into TCustomers (intCustomerID, strFirstName, strLastName, strAddress, strCity, intStateID, strZipCode)
Values	(1, 'Larry', 'David', '123 1st St.', 'Cincinnati', 1, '45219'),
		(2, 'Jeff', 'Greene', '456 2nd St.', 'Liberty', 2, '75602'),
		(3, 'Marty', 'Funkhouser', '789 3rd St.', 'Detroit', 5, '89010'),
		(4, 'Loretta', 'Black', '234 4th St.', 'Newport', 3, '67020'),
		(5, 'Matt', 'Tessler', '567 5th St.', 'Philadelphia', 4, '16701')

Insert Into TWorkerSkills (intWorkerID, intSkillID)
Values	(1, 1),
		(2, 2),
		(3, 3),
		(4, 4),
		(5, 5),
		(6, 4)

Insert Into TJobWorkers (intJobID, intWorkerID, intHoursWorked)
Values	(1, 3, 40.00),
		(2, 1, 80.00),
		(3, 2, 10.00),
		(4, 6, 20.00),
		(5, 3, 40.00),
		(6, 5, 60.00)

Insert Into TVendorMaterials (intVendorID, intMaterialID)
Values	(1, 1),
		(1, 6),
		(2, 2),
		(2, 3),
		(2, 4),
		(2, 7),
		(3, 3),
		(3, 8),
		(4, 4),
		(4, 7),
		(5, 5)

Insert Into TJobMaterials (intJobID, intMaterialID, intMaterialQuantity)
Values	(1, 6, 100),
		(2, 2, 50),
		(3, 8, 20),
		(3, 3, 40),
		(4, 4, 1),
		(5, 6, 2),
		(6, 5, 18),
		(7, 5, 100),
		(8, 9, 10),
		(9, 3, 20),
		(10, 3, 5),
		(10, 6, 10),
		(10, 9, 2)

Insert Into TCustomerJobs (intCustomerID, intJobID)
Values	(1, 1),
		(1, 5),
		(2, 6),
		(3, 4),
		(4, 2),
		(5, 3),
		(1, 7),
		(1, 8),
		(1, 9),
		(1, 10)

-- ---------------------------------------------------------------
-- Step #3.1:	Update the address for a specific customer
-- ---------------------------------------------------------------

Select
		intCustomerID,
		strFirstName,
		strLastName,
		strAddress
From
		TCustomers
Order By
		intCustomerID

Update
		TCustomers
Set
		strAddress = '1612 Broadway St. Apt #1'
Where
		strAddress = '123 1st St.'


Select
		intCustomerID,
		strFirstName,
		strLastName,
		strAddress
From
		TCustomers
Order By
		intCustomerID

-- ---------------------------------------------------------------------------------------------------------
-- Step #3.2:	Increase the hourly rate by $2 for each worker that has been an employee for at least 1 Year
-- ---------------------------------------------------------------------------------------------------------

Select 
		intWorkerID,
		strFirstName,
		strLastName,
		dtmHireDate,
		monHourlyRate

From
		TWorkers

Order By
		intWorkerID


Update
		TWorkers
Set
		monHourlyRate = monHourlyRate + 2
Where
		dtmHireDate <= '2015/12/14'


Select 
		intWorkerID,
		strFirstName,
		strLastName,
		dtmHireDate,
		monHourlyRate

From
		TWorkers

Order By
		intWorkerID

-- ---------------------------------------------------------------------------------------------------------
-- Step #3.3:	Delete a specific job that has associated work hours and material assigned to it
-- ---------------------------------------------------------------------------------------------------------

Select
		TJ.intJobID as "Job ID",
		TJM.intMaterialID as "Material ID",
		TM.strMaterial as "Material Used",
		TJW.intHoursWorked as "Hours Worked"

From 
		TJobs as TJ
		Inner Join TJobWorkers as TJW on (TJ.intJobID = TJW.intJobID)
		Inner Join TJobMaterials as TJM on (TJM.intJobID = TJ.intJobID)
		Inner Join TMaterials as TM on (TM.intMaterialID = TJM.intMaterialID)

Order By
		"Job ID"


Delete From 
		TCustomerJobs
Where
		intCustomerID = 2 and intJobID = 6

Delete From
		TJobMaterials
Where
		intJobID = 6

Delete From
		TJobWorkers
Where
		intJobID = 6

Delete From
		TJobs
Where
		intJobID = 6

Select
		TJ.intJobID as "Job ID",
		TJM.intMaterialID as "Material ID",
		TM.strMaterial as "Material Used",
		TJW.intHoursWorked as "Hours Worked"

From 
		TJobs as TJ
		Inner Join TJobWorkers as TJW on (TJ.intJobID = TJW.intJobID)
		Inner Join TJobMaterials as TJM on (TJM.intJobID = TJ.intJobID)
		Inner Join TMaterials as TM on (TM.intMaterialID = TJM.intMaterialID)

Order By
		"Job ID"

-- -----------------------------------------------------------------------------------------------------------------------------
-- Step #4.1:	List all jobs that are in process - include JobID, Description, CustomerID, First and Last Name, Order by Job ID
-- -----------------------------------------------------------------------------------------------------------------------------

Select
		TCJ.intJobID as "Job ID",
		TJ.strJobDescription as "Job Description",
		TCJ.intCustomerID as "Customer ID",
		TC.strFirstName as "Customer First Name",
		TC.strLastName as "Customer Last Name"

From 
		TCustomerJobs as TCJ
		Inner Join TJobs as TJ on (TCJ.intJobID = TJ.intJobID)
		Inner Join TCustomers as TC on (TC.intCustomerID = TCJ.intCustomerID)

Where
		TJ.intJobStatusID = 2

Order By
		"Job ID"

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Step #4.2:	List all Complete jobs for a specific customer and the materials used on each job.  Include quantity, unit cost, total cost for each material on each job, order by Job ID and Material ID
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Select 
		TJ.intJobID	as "Job ID",
		TM.intMaterialID as "Material ID",
		TJM.intMaterialQuantity as "Material Quantity",
		TM.monMaterialCostPerUnit as "Cost Per Unit",
		TJM.intMaterialQuantity * TM.monMaterialCostPerUnit as "Total Cost"

From
		TCustomers as TC
		Inner Join TCustomerJobs as TCJ on (TC.intCustomerID = TCJ.intCustomerID)
		Inner Join TJobs as TJ on (TCJ.intJobID = TJ.intJobID)
		Inner Join TJobMaterials as TJM on (TJM.intJobID = TJ.intJobID)
		Inner Join TMaterials as TM on (TM.intMaterialID = TJM.intMaterialID)

Where
		TJ.intJobStatusID = 3 and TC.intCustomerID = 1

Order By
		"Job ID",
		"Material ID"

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Step #4.5:	List all materials that have not been used on any job.  Include material ID and Description, Order by Material ID
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select 
		intMaterialID, strMaterial

from 
		TMaterials

Where 
		intMaterialID not in ( select intMaterialID from TJobMaterials)
	
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Step #4.7:	List all Workers that worked greater than 20 hours for all jobs that they worked on.  Include WorkerID, Name, Hours Worked, Number of Jobs worked, Order WorkerID
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Select
		TW.intWorkerID as "Worker ID",
		TW.strFirstName as "First Name",
		TW.strLastName as "Last name",
		TJW.intHoursWorked as "Hours Worked"

From
		TWorkers as TW
		Inner Join TJobWorkers as TJW on (TJW.intWorkerID = TW.intWorkerID)

Where
		TJW.intHoursWorked > 20

Order By
		"Worker ID"

		
		




			
