-- Part 1 Airline
-- From The Previous Assignment insert at least 2 rows per table. 

INSERT INTO Aircraft
VALUES (200,'Boeing 707','Ahmed','Hoda','Ramy','Amr',NULL) , 
(505,'Airbus A320','Khalid','Samy','Mohamed','Waleed',NULL)

INSERT INTO Airline
VALUES ('EGY Airlines','Cairo','Ahmed') ,
('Spain Airlines','Madrid','Paolo')

INSERT INTO Airline_PHONES
VALUES (1, 01010101) , 
(11, 1231233)

INSERT INTO Transaction1
VALUES (987,'Purchased', 950, '2024-01-01',1) ,
(988,'Purchased 2', 1000, '2023-01-01',11)

INSERT INTO Employee
VALUES ('Mohamed Abotrika', 'Cairo', 'M', 'Pilot', '2013-11-30',1),
('Mohamed Ali', 'USA', 'M', 'Host 1', '2020-11-30',11)

INSERT INTO Route
VALUES (7001 , 3000 , 'Japan', 'Egypt' , 'First Class') ,
(7002 , 3500 , 'USA', 'Egypt' , 'Second Class')

INSERT INTO Aircraft_Route
VALUES (31,7001,'2024-05-18 18:00:00',NULL,NULL,'2024-05-18 18:00:00') ,
(41,7002,'2020-05-18 18:00:00',NULL,NULL,'2024-05-18 18:00:00')

INSERT INTO EMP_Qualifications
VALUES (1,'3 YEARS PILOT'),
(1001,'7 YEARS PILOT')


-- Data Manipulating Language 
-- 1.Insert your personal data to the student table as a new Student in department number 30.
INSERT INTO Student 
VALUES (99,'Omar','Khalid',NULL,19,30,NULL)
-- 2.Insert Instructor with personal data of your friend as new Instructor in department number 30, Salary= 4000, but don’t enter any value for bonus.
INSERT INTO Instructor
VALUES (707,'Zyad',NULL,4000,30)
-- 3.Upgrade Instructor salary by 20 % of its last value.
UPDATE Instructor
SET Salary = Salary * 1.2 
WHERe Ins_ID = 707 

-- Part 2
-- Display all the employees Data.
select *
from Employee
-- Display the employee First name, last name, Salary and Department number.
SELECT FNAME , LNAME , SALARY , DNO
FROM Employee
-- Display all the projects names, locations and the department which is responsible for it.
SELECT PNAME , PLOCATION , DNUM
FROM PROJECT
-- If you know that the company policy is to pay an annual commission for each employee with specific percent equals 10% of his/her annual salary .Display each employee full name and his annual commission in an ANNUAL COMM column (alias).
SELECT CONCAT (FNAME, ' ',LNAME) AS FULLNAME , SALARY * 0.1 AS ANNUAL_COMM
FROM Employee
-- Display the employees Id, name who earns more than 1000 LE monthly.
SELECT CONCAT (FNAME, ' ',LNAME) AS FULLNAME , SSN 
FROM Employee
WHERE SALARY > 1000
-- Display the employees Id, name who earns more than 10000 LE annually.
SELECT CONCAT (FNAME, ' ',LNAME) AS FULLNAME , SSN 
FROM Employee
WHERE SALARY*12 > 10000
-- Display the names and salaries of the female employees 
SELECT CONCAT (FNAME, ' ',LNAME) AS FULLNAME , SALARY
FROM EMPLOYEE
WHERE SEX = 'F'
-- Display each department id, name which is managed by a manager with id equals 968574.
SELECT DNUM , DNAME 
FROM Departments
WHERE MGRSSN = 968574
-- Display the ids, names and locations of  the projects which are controlled with department 10.
SELECT PNAME , PNAME , PLOCATION 
FROM PROJECT
WHERE DNUM = 10

-- Part 3
-- Get all instructors Names without repetition
SELECT DISTINCT Ins_Name
FROM Instructor

-- Display instructor Name and Department Name 
--       Note: display all the instructors if they are attached to a department or not
SELECT I.Ins_Name, D.Dept_Name
FROM Instructor I LEFT OUTER JOIN Department D
ON I.Dept_Id = D.Dept_Id
-- Display student full name and the name of the course he is taking For only courses which have a grade  
SELECT CONCAT(S.ST_FNAME,' ',S.ST_LNAME) AS FULLNAME , C.CRS_NAME
FROM STUDENT S INNER JOIN Stud_Course SC 
ON S.ST_ID = SC.ST_ID JOIN COURSE C ON C.CRS_ID = SC.CRS_ID
WHERE SC.GRADE IS NOT NULL
-- Display results of the following two statements and explain what is the meaning of @@AnyExpression
-- select @@VERSION
-- select @@SERVERNAME

-- @@ is a global variable and it returns : 
select @@VERSION -- Returns the SQL Server version
select @@SERVERNAME -- Returns the name of the server running SQL Server

-- Part 4
-- Using MyCompany Database and try to  create the following Queries:
-- Display the Department id, name and id and the name of its manager.
SELECT D.Dnum, D.Dname, E.SSN AS Manager_ID, CONCAT(E.Fname, ' ', E.Lname) AS FULLNAME
FROM Departments D INNER JOIN EMPLOYEE E
ON D.MGRSSN = E.SSN
-- Display the name of the departments and the name of the projects under its control.
SELECT D.Dname, P.Pname
FROM Departments D LEFT JOIN Project P 
ON D.Dnum = P.Dnum
-- Display the full data about all the dependence associated with the name of the employee they depend on .
SELECT D.Dependent_name, D.*, CONCAT(E.Fname, ' ', E.Lname) AS FULLNAME
FROM Dependent D INNER JOIN Employee E 
ON D.ESSN = E.SSN
-- Display the Id, name and location of the projects in Cairo or Alex city.
SELECT Pnumber, Pname, Plocation
FROM Project
WHERE City IN ('Cairo', 'Alex')
-- Display the Projects full data of the projects with a name starting with "a" letter.
SELECT *
FROM Project
WHERE Pname LIKE 'A%'
-- display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
SELECT SSN, FNAME, LNAME, SALARY
FROM EMPLOYEE
WHERE DNO = 30 AND SALARY <= 2000 AND SALARY >= 1000

-- Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.

SELECT E.Fname, E.Lname
FROM Employee E INNER JOIN Works_for W 
ON E.SSN = W.ESSN INNER JOIN Project P ON W.Pno = P.Pnumber
WHERE E.Dno = 10 AND P.Pname = 'AL Rabwah' AND W.Hours >= 10

-- Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
SELECT E.Fname, E.Lname, P.Pname
FROM Employee E INNER JOIN Works_for W 
ON E.SSN = W.ESSN INNER JOIN Project P 
ON W.Pno = P.Pnumber
ORDER BY P.Pname

-- For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
SELECT P.Pnumber, D.Dname, E.Lname, E.Address, E.Bdate
FROM Project P INNER JOIN Departments D 
ON P.Dnum = D.Dnum INNER JOIN Employee E 
ON D.MGRSSN = E.SSN
WHERE P.City = 'Cairo'