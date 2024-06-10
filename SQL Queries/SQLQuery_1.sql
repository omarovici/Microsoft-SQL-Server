-- Part 1
-- Retrieve a number of students who have a value in their age. 
SELECT COUNT(St_Age)
FROM STUDENT
-- Display number of courses for each topic name 
SELECT T.TOP_NAME , COUNT(C.Crs_Id)
FROM TOPIC T INNER JOIN COURSE C
ON T.TOP_ID = C.TOP_ID 
GROUP BY T.TOP_NAME
-- Select Student first name and the data of his supervisor 
SELECT S.St_Fname , M.*
FROM STUDENT S , STUDENT M
WHERE S.St_super = M.St_Id
-- Display student with the following Format (use isNull function)
SELECT ISNULL(S.St_Id,'0000') AS StudentID, 
ISNULL(CONCAT(S.St_Fname,' ',S.St_Lname),'Name not found') AS FullName ,
ISNULL(D.Dept_Name,'First name not found') AS DepartmentName
FROM Student S , Department D
WHERE S.Dept_Id = D.Dept_Id
-- Select instructor name and his salary but if there is no salary display value ‘0000’ . “use one of Null Function” 
SELECT Ins_Name , ISNULL(Salary,'0000')
FROM INSTRUCTOR 
-- Select Supervisor first name and the count of students who supervises on them
SELECT M.St_Fname , COUNT(S.St_Id) AS STUNDENT_CONT
FROM STUDENT S , STUDENT M
WHERE S.St_super = M.St_Id
GROUP BY M.St_Fname
-- Display max and min salary for instructors
SELECT MAX(Salary) AS INS_MAX_SALARY , MIN(Salary) AS INS_MIN_SALARY
FROM INSTRUCTOR
-- Select Average Salary for instructors 
SELECT AVG(SALARY) AS AVG_SALARY
FROM INSTRUCTOR

-- Part 2
-- DQL
-- For each project, list the project name and the total hours per week (for all employees) spent on that project.
SELECT P.Pname , SUM(W.[Hours])
FROM PROJECT P INNER JOIN WORKS_FOR W 
ON P.Pnumber = W.PNO INNER JOIN Employee E 
ON E.SSN = W.ESSN
GROUP BY P.Pname
-- For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
SELECT D.DNAME , MAX(E.Salary) AS MAX , MIN(E.Salary) AS MIN , AVG(E.Salary) AS AVG
FROM DEPARTMENTS D , EMPLOYEE E 
WHERE D.DNUM = E.Dno
GROUP BY D.DNAME 
-- Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name.
SELECT D.DNAME , E.Fname , E.Lname, P.Pname
FROM EMPLOYEE E INNER JOIN WORKS_FOR W 
ON E.SSN = W.ESSN  INNER JOIN Project P 
ON P.Pnumber = W.Pno INNER JOIN DEPARTMENTS D
ON D.DNUM = E.DNO
ORDER BY D.DNAME , E.Lname , E.Fname
-- Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
UPDATE E
SET E.SALARY = E.Salary * 1.30 
FROM EMPLOYEE E INNER JOIN WORKS_FOR W 
ON E.SSN = W.ESSN  INNER JOIN Project P 
ON P.Pnumber = W.Pno
WHERE P.PNAME = 'Al Rabwah' 
-- DML
-- In the department table insert a new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'.
INSERT INTO Departments 
VALUES ('DEPT IT',100,112233,'1-11-2006')
-- Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager) 
-- First try to update her record in the department table
UPDATE Employee
SET DNO = 100 
WHERE SSN = 968574 

UPDATE DEPARTMENTS
SET MGRSSN = 968574
WHERE DNUM = 100
-- Update your record to be department 20 manager.
INSERT INTO Employee (Fname,Lname,SSN,DNO)
VALUES ('Omar','Khalid',102672,20)

UPDATE DEPARTMENTS
SET MGRSSN = 102672
WHERE DNUM = 20
-- Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
UPDATE Employee
SET Superssn = 102672 
WHERE SSN = 102660 

-- Unfortunately the company ended the contract with  Mr.Kamel Mohamed (SSN=223344) so try to delete him from your database in case you know that you will be temporarily in his position.
-- Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handles these cases).
UPDATE DEPARTMENTS SET MGRSSN = NULL WHERE MGRSSN = 223344
DELETE Dependent WHERE ESSN = 223344
UPDATE EMPLOYEE SET SUPERSSN = NULL WHERE SUPERSSN = 223344
DELETE FROM WORKS_FOR WHERE ESSN = 223344
DELETE EMPLOYEE WHERE SSN = 223344

-- Part(3)
-- Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.
SELECT E.Fname, E.Lname
FROM Employee AS E
INNER JOIN Works_for AS W ON E.SSN = W.ESSN
INNER JOIN Project AS P ON W.Pno = P.Pnumber
WHERE E.Dno = 10 AND P.Pname = 'AL Rabwah' AND W.Hours >= 10
-- Find the names of the employees who were directly supervised by Kamel Mohamed.
SELECT E.Fname, E.Lname
FROM Employee AS E
WHERE E.SuperSSN = 223344
-- Display All Data of the managers
SELECT E.*
FROM Employee  E , DEPARTMENTS M
WHERE E.SSN = M.MGRSSN
-- Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name
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
-- Display All Employees data and the data of their dependents even if they have no dependents.
SELECT E.*, DEP.*
FROM Employee E LEFT JOIN Dependent DEP 
ON E.SSN = DEP.ESSN