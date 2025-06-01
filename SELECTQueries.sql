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