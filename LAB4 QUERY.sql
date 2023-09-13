/*1.	Display (Using Union Function)
a.	 The name and the gender of the dependence that's gender is Female and depending on Female Employee.
b.	 And the male dependence that depends on Male Employee.
*/
SELECT Dependent_name, sex 
FROM Dependent 
WHERE ESSN IN (
    SELECT ssn FROM Employee WHERE Sex = 'F'
)
UNION 
SELECT Dependent_name, sex 
FROM Dependent 
WHERE ESSN IN (
    SELECT ssn FROM Employee WHERE Sex = 'M'
);

--2.	For each project, list the project name and the total hours per week (for all employees) spent on that project.
SELECT Pname , sum(Hours)
FROM Project JOIN Works_for ON Pnumber = Pno
GROUP BY Pname

--3.	Display the data of the department which has the smallest employee ID over all employees' ID.
SELECT *  
FROM Departments 
where Dnum = (SELECT Dno from Employee 
where SSN = (SELECT MIN(SSN) FROM Employee)         --3*1 query

--4.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.

SELECT Dname , MAX(Salary) , MIN(Salary)
from Departments JOIN Employee
ON Dnum = Dno
Group by Dname;

--5.	List the full name of all managers who have no dependents.
SELECT Fname + ' ' + Lname AS FULLNAME 
FROM Employee join Departments
ON SSN = MGRSSN
where SSN NOT IN 
(SELECT ESSN FROM Dependent)


/*6.	For each department-- if its average salary is less than the average salary of all employees
-- display its number, name and number of its employees.*/

SELECT Dnum , Dname , COUNT(SSN)
FROM Departments join Employee
ON Dnum = Dno
GROUP BY Dname , Dnum 
HAVING AVG(Salary) >
(SELECT AVG(SALARY) FROM Employee)


/*7.	Retrieve a list of employees names and the projects names they are working on ordered by department number 
and within each department,ordered alphabetically by last name, first name.
*/
SELECT Fname , Pname 
FROM Employee 
JOIN Works_for ON SSN = ESSn
JOIN Project ON Pnumber = Pno
ORDER BY Dno , Lname , Fname


--8.	Try to get the max 2 salaries using subquery
SELECT Salary
FROM Employee
WHERE Salary IN (
    SELECT TOP(2) Salary
    FROM Employee
    ORDER BY Salary DESC
);

--9.	Get the full name of employees that is similar to any dependent name
SELECT Fname + ' ' + Lname AS FULL_NAME
FROM Employee
WHERE Fname + ' ' + Lname IN
(SELECT Dependent_name FROM Dependent)

--10.	Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.

SELECT Fname, SSN
FROM Employee
WHERE EXISTS (
    SELECT NULL
    FROM Dependent Join Employee
    ON ESSN = SSN );

/*11.	In the department table insert new department called "DEPT IT" , with id 100
, employee with SSN = 112233 as a manager for this department.The start date for this manager is '1-11-2006'*/

INSERT INTO Departments 
VALUES('DEPT IT' ,100 , 112233 ,'1-11-2006')

/*12.	Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100), 
and they give you(your SSN =102672) her position (Dept. 20 manager) 

a.	First try to update her record in the department table
b.	Update your record to be department 20 manager.
c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
*/
UPDATE Departments
SET MGRSSN = 968574
WHERE Dnum = 100;

UPDATE Departments
SET MGRSSN = 102672
WHERE Dnum = 20;

UPDATE Employee
SET Superssn = 102672
WHERE SSN = 102660;


 
/*13.	Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) 
so try to delete his data from your database in case you know that you will be temporarily in his position.
Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handle these cases).
*/
UPDATE Departments
SET MGRSSN = 102672
WHERE MGRSSN=223344;


UPDATE Employee
SET Superssn = 102672
WHERE Superssn=223344;


DELETE FROM Works_for 
WHERE ESSn = 223344;

DELETE FROM Dependent 
WHERE ESSN = 223344;

DELETE FROM Employee 
WHERE SSN = 223344;


--14.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
Update Employee
SET Salary = Salary*1.3
WHERE SSN IN 
(SELECT ESSN 
FROM Works_for JOIN Project
ON Pnumber = Pno
WHERE Pname = 'Al Rabwah');


