-- Part 01 (Functions)
-- 1. Create a scalar function that takes a date and returns the Month name of that date. 
CREATE FUNCTION ReturnMonth(@Date date)
returns VARCHAR(15)
BEGIN
DECLARE @MON VARCHAR(15)
SET @MON = DATENAME(MONTH,@Date)
RETURN @MON
END

SELECT DBO.ReturnMonth('9-11-2001') AS MonthName

-- 2. Create a scalar function that takes 2 integers and returns the values between them.
--    Example Function(1 , 5) output : 2 , 3 , 4
ALTER FUNCTION NumbersBetweenThem(@first int , @second int)
RETURNS VARCHAR(50)
BEGIN
DECLARE @ANS VARCHAR(50) = ''
DECLARE @CNT INT = @FIRST + 1
WHILE @CNT < @second
BEGIN
IF @ANS = ''
SET @ANS = CAST(@CNT AS VARCHAR);
ELSE
SET @ANS = CONCAT(@ANS, ' , ', CAST(@CNT AS VARCHAR)); 
SET @CNT = @CNT + 1;
END
RETURN @ANS
END

SELECT DBO.NumbersBetweenThem(0,3) AS NumbersBetweenThem

-- 3. Create a table-valued function that takes Student Number and returns 
--    Department Name with Student full name.
ALTER FUNCTION ReturnDeptFullName(@StudentId int)
RETURNS TABLE
AS
RETURN (
    SELECT D.Dept_Name , CONCAT(S.St_Fname,' ',S.St_Lname) AS FullName
    FROM Department D INNER JOIN Student S 
    ON D.Dept_Id = S.Dept_Id
    WHERE @StudentId = S.St_Id
)

SELECT *
FROM DBO.ReturnDeptFullName(9)

-- 4.	a scalar function that takes Student ID and returns a message to user 
-- a.	If first name and Last name are null then display 'First name & last Create name are null'
-- b.	If First name is null then display 'first name is null'
-- c.	If Last name is null then display 'last name is null'
-- d.	Else display 'First name & last name are not null'

CREATE FUNCTION ReturnNull(@StudentId int)
RETURNS VARCHAR(50)
BEGIN
DECLARE @MESSAGE VARCHAR(50) = 'First name & last name are not null'
DECLARE @FNAME VARCHAR(50)
DECLARE @LNAME VARCHAR(50)
SELECT @FNAME = St_Fname , @LNAME = St_Lname
FROM Student
WHERE @StudentId = St_Id
IF @FNAME IS NULL AND @LNAME IS NULL 
SET @MESSAGE = 'First name & last Create name are null'
ELSE IF @FNAME IS NULL 
SET @MESSAGE = 'first name is null'
ELSE IF @LNAME IS NULL
SET @MESSAGE = 'last name is null'
RETURN @MESSAGE
END

SELECT DBO.ReturnNull(13) AS MESSAGE

-- 5.Create a function that takes an integer which represents the format of the Manager hiring date and displays department name,
--   Manager Name and hiring date with this format.   

-- Note : I did't get the question

-- 6.	Create multi-statement table-valued function that takes a string
-- a.	If string='first name' returns student first name
-- b.	If string='last name' returns student last name 
-- c.	If string='full name' returns Full Name from student table  (Note: Use “ISNULL” function)
CREATE FUNCTION StudentINF(@format varchar)
RETURNS @StudentTable TABLE
(
StudentId int,
StudntName varchar(30)
)
AS
BEGIN
IF @format = 'first'
INSERT INTO @StudentTable
SELECT St_Id,St_Fname
FROM Student
ELSE IF @format = 'last'
INSERT INTO @StudentTable
SELECT St_Id,St_Lname
FROM Student
ELSE IF @format = 'full'
INSERT INTO @StudentTable
SELECT St_Id,CONCAT(St_Fname, ' ', St_Lname)
FROM Student
RETURN
END

SELECT *
FROM DBO.StudentINF('FULL')

-- 7. Create function that takes project number and display all employees in this project (Use MyCompany DB)
CREATE FUNCTION GetEmpByPNO(@ProjectNum int)
RETURNS TABLE
AS
RETURN (
    SELECT E.*
    FROM EMPLOYEE E INNER JOIN WORKS_FOR W 
    ON E.SSN = W.ESSn
    WHERE @ProjectNum = PNO
)

SELECT * FROM GetEmpByPNO(100)

