-- ---------------------------------------------------------------
-- Name: Nick Regan
-- Class: IT-111-200
-- Abstract: Homework 9 Join Practice
-- ---------------------------------------------------------------


use dbsql1

drop table TUserFavoriteSongs
drop table TSongs
drop table TUsers

drop table TTeamPlayers
drop table TPlayers
drop table TTeams


-- ---------------------------------------------------------------
-- Step #1.1:	Create Tables
-- ---------------------------------------------------------------

create table TTeams
(
		intTeamID				int					not null,
		strTeam					varchar(50)			not null,
		constraint TTeams_PK Primary Key (intTeamID)
)

create table TPlayers
(
		intPlayerID				int					not null,
		strFirstName			varchar(50)			not null,
		strLastName				varchar(50)			not null,
		constraint TPlayers_PK Primary Key (intPlayerID)
)

create table TTeamPlayers
(
		intTeamID				int					not null,
		intPlayerID				int					not null,
		constraint TTeamPlayers_PK Primary Key (intTeamID, intPlayerID)
)

-- ---------------------------------------------------------------
-- Step #1.2:	Identify and Create Foreign Keys
-- ---------------------------------------------------------------

Alter Table TTeamPlayers Add Constraint TTeamPlayers_TTeams_FK 
Foreign Key (intTeamID) References TTeams (intTeamID)

Alter Table TTeamPlayers Add Constraint TTeamPlayers_TPlayers_FK 
Foreign Key (intPlayerID) References TPlayers (intPlayerID)

-- ---------------------------------------------------------------
-- Step #1.3:	Add Sample Data
-- ---------------------------------------------------------------

insert into TTeams (intTeamID, strTeam)
values	(1, 'Bengals'),
		(2, 'Browns')

insert into TPlayers (intPlayerID, strFirstName, strLastName)
values	(1, 'Nick', 'Regan'),
		(2, 'Hailey', 'Bollinger')

insert into TTeamPlayers (intTeamID, intPlayerID)
values	(1, 1),
		(2, 2)

-- ---------------------------------------------------------------
-- Step #1.4:	Write Joins
-- ---------------------------------------------------------------

Select
	TT.intTeamID							as "TeamID",
	TT.strTeam								as "Team",
	TP.intPlayerID							as "PlayerID",
	TP.strLastName + ', ' + TP.strFirstName as "Player Name"

From
	TTeams				as		TT,
	TTeamPlayers		as		TTP,
	TPlayers			as		TP

Where
	TT.intTeamID = TTP.intTeamID and
	TTP.intPlayerID = TP.intPlayerID

Order by
	TT.strTeam




-- ---------------------------------------------------------------
-- Step #2.1:	Create Tables
-- ---------------------------------------------------------------

create table TUsers
(
		intUserID				int					not null,
		strFirstName			varchar(50)			not null,
		strLastName				varchar(50)			not null,
		strEmailAddress			varchar(50)			not null,
		constraint TUsers_PK Primary Key (intUserID)
)

create table TSongs
(
		intSongID				int					not null,
		strSongName				varchar(50)			not null,
		strSongArtist			varchar(50)			not null,
		constraint TSongs_PK Primary Key (intSongID)
)

create table TUserFavoriteSongs
(
		intFavoriteSongID		int					not null,
		intUserID				int					not null,
		intSongID				int					not null,
		constraint TUserFavoriteSongs_PK Primary Key (intFavoriteSongID)
)

-- ---------------------------------------------------------------
-- Step #2.2:	Identify and Create Foreign Keys
-- ---------------------------------------------------------------

Alter Table TUserFavoriteSongs Add Constraint TUserFavoriteSongs_TUsers_FK 
Foreign Key (intUserID) References TUsers (intUserID)

Alter Table TUserFavoriteSongs Add Constraint TUserFavoriteSongs_TSongs_FK 
Foreign Key (intSongID) References TSongs (intSongID)

-- ---------------------------------------------------------------
-- Step #2.3:	Add Sample Data
-- ---------------------------------------------------------------

insert into TUsers (intUserID, strFirstName, strLastName, strEmailAddress)
values	(1, 'Dennis', 'Reynolds', 'DRen@gmail.com'),
		(2, 'Charlie', 'Kelly', 'RatKing@gmail.com')

insert into TSongs (intSongID, strSongName, strSongArtist)
values	(1, 'Because I Got High', 'Afroman'),
		(2, 'Three Little Birds', 'Bob Marley')

insert into TUserFavoriteSongs (intFavoriteSongID, intUserID, intSongID)
values	(1, 1, 1),
		(2, 2, 2)

-- ---------------------------------------------------------------
-- Step #2.4:	Write Join That Shows Favorite Songs of All Users
-- ---------------------------------------------------------------

Select
	TU.intUserID	as "UserID",
	TU.strFirstName + ', ' + TU.strLastName		as "User Name",
	TS.strSongName + ' by ' + TS.strSongArtist	as "Favorite Song"

From
	TUsers					as		TU,
	TSongs					as		TS,
	TUserFavoriteSongs		as		TUFS

Where
	TU.intUserID = TUFS.intUserID and
	TUFS.intSongID = TS.intSongID

Order By
	TU.intUserID




