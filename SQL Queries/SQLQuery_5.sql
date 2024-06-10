-- Part 01
-- Use ITI DB:
-- Create a view “V1” that displays student data for students who live in Alex
-- or Cairo.
-- Note: Prevent the users to run the following query
-- Update V1 set st_address=’tanta’
-- Where st_address=’alex’;

CREATE VIEW V1 
AS
SELECT *
FROM STUDENT
WHERE St_Address IN ('Alex', 'Cairo')

SELECT * FROM V1;

UPDATE V1
SET St_Address = 'Tanta'
WHERE St_Address = 'Alex'

SELECT * FROM V1;

-- use CompanySD32_DB:
-- Create view named “v_dept” that will display the department# and department name

DROP VIEW v_dept

CREATE VIEW v_dept 
AS
SELECT DeptNo , DeptName
FROM DEPARTMENT

-- using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’

SELECT * FROM v_dept

INSERT INTO v_dept (DeptNo,DeptName)
VALUES (4,'Development')

-- Create view name “v_2006_check” that will display employee Number, the project Number where he works and the date of joining the project which must be from the first of
-- January and the last of December 2006.this view will be
-- used to insert data so make sure that the coming new data must match the condition


DROP VIEW v_2006_check

CREATE VIEW v_2006_check
AS
SELECT E.EMPNO , W.ProjectNo , W.Enter_Date
FROM HR.EMPLOYEE E INNER JOIN Works_on W 
ON E.EMPNO = W.EmpNo
WHERE W.Enter_Date BETWEEN '2006-01-01' AND '2006-12-31'

SELECT * FROM v_2006_check

-- Part 02
-- Create a stored procedure to show the number of students per department.[use ITI DB] 
CREATE PROC ShowStudentCountPerDept
AS
SELECT D.Dept_Name , COUNT(S.St_Id) AS NumberOfEmployees
FROM STUDENT S INNER JOIN DEPARTMENT D
ON S.DEPT_ID = D.DEPT_ID
GROUP BY D.Dept_Name

ShowStudentCountPerDept

-- Create a stored procedure that will check for the Number of employees in the project 100 if they are more than 3 print message to the user “'The number of employees in the project 100 is 3 or more'” if they are less display a message to the user “'The following employees work for the project 100'” in addition to the first name and last name of each one. [MyCompany DB]
CREATE PROC PROJECT100 
AS
BEGIN
DECLARE @EMP INT
SELECT @EMP = COUNT(E.SSN)
FROM WORKS_FOR W INNER JOIN EMPLOYEE E
ON W.ESSN = E.SSN
WHERE W.Pno = 100
IF @EMP >= 3
BEGIN
PRINT 'The number of employees in the project 100 is 3 or more'
END
ELSE
BEGIN
PRINT 'The following employees work for the project 100'
SELECT E.Fname , E.Lname
FROM Employee E INNER JOIN Works_for W 
ON E.SSN = W.ESSN
WHERE W.PNO = 100
END
END

-- Create a stored procedure that will be used in case an old employee has left the project and a new one becomes his replacement. The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. [MyCompany DB]

CREATE PROC ReplaceOldEmp @OldEmp INT, @NewEmp INT, @Project INT
AS
UPDATE Works_for
SET ESSN = @NewEmp 
WHERE ESSN = @OldEmp AND PNO = @Project

ReplaceOldEmp @OldEmp = 112233 , @NewEmp = 512463 , @Project = 500

-- Part 03
-- Create a stored procedure that calculates the sum of a given range of numbers
CREATE PROC Range @FIRST INT , @LAST INT
AS
BEGIN
DECLARE @SUM INT
SET @Sum = (@FIRST + @LAST ) * (@LAST-@FIRST+1) /2
SELECT @SUM AS GivenRange
END

Range @FIRST = 9 , @LAST = 15

-- Create a stored procedure that calculates the area of a circle given its radius

CREATE PROC CircleArea @RADIUS FLOAT
AS
BEGIN
DECLARE @PI  FLOAT = 3.14159
DECLARE @AREA FLOAT = @PI * @RADIUS * @RADIUS
SELECT @AREA AS Area
END

CircleArea @RADIUS = 8

-- Create a stored procedure that calculates the age category based on a person's age ( Note: IF Age < 18 then Category is Child and if Age >= 18 AND Age < 60 then Category is Adult otherwise Category is Senior)

