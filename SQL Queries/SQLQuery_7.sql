-- Part 01

CREATE TABLE Department (
  DeptNo VARCHAR(2) PRIMARY KEY,
  DeptName VARCHAR(15) ,
  Location VARCHAR(5) 
)

INSERT INTO Department
VALUES ('d1', 'Research', 'NY'),
('d2', 'Accounting', 'DS'),
('d3', 'Marketing', 'KW')

CREATE TABLE Employee (
    EmpNo INT PRIMARY KEY,
    EmpFname VARCHAR(20) NOT NULL,
    EmpLname VARCHAR(20) NOT NULL,
    DeptNo VARCHAR(2),
    Salary INT,
    CONSTRAINT DeptNo FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo),
    CONSTRAINT Salary UNIQUE (Salary)
)

INSERT INTO Employee 
VALUES (25348, 'Mathew', 'Smith', 'd3', 2500),
(10102, 'Ann', 'Jones', 'd3', 3000),
(18316, 'John', 'Barrymore', 'd1', 2400),
(29346, 'James', 'James', 'd2', 2800),
(9031, 'Lisa', 'Bertoni', 'd2', 4000),
(2581, 'Elisa', 'Hansel', 'd2', 3600),
(28559, 'Sybl', 'Moser', 'd1', 2900)

INSERT INTO Project
VALUES ('p1', 'Apollo', 120000),
('p2', 'Gemini', 95000),
('p3', 'Mercury', 185600)

INSERT INTO Works_on (EmpNo, ProjectNo, Job, Enter_Date) 
VALUES (10102, 'p1', 'Analyst', '2006-10-01'),
(10102, 'p3', 'Manager', '2012-01-01'),
(25348, 'p2', 'Clerk', '2007-02-15'),
(18316, 'p2', NULL, '2007-06-01'),
(29346, 'p2', NULL, '2006-12-15'),
(2581, 'p3', 'Analyst', '2007-10-15'),
(9031, 'p1', 'Manager', '2007-04-15'),
(28559, 'p1', NULL, '2007-08-01'),
(28559, 'p2', 'Clerk', '2012-02-01'),
(9031, 'p3', 'Clerk', '2006-11-15'),
(29346, 'p1', 'Clerk', '2007-01-04')

INSERT INTO Works_on
VALUES (11111, 'p1', 'Clerk', '2007-01-01')
-- 1111 is not in employee table

UPDATE Works_on
SET EmpNo = 11111
WHERE EmpNo = 10102
-- 1111 is not in employee table so its not inserted in Works_on

UPDATE Employee
SET EmpNo = 22222
WHERE EmpNo = 10102
-- EmpNo 10102 is in the Works_on

DELETE FROM Employee
WHERE EmpNo = 10102
-- This is in works on so that we can't delete it

ALTER TABLE Employee
ADD TelephoneNumber VARCHAR(10)

ALTER TABLE Employee
DROP COLUMN TelephoneNumber

CREATE SCHEMA Company
CREATE SCHEMA HumanResource

ALTER SCHEMA Company
TRANSFER dbo.Department

ALTER SCHEMA Company
TRANSFER dbo.Project

ALTER SCHEMA HumanResource
TRANSFER dbo.Employee

UPDATE Company.Project
SET Budget = Budget * 1.10
FROM Company.Project
JOIN dbo.Works_on ON Company.Project.ProjectNo = dbo.Works_on.ProjectNo
WHERE dbo.Works_on.EmpNo = 10102 AND dbo.Works_on.Job = 'Manager'

UPDATE Company.Department
SET DeptName = 'Sales'
WHERE DeptNo = (SELECT DeptNo FROM HumanResource.Employee WHERE EmpFname = 'James')

UPDATE Works_on
SET Enter_Date = '2007-12-12'
WHERE ProjectNo = 'p1' AND EmpNo IN (SELECT EmpNo FROM HumanResource.Employee WHERE DeptNo = (SELECT DeptNo FROM Company.Department WHERE DeptName = 'Sales'))

DELETE FROM Works_on
WHERE EmpNo IN (SELECT EmpNo FROM HumanResource.Employee WHERE DeptNo = (SELECT DeptNo FROM Company.Department WHERE Location = 'KW'))

-- Part 02

CREATE TABLE Audit (
    ProjectNo CHAR(2),
    UserName VARCHAR(20),
    ModifiedDate DATE,
    Budget_Old INT,
    Budget_New INT
)

CREATE TRIGGER BudgetAudit
ON hr.Project
AFTER UPDATE
AS
BEGIN
IF UPDATE(Budget)
BEGIN
DECLARE @ProjectNo CHAR(2)
DECLARE @UserName VARCHAR(20)
DECLARE @ModifiedDate DATE
DECLARE @Budget_Old INT
DECLARE @Budget_New INT
SELECT @ProjectNo = inserted.ProjectNo,
@UserName = SYSTEM_USER,
@ModifiedDate = GETDATE(),
@Budget_Old = deleted.Budget,
@Budget_New = inserted.Budget
FROM inserted
JOIN deleted ON inserted.ProjectNo = deleted.ProjectNo
INSERT INTO Audit (ProjectNo, UserName, ModifiedDate, Budget_Old, Budget_New)
VALUES (@ProjectNo, @UserName, @ModifiedDate, @Budget_Old, @Budget_New)
END
END

UPDATE hr.Project
SET Budget = 200000
WHERE ProjectNo = 2;


SELECT * FROM Audit

-- Part 03

CREATE CLUSTERED INDEX DeptHiredate ON Department(Manager_hiredate)
-- Cannot create more than one clustered index on table 'Department'. Drop the existing clustered index 'PK_Department' before creating another.
-- Cannot create more than 1 cluster in a table

CREATE UNIQUE INDEX UQ_Student_Age ON Student(st_Age)
-- can't create that becase there are dublicates ages null is 11 times and 22 is 5 times