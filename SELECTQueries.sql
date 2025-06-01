-- SELECT Queries
USE LibraryDatabase;
-- SELECT Queries 
-- – Think Like a Frontend API Imagine the following queries are API endpoints the frontend will call:

-- • GET /loans/overdue → List all overdue loans with member name, book title, due date
SELECT M.FName +' '+ M.LName AS 'FULL NAME' , B.Title AS 'BOOK TITLE' , L.Status AS 'LOAN STATUS' FROM Members M
INNER JOIN Loan L ON M.M_ID = L.M_ID
INNER JOIN Book B ON B.Book_ID = L.Book_ID WHERE L.Status ='Overdue'
-- • GET /books/unavailable → List books not available
SELECT * FROM Book WHERE Available_State = 'False'
-- • GET /members/top-borrowers → Members who borrowed >2 books
SELECT M.FName + ' ' + M.LName AS 'MEMEBER NAME', COUNT (B.M_ID) AS 'TOTAL BORROWED' FROM Members M 
INNER JOIN Book B ON M.M_ID = B.M_ID
GROUP BY M.FName,M.LName, M.M_ID
HAVING COUNT (B.M_ID)  > 2;
-- • GET /books/:id/ratings → Show average rating per book
SELECT Book_ID AS 'BOOK ID' , AVG(Rating) AS 'AVERAGE RATING' FROM ReviewBook 
GROUP BY Book_ID
-- • GET /libraries/:id/genres → Count books by genre
SELECT Genre, COUNT(*) AS 'GENRE COUNT'
FROM Book 
GROUP BY Genre;
-- • GET /members/inactive → List members with no loans
SELECT * 
FROM Members 
WHERE M_ID NOT IN (SELECT DISTINCT M_ID FROM Loan);
-- • GET /payments/summary → Total fine paid per member
SELECT M.FName + ' ' + M.LName AS 'MEMBER NAME', SUM(P.Amount) AS 'TOTAL FINE'
FROM Payment P
JOIN Members M ON P.M_ID = M.M_ID
GROUP BY M.FName, M.LName;
-- • GET /reviews → Reviews with member and book info
 SELECT  M.FName +' '+M.LName AS 'MEMBER NAME' ,B.* ,RB.Rating AS 'RATING', RB.Comments AS 'COMMENTS',RB.Review_Date AS 'REVIEW DATE' FROM ReviewBook RB 
 INNER JOIN Book B ON B.Book_ID = RB.Book_ID 
 INNER JOIN Members M ON M.M_ID = B.M_ID
-- • GET /books/popular → List top 3 books by number of times they were loaned
SELECT TOP 3 B.Title, COUNT(*) AS Loan_Count
FROM Loan L
JOIN Book B ON L.Book_ID = B.Book_ID
GROUP BY B.Title
ORDER BY Loan_Count DESC;
-- • GET /members/:id/history → Retrieve full loan history of a specific member including book title,loan & return dates
SELECT M.* , B.Title AS 'BOOK TITLE' , L.Loan_Date AS 'LONE DATE' ,L.Return_Date AS 'RETURN DATE' FROM Members M 
INNER JOIN Loan L ON M.M_ID = L.M_ID
INNER JOIN Book B ON B.Book_ID = L.Book_ID
-- • GET /books/:id/reviews → Show all reviews for a book with member name and comments
SELECT  RB .* ,M.FName +' '+M.LName AS 'MEMBER NAME' FROM ReviewBook RB
LEFT JOIN Members M ON M.M_ID = RB.M_ID 
-- • GET /libraries/:id/staff → List all staff working in a given library
SELECT S.* , l.L_Name AS 'LIBRARY NAME' FROM Staff S INNER JOIN Library L ON L.L_ID = S.L_ID
-- • GET /books/price-range?min=5&max=15 → Show books whose prices fall within a given range
SELECT * FROM Book WHERE Price BETWEEN 5 AND 15
-- • GET /loans/active → List all currently active loans (not yet returned) with member and book info
SELECT L.* , B.* , M.FName +' '+M.LName AS 'MEMBER NAME' FROM Members M 
INNER JOIN Loan L ON M.M_ID = L.M_ID 
INNER JOIN Book B ON B.Book_ID = L.Book_ID
WHERE L.Status='Issued'
-- • GET /members/with-fines → List members who have paid any fine
SELECT M.* , P.Amount FROM Members M
INNER JOIN Payment P ON M.M_ID = P.M_ID
-- • GET /books/never-reviewed → List books that have never been reviewed
SELECT * 
FROM Book 
WHERE Book_ID NOT IN (SELECT DISTINCT Book_ID FROM ReviewBook);

-- • GET /members/:id/loan-history →Show a member’s loan history with book titles and loan status.
SELECT L.* ,B.Title AS 'BOOK TITLE', L.Status  FROM Loan L 
INNER JOIN Book B ON B.Book_ID=L.Book_ID
-- • GET /members/inactive →List all members who have never borrowed any book.
SELECT * FROM Members WHERE M_ID NOT IN (SELECT DISTINCT M_ID FROM Loan);

-- • GET /books/never-loaned → List books that were never loaned.
SELECT * FROM Book WHERE Book_ID NOT IN (SELECT DISTINCT Book_ID FROM Loan);
-- • GET /payments →List all payments with member name and book title.
SELECT P.* ,M.FName +' '+M.LName AS 'MEMBER NAME' , B.Title AS 'BOOK TITLE' FROM Members M 
INNER JOIN Book B ON M.M_ID = B.M_ID
INNER JOIN Payment P ON B.Book_ID= P.Book_ID


-- • GET /loans/overdue→ List all overdue loans with member and book details.
SELECT M.FName +' '+ M.LName AS 'FULL NAME' , B.* , L.* FROM Members M
INNER JOIN Loan L ON M.M_ID = L.M_ID
INNER JOIN Book B ON B.Book_ID = L.Book_ID WHERE L.Status ='Overdue'


-- • GET /books/:id/loan-count → Show how many times a book has been loaned.
SELECT COUNT(*) AS Loan_Count FROM Loan
-- • GET /members/:id/fines → Get total fines paid by a member across all loans.
SELECT SUM(Amount) AS Total_Fines FROM Payment