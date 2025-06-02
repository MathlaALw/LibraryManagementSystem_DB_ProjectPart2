-- 6. Aggregation Functions – Dashboard Reports 
-- Tasks simulate admin dashboards: 
-- • Total fines per member 
SELECT  M_ID, SUM(Amount) AS TotalFines
FROM Payment
GROUP BY  M_ID;


-- • Most active libraries (by loan count) 


SELECT LB.L_ID AS LibraryID, COUNT(*) AS TotalLoans
FROM Loan L
INNER JOIN LibraryBook LB ON L.Book_ID = LB.Book_ID
GROUP BY LB.L_ID
ORDER BY TotalLoans DESC;

SELECT * FROM Loan


-- • Avg book price per genre 
SELECT Genre,AVG(Price) AS AveragePrice
FROM Book
GROUP BY Genre;


-- • Top 3 most reviewed books 

SELECT TOP 3 Book_ID, COUNT(*) AS ReviewCount
FROM ReviewBook
GROUP BY Book_ID
ORDER BY ReviewCount DESC;


-- • Library revenue report 

SELECT L.L_ID AS LibraryID, SUM(P.Amount) AS TotalRevenue
FROM Payment P 
INNER JOIN LibraryBook LB ON LB.Book_ID = P.Book_ID
INNER JOIN Library L ON L.L_ID = LB.L_ID
GROUP BY L.L_ID;













-- • Member activity summary (loan + fines) 

SELECT 
    m.MemberID,
    COUNT(DISTINCT l.LoanID) AS TotalLoans,
    SUM(p.Amount) AS TotalFines
FROM 
    Members m
LEFT JOIN 
    Loans l ON m.MemberID = l.MemberID
LEFT JOIN 
    Payments p ON m.MemberID = p.MemberID AND p.Status = 'Completed'
GROUP BY 
    m.MemberID;
