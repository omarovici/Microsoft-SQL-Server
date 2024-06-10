-- Part 01
-- Use ITI DB
-- Display instructors who have salaries less than the average salary of all instructors.
SELECT *
FROM Instructor
WHERE Salary < (SELECT AVG(Salary) FROM Instructor)
-- Display the Department name that contains the instructor who receives the minimum salary.
SELECT TOP(1) D.Dept_Name AS DepartmentDame
FROM Instructor I JOIN Department D ON I.Dept_Id = D.Dept_Id 
WHERE I.SALARY IS NOT NULL
ORDER BY I.Salary
-- Select max two salaries in instructor table. 
SELECT TOP(2) Salary AS MaxTowSalaries
FROM Instructor
WHERE SALARY IS NOT NULL
ORDER BY Salary DESC
-- Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
SELECT Dept_Name, Salary 
FROM (SELECT D.Dept_Name , I.SALARY , RANK() OVER(PARTITION BY D.Dept_Name ORDER BY I.SALARY DESC) AS SALARY1
FROM Instructor I JOIN Department D ON I.Dept_Id = D.Dept_Id 
WHERE I.SALARY IS NOT NULL ) AS NEWTABLE
WHERE SALARY1 <= 2
ORDER BY Dept_Name, SALARY1;
--  Write a query to select a random  student from each department.  “using one of Ranking Functions”
SELECT Dept_Name , St_Id , CONCAT (St_Fname,' ',ST_Lname) AS FullName
FROM (SELECT D.Dept_Name , S.St_Id , S.St_Fname ,ST_Lname, RANK() OVER(PARTITION BY D.DEPT_ID ORDER BY NEWID()) AS RAND
FROM STUDENT S JOIN Department D ON S.Dept_Id = D.Dept_Id 
) AS NEWTABLE
WHERE RAND <= 1

-- Use MyCompany DB
-- Display the data of the department which has the smallest employee ID over all employees' ID.
Select TOP(1)D.*
FROM Employee E JOIN Departments D
ON E.Dno = D.Dnum 
ORDER BY E.SSN 
-- List the last name of all managers who have no dependents.
SELECT E.Lname
FROM DEPARTMENTS D INNER JOIN Employee E
ON D.MGRSSN = E.SSN LEFT JOIN Dependent DE
ON DE.ESSN = E.SSN
WHERE DE.ESSN IS NULL
-- For each department-- if its average salary is less than the average salary of all employees display its number, name and number of its employees.
SELECT D.Dname , D.Dnum , COUNT(E.SSN) AS EmployeeCount
FROM Departments D JOIN Employee E 
ON D.Dnum = E.Dno
GROUP BY D.Dname , D.Dnum 
HAVING AVG(E.Salary) < (SELECT AVG(SALARY) FROM Employee)
-- Try to get the max 2 salaries using subquery
SELECT TOP(2) SALARY
FROM (SELECT SALARY FROM Employee) AS EmployeeSalary
WHERE SALARY IS NOT NULL
ORDER BY SALARY DESC
-- Display the employee number and name if he/she has at least one dependent (use exists keyword) self-study.
SELECT DISTINCT E.*
FROM Employee E LEFT JOIN Dependent DE
ON DE.ESSN = E.SSN
WHERE EXISTS (SELECT ESSN FROM Dependent WHERE DE.ESSN IS NOT NULL)


-- Part 02
-- Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to designate SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
SELECT SALESORDERID, SHIPDATE
FROM SALES.SalesOrderHeader
WHERE SHIPDATE >= '2002-07-28' AND SHIPDATE < '2014-07-29'
-- Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
SELECT STANDARDCOST , PRODUCTID , NAME 
FROM Production.Product
WHERE STANDARDCOST < 110.00
-- Display ProductID, Name if its weight is unknown
SELECT PRODUCTID , NAME , WEIGHT
FROM Production.Product
WHERE WEIGHT IS NULL
--  Display all Products with a Silver, Black, or Red Color
SELECT *
FROM Production.Product
WHERE COLOR = 'SILVER' OR COLOR = 'RED' OR COLOR = 'BLACK'
--  Display any Product with a Name starting with the letter B
SELECT *
FROM Production.Product
WHERE NAME LIKE 'B%'
-- Run the following Query
-- UPDATE Production.ProductDescription
-- SET Description = 'Chromoly steel_High of defects'
-- WHERE ProductDescriptionID = 3
-- Then write a query that displays any Product description with underscore value in its description.

UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

SELECT *
FROM Production.ProductDescription
WHERE Description LIKE '%_%'
--  Display the Employees HireDate (note no repeated values are allowed)
SELECT DISTINCT HireDate
FROM HumanResources.Employee
-- Display the Product Name and its ListPrice within the values of 100 and 120 the list should have the following format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
SELECT CONCAT('The ', Name, ' is only! ', ListPrice) AS Product
FROM Production.Product
WHERE ListPrice >= 100.00 AND ListPrice < 120.00
ORDER BY ListPrice