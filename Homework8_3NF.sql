-- ---------------------------------------------------------------
-- Name: Nick Regan
-- Class: IT-111-200
-- Abstract: Homework 8 3NF Practice
-- ---------------------------------------------------------------


use dbsql1

drop table TPaymentRecipients
drop table TInsurancePolicyClaimPayments
drop table TInsurancePolicyClaims
drop table TClients
drop table TSellingAgents
drop table TPaymentStatuses
drop table TInsurancePolicyTypes
drop table TInsurancePolicies

drop table TPatientLabTests
drop table TPatientVisits
drop table TPatients
drop table TLabTests
drop table TMedications
drop table TProcedures

drop table TTeamPlayers
drop table TTeams
drop table TMascots
drop table TPlayers
drop table TCoaches


-- ---------------------------------------------------------------
-- Step #1.1:	Create Tables
-- ---------------------------------------------------------------

create table TCoaches
(
		intCoachesID			int				not null,
		strFirstName			varchar(50)		not null,
		strLastName				varchar(50)		not null,
		strPhoneNumber			varchar(50)		not null,
		constraint TCoaches_PK Primary Key (intCoachesID)
)

create table TPlayers
(
		intPlayerID				int				not null,
		strFirstName			varchar(50)		not null,
		strLastName				varchar(50)		not null,
		strPhoneNumber			varchar(50)		not null,
		constraint TPlayers_PK Primary Key (intPlayerID)
)

create table TMascots
(
		intMascotID				int				not null,
		strName					varchar(50)		not null,
		strColors				varchar(50)		not null,
		strAnimalType			varchar(50)		not null,
		constraint TMascots_PK Primary Key (intMascotID)
)

create table TTeams
(
		intTeamID				int				not null,
		strTeam					varchar(50)		not null,
		intMascotID				int				not null,
		intCoachesID			int				not null,
		constraint TTeams_PK Primary Key (intTeamID, intMascotID, intCoachesID)
)

create table TTeamPlayers
(
		intTeamID				int				not null,
		intPlayerID				int				not null,
		constraint TTeamPlayers_PK Primary Key (intTeamID, intPlayerID)
)

-- ---------------------------------------------------------------
-- Step #1.2:	Identify and Create Foreign Keys
-- ---------------------------------------------------------------

Alter Table TTeams Add Constraint TTeams_TMascots_FK 
Foreign Key (intMascotID) References TMascots (intMascotID)

Alter Table TTeams Add Constraint TTeams_TCoaches_FK 
Foreign Key (intCoachesID) References TCoaches (intCoachesID)

Alter Table TTeamPlayers Add Constraint TTeamPlayers_TPlayers_FK 
Foreign Key (intPlayerID) References TPlayers (intPlayerID)




-- ---------------------------------------------------------------
-- Step #2.1:	Create Tables
-- ---------------------------------------------------------------

create table TProcedures
(
		intProcedureID			int					not null,
		strProcedure			varchar(50)			not null,
		strNotes				varchar(50)			not null,
		constraint TProcedures_PK Primary Key (intProcedureID)
)

create table TMedications
(
		intMedicationID			int					not null,
		strMedication			varchar(50)			not null,
		strDosage				varchar(50)			not null,
		constraint TMedications_PK Primary Key (intMedicationID)
)

create table TLabTests
(
		intLabTestID			int					not null,
		strLabTest				varchar(50)			not null,
		strBillingCode			varchar(50)			not null,
		constraint TLabTests_PK Primary Key (intLabTestID)
)

create table TPatients
(
		intPatientID			int					not null,
		strFirstName			varchar(50)			not null,
		strLastName				varchar(50)			not null,
		intProcedureID			int					not null,
		intMedicationID			int					not null,
		intLabTestID			int					not null,
		constraint TPatients_PK Primary Key (intPatientID, intProcedureID, intMedicationID, intLabTestID)
)

create table TPatientVisits
(
		intPatientVisitID		int					not null,
		dtmVisitDate			Datetime			not null,
		intPatientID			int					not null,
		constraint TPatientVisits_PK Primary Key (intPatientVisitID, intPatientID)
)

create table TPatientLabTests
(
		intPatientLabTestID		int					not null,
		strResults				varchar(50)			not null,
		intLabTestID			int					not null,
		intPatientID			int					not null,
		constraint TPatientLabTests_PK Primary Key (intPatientLabTestID, intLabTestID, intPatientID)
)

-- ---------------------------------------------------------------
-- Step #2.2:	Identify and Create Foreign Keys
-- ---------------------------------------------------------------

Alter Table TPatients Add Constraint TPatients_TProcedures_FK 
Foreign Key (intProcedureID) References TProcedures (intProcedureID)

