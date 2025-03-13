USE Booking;


-- Selection, Projection, and Restriction
-- Show all customers with all their information.
SELECT * FROM Customers;

-- Show all customers, but only with their name and birthdate.
SELECT Name, Birthdate FROM Customers;

-- Show all cars that cost more than 1000:- per day.
SELECT * FROM Cars WHERE PricePerDay > 1000;

-- Show all Volvo cars, only with their brand name and their model.
SELECT Brand, Model FROM Cars WHERE Brand = 'Volvo';

-- Show all customers, only with their names, in a sorted fashion based on their name. Both in ascending and descending order.
SELECT Name FROM Customers ORDER BY Name DESC;
SELECT Name FROM Customers ORDER BY Name ASC;

-- Show all customers, only with their names, that were born in 1990 or later in a sorted fashion based on their birthdate.
SELECT Name, Birthdate FROM Customers WHERE YEAR(Birthdate) >= 1990 ORDER BY Birthdate DESC;

-- Show all cars that are red and cost less than 1500.
SELECT * FROM Cars WHERE Color = 'Red' AND PricePerDay < 1500;

-- Show all customers, only with their names, that were born between 1970-1990.
SELECT Name, Birthdate FROM Customers WHERE YEAR(Birthdate) BETWEEN 1970 AND 1990;

-- Show all bookings that are longer than 6 days.
SELECT * FROM Bookings WHERE DATEDIFF(EndDate, StartDate) > 6;

-- Show all bookings that overlap with the interval 2018-02-01 - 2018-02-25.
SELECT * FROM Bookings WHERE StartDate <= '2018-02-25' AND EndDate >= '2018-02-01';

-- Show all customers whose first name starts with an O.
SELECT * FROM Customers WHERE Name LIKE 'O%';


-- Aggregated Functions
-- Show the average price per day for the cars.
SELECT AVG(PricePerDay) FROM Cars;

-- Show the total price per day for the cars.
SELECT SUM(PricePerDay) FROM Cars;

-- Show the average price for red cars.
SELECT AVG(PricePerDay) FROM Cars WHERE Color = 'Red';

-- Show the total price for all cars grouped by the different colors.
SELECT Color, SUM(PricePerDay) FROM Cars GROUP BY Color;

-- Show how many cars are of red color.
SELECT COUNT(CarNumber) FROM Cars WHERE Color = 'Red';

-- Show how many cars exist of each color.
SELECT Color, COUNT(CarNumber) FROM Cars GROUP BY Color;

-- Show the car that is the most expensive to rent.
SELECT * FROM Cars ORDER BY PricePerDay DESC LIMIT 1;


-- Joins
-- Show the Cartesian product between Cars and Bookings.
SELECT * FROM Cars CROSS JOIN Bookings;

-- Show the Cartesian product between Customers and Bookings.
SELECT * FROM Customers, Bookings;

-- Show the results of converting the previous two joins to inner joins.
SELECT * FROM Customers INNER JOIN Bookings ON Customers.CustomerNumber = Bookings.CustomerNumber;
SELECT * FROM Cars INNER JOIN Bookings ON Cars.CarNumber = Bookings.CarNumber;

-- Show the names of all the customers that have made a booking.
SELECT Name FROM Customers INNER JOIN Bookings ON Customers.CustomerNumber = Bookings.CustomerNumber;

-- Same as the previous but without all the duplicates.
SELECT DISTINCT Name FROM Customers INNER JOIN Bookings ON Customers.CustomerNumber = Bookings.CustomerNumber;

-- Show all the Volkswagen cars that have been booked at least once.
SELECT * FROM Cars INNER JOIN Bookings ON Cars.CarNumber = Bookings.CarNumber WHERE Cars.Brand = 'Volkswagen';

-- Show all the customers that have rented a Volkswagen.
SELECT * FROM ((Bookings INNER JOIN Cars ON Cars.CarNumber = Bookings.CarNumber)
    INNER JOIN Customers ON Customers.CustomerNumber = Bookings.CustomerNumber) WHERE Brand = 'Volkswagen';

-- Show all cars that have been booked at least once.
SELECT DISTINCT Cars.* FROM Cars INNER JOIN Bookings ON Cars.CarNumber = Bookings.CarNumber;

-- Show all cars that have never been booked.
SELECT * FROM Cars LEFT JOIN Bookings ON Cars.CarNumber = Bookings.CarNumber WHERE Bookings.CarNumber IS NULL;

-- Show all the black cars that have been booked at least once.
SELECT DISTINCT Cars.* FROM Cars INNER JOIN Bookings ON Cars.CarNumber = Bookings.CarNumber WHERE Cars.Color = 'Black';


