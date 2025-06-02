-- 3. Functions – Reusable Logic

USE LibraryDatabase;


-- GetBookAverageRating(BookID)  ->   Returns average rating of a book

CREATE FUNCTION GetBookAverageRating (@BookID INT)
RETURNS DECIMAL(3,2)
AS
BEGIN
    DECLARE @AvgRating DECIMAL(3,2);

    SELECT @AvgRating = AVG(Rating)
    FROM ReviewBook
    WHERE Book_ID = @BookID;

    RETURN ISNULL(@AvgRating, 0);
END;

-- TEST THE FUNCTION FOR SPECIFIC ID
SELECT dbo.GetBookAverageRating(30) AS AverageRating;

-- TEST FUNCTION FOR ALL BOOK ID
SELECT Book_ID,Title,dbo.GetBookAverageRating(Book_ID) AS AverageRating
FROM Book;



-- GetNextAvailableBook(Genre, Title, LibraryID) -> Fetches the next available book


CREATE FUNCTION GetNextAvailableBook(@Genre VARCHAR(100), @Title VARCHAR(200), @LibraryID INT)
RETURNS TABLE
AS
RETURN
( SELECT TOP 1 B.Book_ID,B.Title, B.Genre,B.Available_State, LB.L_ID,LB.Book_ID AS LB_Book_ID  
FROM Book B
INNER JOIN LibraryBook LB ON LB.Book_ID = B.Book_ID
WHERE B.Genre = @Genre AND B.Title = @Title AND LB.L_ID = @LibraryID AND B.Available_State = 'True'
ORDER BY B.Book_ID
);

--

SELECT * FROM Book
SELECT * FROM LibraryBook
SELECT * FROM Library
--

SELECT * FROM dbo.GetNextAvailableBook('Reference', 'The Da Vinci Code', 2);

------------------
-- CalculateLibraryOccupancyRate(LibraryID) -> Returns % of books currently issued

CREATE FUNCTION CalculateLibraryOccupancyRate (@LibraryID INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @IssuedCount INT, @TotalCount INT;
    SELECT @IssuedCount = COUNT(*) FROM Book B
	INNER JOIN LibraryBook LB ON LB.Book_ID = B.Book_ID
    WHERE L_ID = @LibraryID AND Available_State = 'False';

    SELECT @TotalCount = COUNT(*) FROM Book B
	INNER JOIN LibraryBook LB ON LB.Book_ID = B.Book_ID
	WHERE LB.L_ID = @LibraryID;

    RETURN CASE 
        WHEN @TotalCount = 0 THEN 0
        ELSE CAST(@IssuedCount * 100.0 / @TotalCount AS DECIMAL(5,2))
    END;
END;

-- CALL CalculateLibraryOccupancyRate() FUNCTION
SELECT dbo.CalculateLibraryOccupancyRate(2) AS OccupancyRate;


-- Fn_GetMemberLoanCount -> Return the total number of loans made by a given member.

CREATE FUNCTION fn_GetMemberLoanCount (@MemberID INT)
RETURNS INT
AS
BEGIN
    DECLARE @LoanCount INT;

    SELECT @LoanCount = COUNT(*)
    FROM Loan
    WHERE M_ID = @MemberID;

    RETURN ISNULL(@LoanCount, 0);
END;

-- CALL fn_GetMemberLoanCount FUNCTION 
SELECT * FROM Members
SELECT dbo.fn_GetMemberLoanCount(1) AS MemberLoanCount;

-- fn_GetLateReturnDays ->  Return the number of late days for a loan (0 if not late).

CREATE FUNCTION fn_GetLateReturnDays (@Book_ID INT,@M_ID INT,@Loan_Date DATE)
RETURNS INT
AS
BEGIN
    DECLARE @LateDays  INT ;
    SELECT @LateDays = DATEDIFF(DAY, Due_Date, Return_Date) FROM Loan
	WHERE Book_ID = @Book_ID AND M_ID = @M_ID AND Loan_Date =@Loan_Date

    RETURN CASE 
        WHEN @LateDays > 0 THEN @LateDays
        ELSE 0
    END;
END;

-- CALL fn_GetLateReturnDays FUNCTION
SELECT * FROM Book
SELECT * FROM Loan
SELECT dbo.fn_GetLateReturnDays(30,1,'2023-01-10') AS LateReturnDays;

-- fn_ListAvailableBooksByLibrary Returns a table of available books from a specific library

CREATE FUNCTION fn_ListAvailableBooksByLibrary (@LibraryID INT)
RETURNS TABLE
AS
RETURN
( SELECT B.Book_ID,B.Title,B.Genre,B.Available_State, LB.L_ID,LB.Book_ID AS LB_Book_ID 
FROM Book B
INNER JOIN LibraryBook LB ON LB.Book_ID = B.Book_ID
WHERE LB.L_ID = @LibraryID AND B.Available_State = 'True'
);

-- CALL 
SELECT * FROM dbo.fn_ListAvailableBooksByLibrary(2);


-- fn_GetTopRatedBooks Returns books with average rating ≥ 4.5 

CREATE FUNCTION fn_GetTopRatedBooks()
RETURNS TABLE
AS
RETURN
( SELECT B.* FROM Book B
INNER JOIN ( SELECT Book_ID, AVG(Rating) AS AvgRating FROM ReviewBook
GROUP BY Book_ID
HAVING AVG(Rating) >= 4.5) R ON B.Book_ID = R.Book_ID
);

-- CALL fn_GetTopRatedBooks FUNCTION 

SELECT * FROM dbo.fn_GetTopRatedBooks();


-- fn_FormatMemberName Returns  the  full  name  formatted  as  "LastName, FirstName" 
CREATE FUNCTION fn_FormatMemberName (@MemberID INT)
RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @FullName VARCHAR(200);

    SELECT @FullName = LName + ' ' + FName
    FROM Members
    WHERE M_ID = @MemberID;

    RETURN ISNULL(@FullName, '');
END;

-- CALL fn_FormatMemberName FUNCTION

SELECT dbo.fn_FormatMemberName(1) AS FormatMemberName ;

