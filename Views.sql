-- 2. Views – Frontend Integration Support-- ViewPopularBooks  -> Books with average rating > 4.5 + total loansCREATE VIEW ViewPopularBooks AS
SELECT B.Book_ID,B.Title,b.ISBN, AVG(RB.Rating) AS 'AVERAGE RATING', COUNT(L.Loan_Date) AS TotalLoans
FROM Book B
LEFT JOIN ReviewBook RB ON B.Book_ID = RB.Book_ID
LEFT JOIN Loan L ON B.Book_ID = L.Book_ID
GROUP BY B.Book_ID, B.Title, B.ISBN
HAVING AVG(RB.Rating) > 4.5;SELECT * FROM ViewPopularBooks;-- ViewMemberLoanSummary  ->  Member loan count + total fines paid