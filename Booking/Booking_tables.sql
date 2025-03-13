CREATE DATABASE Booking;
USE Booking;


DROP TABLE IF EXISTS Cars;
CREATE TABLE Cars (
    CarNumber INT NOT NULL PRIMARY KEY, 
    Brand VARCHAR(20) NOT NULL, 
    Model VARCHAR(20) NOT NULL, 
    Color VARCHAR(20) NOT NULL, 
    PricePerDay INT NOT NULL
);

INSERT INTO Cars (CarNumber, Brand, Model, Color, PricePerDay) VALUES
(1, 'Peugeot', '208', 'Blue', 800),
(2, 'Peugeot', '3008', 'Green', 700),
(3, 'Volkswagen', 'Polo', 'Red', 600),
(4, 'Volvo', 'V70', 'Silver', 1200),
(5, 'Tesla', 'X', 'Black', 2000),
(6, 'SAAB', '9-5', 'Green', 850),
(7, 'Volvo', 'V40', 'Red', 900),
(8, 'Fiat', '500', 'Black', 1050),
(9, 'Volvo', 'V40', 'Green', 850),
(10, 'Fiat', '500', 'Red', 950),
(11, 'Volkswagen', 'Polo', 'Blue', 700),
(12, 'BMW', 'M3', 'Black', 1599),
(13, 'Volkswagen', 'Golf', 'Red', 1500);

SELECT * FROM Cars;


DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    CustomerNumber INT NOT NULL PRIMARY KEY, 
    Name VARCHAR(40) NOT NULL, 
    BirthDate DATE NOT NULL
);

INSERT INTO Customers (CustomerNumber, Name, BirthDate) VALUES
(1, 'Alice Andersson', '1990-05-05'),
(2, 'Oscar Johansson', '1975-08-10'),
(3, 'Nora Hansen', '1981-10-27'),
(4, 'William Johansen', '2000-01-17'),
(5, 'Lucía García', '1987-12-13'),
(6, 'Hugo Fernández', '1950-03-16'),
(7, 'Sofia Rossi', '1995-08-04'),
(8, 'Francesco Russo', '2000-02-26'),
(9, 'Olivia Smith', '1972-05-23'),
(10, 'Oliver Jones', '1964-05-08'),
(11, 'Shaimaa Elhawary', '1999-12-23'),
(12, 'Mohamed Elshabrawy', '1997-11-07'),
(13, 'Jing Wong', '1947-07-15'),
(14, 'Wei Lee', '1962-09-29'),
(15, 'Aadya Singh', '1973-01-01'),
(16, 'Aarav Kumar', '1986-06-28'),
(17, 'Louise Martin', '1994-04-22'),
(18, 'Gabriel Bernard', '1969-12-01'),
(19, 'Emma Smith', '1971-03-18'),
(20, 'Noah Johnson', '1800-12-16'),
(21, 'Alice Silva', '1988-12-04'),
(22, 'Miguel Santos', '1939-12-29');

SELECT * FROM Customers;


DROP TABLE IF EXISTS Bookings;
CREATE TABLE Bookings (
    CustomerNumber INT NOT NULL, 
    CarNumber INT NOT NULL, 
    StartDate DATE NOT NULL, 
    EndDate DATE NOT NULL,
    PRIMARY KEY (StartDate, CarNumber),
    FOREIGN KEY (CustomerNumber) REFERENCES Customers(CustomerNumber),
    FOREIGN KEY (CarNumber) REFERENCES Cars(CarNumber)
);

INSERT INTO Bookings (CustomerNumber, CarNumber, StartDate, EndDate) VALUES
(1, 6, '2018-01-02', '2018-01-15'),
(2, 1, '2018-01-03', '2018-01-05'),
(4, 3, '2018-01-03', '2018-01-04'),
(5, 8, '2018-01-04', '2018-01-30'),
(6, 10, '2018-01-10', '2018-01-13'),
(1, 1, '2018-01-20', '2018-01-25'),
(2, 13, '2018-01-21', '2018-01-30'),
(3, 6, '2018-01-22', '2018-01-30'),
(1, 2, '2018-01-29', '2018-02-01'),
(2, 5, '2018-02-02', '2018-02-06'),
(6, 1, '2018-02-20', '2018-02-25'),
(7, 6, '2018-02-21', '2018-02-24'),
(8, 3, '2018-02-21', '2018-02-28'),
(10, 3, '2018-02-22', '2018-02-26'),
(9, 12, '2018-02-22', '2018-02-28'),
(10, 13, '2018-03-01', '2018-03-10'),
(11, 1, '2018-03-04', '2018-03-09'),
(10, 3, '2018-03-11', '2018-03-14'),
(8, 6, '2018-03-14', '2018-03-17'),
(9, 5, '2018-03-14', '2018-03-30'),
(7, 12, '2018-03-18', '2018-03-20'),
(6, 8, '2018-03-18', '2018-04-02');

SELECT * FROM Bookings;