Alter Table TPatients Add Constraint TPatients_TMedications_FK 
Foreign Key (intMedicationID) References TMedications (intMedicationID)

Alter Table TPatients Add Constraint TPatients_TLabTests_FK 
Foreign Key (intLabTestID) References TLabTests (intLabTestID)



-- ---------------------------------------------------------------
-- Step #3.1:	Create Tables
-- ---------------------------------------------------------------

create table TInsurancePolicies
(
		intInsurancePolicyID			int					not null,
		strInsurancePolicyNumber		varchar(50)			not null,
		intInsurancePolicyTypeID		int					not null,
		dtmStartDate					datetime			not null,
		monAnnualPayment				money				not null,
		intPaymentStatusID				int					not null,
		intSellingAgentID				int					not null,
		intClientID						int					not null,
		constraint TInsurancePolicies_PK Primary Key (intInsurancePolicyID)
)

create table TInsurancePolicyTypes
(
		intInsurancePolicyTypeID		int					not null,
		strInsurancePolicyType			varchar(50)			not null,
		constraint TInsurancePolicyTypes_PK Primary key (intInsurancePolicyTypeID)
)

create table TPaymentStatuses
(
		intPaymentStatusID				int					not null,
		strPaymentStatus				varchar(50)			not null,
		constraint TPaymentStatuses_PK Primary Key (intPaymentStatusID)
)

create table TSellingAgents
(
		intSellingAgentID				int					not null,
		strFirstName					varchar(50)			not null,
		strLastName						varchar(50)			not null,
		strPhoneNumber					varchar(50)			not null,
		strAddress						varchar(50)			not null,
		constraint TSellingAgents_PK Primary key (intSellingAgentID)
)

create table TClients
(
		intClientID						int					not null,
		strFirstName					varchar(50)			not null,
		strLastName						varchar(50)			not null,
		strPhoneNumber					varchar(50)			not null,
		strAddress						varchar(50)			not null,
		constraint TClients_PK Primary key (intClientID)
)

create table TInsurancePolicyClaims
(
		intInsurancePolicyID			int					not null,
		intClaimIndex					int					not null,
		dtmClaimDate					datetime			not null,
		strClaimDescription				Varchar(500)		not null,
		constraint TInsurancePolicyClaims_PK Primary key (intInsurancePolicyID, intClaimIndex)
)

create table TInsurancePolicyClaimPayments
(
		intInsurancePolicyID			int					not null,
		intClaimIndex					int					not null,
		intPaymentIndex					int					not null,
		strPaymentDate					datetime			not null,
		intPaymentRecipientID			int					not null,
		monPaymentAmount				money				not null,
		constraint TInsurancePolicyClaimPayments_PK Primary Key (intInsurancePolicyID, intClaimIndex, intPaymentIndex)
)

create table TPaymentRecipients
(
		intPaymentRecipientID			int					not null,
		strFirstName					varchar(50)			not null,
		strLastName						varchar(50)			not null,
		strPhoneNumber					varchar(50)			not null,
		strAddress						varchar(50)			not null,
		constraint TPaymentRecipients_PK Primary Key (intPaymentRecipientID)
)

-- ---------------------------------------------------------------
-- Step #3.2:	Identify and Create Foreign Keys
-- ---------------------------------------------------------------

Alter Table TInsurancePolicies Add Constraint TInsurancePolicies_TInsurancePolicyTypes_FK 
Foreign Key (intInsurancePolicyTypeID) References TInsurancePolicyTypes (intInsurancePolicyTypeID)

Alter Table TInsurancePolicies Add Constraint TInsurancePolicies_TPaymentStatuses_FK 
Foreign Key (intPaymentStatusID) References TPaymentStatuses (intPaymentStatusID)

Alter Table TInsurancePolicies Add Constraint TInsurancePolicies_TSellingAgents_FK 
Foreign Key (intSellingAgentID) References TSellingAgents (intSellingAgentID)

Alter Table TInsurancePolicies Add Constraint TInsurancePolicies_TClients_FK 
Foreign Key (intClientID) References TClients (intClientID)

Alter Table TInsurancePolicyClaims Add Constraint TInsurancePolicyClaims_TInsurancePolicies_FK 
Foreign Key (intInsurancePolicyID) References TInsurancePolicies (intInsurancePolicyID)

--Alter Table TInsurancePolicyClaimPayments Add Constraint TInsurancePolicyClaimPayments_TInsurancePolicyClaims_FK 
--Foreign Key (intClaimIndex) References TInsurancePolicyClaims (intClaimIndex)

Alter Table TInsurancePolicyClaimPayments Add Constraint TInsurancePolicyClaimPayments_TPaymentRecipients_FK 
Foreign Key (intPaymentRecipientID) References TPaymentRecipients (intPaymentRecipientID)