-- 5. Triggers – Real-Time Business Logic 


-- trg_UpdateBookAvailability ---> After new loan → set book to unavailable 
CREATE TRIGGER trg_UpdateBookAvailability
ON Loan
AFTER INSERT
AS
BEGIN
    UPDATE Book
    SET Available_State = 'False'
    WHERE Book_ID IN (SELECT Book_ID FROM Book);
END;


SELECT * FROM Loan

-- Inserting a loan 
INSERT INTO Loan ( Due_Date, Return_Date, Status , Loan_Date , M_ID ,Book_ID)
VALUES ('2025-06-02', '2025-06-10', 'Issued' ,'2023-03-30' ,1,31 );


--------------------

-- trg_CalculateLibraryRevenue ---> After new payment → update library revenue

CREATE TRIGGER trg_CalculateLibraryRevenue
ON Payment
AFTER INSERT
AS
BEGIN
    UPDATE Library
    SET TotalRevenue = TotalRevenue + (SELECT SUM(Amount) FROM Payment)
    WHERE L_ID IN (SELECT L_ID FROM LibraryBook);
END;


SELECT * FROM Payment

-- Inserting a payment
INSERT INTO Payment (P_Date, Method,Loan_Date,M_ID,Book_ID, Amount)
VALUES ('2023-03-30','Cash','2023-02-05',1,31,200);


----------------

-- trg_LoanDateValidation ---> Prevents invalid return dates on insert

CREATE TRIGGER trg_LoanDateValidation
ON Loan
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Return_Date < Loan_Date )
    BEGIN
        RAISERROR ('Return date cannot be earlier than loan date.', 16, 1);
        ROLLBACK;
        RETURN;
    END

	INSERT INTO Loan ( Due_Date, Return_Date, Status , Loan_Date , M_ID ,Book_ID)
	SELECT Due_Date, Return_Date, Status , Loan_Date , M_ID ,Book_ID FROM Loan;
  
END;



INSERT INTO Loan ( Due_Date, Return_Date, Status , Loan_Date , M_ID ,Book_ID)
VALUES ('2025-06-05', '2025-06-15', 'Issued' ,'2023-01-10' ,1,00 );

-- ERROR -- 
-- Violation of PRIMARY KEY constraint 'PK__Loan__19B2C0F7A817CB56'. Cannot insert duplicate key in object 'dbo.Loan'. The duplicate key value is (2023-01-10, 1, 30).


