# SELECT Queries

**SELECT Queries**  
– Think Like a Frontend API Imagine the following queries are API endpoints the
frontend will call:

**• GET /loans/overdue → List all overdue loans with member name, book title, due date**

```sql
SELECT M.FName +' '+ M.LName AS 'FULL NAME' , B.Title AS 'BOOK TITLE' , L.Status AS 'LOAN STATUS' FROM Members M
INNER JOIN Loan L ON M.M_ID = L.M_ID
INNER JOIN Book B ON B.Book_ID = L.Book_ID WHERE L.Status ='Overdue'
```
![List all overdue loans with member name, book title, due date](./image/GET-loans-overdue.png)

**• GET /books/unavailable → List books not available**
```sql
SELECT * FROM Book WHERE Available_State = 'False'
```
![List books not available](./image/GET-books-unavailable.png)
**• GET /members/top-borrowers → Members who borrowed >2 books**
```sql
SELECT M.FName + ' ' + M.LName AS 'MEMEBER NAME', COUNT (B.M_ID) AS 'TOTAL BORROWED' FROM Members M 
INNER JOIN Book B ON M.M_ID = B.M_ID
GROUP BY M.FName,M.LName, M.M_ID
HAVING COUNT (B.M_ID)  > 2;
```
![Members who borrowed >2 books](./image/GET-members-top-borrowers.png)

**• GET /books/:id/ratings → Show average rating per book**
```sql
SELECT Book_ID AS 'BOOK ID' , AVG(Rating) AS 'AVERAGE RATING' FROM ReviewBook 
GROUP BY Book_ID

```
![Show average rating per book](./image/GET-books-id-ratings.png)
**• GET /libraries/:id/genres → Count books by genre**
```sql
SELECT Genre, COUNT(*) AS 'GENRE COUNT'
FROM Book 
GROUP BY Genre;
```
![Count books by genre](./image/GET-libraries-id-genres.png)

**• GET /members/inactive → List members with no loans**
```sql
SELECT * 
FROM Members 
WHERE M_ID NOT IN (SELECT DISTINCT M_ID FROM Loan);
```
![List members with no loans](./image/GET-members-inactive.png)

**• GET /payments/summary → Total fine paid per member**
```sql
SELECT M.FName + ' ' + M.LName AS 'MEMBER NAME', SUM(P.Amount) AS 'TOTAL FINE'
FROM Payment P
JOIN Members M ON P.M_ID = M.M_ID
GROUP BY M.FName, M.LName;
```

![Total fine paid per member](./image/GET-payments-summary.png)


**• GET /reviews → Reviews with member and book info**
```sql

```
**• GET /books/popular → List top 3 books by number of times they were loaned**
```sql

```
**• GET /members/:id/history → Retrieve full loan history of a specific member including book title,loan & return dates**
```sql

```
**• GET /books/:id/reviews → Show all reviews for a book with member name and comments**
```sql

```
**• GET /libraries/:id/staff → List all staff working in a given library**
```sql

```
**• GET /books/price-range?min=5&max=15 → Show books whose prices fall within a given range**
```sql

```
**• GET /loans/active → List all currently active loans (not yet returned) with member and book info**
```sql

```
**• GET /members/with-fines → List members who have paid any fine**
```sql

```
**• GET /books/never-reviewed → List books that have never been reviewed**
```sql

```
**• GET /members/:id/loan-history →Show a member’s loan history with book titles and loan status.**
```sql

```
**• GET /members/inactive →List all members who have never borrowed any book.**
```sql

```
**• GET /books/never-loaned → List books that were never loaned.**
```sql

```
**• GET /payments →List all payments with member name and book title.**
```sql

```
**• GET /loans/overdue→ List all overdue loans with member and book details.**
```sql

```
**• GET /books/:id/loan-count → Show how many times a book has been loaned.**
```sql

```
**• GET /members/:id/fines → Get total fines paid by a member across all loans.**
```sql

```
**• GET /libraries/:id/book-stats → Show count of available and unavailable books in a library.**
```sql

```
**• GET /reviews/top-rated → Return books with more than 5 reviews and average rating > 4.5.**
```sql

```