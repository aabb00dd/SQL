use Library;


-- Write an SQL statement that shows info about students who have not borrowed any book. Table should have the following columns: stNum | Fname | Lname | numOfLeases.
SELECT S.stNum, S.Fname, S.Lname, COUNT(L.leaseNumber) AS numOfLeases
FROM student S
LEFT JOIN booklease L ON S.stNum = L.stNum
GROUP BY S.stNum
HAVING numOfLeases = 0;


-- Write an SQL statement that shows each Book and its average lease time (the actual days, not the planned ones), only count leases 
-- that are completed (dateReturned is available). The result table should show the following columns: the ISBN, Title, and the average rental days as “AverageBorrowTime”.
SELECT B.ISBN, B.Title, AVG(DATEDIFF(L.dateReturned, L.startDate)) AS AverageBorrowTime
FROM book B
JOIN booklease L ON B.ISBN = L.ISBN
WHERE L.dateReturned IS NOT NULL
GROUP BY B.ISBN, B.Title;


-- Create a view that shows which Books are currently rented (dateReturned is null), with the columns ISBN, Title, Fname, Lname, 
-- and expected return date (e.g., startDate plus leaseInDays) as “ExpectedDate”.
CREATE VIEW CurrentlyRentedBooks AS
SELECT BL.ISBN, B.Title, S.Fname, S.Lname, DATE_ADD(BL.startDate, INTERVAL BL.leaseInDays DAY) AS ExpectedDate
FROM booklease BL
JOIN book B ON BL.ISBN = B.ISBN
JOIN student S ON BL.stNum = S.stNum
WHERE BL.dateReturned IS NULL;


-- Create a trigger on the BookLease table which, when a lease is returned (when null is changed to date in returnDate), increases the respective Book's number of copies by 1.
DROP TRIGGER IF EXISTS lease_update;
DELIMITER //
CREATE TRIGGER lease_update AFTER UPDATE ON booklease
FOR EACH ROW
BEGIN
    IF NEW.dateReturned IS NOT NULL AND OLD.dateReturned IS NULL THEN
        UPDATE book SET numOfCopies = numOfCopies + 1 WHERE ISBN = NEW.ISBN;
    END IF;
END //
DELIMITER ;

SELECT * FROM BookLease;
update BookLease set datereturned = "2021-12-11" where leasenumber = 6;


-- Create a procedure that handles a lease of a book. Checks must be made so that the book’s number of copies is not equal to zero. If no copy is available of the book (numOfCopies = 0) the lease must not go through (aborted). 
-- The procedure must check if the book is still available and do the following actions:
-- if available, it inserts the new row into the BookLease table, it decrements the numOfCopies in the Book table, and it displays the message “Row inserted”.
-- Else, nothing will happen except getting the message: “Row NOT inserted! No copies available.”
DROP PROCEDURE IF EXISTS LeaseBook;
DELIMITER $$
CREATE PROCEDURE LeaseBook (
    IN xleaseNumber INT,
    IN xISBN VARCHAR(40),
    IN xstNum VARCHAR(40),
    IN xstartDate DATE,
    IN xleaseInDays INT,
    IN xdateReturned DATE,
    OUT txt TEXT
)
BEGIN
    DECLARE copies INT;
    
    SELECT numOfCopies INTO copies
    FROM book
    WHERE ISBN = xISBN;
    
    IF copies > 0 THEN
        INSERT INTO booklease VALUES (xleaseNumber, xISBN, xstNum, xstartDate, xleaseInDays, xdateReturned);
        UPDATE book SET numOfCopies = numOfCopies - 1 WHERE ISBN = xISBN;
        SET txt = 'Row inserted';
    ELSE
        SET txt = 'Row NOT inserted! No copies available';
    END IF;
    
    SELECT txt;
END $$
DELIMITER 

sELECT * FROM booklease;
SELECT * FROM book;

