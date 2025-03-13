CREATE DATABASE Bid;
USE Bid;

CREATE TABLE item (
    itemNumber INT NOT NULL PRIMARY KEY, 
    name VARCHAR(20) NOT NULL, 
    startingPrice INT NOT NULL, 
    lastBidDate DATE NOT NULL, 
    acceptedBid INT
);

INSERT INTO item (itemNumber, name, startingPrice, lastBidDate, acceptedBid) VALUES
(0, 'Pryl 1', 50, '2019-06-30', NULL),
(1, 'Pryl 2', 500, '2019-06-02', 800),
(2, 'Pryl 3', 1000, '2019-05-30', 1100),
(3, 'Pryl 4', 800, '2019-05-06', 800),
(4, 'Pryl 5', 200, '2019-07-31', NULL);

CREATE TABLE bidder (
    bidderNumber INT NOT NULL PRIMARY KEY, 
    name VARCHAR(20) NOT NULL, 
    address VARCHAR(20) NOT NULL, 
    credit DECIMAL NOT NULL
);

INSERT INTO bidder (bidderNumber, name, address, credit) VALUES
(0, 'Ada Asson', 'HemmaIHuset', 10000),
(1, 'Beda Bsson', 'StuganVidVägen', 70000),
(2, 'Ceasar Csson', 'Någonstans', 25000),
(3, 'Dino Dsson', 'Where', 5000),
(4, 'Eve Esson', 'Bråkmakaregatan', 200000),
(5, 'Fabian Fsson', 'Here', 14000);

DROP TABLE IF EXISTS bid;

CREATE TABLE bid (
    bidNumber INT NOT NULL PRIMARY KEY,
    itemNumber INT NOT NULL,
    bidderNumber INT NOT NULL,
    bidDate DATE NOT NULL,
    bid INT NOT NULL,
    FOREIGN KEY (bidderNumber) REFERENCES bidder(bidderNumber),
    FOREIGN KEY (itemNumber) REFERENCES item(itemNumber)
);

INSERT INTO bid (bidNumber, itemNumber, bidderNumber, bidDate, bid) VALUES
(0, 0, 0, '2019-04-20', 50),
(1, 0, 2, '2019-04-25', 70),
(2, 1, 1, '2019-05-01', 500),
(3, 1, 2, '2019-05-01', 600),
(4, 1, 1, '2019-05-01', 700),
(5, 2, 5, '2019-05-01', 1000),
(6, 3, 3, '2018-05-02', 300),
(7, 3, 2, '2018-05-03', 400),
(8, 1, 3, '2018-05-06', 800),
(9, 2, 4, '2018-05-22', 1100);
