-- 1. Indexing Strategy – Performance Optimization
-- Apply indexes to speed up commonly-used queries:

USE LibraryDatabase;
-- Library Table
-- • Non-clustered on Name → Search by name
CREATE NONCLUSTERED INDEX Library_Name ON Library(L_Name);

-- • Non-clustered on Location → Filter by location
CREATE NONCLUSTERED INDEX Library_Location ON Library(Location);




-- Book Table
-- • Clustered on LibraryID, ISBN → Lookup by book in specific library

CREATE NONCLUSTERED INDEX Book_ISBN ON Book(ISBN);
CREATE CLUSTERED INDEX LibraryBook_LibraryID_BookID ON LibraryBook(L_ID, Book_ID);


-- • Non-clustered on Genre → Filter by genre
CREATE NONCLUSTERED INDEX Book_Genre ON Book(Genre);




-- Loan Table
-- • Non-clustered on MemberID → Loan history
CREATE NONCLUSTERED INDEX Loan_MemberID ON Loan(M_ID);

-- • Non-clustered on Status → Filter by status
CREATE NONCLUSTERED INDEX Loan_Status ON Loan(Status);

-- • Composite index on BookID, LoanDate, ReturnDate → Optimize overdue checks
CREATE NONCLUSTERED INDEX Loan_Book_Loan_Return ON Loan(Book_ID, Loan_Date, Return_Date);
