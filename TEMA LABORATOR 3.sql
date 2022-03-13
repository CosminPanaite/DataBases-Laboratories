GO
USE TemaLaborator2
GO

--CREATE THE TABLE OF VERSIONS
CREATE TABLE VERSIONS (Version INT,
Command_previous varchar(30), Command_next varchar(30)
)
INSERT INTO VERSIONS(Version, Command_previous, Command_next) VALUES(0, 'none', 'do_procedure_1')

-- stored procedure for adding a column
select * from VERSIONS

create procedure do_procedure_1
as
	ALTER Table Player
	ADD Age int
	INSERT INTO VERSIONS (Version, Command_previous, Command_next) VALUES (1,'undo_procedure_1','do_procedure_2') 

go

-- stored procedure for removing a column
create procedure undo_procedure_1
as
	ALTER TABLE Player
	DROP COLUMN Age
	DELETE FROM VERSIONS WHERE  Version >= ALL(SELECT Version FROM VERSIONS)

go

--stored procedure for adding a column with default constraint IN STAFF MEMBERS
create procedure do_procedure_2
as
	alter table STAFF_MEMBERS
	add constraint df_2 default 2
	for Attribute_Number
	INSERT INTO VERSIONS (Version, Command_previous, Command_next) VALUES (2,'undo_procedure_2','do_procedure_3') 

go

--stored procedure for removing the default constraint from a column from TABLE STAFF MEMBERS
create procedure undo_procedure_2
as
	alter table STAFF_MEMBERS
	drop constraint df_2;
	
	DELETE FROM VERSIONS WHERE  Version >= ALL(SELECT Version FROM VERSIONS)

go

-- procedure for adding a foreign key to an existing table


	
	
alter procedure do_procedure_3
as
	Alter table Team add   Agent_Id Int
	Alter table Team
	add constraint fk__Agent_ID foreign key(Agent_Id) references Player(Player_ID) 
	INSERT INTO VERSIONS (Version, Command_previous, Command_next) VALUES (3,'undo_procedure_3','do_procedure_4') 

go

-- procedure for removing a foreign key constraint
alter procedure undo_procedure_3
as
	alter table Team
	
	drop constraint fk__Agent_Id;
	alter table Team
	drop column Agent_Id
	DELETE FROM VERSIONS WHERE  Version >= ALL(SELECT Version FROM VERSIONS)

go
select * from VERSIONS
exec undo_procedure_1
exec undo_procedure_2
exec undo_procedure_3

create procedure do_procedure_4
as
	CREATE TABLE Tournament (
	T_ID INT NOT NULL,
	Name varchar(30),
	Games INT NOT NULL
	)
	INSERT INTO VERSIONS (Version, Command_previous, Command_next) VALUES (4,'undo_procedure_4','-') 

go


create procedure undo_procedure_4

as
	DROP TABLE Tournament
	DELETE FROM VERSIONS WHERE  Version >= ALL(SELECT Version FROM VERSIONS)
go


delete from VERSIONS
DROP TABLE Tournament

 Create PROCEDURE Main(@Version INT)
 AS
	DECLARE @current_version INT = 0
	SET @current_version = (SELECT Version FROM VERSIONS WHERE  Version >= ALL(SELECT Version FROM VERSIONS))
	
	IF @Version >= 5
			BEGIN 
				RAISERROR('The version should be less than 5', 10, 1)
			END
	else BEGIN 
	DECLARE @string varchar(30) = ''
	if( @current_version = @Version)
		BEGIN
			PRINT 'The database is already at version '
			PRINT @Version
		END
	else BEGIN
		if( @current_version > @Version)
			BEGIN
				WHILE(@current_version > @Version )	
				BEGIN
					SET @string = (SELECT Command_previous FROM VERSIONS WHERE Version=@current_version)
					EXEC @string
					SET @current_version = (SELECT Version FROM VERSIONS WHERE  Version >= ALL(SELECT Version FROM VERSIONS))
				END
				PRINT 'The database is now at version '
				PRINT @current_version
			END
		else
			BEGIN
				WHILE(@current_version < @Version )	
				BEGIN
					SET @string = (SELECT Command_next FROM VERSIONS WHERE Version=@current_version)
					EXEC @string
					SET @current_version = (SELECT Version FROM VERSIONS WHERE  Version >= ALL(SELECT Version FROM VERSIONS))
				END
				PRINT 'The database is now at version '
				PRINT @current_version
			END
	END
	END
 GO

 Select * from VERSIONS
 select * from GAMES
 select * from TEAM
use TemaLaborator2

 exec Main 0