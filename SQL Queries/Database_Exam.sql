-- 1. Write a query that displays Full name of an employee who has more than
-- 3 letters in his/her First Name.{1 Point}
SELECT CONCAT(Fname,' ',Lname) AS FullName
FROM Employee
WHERE LEN(FNAME) > 3

-- 2. Write a query to display the total number of Programming books 
-- available in the library with alias name ‘NO OF PROGRAMMING
-- BOOKS’ {1 Point}
SELECT COUNT(*) AS [NO OF PROGRAMMING BOOKS]
FROM Book B INNER JOIN Category C
ON B.Cat_id = C.Id
WHERE C.Cat_name = 'Programming'

-- 3. Write a query to display the number of books published by
-- (HarperCollins) with the alias name 'NO_OF_BOOKS'. {1 Point}
SELECT COUNT(*) AS [NO_OF_BOOKS]
FROM BOOK B INNER JOIN Publisher P
ON B.Publisher_id = P.Id
WHERE P.Name = 'HarperCollins'

-- 4. Write  a query to display the User SSN and name, date of borrowing and due date 
-- of the User whose due date is before July 2022. {1 Point}
SELECT U.SSN , U.USER_NAME , B.BORROW_DATE , B.DUE_DATE
FROM USERS U INNER JOIN BORROWING B
ON U.SSN = B.USER_SSN
WHERE B.DUE_DATE < '2022-07-01'

-- 5. Write a query to display book title, author name and display in the 
-- following format,
-- ' [Book Title] is written by [Author Name]. {2 Points}
SELECT CONCAT(B.Title,' is written by ',A.Name) AS BOOK_AUTHOR
FROM BOOK B INNER JOIN BOOK_AUTHOR BA
ON BA.Book_id = B.Id INNER JOIN Author A
ON A.Id = BA.Author_id

-- 6. Write a query to display the name of users who have letter 'A' in their 
-- names. {1 Point}
SELECT User_Name
FROM Users
WHERE User_Name LIKE '%A%'

-- 7. Write a query that display user SSN who makes the most borrowing {2 Points}
SELECT TOP 1 User_ssn
FROM Borrowing
GROUP BY User_ssn
ORDER BY COUNT(User_ssn) DESC

-- 8. Write a query that displays the total amount of money that each user paid 
-- for borrowing books. {2 Points}
SELECT User_ssn , SUM(amount) AS [Total amount of money paid]
FROM Borrowing
GROUP BY User_ssn

-- 9. write a query that displays the category which has the book that has the 
-- minimum amount of money for borrowing. {2 Points}
SELECT C.Cat_name 
FROM Category C INNER JOIN BOOK B
ON C.Id = B.Cat_id INNER JOIN 
Borrowing BO ON BO.Book_id = B.Id
WHERE BO.Amount = (SELECT MIN(Amount) FROM Borrowing)

-- 10.write a query that displays the email of an employee if it's not found, 
-- display address if it's not found, display date of birthday. {1 Point}
SELECT COALESCE(email, address, CONVERT(VARCHAR,DOB,20)) AS EMP_INFO
FROM employee

-- 11.Write a query to list the category and number of books in each category 
-- with the alias name 'Count Of Books'. {1 Point}
SELECT C.Cat_name , COUNT(B.Id) AS [Count Of Books]
FROM CATEGORY C LEFT JOIN BOOK B
ON C.Id = B.Cat_id
GROUP BY C.Cat_name

-- 12.Write a query that display books id which is not found in floor num = 1 
-- and shelf-code = A1.{2 Points}
SELECT B.Id
FROM BOOK B INNER JOIN Shelf S
ON B.Shelf_code = S.Code INNER JOIN
FLOOR F ON S.Floor_num = F.Number
WHERE Floor_num > 1 AND S.Code != 'A1'

-- 13.Write a query that displays the floor number , Number of Blocks and 
-- number of employees working on that floor.{2 Points}
SELECT F.Number , F.Num_blocks , COUNT(E.Id) AS [Number of employees in the floor]
FROM FLOOR F LEFT JOIN Employee E
ON E.Floor_no = F.Number
GROUP BY F.Number , F.Num_blocks

