create database lab4
go
use LAB2Inserturile
Go




--check an integer number
create function checkInteger(@n int)
returns int as
begin
	declare @number int
	if @n>1 and @n<=1000
		set @number=1
	else
		set @number=0
	return @number
end 
go

--checks if a variable has atleast 2 letters
create function checkVarchar(@v varchar(50))
returns bit as
begin
	declare @b bit
		if @v LIKE '[a-z]%[a-z]'
			set @b=1
		else
			set @b=0
	return @b
end
go

create procedure addInTeam   @team_Name varchar(50), @trophy_Number int,@stadium_Name varchar(50),@players_Number int
as
		Begin
		if dbo.checkInteger(@trophy_Number)=1 and dbo.checkVarchar(@team_Name)=1
			Begin
				Insert into TEAM(Team_Name,Trophies_Number,Stadium_Name,Players_Number) Values (@team_Name,@trophy_Number,@stadium_Name,@players_Number)
				print 'Values added in Team'
				select * from TEAM
			End
		else 
			Begin
				print 'Parameters are not correct'
				select * from TEAM
			End
		End
go
exec addInTeam 'Chelsea',33,'The Bridge',26

go
create procedure addInPlayer @first_Name VARCHAR(50) , @last_Name VARCHAR(60) ,@birth_Date DATETIME ,@number INT
as
	Begin
		if dbo.checkInteger(@number)=1 and dbo.checkVarchar(@first_Name)=1 and dbo.checkVarchar(@last_Name)=1
			begin
				DECLARE @team_Id INT
				SELECT TOP 1 @team_Id=Team_ID FROM TEAM
				SET @team_Id=(SELECT TOP 1 Team_ID FROM TEAM)
				insert into PLAYER(First_Name,Last_Name,Birth_Date,Number,Team_ID) values (@first_Name,@last_Name,@birth_Date,@number,@team_Id)
				print 'values were introduced in player'
				select * from PLAYER
			end
		else 
			begin
				print 'parameters are not correct'
				select * from PLAYER
			end
	End
go


exec addInPlayer 'Carlo',Davies,'19981210 10:35:05 AM',19
select * from PLAYER


--2. view with 4 tables

--show a table with Id of a game , first name of player , his team and id of a staff member

go
create view viewAll
as
	Select g.Game_Id,p.First_Name,t.Team_Name,s.Staff_ID
	from STAFF_MEMBERS s inner join TEAM t on s.Team_ID=t.Team_ID
	inner join PLAYER p on p.Team_ID=t.Team_ID
	inner join GAMES g on g.Player_ID=p.Player_ID
	where Home_Goals>=0
go

select * from viewAll

create table Logs(
TriggerDate date,
TriggerType varchar(50),
NameAffectedTable varchar(50),
NoAMDRows int)

select * from Logs

go

create  trigger Insert_Team ON TEAM for insert as
begin
	 insert into Logs(TriggerDate, TriggerType,NameAffectedTable, NoAMDRows)
	values (GETDATE(), 'INSERT', 'TEAM', @@ROWCOUNT)
	
end
go

go

create or alter trigger Delete_Team ON TEAM for delete as
begin
	 insert into Logs(TriggerDate, TriggerType,NameAffectedTable, NoAMDRows)
	values (GETDATE(), 'DELETE', 'TEAM', @@ROWCOUNT)
	
end
go

go
create or alter trigger Update_Team ON TEAM for update as
begin
	
	 insert into Logs(TriggerDate, TriggerType,NameAffectedTable, NoAMDRows)
	values (GETDATE(), 'UPDATE', 'TEAM', @@ROWCOUNT)
	
end
go

SELECT * FROM TEAM

INSERT INTO TEAM VALUES('Guadalajara',19,'Ciudad',25)

UPDATE TEAM
SET Players_Number =33
WHERE Trophies_Number>=70 AND Trophies_Number<95


DELETE FROM TEAM
WHERE Trophies_Number<0


DELETE FROM TEAM 
WHERE  Stadium_Name LIKE'%Shesb'

DELETE FROM TEAM 
WHERE  Stadium_Name LIKE'%Arena'

DELETE FROM TEAM
WHERE Team_ID=23
SELECT * FROM TEAM
SELECT * FROM PLAYER


--INDEXES

SELECT * FROM PLAYER

IF EXISTS (SELECT name FROM sys.indexes WHERE NAME='index_PLAYER_NUMBER')
DROP INDEX index_PLAYER_NUMBER ON PLAYER
GO

--create a non clustered index
CREATE NONCLUSTERED INDEX index_PLAYER_NUMBER ON PLAYER(Number)
GO
SELECT * FROM PLAYER ORDER BY Number

SELECT * FROM PLAYER 
WHERE NUMBER>10 AND Player_ID<15

--SECOND 
CREATE NONCLUSTERED INDEX index_Of_Number_Of_Players_In_A_Team on TEAM(Players_Number)
GO
SELECT Players_Number from TEAM where Players_Number=26


SELECT * FROM TEAM 
WHERE Trophies_Number>6
ORDER BY Players_Number

--SELECT USING INNER JOIN AND ORDER BY 
--obtain the average of players number in a team
SELECT  T.Team_ID ,AVG(P.Number)AS Average_of_Players_Number
FROM TEAM T INNER JOIN PLAYER P ON T.Team_ID=P.Team_ID  
Group by T.Team_ID
HAVING AVG(P.Team_ID)>5
ORDER BY Team_ID