CREATE PROC AgeCategory @AGE INT
AS
BEGIN
DECLARE @ANS VARCHAR(10) = 'Senior'
IF @AGE < 18
SET @ANS = 'Child'
ELSE IF @AGE >= 18 AND @AGE < 60
SET @ANS = 'Adult'
SELECT @ANS AS AgeCategory
END

AgeCategory @AGE = 90

-- Create a stored procedure that determines the maximum, minimum, and average of a given set of numbers ( Note : set of numbers as Numbers = '5, 10, 15, 20, 25')

CREATE PROCEDURE MaxMinAvg @Num1 INT, @Num2 INT, @Num3 INT, @Num4 INT
AS
BEGIN
DECLARE @MAX INT, @MIN INT, @AVG FLOAT
SET @MAX = GREATEST(@Num1,@Num2,@Num3,@Num4)
SET @MIN = LEAST(@Num1,@Num2,@Num3,@Num4)
SET @AVG = (@Num1+@Num2+@Num3+@Num4)/4
SELECT @Max AS Max, @Min AS Min, @Avg AS Average;
END

MaxMinAvg @Num1 = 1, @Num2 = 2, @Num3 = 3, @Num4 = 4

-- Part 04
-- Create a trigger to prevent anyone from inserting a new record in the Department table ( Display a message for user to tell him that he can’t insert a new record in that table ) Create a table named “StudentAudit”. Its Columns are (Server User Name , Date, Note)

CREATE TABLE StudentAudit (
  ServerUserName VARCHAR(50),
  AudDate DATETIME,
  Note VARCHAR(100)
)

CREATE TRIGGER PrevInsertIntoDept
ON DEPARTMENT
AFTER INSERT
AS
PRINT 'cant insert a new record in that table'

INSERT INTO Department (DEPT_ID,DEPT_NAME)
VALUES (0987654321,'Ahmed')

-- Create a trigger on student table after insert to add Row in StudentAudit table
-- • The Name of User Has Inserted the New Student
-- • Date
-- • Note that will be like ([username] Insert New Row with Key = [Student Id] in table [table name


ALTER TRIGGER PrevStudentInsert
ON STUDENT
INSTEAD OF INSERT
AS
BEGIN

DECLARE @UserName VARCHAR(20)
DECLARE @StudentId INT
DECLARE @Note VARCHAR(150)
DECLARE @Date DATETIME

SET @UserName = SUSER_NAME()
SET @Date = GETDATE()
SELECT TOP 1 @StudentId = i.St_Id FROM INSERTED i
SET @Note = @UserName + ' Inserted New Row with Key = ' + CAST(@StudentId AS VARCHAR(10)) + ' in table Student'
INSERT INTO StudentAudit (ServerUserName, AudDate, Note)
VALUES (@UserName, @Date, @Note)
END

INSERT INTO STUDENT (ST_FNAME,ST_ID)
VALUES('Omar',122300)

--  Create a trigger on student table instead of delete to add Row in StudentAudit table
-- ○ The Name of User Has Inserted the New Student
-- ○ Date
-- ○ Note that will be like “try to delete Row with id = [Student Id]”
CREATE TRIGGER DelStudent
ON STUDENT
INSTEAD OF DELETE
AS
BEGIN
DECLARE @UserName VARCHAR(20)
DECLARE @StudentId INT
DECLARE @Date DATETIME
SET @Date = GETDATE()
DECLARE @Note VARCHAR(100)
SET @UserName = SUSER_NAME()
SELECT TOP 1 @StudentId = d.St_Id FROM DELETED d
SET @Note = 'Tried to Delete Row with Id = '+ CAST(@StudentId AS VARCHAR(10))
INSERT INTO StudentAudit (ServerUserName, AudDate, Note)
VALUES (@UserName, @Date, @Note)
END

DELETE FROM Student
WHERE St_Id = 122300

-- Create a trigger that prevents the insertion Process for Employee table in March
ALTER TRIGGER MarchEmp
ON Employee
INSTEAD OF INSERT
AS
BEGIN
IF MONTH(GETDATE()) = 6
Print 'Invalid Insert in march'
ELSE
INSERT INTO Employee
SELECT * FROM inserted
END

INSERT INTO Employee (SSN, Fname, Lname)
VALUES (500100,'Hello','World')