--  7. Advanced Aggregations – Analytical Insight

-- Includes: 
-- • HAVING for filtering aggregates 
SELECT Genre,AVG(Rating) AS AverageRating
FROM ReviewBook RB
INNER JOIN Book B ON RB.Book_ID = B.Book_ID
GROUP BY Genre
HAVING AVG(Rating) >= 4.5;


-- • Subqueries for complex logic (e.g., max price per genre) 
SELECT Genre,Title,Price
FROM Book b
WHERE Price = (SELECT MAX(Price) FROM Book BB WHERE BB.Genre = B.Genre );


-- • Occupancy rate calculations 

SELECT
L.L_Name,
CAST(SUM(CASE WHEN B.Available_State <> 'Available' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS OccupancyRate
FROM Book B 
INNER JOIN LibraryBook LB ON B.Book_ID = LB.Book_ID
INNER JOIN Library L ON L.L_ID =LB.L_ID
GROUP BY L.L_Name;

-- • Members with loans but no fine 

SELECT M.M_ID, M.FName, M.LName
FROM Members M
INNER JOIN Loan L ON M.M_ID = L.M_ID
LEFT JOIN Payment P ON L.Book_ID = P.Book_ID
WHERE P.P_Date IS NULL 
GROUP BY M.M_ID, M.FName, M.LName;


SELECT * FROM Payment

-- • Genres with high average ratings

SELECT TOP 1 AVG(RB.Rating) AS AverageRating, B.Genre
FROM ReviewBook RB
INNER JOIN Book B ON RB.Book_ID = B.Book_ID
GROUP BY B.Genre