-- 14.Display Book Title and User Name to designate Borrowing that occurred 
-- within the period ‘3/1/2022’ and ‘10/1/2022’.{2 Points}
SELECT BO.Title , U.[User_Name]
FROM USERS U INNER JOIN Borrowing B
ON U.SSN = B.User_ssn INNER JOIN BOOK BO
ON B.Book_id = BO.Id
WHERE B.Borrow_date BETWEEN '2022-3-1' AND '2022-10-1'

-- 15.Display Employee Full Name and Name Of his/her Supervisor as
-- Supervisor Name.{2 Points}
SELECT CONCAT(E1.Fname,' ',E1.Lname) AS [Employee Full Name] , CONCAT(E2.Fname,' ',E2.Lname) AS [Supervisor Full Name]
FROM Employee E1 INNER JOIN Employee E2
ON E1.Super_id = E2.Id

-- 16.Select Employee name and his/her salary but if there is no salary display
-- Employee bonus. {2 Points}
SELECT CONCAT(Fname,' ',Lname) AS [Employee name], COALESCE(salary, bouns) AS [Salary or Bonus]
FROM Employee

-- 17.Display max and min salary for Employees {2 Points}
SELECT  MAX(salary) AS MAX,  MIN(salary) AS MIN
FROM Employee

-- 18.Write a function that take Number and display if it is even or odd {2 Points}
CREATE FUNCTION EvenOddFun (@num INT)
RETURNS VARCHAR(5)
AS
BEGIN
DECLARE @result VARCHAR(5)  
IF (@num % 2 = 0)
SET @result = 'Even'
ELSE
SET @result = 'Odd'    
RETURN @result
END

SELECT DBO.EvenOddFun(92)

-- 19.write a function that take category name and display Title of books in that 
-- category {2 Points}
CREATE FUNCTION GetBookByCategory (@cat_name VARCHAR(30))
RETURNS TABLE
AS
RETURN
(
    SELECT B.Title AS [Book Title]
    FROM BOOK B INNER JOIN Category C
    ON B.Cat_id = C.Id
    WHERE Cat_name = @cat_name
)


SELECT [Book Title]
FROM dbo.GetBookByCategory('Medical')

-- 20. write a function that takes the phone of the user and displays Book Title , 
-- user-name, amount of money and due-date. {2 Points}
CREATE FUNCTION PhoneNum (@Phone VARCHAR(11))
RETURNS TABLE
AS
RETURN
(
    SELECT B.Title , U.[User_Name] , BO.Amount , BO.Due_date
    FROM Borrowing BO INNER JOIN USERS U
    ON BO.User_ssn = U.SSN INNER JOIN BOOK B
    ON B.Id = BO.Book_id INNER JOIN User_phones UP
    ON UP.User_ssn = U.SSN
    WHERE UP.Phone_num = @Phone
)

SELECT *
FROM DBO.PhoneNum('0123654789')

-- 21.Write a function that take user name and check if it's duplicated
-- return Message in the following format ([User Name] is Repeated 
-- [Count] times) if it's not duplicated display msg with this format [user 
-- name] is not duplicated,if it's not Found Return [User Name] is Not
-- Found {2 Points}
CREATE FUNCTION UserNameDuplication (@username VARCHAR(100))
RETURNS VARCHAR(200)
AS
BEGIN
DECLARE @ans VARCHAR(200)
DECLARE @cnt INT

SELECT @cnt = COUNT(*)
FROM USERS
WHERE USER_NAME = @username

IF @cnt = 1
SET @ans = CONCAT(@username, ' is not duplicated')
ELSE IF @cnt > 1
SET @ans = CONCAT(@username, ' is Repeated ', CAST(@cnt AS VARCHAR(10)), ' times')
ELSE
SET @ans = CONCAT(@username, ' is Not Found')

RETURN @ans
END

SELECT dbo.UserNameDuplication('Amr Ahmed')

