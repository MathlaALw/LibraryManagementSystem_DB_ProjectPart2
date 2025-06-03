-- 8. Transactions – Ensuring Consistency
-- Real-world transactional flows: 
-- • Borrowing a book (loan insert + update availability) 
BEGIN TRANSACTION;

DECLARE @LoanDate DATE = GETDATE();
DECLARE @DueDate DATE = DATEADD(DAY, 14, @LoanDate); -- 2 weeks loan period
DECLARE @M_ID INT = 1;
DECLARE @Book_ID INT = 30; 

BEGIN TRY
    INSERT INTO Loan (Due_Date, Return_Date, Status, Loan_Date, M_ID, Book_ID)
    VALUES (@DueDate, NULL, 'Issued', @LoanDate, @M_ID, @Book_ID);

    UPDATE Book
    SET Available_State = 'FALSE'
    WHERE Book_ID = @Book_ID;

    COMMIT TRANSACTION;
    PRINT 'Book borrowed successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH;



-- • Returning a book (update status, return date, availability) 
BEGIN TRANSACTION;

DECLARE @ReturnDate DATE = GETDATE();
DECLARE @LoanDate1 DATE = '2023-01-10';
DECLARE @M_ID1 INT = 1; 
DECLARE @Book_ID1 INT = 30;

BEGIN TRY
    UPDATE Loan
    SET Return_Date = @ReturnDate,
        Status = 'Returned'
    WHERE Loan_Date = @LoanDate1
      AND M_ID = @M_ID1
      AND Book_ID = @Book_ID1;

    
    UPDATE Book
    SET Available_State = 'TRUE'
    WHERE Book_ID = @Book_ID1;

    COMMIT TRANSACTION;
    PRINT 'Book returned successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH;



-- • Registering a payment (with validation) 
BEGIN TRANSACTION;

DECLARE @P_Date DATE = GETDATE();
DECLARE @Method VARCHAR(200) = 'Credit Card';
DECLARE @LoanDate2 DATE = '2023-01-10';
DECLARE @M_ID2 INT = 1;
DECLARE @Book_ID2 INT = 30;
DECLARE @Amount DECIMAL(10,2) = 15.00;

BEGIN TRY
  
    IF EXISTS (
        SELECT 1 FROM Loan
        WHERE Loan_Date = @LoanDate2
          AND M_ID = @M_ID2
          AND Book_ID = @Book_ID2
          AND Status IN ('Returned', 'Overdue')
    )
    BEGIN
        INSERT INTO Payment (P_Date, Method, Loan_Date, M_ID, Book_ID, Amount)
        VALUES (@P_Date, @Method, @LoanDate2, @M_ID2, @Book_ID2, @Amount);

        COMMIT TRANSACTION;
        PRINT 'Payment registered successfully.';
    END
    ELSE
    BEGIN
        THROW 50000, 'Loan record not valid for payment.', 1;
    END
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH;




-- • Batch loan insert with rollback on failure 

BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO Loan (Due_Date, Return_Date, Status, Loan_Date, M_ID, Book_ID)
    VALUES
    (DATEADD(DAY, 14, GETDATE()), NULL, 'Issued', GETDATE(), 2, 31),
    (DATEADD(DAY, 14, GETDATE()), NULL, 'Issued', GETDATE(), 3, 32),
    (DATEADD(DAY, 14, GETDATE()), NULL, 'Issued', GETDATE(), 4, 33);

    UPDATE Book
    SET Available_State = 'FALSE'
    WHERE Book_ID IN (31, 32, 33);

    COMMIT TRANSACTION;
    PRINT 'Batch loan insert successful.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH;
