--1.	Create a stored procedure to show the number of students per department.[use ITI DB] 
USE [ITI]

CREATE PROC NUM_OF_ST 
AS
    SELECT COUNT(*) , Dept_Id
    FROM Student
    GROUP BY Dept_Id


/*2.	Create a stored procedure that will check for the # of employees in the project p1 
if they are more than 3 print message to the user “'The number of employees in the project p1 is 3 or more'” 
if they are less display a message to the user “'The following employees work for the project p1'” 
in addition to the first name and last name of each one. [Company DB] 
*/

USE [Company_SD]

CREATE PROC NUMB_OF_EMP @PROJ_NAME VARCHAR(20)
AS
   DECLARE @NUMB INT =( SELECT COUNT(*) FROM Employee AS E JOIN Works_for AS W ON E.SSN = W.ESSn
   JOIN Project AS P ON P.Pnumber = W.Pno WHERE P.Pname = @PROJ_NAME)
   IF @NUMB >= 3
      SELECT 'The number of employees in the project '+ @PROJ_NAME +' is 3 or more'
   ELSE   
      SELECT 'The following employees work for the project '+@PROJ_NAME + Fname ,Lname  FROM Employee

NUMB_OF_EMP 'Al Rowad'



/*3.	Create a stored procedure that will be used in case 
there is an old employee has left the project and a new one become instead of him. 
The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) 
and it will be used to update works_on table. [Company DB]
*/
USE [Company_SD]

CREATE PROC REPLACE @OLD_EMP_NUM INT , @NEW_EMP_NUM INT , @PROJ_NUM INT
AS 
   UPDATE Works_for
   SET ESSn = @NEW_EMP_NUM
   WHERE ESSn = @OLD_EMP_NUM AND Pno = @PROJ_NUM


/*4.	Create an Audit table with the following structure 
ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
p2 	Dbo 	2008-01-31	95000 	200000 

This table will be used to audit the update trials on the Budget column (Project table, Company DB)
Example:
If a user updated the budget column then the project number, user name that made that update, 
the date of the modification and the value of the old and the new budget will be inserted into the Audit table
Note: This process will take place only if the user updated the budget column
*/
USE [Company_SD]

CREATE TABLE AUDIT(
ProjectNo int ,
UserName Varchar(20),
ModifiedDate datetime,
old_dnum int,
new_dnum int
)

CREATE TRIGGER t4
ON Project
AFTER UPDATE
AS
BEGIN
   INSERT INTO AUDIT (ProjectNO, UserName, ModifiedDate, Old_dnum, New_dnum)
   SELECT i.Pnumber, SUSER_NAME(), GETDATE(), d.dnum AS old_dnum, i.dnum AS new_dnum
   FROM inserted AS i
   INNER JOIN deleted AS d ON i.Pnumber = d.Pnumber;
END;



/*5.	Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
“Print a message for user to tell him that he can’t insert a new record in that table”
*/
USE [ITI]

CREATE TRIGGER t5
ON Department
instead of Insert
AS
BEGIN
   select 'you cant insert a new record in that table'
END;



--6.	 Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
USE [Company_SD]

CREATE TRIGGER t6
ON Employee
instead of Insert
AS
BEGIN
  
  IF MONTH(GETDATE()) = 3
     select 'you can not'
  else 
     insert into Employee
	 SELECT * FROM inserted

END;



/*7.Create a trigger on student table after insert to add Row in Student Audit table 
(Server User Name , Date, Note) where note will be 
“[username] Insert New Row with Key=[Key Value] in table [table name]”
*/
USE [ITI]

CREATE TABLE ST_AUDIT(
SERVER_UserName Varchar(20),
DATEE datetime,
NOTE VARCHAR(60)
)

CREATE TRIGGER t7
ON Student
AFTER Insert
AS
BEGIN
   INSERT INTO ST_AUDIT
   VALUES(SUSER_NAME(),GETDATE(),  SUSER_NAME()+' Insert New Row with Key= '+ (SELECT ST_ID FROM inserted) +' in table Student')
END;



/*8.Create a trigger on student table instead of delete to add Row in Student Audit table 
(Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”
*/
USE[ITI]


CREATE TRIGGER t8
ON Student
Instead of delete
AS
BEGIN
   INSERT INTO ST_AUDIT
   VALUES(SUSER_NAME(),GETDATE(),  SUSER_NAME()+' try to delete Row with Key= '+ (SELECT ST_ID FROM inserted))
END;

