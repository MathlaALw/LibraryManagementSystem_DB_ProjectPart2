-- 1. Indexing Strategy – Performance Optimization
-- Apply indexes to speed up commonly-used queries:

USE LibraryDatabase;
-- Library Table
-- • Non-clustered on Name → Search by name
CREATE NONCLUSTERED INDEX Library_Name ON Library(L_Name);