-- Part 02 (Views)
-- Use ITI DB:
-- 1. Create a view that displays the student's full name, course name if the student has a grade more than 50. 
CREATE VIEW StudentView AS
SELECT CONCAT(S.St_Fname,' ',S.St_Lname) AS FullName , C.Crs_Name
FROM STUDENT S INNER JOIN Stud_Course SC 
ON S.St_Id = SC.St_Id INNER JOIN Course C 
ON SC.Crs_Id = C.Crs_Id 
WHERE SC.Grade > 50

SELECT * FROM StudentView

-- 2. Create an Encrypted view that displays manager names and the topics they teach.
ALTER VIEW ManTopic
WITH ENCRYPTION 
AS
SELECT DISTINCT I.Ins_Name , T.Top_Name
FROM Instructor I INNER JOIN Ins_Course IC
ON I.Ins_Id = IC.Ins_Id INNER JOIN Course C 
ON C.Crs_Id = IC.Crs_Id INNER JOIN Topic T 
ON T.Top_Id = C.Top_Id

SELECT * FROM ManTopic

-- 3. Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department
--    “use Schema binding” and describe what is the meaning of Schema Binding
-- The SCHEMABINDING option in SQL Server ensures that the view is bound to the schema of the underlying tables.
CREATE VIEW InsDep WITH SCHEMABINDING 
AS
SELECT I.Ins_Name,D.Dept_Name
FROM DBO.Instructor I JOIN DBO.Department D 
ON I.Dept_Id = D.Dept_Id
WHERE D.Dept_Name IN ('SD', 'Java')

SELECT * FROM InsDep

-- 4. Create a view that will display the project name and the number of employees working on it. (Use Company DB)
CREATE VIEW DisplayNumberOfEmp 
AS
SELECT P.Pname , COUNT(E.SSN) AS NumberOfEmployees
FROM EMPLOYEE E INNER JOIN Works_for W
ON E.SSN = W.ESSn INNER JOIN Project P 
ON W.Pno = P.Pnumber
GROUP BY P.Pname

SELECT * FROM DisplayNumberOfEmp

-- use CompanySD32_DB:
-- 1. Create a view named   “v_clerk” that will display employee Number ,project Number, the date of hiring of all the jobs of the type 'Clerk'.
DROP VIEW v_clerk

CREATE VIEW v_clerk 
AS
SELECT EmpNo, ProjectNo, Enter_Date
FROM Works_on
WHERE Job = 'Clerk'

SELECT * FROM v_clerk
 -- 2. Create view named  “v_without_budget” that will display all the projects data without budget
DROP view v_without_budget 

CREATE VIEW v_without_budget 
AS
SELECT ProjectNo , ProjectName
FROM hr.Project
WHERE Budget IS NULL

SELECT * FROM v_without_budget

-- 3. Create view named  “v_count “ that will display the project name and the Number of jobs in i
DROP VIEW v_count

CREATE VIEW v_count 
AS
SELECT P.ProjectName, COUNT(W.Job) AS NumberOfJobs
FROM hr.Project P JOIN Works_on W ON P.ProjectNo = W.ProjectNo
GROUP BY P.ProjectName

SELECT * FROM v_count

-- 4. Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ . (use the previously created view  “v_clerk”)
DROP view v_project_p2 

CREATE VIEW v_project_p2 
AS
SELECT EmpNo
FROM v_clerk
WHERE ProjectNo = 'p2'

SELECT * FROM v_project_p2

-- 5. modify the view named  “v_without_budget”  to display all DATA in project p1 and p2.
DROP VIEW v_without_budget

ALTER VIEW v_without_budget AS
SELECT *
FROM hr.Project
WHERE ProjectNo = 'P1' OR ProjectNo = 'P2'

SELECT * FROM v_without_budget

-- 6. Delete the views  “v_ clerk” and “v_count”
DROP VIEW v_clerk
DROP VIEW v_count

-- 7. Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’
CREATE VIEW v_emp_d2 AS
SELECT E.EmpNo, E.EmpLname
FROM hr.Employee E
WHERE E.DeptNo = '2'

SELECT * FROM v_emp_d2

-- 8. Display the employee  lastname that contains letter “J” (Use the previous view created in Q#7)
SELECT EmpLname
FROM dbo.v_emp_d2
WHERE EmpLname LIKE '%J%';

-- 9. Create view named “v_dept” that will display the department# and department name
DROP VIEW v_dept

CREATE VIEW v_dept 
AS
SELECT DeptNo , DeptName
FROM Department

SELECT * FROM v_dept