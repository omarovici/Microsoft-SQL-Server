-- Part 01
-- Use ITI DB
-- (1)
SELECT *
FROM Instructor
WHERE Salary < (SELECT AVG(Salary) FROM Instructor)
-- (2)
SELECT TOP(1) D.Dept_Name AS DepartmentDame
FROM Instructor I JOIN Department D ON I.Dept_Id = D.Dept_Id 
WHERE I.SALARY IS NOT NULL
ORDER BY I.Salary
-- (3)
SELECT TOP(2) Salary AS MaxTowSalaries
FROM Instructor
WHERE SALARY IS NOT NULL
ORDER BY Salary DESC
-- (4)
SELECT Dept_Name, Salary 
FROM (SELECT D.Dept_Name , I.SALARY , RANK() OVER(PARTITION BY D.Dept_Name ORDER BY I.SALARY DESC) AS SALARY1
FROM Instructor I JOIN Department D ON I.Dept_Id = D.Dept_Id 
WHERE I.SALARY IS NOT NULL ) AS NEWTABLE
WHERE SALARY1 <= 2
ORDER BY Dept_Name, SALARY1;
-- (5)
SELECT Dept_Name , St_Id , CONCAT (St_Fname,' ',ST_Lname) AS FullName
FROM (SELECT D.Dept_Name , S.St_Id , S.St_Fname ,ST_Lname, RANK() OVER(PARTITION BY D.DEPT_ID ORDER BY NEWID()) AS RAND
FROM STUDENT S JOIN Department D ON S.Dept_Id = D.Dept_Id 
) AS NEWTABLE
WHERE RAND <= 1

-- Use MyCompany DB
-- (1)
Select TOP(1)D.*
FROM Employee E JOIN Departments D
ON E.Dno = D.Dnum 
ORDER BY E.SSN 
-- (2)
SELECT E.Lname
FROM DEPARTMENTS D INNER JOIN Employee E
ON D.MGRSSN = E.SSN LEFT JOIN Dependent DE
ON DE.ESSN = E.SSN
WHERE DE.ESSN IS NULL
-- (3)
SELECT D.Dname , D.Dnum , COUNT(E.SSN) AS EmployeeCount
FROM Departments D JOIN Employee E 
ON D.Dnum = E.Dno
GROUP BY D.Dname , D.Dnum 
HAVING AVG(E.Salary) < (SELECT AVG(SALARY) FROM Employee)
-- (4)
SELECT TOP(2) SALARY
FROM (SELECT SALARY FROM Employee) AS EmployeeSalary
WHERE SALARY IS NOT NULL
ORDER BY SALARY DESC
-- (5)
SELECT DISTINCT E.*
FROM Employee E LEFT JOIN Dependent DE
ON DE.ESSN = E.SSN
WHERE EXISTS (SELECT ESSN FROM Dependent WHERE DE.ESSN IS NOT NULL)


-- Part 02
-- (1)
SELECT SALESORDERID, SHIPDATE
FROM SALES.SalesOrderHeader
WHERE SHIPDATE >= '2002-07-28' AND SHIPDATE < '2014-07-29'
-- (2)
SELECT STANDARDCOST , PRODUCTID , NAME 
FROM Production.Product
WHERE STANDARDCOST < 110.00
-- (3)
SELECT PRODUCTID , NAME , WEIGHT
FROM Production.Product
WHERE WEIGHT IS NULL
-- (4)
SELECT *
FROM Production.Product
WHERE COLOR = 'SILVER' OR COLOR = 'RED' OR COLOR = 'BLACK'
-- (5)
SELECT *
FROM Production.Product
WHERE NAME LIKE 'B%'
-- (6)
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

SELECT *
FROM Production.ProductDescription
WHERE Description LIKE '%_%'
-- (7)
SELECT DISTINCT HireDate
FROM HumanResources.Employee
--(8)
SELECT CONCAT('The ', Name, ' is only! ', ListPrice) AS Product
FROM Production.Product
WHERE ListPrice >= 100.00 AND ListPrice < 120.00
ORDER BY ListPrice