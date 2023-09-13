--1.	Retrieve number of students who have a value in their age. 
select COUNT(ST_ID)
FROM Student
WHERE St_Age IS NOT NULL;


--2.	Get all instructors Names without repetition
SELECT DISTINCT ins_name 
FROM Instructor;

--3.	Display student with the following Format (use isNull function)
SELECT ST_id , ISNULL(s.St_Fname,'#') + ' ' + ISNULL(s.St_Lname , '#') AS FULLNAME , Dept_name
FROM Student AS S JOIN Department AS D
ON S.Dept_Id = D.Dept_Id;

/*4.	Display instructor Name and Department Name 
Note: display all the instructors if they are attached to a department or not
*/
SELECT Ins_Name , Dept_Name
FROM Instructor AS I LEFT JOIN Department AS D
ON I.Dept_Id = D.Dept_Id;


/*5.	Display student full name and the name of the course he is taking
For only courses which have a grade  
*/
SELECT ST_FNAME + ' ' +ST_LNAME AS FULL_NAME , CRS_NAME
FROM Student AS S JOIN Stud_Course AS SC
ON S.St_Id = SC.St_Id
JOIN Course AS C
ON SC.Crs_Id = C.Crs_Id
WHERE SC.Grade IS NOT NULL;


--6.	Display number of courses for each topic name
SELECT C.Crs_Name , COUNT(SC.Crs_Id)
FROM Course AS C JOIN Stud_Course AS SC
ON C.Crs_Id = SC.Crs_Id
GROUP BY C.Crs_Name;


--7.	Display max and min salary for instructors
SELECT MIN(SALARY) , MAX(SALARY)
FROM Instructor;

--8.	Display instructors who have salaries less than the average salary of all instructors.
SELECT SALARY 
FROM Instructor
WHERE Salary<(SELECT AVG(Salary)FROM Instructor);

--9.	Display the Department name that contains the instructor who receives the minimum salary.
SELECT Dept_Name 
FROM Department
WHERE Dept_Id =(SELECT Dept_Id FROM Instructor WHERE Salary =(SELECT MIN(SALARY) FROM Instructor ));  --3*1

--10 .Select max two salaries in instructor table. 
SELECT DISTINCT TOP(2) Salary
FROM Instructor
ORDER BY Salary DESC;

--11 .Select instructor name and his salary but if there is no salary display instructor bonus keyword. “use coalesce Function”
SELECT INS_name, COALESCE(salary, 'bonus') AS SalaryOrBonus
FROM Instructor;

--12.	Select Average Salary for instructors 
select AVG(salary)
from Instructor;

--13.	Select Student first name and the data of his supervisor 
select s.st_fname , su.*
from Student as s join Student as su
ON su.St_Id = s.St_super;

--14.	Write a query to select the highest two salaries in Each Department for instructors who have salaries.
--“using one of Ranking Functions”
WITH RankedSalaries AS (
    SELECT
        INS_name,
        Dept_id,
        Salary,
        DENSE_RANK() OVER (PARTITION BY Dept_id ORDER BY Salary DESC) AS SalaryRank
    FROM Instructor
    WHERE Salary IS NOT NULL
)
SELECT INS_name, Dept_id, Salary
FROM RankedSalaries
WHERE SalaryRank <= 2;


--15.	 Write a query to select a random  student from each department.  “using one of Ranking Functions”
WITH RANDOMTABLE AS (
    SELECT St_Fname , 
        ROW_NUMBER() OVER (PARTITION BY Dept_id ORDER BY NEWID()) AS RND
    FROM STUDENT
)
SELECT *
FROM RANDOMTABLE
WHERE RND=1;
