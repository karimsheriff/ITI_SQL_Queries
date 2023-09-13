--1.	Display the Department id, name and id and the name of its manager.
select Dnum,Dname,MGRSSN,Fname AS manager_name
from Departments JOIN Employee
ON Employee.SSN = Departments.MGRSSN;

--2.	Display the name of the departments and the name of the projects under its control.
select Dname,Pname
from Departments JOIN Project
ON Departments.Dnum=Project.Dnum;

--3.	Display the full data about all the dependence associated with the name of the employee they depend on him/her.
select ESSN,Dependent_name,d.sex,d.Bdate,E.Fname
from Dependent as D left join Employee as E
ON e.SSN = d.ESSN;

--4.	Display the Id, name and location of the projects in Cairo or Alex city.
select Pnumber,Pname,Plocation 
from Project
where  City in ('Alex','cairo');


--5.	Display the Projects full data of the projects with a name starts with "a" letter.
select *
from Project
where Pname LIKE 'a%';


--6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select * 
from Employee
where Salary between 1000 and 2000;

--7.	Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
select E.Fname 
FROM Employee AS E 
JOIN Works_for AS W ON E.SSN = W.ESSn
JOIN Project AS P ON W.Pno = P.Pnumber
where Dno=10 
AND Hours >=10
AND Pname='AL Rabwah';

--8.	Find the names of the employees who directly supervised with Kamel Mohamed.
select e.Fname
from Employee as e join Employee as s
ON s.SSN = e.Superssn
where s.Fname='Kamel'AND s.Lname='Mohamed';

--9.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select e.Fname,p.Pname
from Employee AS e
left join Works_for AS w ON e.SSN = w.ESSn
join Project AS p ON p.Pnumber = W.Pno
ORDER BY p.Pname; 

--10.	For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
select P.Pnumber , D.Dname , E.Lname , E.Address , E.Bdate
FROM Project AS P
JOIN Departments AS D ON D.Dnum =P.Dnum
JOIN Employee AS E ON D.MGRSSN = E.SSN
WHERE P.City = 'Cairo';

--11.	Display All Data of the managers
select * from Employee
join Departments ON Employee.SSN = Departments.MGRSSN;


--12.	Display All Employees data and the data of their dependents even if they have no dependents
select *
FROM Employee AS E
LEFT JOIN Dependent AS D ON E.SSN = D.ESSn

--13.	Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
INSERT INTO Employee (SSN, Fname, Lname, Dno, Superssn, Salary)
VALUES (102672, 'Karim', 'Taha', 30, 112233, 3000);

--14.	Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or supervisor number to him.
INSERT INTO Employee (SSN, Fname, Lname, Dno)
VALUES (102660, 'Karim', 'Sherif', 30);

--15.	Upgrade your salary by 20 % of its last value.
UPDATE Employee
SET Salary = Salary * 1.2
WHERE SSN = 102672;



