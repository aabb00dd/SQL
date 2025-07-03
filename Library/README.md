# Library Database SQL Scripts

This is a SQL scripts for managing a library database system. It includes table creation, queries, views, triggers, stored procedures, and functions to handle book leases, student records, and overdue fines.

## Features

### 1. **Database Schema**
- `Student`: Stores student information including ID, name, age, contact details, and address.
- `Book`: Contains book details such as ISBN, title, author, shelf location, and number of available copies.
- `BookLease`: Tracks book leases with student references, start date, lease duration, and return date.

### 2. **Queries**
- Retrieve students who have never borrowed a book.
- Calculate the average lease time for books (only completed leases).
- Display students, their leases, and borrowed books (including those who never borrowed).
- Identify students with ongoing leases and their expected return dates.
- Find overdue books and calculate fines (12.5 SEK per overdue day).

### 3. **Views**
- `CurrentlyRentedBooks`: Displays books that are currently rented, with student details and expected return dates.

### 4. **Triggers**
- `lease_update`: Automatically increases a book's available copies when it is returned.

### 5. **Stored Procedures**
- `LeaseBook`: Handles book leasing by checking availability and updating records accordingly.

### 6. **Functions**
- `FineAmount(leaseNum)`: Calculates overdue fines based on the lease duration.
- `CountBorrowed(ISBN)`: Determines how many times a book has been borrowed.

