CREATE FUNCTION GetStudentDaneBasedOnFormat(@format VARCHAR(20))
RETURNS @StudentTable TABLE 
(
    STUDENTID INT ,
    STUDENTNAME VARCHAR(30)
)
AS 
BEGIN
IF @format = 'FIRST'
INSERT INTO @StudentTable
SELECT St_Id,St_Fname
FROM STUDENT
ELSE IF @format = 'LAST'
INSERT INTO @StudentTable
SELECT St_Id,St_Lname
FROM STUDENT
ELSE IF @format = 'FULL'
INSERT INTO @StudentTable
SELECT St_Id,CONCAT(St_Fname,' ',St_Lname)
FROM STUDENT
RETURN
END

SELECT * FROM GetStudentDaneBasedOnFormat('First')

--==============================================================
ALTER FUNCTION GetStudentsLocationReturnDepartName
(@Location VARCHAR(20))
RETURNS @StudentTableDep TABLE 
(
    StudentN VARCHAR(100),
    DepartmentN VARCHAR(100)
)
AS
BEGIN
    INSERT INTO @StudentTableDep
    SELECT s.St_Fname, d.Dept_Name
    FROM STUDENT s
    INNER JOIN DEPARTMENT d ON s.Dept_Id = d.Dept_Id
    WHERE s.St_Address = @Location
    RETURN
END

SELECT * FROM GetStudentsLocationReturnDepartName('Cairo')

--==============================================================

CREATE VIEW CairoStudentsView
as 
SELECT St_Id , St_Fname , St_Age , St_Address
FROM Student
WHERE St_Address = 'Cairo'

SELECT *
FROM CairoStudentsView


CREATE VIEW AlexStudentsView
as 
SELECT St_Id , St_Fname , St_Age , St_Address
FROM Student
WHERE St_Address = 'ALEX'

SELECT *
FROM AlexStudentsView


CREATE VIEW CairoAndAlex
as 
SELECT * FROM AlexStudentsView
UNION ALL
SELECT * FROM CairoStudentsView

SELECT * FROM CairoAndAlex

ALTER VIEW StudenInfoView (STUDENTID , STUDENTNAME , DEPARTMENTID , DEPARTMENTNAME)
WITH ENCRYPTION
AS 
SELECT S.St_Id , S.St_Fname , D.Dept_Id , D.Dept_Name
FROM Student S JOIN Department D 
ON D.Dept_Id = S.Dept_Id

SELECT * FROM StudenInfoView

SP_HELPTEXT 'StudenInfoView'

CREATE VIEW CairoAndAlexStudentsGRADEView
WITH ENCRYPTION
AS 
SELECT CA.St_Fname , C.Crs_Name , SC.Grade
FROM CairoAndAlex CA , Stud_Course SC , Course C 
WHERE CA.St_Id = SC.St_Id AND C.Crs_Id = SC.Crs_Id

SELECT * FROM CairoAndAlexStudentsGRADEView

ALTER VIEW CairoStudentsView(id , name , age , address)
as 
SELECT St_Id , St_Fname , St_Age , St_Address
FROM Student
WHERE St_Address = 'Cairo'

SELECT *
FROM CairoStudentsView

INSERT INTO CairoStudentsView 
VALUES (124,'Ahmed',22,'Alex')
--==============================================================
--==============================================================
--==============================================================

ALTER VIEW StudenInfoView (STUDENTID , STUDENTNAME , DEPARTMENTID , DEPARTMENTNAME)
WITH ENCRYPTION
AS 
SELECT S.St_Id , S.St_Fname , S.Dept_Id , D.Dept_Name
FROM Student S LEFT JOIN Department D 
ON D.Dept_Id = S.Dept_Id

SELECT * FROM StudenInfoView

INSERT INTO StudenInfoView (STUDENTID , STUDENTNAME)
VALUES (451,'Ali')

UPDATE StudenInfoView
SET DEPARTMENTID = 20 
WHERE STUDENTID = 451


ALTER VIEW CairoStudentsView(id,name,age,address)
WITH ENCRYPTION
as 
SELECT St_Id , St_Fname , St_Age , St_Address
FROM Student
WHERE St_Address = 'Cairo'
WITH CHECK OPTION

INSERT INTO CairoStudentsView 
VALUES (666,'Omar',19,'Cairo')

SELECT *
FROM CairoStudentsView