-- Nested Queries
-- Show all the cars that cost more than the average.
SELECT * FROM Cars WHERE PricePerDay > (SELECT AVG(PricePerDay) FROM Cars);

-- Show the car with the lowest cost with black color.
SELECT * FROM Cars WHERE Color = 'Black' ORDER BY PricePerDay ASC LIMIT 1;

-- Show the car which has the lowest cost.
SELECT * FROM Cars ORDER BY PricePerDay ASC LIMIT 1;

-- Show all the black cars that have been booked at least once by using a sub query.
SELECT * FROM Cars WHERE CarNumber IN (SELECT CarNumber FROM Bookings) AND Color = 'Black';


-- IN
-- Show all cars that have the cost 700, 800, and 850.
SELECT * FROM Cars WHERE PricePerDay IN (700, 800, 850);

-- Show all the customers that were born in 1990, 1995, and 2000.
SELECT * FROM Customers WHERE YEAR(Birthdate) IN (1990, 1995, 2000);

-- Show all the bookings that start on 2018-01-03, 2018-02-22, or 2018-03-18.
SELECT * FROM Bookings WHERE StartDate IN ('2018-01-03', '2018-02-22', '2018-03-18');


-- BETWEEN
-- Show all cars whose price is in the range 600 - 1000.
SELECT * FROM Cars WHERE PricePerDay BETWEEN 600 AND 1000;

-- Show all the customers who are born between 1960 - 1980.
SELECT * FROM Customers WHERE YEAR(Birthdate) BETWEEN 1960 AND 1980;

-- Show all bookings that last between 2 - 4 days.
SELECT * FROM Bookings WHERE DATEDIFF(EndDate, StartDate) BETWEEN 2 AND 4;


-- A mix of everything
-- Show all the cars that are eligible for booking between 2018-01-10 - 2018-01-20.
SELECT * FROM Cars WHERE CarNumber NOT IN (SELECT Bookings.CarNumber FROM Bookings WHERE StartDate <= '2018-01-20' AND EndDate >= '2018-01-10');

-- Show the car that has been booked the most.
SELECT COUNT(Cars.CarNumber), Cars.CarNumber FROM Cars INNER JOIN Bookings ON Cars.CarNumber = Bookings.CarNumber GROUP BY Cars.CarNumber ORDER BY COUNT(Cars.CarNumber) DESC LIMIT 1;

-- Show all the customers who are born in January or February and have booked at least one car.
SELECT * FROM Customers INNER JOIN Bookings ON Customers.CustomerNumber = Bookings.CustomerNumber WHERE MONTH(Birthdate) IN (1, 2);
SELECT * FROM Customers WHERE MONTH(Birthdate) IN (1, 2) AND CustomerNumber IN (SELECT CustomerNumber FROM Bookings);


-- DELETE, UPDATE, ALTER, & INSERT
-- There is a customer born in 1800 according to the records, this is obviously not possible so delete that customer.
DELETE FROM Customers WHERE YEAR(Birthdate) = 1800;

-- The Tesla X car that is available for renting needs to have its price increased by 200:-.
UPDATE Cars SET PricePerDay = PricePerDay + 200 WHERE Brand = 'Tesla';

-- All the Peugeot cars also need to be increased in price, in this case by 20%.
UPDATE Cars SET PricePerDay = PricePerDay * 1.2 WHERE Brand = 'Peugeot';

-- Now we fast forward into the future and Sweden has changed its currency to Euros (€). Fix both the data itself (assume the conversion rate is 10 SEK == 1 EUR) and the table so it can handle the new prices.
UPDATE Cars SET PricePerDay = PricePerDay / 10;


-- VIEW
-- Create a view that shows all the information about black cars.
CREATE VIEW Black_Cars AS SELECT * FROM Cars WHERE Color = 'Black';
SELECT * FROM Black_Cars;

-- Create a view that shows all information about black cars and the addition of the weekly price as a column.
CREATE VIEW Black_Cars2 AS SELECT *, PricePerDay * 7 AS WeeklyPrice FROM Cars WHERE Color = 'Black';
SELECT * FROM Black_Cars2;

-- Create a view that shows all the cars available for booking at this current time.
CREATE VIEW Available_Cars_View AS SELECT * FROM Cars WHERE CarNumber NOT IN (SELECT CarNumber FROM Bookings WHERE StartDate <= NOW() AND EndDate >= NOW());
SELECT * FROM Available_Cars_View;

-- Alter the previous view, with the condition that the cars have to be available for at least 3 days of renting.
CREATE VIEW Available_Cars_View2 AS SELECT * FROM Cars WHERE CarNumber NOT IN (SELECT CarNumber FROM Bookings WHERE StartDate <= NOW() AND EndDate >= NOW() OR DATEDIFF(EndDate, StartDate) < 3);
SELECT * FROM Available_Cars_View2;


