# Developer Reflection 

**What Part Was Hardest and Why?**

**The implementation of triggers and stored procedures**
probably presented several difficulties. 
A thorough understanding of SQL and database behavior is necessary for these components. 
It might be difficult to make that triggers operate as intended without producing unexpected side effects or performance problems.
Writing effective stored procedures that manage a variety of edge circumstances also necessitates thorough preparation and testing.


**Which Concept Helped Me Think Like a Backend Developer?**

A backend developer attitude would have been greatly enhanced by the use of **transactions and advanced aggregations**.
Particularly in systems where several activities must either all succeed or fail simultaneously, transactions provide data consistency and integrity. 
For backend data processing and reporting, advanced aggregations aid in the effective summarization and analysis of data.

**How Would They Test This if It Were a Live Web App?**

**- Unit Testing:** Verifying individual stored procedures, functions, and triggers to ensure they work as intended.

**- Integration Testing:** Ensuring that different parts of the system interact correctly, such as the interaction between the application layer and the database.

**- Performance Testing:** Assessing how the system performs under load, especially the efficiency of complex queries and the responsiveness of the application.

**- Security Testing:** Checking for vulnerabilities like SQL injection, ensuring that user inputs are properly sanitized.