CALL CheckProc (11, 'F-0055-G', 'W6T5WZG', '2021-11-03', 10, NULL, @str); 
CALL CheckProc (12, 'F-0055-G', 'W6T5WZG', '2021-11-03', 10, NULL, @str); 
CALL CheckProc (13, 'F-0055-G', 'W6T5WZG', '2021-11-03', 10, NULL, @str); 
CALL CheckProc (14, 'F-0055-G', 'W6T5WZG', '2021-11-03', 10, NULL, @str); 
CALL CheckProc (15, 'F-0055-G', 'W6T5WZG', '2021-11-03', 10, NULL, @str);


-- Write an SQL statement that shows all students, each lease the student has made, and which books they have borrowed. If a student has not made any lease, s/he must still appear in the results. The result table should show the following columns: stNum | combine FName and LName as name_ | leaseNumber | ISBN. Display leaseNumber in descending order.
SELECT S.stNum, CONCAT(S.Fname, ' ', S.Lname) AS name_, L.leaseNumber, L.ISBN
FROM student S
LEFT JOIN booklease L ON S.stNum = L.stNum
ORDER BY L.leaseNumber DESC;


-- Write an SQL statement that displays the students who are still borrowing a book. The result table should show the following columns: studentName (concatenate with a space: Fname and Lname), Title and ExpectedReturnDate.
SELECT CONCAT(S.Fname, ' ', S.Lname) AS studentName, B.Title, DATE_ADD(L.startDate, INTERVAL L.leaseInDays DAY) AS ExpectedReturnDate
FROM booklease L
JOIN student S ON L.stNum = S.stNum
JOIN book B ON L.ISBN = B.ISBN
WHERE L.dateReturned IS NULL;


-- Let’s say that the library imposes a fine of 12.5 SEK for each day a book is overdue. Write a SQL statement that shows each rented book, the student’s name, number of overdue days, and the overdue amount. The result table should show the following columns: the leaseNumber, ISBN, Fname, Lname, numOfOverdueDays, and totalAmount (OBS! Only show the students who have overdue amount). Use a function that accepts an input (i.e., leaseNumber) and returns numOfOverdueDays.
DROP FUNCTION IF EXISTS FineAmount;
DELIMITER $$
CREATE FUNCTION FineAmount (leaseNum INT) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE overdueDays INT;
    DECLARE fine DECIMAL(10, 2);
    
    SELECT DATEDIFF(CURDATE(), L.startDate) - L.leaseInDays INTO overdueDays
    FROM booklease L
    WHERE L.leaseNumber = leaseNum;
    
    IF overdueDays > 0 THEN
        SET fine = overdueDays * 12.5;
    ELSE
        SET fine = 0;
    END IF;
    
    RETURN fine;
END $$
DELIMITER ;

SELECT BL.leaseNumber, BL.ISBN, S.Fname, S.Lname, DATEDIFF(CURDATE(), BL.startDate) AS numOfOverdueDays, FineAmount(BL.leaseNumber) AS totalAmount
FROM booklease BL
LEFT JOIN student S ON BL.stNum = S.stNum
WHERE FineAmount(BL.leaseNumber) > 0;


-- Create a function that accepts as an input the book ISBN and outputs the number of times this book has been borrowed (from table BookLease). Plug this function into a SELECT statement to display the books in descending order by numOfTimes, if a book has never been borrowed (i.e, H-0082-M), it still must be shown. The table should have the following columns: ISBN | Title | numOfTimes
DROP FUNCTION IF EXISTS CountBorrowed;
DELIMITER $$
CREATE FUNCTION CountBorrowed (isbn VARCHAR(40)) RETURNS INT
BEGIN
    DECLARE count INT;
    
    SELECT COUNT(*) INTO count
    FROM booklease
    WHERE ISBN = isbn;
    
    RETURN count;
END $$
DELIMITER ;

SELECT B.ISBN, B.Title, CountBorrowed(B.ISBN) AS numOfTimes
FROM book B
ORDER BY numOfTimes DESC;
