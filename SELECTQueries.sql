-- SELECT Queries
USE LibraryDatabase;
-- SELECT Queries 
-- – Think Like a Frontend API Imagine the following queries are API endpoints the frontend will call:

-- • GET /loans/overdue → List all overdue loans with member name, book title, due date
SELECT M.FName +' '+ M.LName AS 'FULL NAME' , B.Title AS 'BOOK TITLE' , L.Status AS 'LOAN STATUS' FROM Members M
INNER JOIN Loan L ON M.M_ID = L.M_ID
INNER JOIN Book B ON B.Book_ID = L.Book_ID WHERE L.Status ='Overdue'
