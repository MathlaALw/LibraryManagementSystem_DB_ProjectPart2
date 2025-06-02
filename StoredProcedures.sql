-- 4. Stored Procedures – Backend Automation

-- sp_MarkBookUnavailable(BookID) --> Updates availability after issuing

CREATE PROCEDURE sp_MarkBookUnavailable @BookID INT
AS
BEGIN
    UPDATE Book
    SET Available_State = 'FALSE'
    WHERE Book_ID = @BookID;
END;

-- EXECUTE sp_MarkBookUnavailable PROCEDURE

EXEC sp_MarkBookUnavailable @BookID = 34;

SELECT * FROM Book

-- sp_UpdateLoanStatus() --> Checks dates and updates loan statuses

CREATE PROCEDURE sp_UpdateLoanStatus
AS
BEGIN
    UPDATE Loan
    SET Status = CASE
        WHEN Return_Date IS NOT NULL THEN 'Returned'
        WHEN Due_Date < CAST(GETDATE() AS DATE) THEN 'Overdue'
        ELSE 'Issued'
    END
    WHERE Status <> CASE
        WHEN Return_Date IS NOT NULL THEN 'Returned'
        WHEN Due_Date < CAST(GETDATE() AS DATE) THEN 'Overdue'
        ELSE 'Issued'
    END;
END;


-- EXECUTE sp_UpdateLoanStatus PROCEDURE

EXEC sp_UpdateLoanStatus;

SELECT * FROM Loan



-- sp_RankMembersByFines() --> Ranks members by total fines paid 

CREATE PROCEDURE sp_RankMembersByFines
AS
BEGIN
    SELECT 
        M.M_ID,
        M.FName,
        M.LName,
        SUM(P.Amount) AS TotalFines,
        RANK() OVER (ORDER BY SUM(P.Amount) DESC) AS Rank
    FROM Members M
    JOIN Payment P ON M.M_ID = P.M_ID
    GROUP BY M.M_ID, M.FName, M.LName
    ORDER BY TotalFines DESC;
END;

-- EXECUTE sp_RankMembersByFines PROCEDURE

EXEC sp_RankMembersByFines;
