--1.	 Create a view that displays student full name, course name if the student has a grade more than 50. 
SELECT St_Fname + ' ' + ST_Lname AS FULL_NAME , C.Crs_Name 
FROM Student AS S
JOIN Stud_Course AS SC ON S.St_Id = SC.St_Id
JOIN Course AS C ON C.Crs_Id = SC.Crs_Id
WHERE Grade > 50;


--2.	 Create an Encrypted view that displays manager names and the topics they teach. 
CREATE VIEW MT
WITH ENCRYPTION
AS
SELECT I.Ins_Name, T.TOP_Name
FROM Instructor AS I
JOIN Ins_Course AS IC ON I.Ins_Id = IC.Ins_Id
JOIN Course AS C ON C.Crs_Id = IC.Crs_Id
JOIN Topic AS T ON T.Top_Id = C.Top_Id
JOIN Department AS D ON I.Ins_Id = D.Dept_Manager;


--3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
CREATE VIEW IDN
AS
SELECT I.Ins_Name, D.Dept_Name
FROM Instructor AS I
JOIN Department AS D ON I.Dept_Id = D.Dept_Id
WHERE D.Dept_Name IN ('SD' , 'Java');


/*4.	 Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
Note: Prevent the users to run the following query 
Update V1 set st_address=’tanta’
Where st_address=’alex’;
*/
CREATE VIEW V1
AS
SELECT *
FROM Student
WHERE St_Address IN ('Alex' , 'Cairo')
WITH CHECK OPTION;


--5.	Create a view that will display the project name and the number of employees work on it. “Use Company DB”

CREATE VIEW CSD
AS
SELECT P.PNAME , COUNT(W.ESSN) AS EMP_NUM
FROM Company_SD.dbo.PROJECT AS P
JOIN Company_SD.dbo.Works_for AS W ON P.Pnumber = W.PNO
GROUP BY P.PNAME;


/*6.	Create the following schema and transfer the following tables to it 
a.	Company Schema 
i.	Department table (Programmatically)
ii.	Project table (visually)
b.	Human Resource Schema
i.	  Employee table (Programmatically)
*/
create schema Company

alter schema Comapny transfer Department

CREATE SCHEMA HR 

ALTER SCHEMA HR TRANSFER  instructor



--7.	Create index on column (Hiredate) that allow u to cluster the data in table Department. 
--What will happen?


CREATE INDEX Index_Hiredate ON Department (Manager_hiredate);


--8.	Create index that allow u to enter unique ages in student table. What will happen?

CREATE unique INDEX Index_age ON Student (St_Age);

/*The CREATE UNIQUE INDEX statement terminated
because a duplicate key was found for the object name 'dbo.Student' and the index name 'Index_age'.
The duplicate key value is (21).
*/


--10.	Write a query that returns the Student No and Student first name without the last char

SELECT ST_ID , LEFT(ST_FNAME,LEN(ST_FNAME) -1) 
FROM Student;


--11.	Wirte query to delete all grades for the students Located in SD Department 

Delete SC
from Stud_Course AS SC
JOIN STUDENT AS S ON  S.St_Id = SC.St_Id
JOIN Department AS D ON D.Dept_Id = S.Dept_Id
WHERE D.Dept_Name = 'SD';


--12.	Using Merge statement between the following two tables [User ID, Transaction Amount]
CREATE TABLE DAILY_TRANSACTIONS(
NUM int NOT NULL PRIMARY KEY,
CASH INT 
)

CREATE TABLE LAST_TRANSACTIONS(
NUM int NOT NULL PRIMARY KEY,
CASH INT 
)

MERGE INTO DAILY_TRANSACTIONS AS T
USING LAST_TRANSACTIONS AS S
ON T.NUM = S.NUM

WHEN MATCHED THEN
  UPDATE SET T.CASH = S.CASH

WHEN NOT MATCHED BY TARGET THEN
  INSERT (NUM , CASH)
  VALUES (S.NUM, S.CASH)

WHEN NOT MATCHED BY SOURCE THEN
  DELETE

OUTPUT $ACTION, INSERTED.*, DELETED.*;




