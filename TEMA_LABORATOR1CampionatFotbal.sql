CREATE DATABASE TemaLaborator1
GO
USE TemaLaborator1	

CREATE TABLE TEAM
(
	Team_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Team_Name VARCHAR(50) NOT NULL,
	Trophy_Number INT NOT NULL,
	Stadium_Name VARCHAR(30) NOT NULL,
	Player_Number INT NOT NULL CHECK( Player_Number>0 AND Player_Number<42),
	

)

CREATE TABLE PLAYER 
(
	Player_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	First_Name VARCHAR(50) NOT NULL,
	Last_Name VARCHAR(60) NOT NULL,
	Birth_Date DATETIME NOT NULL,
	Number INT NOT NULL,
	Team_ID INT NOT NULL , 
	CONSTRAINT FK_Team_ID FOREIGN KEY (Team_ID )REFERENCES TEAM(Team_ID)
	)

CREATE TABLE GAMES
(
Game_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Home_Goals INT NOT NULL CHECK( Home_Goals >=0 AND Home_Goals <10),
Away_Goals INT NOT NULL CHECK (Away_Goals>=0 AND Away_Goals<10),
Attendance BIGINT NOT NULL,
)
CREATE TABLE FANS
(
Fans_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Tiket_Value MONEY NOT NULL,
Stadium_Place BIGINT NOT NULL CHECK(Stadium_Place>0 AND Stadium_Place<100000) 
)
CREATE TABLE VISUALISATIONS
(
Game_ID INT NOT NULL FOREIGN KEY REFERENCES GAMES(Game_ID),
Fans_ID INT NOT NULL FOREIGN KEY REFERENCES FANS(Fans_ID),
CONSTRAINT PK_VISUALISATIONS PRIMARY KEY(Game_ID,Fans_ID)

)
ALTER TABLE GAMES
ADD  Player_ID INT NOT NULL FOREIGN KEY REFERENCES PLAYER(Player_ID)

CREATE TABLE STAFF_MEMBERS
(
Staff_ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
First_Name VARCHAR(45) NOT NULL,
Last_Name VARCHAR (50) NOT NULL,
Team_Role VARCHAR(40) NOT NULL,
Attribute_Number SMALLINT NOT NULL,
Wage MONEY NOT NULL,
Team_ID INT NOT NULL , 
	CONSTRAINT FK_Team_ID1 FOREIGN KEY (Team_ID )REFERENCES TEAM(Team_ID)
)

ALTER TABLE PLAYER


select * from PLAYER