-- 22.Create a scalar function that takes date and Format to return Date With
-- That Format. {2 Points}
CREATE FUNCTION FormatNum (@date Date,@format VARCHAR(50))
RETURNS VARCHAR(50)
AS
BEGIN
DECLARE @DateFormat VARCHAR(50)
SET @DateFormat = FORMAT(@date,@format)
RETURN @DateFormat
END

SELECT dbo.FormatNum(GETDATE(), 'YYYY-MM-DD') AS [Date and format]
SELECT dbo.FormatNum(GETDATE(), 'MM-dd-yyyy') AS [Date and format]
SELECT dbo.FormatNum(GETDATE(), 'MM-yyyy-dd') AS [Date and format]

-- 23.Create a stored procedure to show the number of books per Category.{2 Points}
CREATE PROC BookPerCategory
AS
BEGIN
SELECT c.cat_name , COUNT(b.id) AS [Number of books]
FROM Category C LEFT JOIN BOOK B
ON C.Id = B.Cat_id
GROUP BY C.Cat_name
END

EXEC DBO.BookPerCategory

-- 24.Create a stored procedure that will be used in case there is an old manager 
-- who has left the floor and a new one becomes his replacement. The 
-- procedure should take 3 parameters (old Emp.id, new Emp.id and the 
-- floor number) and it will be used to update the floor table. {3 Points}
CREATE PROC UpdateManger (@old_id INT , @new_id INT , @floor_num INT)
AS
BEGIN
UPDATE FLOOR
SET MG_ID = @new_id
WHERE MG_ID = @old_id AND Number = @floor_num
END

EXEC DBO.UpdateManger @old_id = 3 , @new_id = 2, @floor_num = 1

-- 25.Create a view AlexAndCairoEmp that displays Employee data for users 
-- who live in Alex or Cairo. {2 Points}
CREATE VIEW AlexCairoEmp
AS
SELECT * 
FROM Employee
WHERE Address = 'CAIRO' OR Address = 'ALEX'

SELECT * FROM AlexCairoEmp

-- 26.create a view "V2" That displays number of books per shelf {2 Points}
CREATE VIEW V2
AS
SELECT S.Code , COUNT(B.Id) AS [Number of Books]
FROM Shelf S INNER JOIN Book B
ON S.Code = B.Shelf_code
GROUP BY S.Code

SELECT * FROM V2

-- 27.create a view "V3" That display the shelf code that have maximum 
-- number of books using the previous view "V2" {2 Points}
CREATE VIEW V3
AS
SELECT V2.code , V2.[Number of Books]
FROM  V2
WHERE  V2.[Number of Books] = (SELECT MAX([Number of Books]) FROM V2)

SELECT * FROM V3

-- 28.Create a table named ‘ReturnedBooks’ With the Following Structure :
-- User SSN , Book Id , Due Date , Return Date , fees
-- then create A trigger that instead of inserting the data of returned book 
-- checks if the return date is the due date or not if not so the user must pay 
-- a fee and it will be 20% of the amount that was paid before. {3 Points}
CREATE TABLE ReturnedBooks 
(
    USER_SSN VARCHAR(20),
    BOOK_ID INT,
    DUE_DATE DATE,
    RETURN_DATE DATE,
    FEES INT
)

CREATE TRIGGER ReturnedBook_InsertBook ON ReturnedBooks
INSTEAD OF INSERT
AS
BEGIN
DECLARE @USER_SSN VARCHAR(20) , @BOOK_ID INT , @DUE_DATE DATE , @RETURN_DATE DATE , @FEES INT , @Amount INT, @ReturnDate DATE
SELECT @USER_SSN = I.USER_SSN , @BOOK_ID = I.BOOK_ID , @DUE_DATE = I.DUE_DATE , @RETURN_DATE = I.RETURN_DATE , @FEES = I.FEES
FROM Inserted I 

SELECT @Amount = Amount
FROM Borrowing
WHERE User_ssn = @USER_SSN AND Book_id = @BOOK_ID

