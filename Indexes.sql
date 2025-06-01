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