-- Functions
-- Create a function that checks if a car is available for renting between two dates.
-- The input to the function should be the starting and ending dates of the rental, the car's number,
-- and it should return 0 if it is not available and 1 if it is available between the two dates.

DROP FUNCTION IF EXISTS Check_Car;
DELIMITER $$
CREATE FUNCTION Check_Car(Start_Date DATE, End_Date DATE, CarNum INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE available INT;
    
    SELECT COUNT(*) INTO available
    FROM Bookings
    WHERE CarNumber = CarNum
    AND StartDate <= End_Date
    AND EndDate >= Start_Date;
    
    IF available > 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END$$
DELIMITER ;

SELECT Check_Car('2018-01-02', '2018-01-15', 1);

-- Create a function that sums the total amount of days cars have been booked and returns the sum.
-- If there is an input parameter that matches a car's unique number, then it should only return the sum of that car.
-- If the number doesn't match or it is -1, it returns the total sum as before.

DROP FUNCTION IF EXISTS Count_Car;
DELIMITER $$
CREATE FUNCTION Count_Car(CarNum INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_days INT;
    
    IF CarNum = -1 THEN
        SELECT SUM(DATEDIFF(EndDate, StartDate)) INTO total_days FROM Bookings;
    ELSE
        SELECT SUM(DATEDIFF(EndDate, StartDate)) INTO total_days FROM Bookings WHERE CarNumber = CarNum;
    END IF;
    
    RETURN total_days;
END$$
DELIMITER ;

SELECT Count_Car(-1);

DROP FUNCTION IF EXISTS Count_Car2;
DELIMITER $$
CREATE FUNCTION Count_Car2(CarNum INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_days INT;
    
    IF CarNum NOT IN (SELECT CarNumber FROM Bookings) THEN
        SELECT SUM(DATEDIFF(EndDate, StartDate)) INTO total_days FROM Bookings;
    ELSE
        SELECT SUM(DATEDIFF(EndDate, StartDate)) INTO total_days FROM Bookings WHERE CarNumber = CarNum;
    END IF;
    
    RETURN total_days;
END$$
DELIMITER ;

SELECT Count_Car2(1);


-- Stored Procedures
-- Create a stored procedure that collects all the cars that are available between two dates.
-- The inputs to the procedure are starting and ending dates, and it prints all the car numbers that are available to be booked between the two dates.

DROP PROCEDURE IF EXISTS two_dates;
DELIMITER $$
CREATE PROCEDURE two_dates(startt DATE, endd DATE)
BEGIN
    SELECT CarNumber
    FROM Cars
    WHERE CarNumber NOT IN (
        SELECT DISTINCT CarNumber
        FROM Bookings
        WHERE StartDate <= endd AND EndDate >= startt
    );
END$$
DELIMITER ;

CALL two_dates('2018-01-01', '2018-01-16');

-- Create a stored procedure that handles the booking of renting a car.
-- The input to the procedure is the starting and ending dates, the car's number, and the customer number.
-- If it is successful, it should return 0; if it is unsuccessful in booking, it should return 1.

DROP PROCEDURE IF EXISTS renting_car;
DELIMITER $$
CREATE PROCEDURE renting_car(IN cust_num INT, IN car_num INT, IN start_date DATE, IN end_date DATE, OUT num INT)
BEGIN
    DECLARE already_booked INT;
    
    SELECT COUNT(*) INTO already_booked
    FROM Bookings
    WHERE CustomerNumber = cust_num AND CarNumber = car_num AND StartDate = start_date AND EndDate = end_date;
    
    IF already_booked > 0 THEN 
        SET num = 0;
    ELSE
        INSERT INTO Bookings(CustomerNumber, CarNumber, StartDate, EndDate)
        VALUES (cust_num, car_num, start_date, end_date);
        SET num = 1;
    END IF;
END$$
DELIMITER ;

CALL renting_car(6, 10, '2040-01-10', '2030-12-23', @result);
SELECT @result;


-- Triggers
-- Add an additional column to Customers that contains the amount of times a customer has booked a car.
-- Then create an after insert trigger on the Bookings table that increments the newly created column in Customers whenever they do a successful booking of a car.

ALTER TABLE Customers ADD COLUMN BookedTimes INT DEFAULT 0;

DROP TRIGGER IF EXISTS count_cust;
DELIMITER $$
CREATE TRIGGER count_cust AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Customers
    SET BookedTimes = BookedTimes + 1
    WHERE CustomerNumber = NEW.CustomerNumber;
END$$
DELIMITER ;

INSERT INTO Bookings VALUES (1, 6, '2020-01-02', '2020-01-15');
