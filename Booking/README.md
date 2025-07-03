# Booking Database SQL Queries

## Overview
This project contains a comprehensive set of SQL queries for managing a car rental booking system. The queries cover various SQL operations, including selection, projection, restriction, aggregation, joins, nested queries, and database modifications.

## Database Schema
The database consists of the following tables:
- **Cars**: Stores details about cars available for rent.
- **Customers**: Contains customer information.
- **Bookings**: Records booking details linking customers and cars.

## Queries and Features
### Basic Queries
- Retrieve all customer records.
- Fetch specific customer details like name and birthdate.
- Filter cars based on price and color.
- Sort customer records in ascending and descending order.

### Aggregation Functions
- Calculate the average and total rental price of cars.
- Count the number of cars by color.
- Find the most expensive car.

### Joins
- Perform Cartesian products and inner joins between tables.
- Retrieve customer names who have made bookings.
- Find all booked Volkswagen cars and customers who rented them.
- Identify cars that have never been booked.

### Nested Queries
- Find cars that cost more than the average price.
- Retrieve the cheapest black car.
- Identify black cars that have been booked using subqueries.

### IN and BETWEEN Operators
- Filter cars and customers based on specific price ranges or birth years.
- Identify bookings within certain date ranges.

### Advanced Queries
- Determine available cars for booking within a specific date range.
- Find the most frequently booked car.
- Identify customers born in specific months who have booked a car.

### Data Modification
- Delete customers with incorrect birthdates.
- Update rental prices of specific car brands.
- Adjust prices based on currency conversion.

### Views
- Create views for black cars and their weekly rental prices.
- Define a view for currently available cars.

### Functions
- Implement a function to check if a car is available for rent.
- Create a function to sum the total rental days for cars.

### Stored Procedures
- Retrieve all available cars between two dates.
- Handle car bookings by verifying availability before inserting a record.

### Triggers
- Add a column to track the number of times a customer has booked a car.
- Implement a trigger to update this column after each successful booking.