IF @RETURN_DATE > @DUE_DATE
BEGIN
INSERT INTO ReturnedBooks (USER_SSN, BOOK_ID, DUE_DATE, RETURN_DATE, FEES)
VALUES (@USER_SSN, @BOOK_ID, @DUE_DATE, @RETURN_DATE, @Amount * 0.2)
END
ELSE
BEGIN
INSERT INTO ReturnedBooks (USER_SSN, BOOK_ID, DUE_DATE, RETURN_DATE, FEES)
VALUES (@USER_SSN, @BOOK_ID, @DUE_DATE, @RETURN_DATE, 0)
END
END

INSERT INTO ReturnedBooks
VALUES (1,3,'2021-02-27','2021-02-28',200)

INSERT INTO ReturnedBooks
VALUES (2,3,'2022-03-24','2022-03-24',350)

SELECT * FROM ReturnedBooks

-- 29.In the Floor table insert new Floor With Number of blocks 2 , employee 
-- with SSN = 20 as a manager for this Floor,The start date for this manager 
-- is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5) 
-- moved to be the manager of the new Floor (id = 6), and they give Mr. Ali
-- Mohamed(his SSN =12) His position . {3 Points}
INSERT INTO Floor
VALUES (6, 2, 20, GETDATE())

UPDATE Floor
SET MG_ID = 5
WHERE number = 6

UPDATE Floor
SET MG_ID = 12
WHERE number = 4

-- 30.Create view name (v_2006_check) that will display Manager id, Floor 
-- Number where he/she works , Number of Blocks and the Hiring Date 
-- which must be from the first of March and the end of May 2022.this view 
-- will be used to insert data so make sure that the coming new data must 
-- match the condition then try to insert this 2 rows and
-- Mention What will happen {3 Point}
-- Employee Id ,  Floor Number , Number of Blocks , Hiring Date
-- 2 , 6 , 2 , 7-8-2023
-- 4 , 7 , 1 , 4-8-2022
DELETE FROM Floor WHERE number = 6

CREATE VIEW v_2006_check
AS
SELECT MG_ID , Number, num_blocks, hiring_date
FROM Floor
WHERE hiring_date BETWEEN '2022-03-01' AND '2022-05-31'

INSERT INTO v_2006_check
VALUES (2, 6, 2, '2023-07-08') -- It will not insert into the view because it follows the rules of the hiring date

INSERT INTO v_2006_check
VALUES (4, 7, 1, '2022-04-08') -- It will insert into the view because it follows the rules of the hiring date

SELECT * FROM v_2006_check -- check my answer

-- 31.Create a trigger to prevent anyone from Modifying or Delete or Insert in 
-- the Employee table ( Display a message for user to tell him that he can’t 
-- take any action with this Table) {3 Point}
CREATE TRIGGER PreventModifyDeleteInsert
ON Employee
FOR INSERT, UPDATE, DELETE
AS
BEGIN
PRINT 'You cant take any action with this Table'
ROLLBACK TRANSACTION
END

-- 32. Testing Referential Integrity, Mention What Will Happen When:
-- A. Add a new User Phone Number with User_SSN = 50 in
-- User_Phones Table {1 Point}
INSERT INTO User_Phones
VALUES (50, '01012345678') -- here the user ssn is not even inserted to insert a phone for him

-- B. Modify the employee id 20 in the employee table to 21 (1 Point)
UPDATE Employee
SET id = 21
WHERE id = 20 -- here you cannot update the id because its an identity column 

-- C. Delete the employee with id 1 {1 Point}
DELETE FROM Employee
WHERE id = 1 -- here you cannot delete the id 1 because it has a refrence in book borrowing means that 
-- you cant delete that id unless you deleted it's data from book borrowing thats a conflict

-- D. Delete the employee with id 12 {1 Point}
DELETE FROM Employee
WHERE id = 12 -- here you cannot delete the id 12 because it has a refrence in book borrowing means that 
-- you cant delete that id unless you deleted it's data from book borrowing thats a conflict
-- the same as above

-- E. Create an index on column (Salary) that allows you to cluster the data in table Employee. (1 Point)
CREATE CLUSTERED INDEX EMP_SALARY ON Employee (Salary) -- here you cannot create more than one clusterd index on the table
-- you must drop the clusterd index on the primary key in employee so you can add your clusterd index