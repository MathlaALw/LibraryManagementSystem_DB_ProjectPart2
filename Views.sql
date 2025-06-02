-- 2. Views – Frontend Integration Support

-- ViewPopularBooks  -> Books with average rating > 4.5 + total loans

CREATE VIEW ViewPopularBooks AS
SELECT B.Book_ID,B.Title,b.ISBN, AVG(RB.Rating) AS 'AVERAGE RATING', COUNT(L.Loan_Date) AS TotalLoans
FROM Book B
LEFT JOIN ReviewBook RB ON B.Book_ID = RB.Book_ID
LEFT JOIN Loan L ON B.Book_ID = L.Book_ID
GROUP BY B.Book_ID, B.Title, B.ISBN
HAVING AVG(RB.Rating) > 4.5;

SELECT * FROM ViewPopularBooks;

-- ViewMemberLoanSummary  ->  Member loan count + total fines paid

CREATE VIEW ViewMemberLoanSummary AS
SELECT M.M_ID,M.FName + ' ' + M.LName AS 'MEMBER NAME ',COUNT(l.Loan_Date) AS 'TOTAL LOANS',ISNULL(SUM(p.Amount), 0) AS 'TOTAL FINES'
FROM Members M
LEFT JOIN Loan L ON M.M_ID = L.M_ID
LEFT JOIN Payment P ON M.M_ID = P.M_ID AND P.Loan_Date = L.Loan_Date AND P.Book_ID = L.Book_ID
GROUP BY M.M_ID, M.FName, M.LName;

SELECT * FROM ViewMemberLoanSummary;

-- ViewAvailableBooks  ->  Available books grouped by genre, ordered by price


CREATE VIEW ViewAvailableBooks AS
SELECT Genre, Title, Shelf_Location,Price
FROM Book
WHERE Available_State = 'TRUE'


SELECT * FROM ViewAvailableBooks
ORDER BY Price , Genre;
  

-- ViewLoanStatusSummary Loan stats (issued, returned, overdue) per library 

CREATE VIEW ViewLoanStatusSummary AS
SELECT LB.L_ID, L.Status, COUNT(*) AS 'STATUS COUNT'
FROM Loan L
LEFT JOIN Book B ON L.Book_ID = B.Book_ID
LEFT JOIN LibraryBook LB ON B.Book_ID = LB.Book_ID
GROUP BY LB.L_ID, L.Status;

SELECT * FROM ViewLoanStatusSummary;


-- ViewPaymentOverview -> Payment info with member, book, and status

CREATE VIEW ViewPaymentOverview AS
SELECT  P.P_Date AS 'PAYMENT DATE', P.Method AS 'PAYMENT METHOD',P.Amount AS 'PAYMENT AMOUNT',
M.M_ID AS 'MEMBER ID',M.FName+' '+ M.LName AS 'MEMBER NAME', B.Book_ID AS 'BOOK ID',
B.Title AS BookTitle,L.Status AS LoanStatus
FROM Payment P
INNER JOIN Members M ON P.M_ID = M.M_ID
INNER JOIN Book B ON P.Book_ID = B.Book_ID
INNER JOIN Loan L ON P.Loan_Date = L.Loan_Date 



SELECT * FROM ViewPaymentOverview;