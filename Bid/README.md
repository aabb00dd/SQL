# Bid Database SQL Scripts

## Overview
This project contains SQL scripts for managing an auction bidding system. It includes table definitions, data insertion, queries for retrieving bidding information, a view for active bidding, a trigger for extending auction end dates, and a function for calculating company revenue.

## Database and Tables
### 1. **Creating the Database**
```sql
CREATE DATABASE Bid;
USE Bid;
```
This creates and selects the `Bid` database.

### 2. **Item Table**
```sql
CREATE TABLE item (
    itemNumber INT NOT NULL PRIMARY KEY, 
    name VARCHAR(20) NOT NULL, 
    startingPrice INT NOT NULL, 
    lastBidDate DATE NOT NULL, 
    acceptedBid INT
);
```
This table stores auction items with attributes like item number, name, starting price, last bid date, and accepted bid.

### 3. **Bidder Table**
```sql
CREATE TABLE bidder (
    bidderNumber INT NOT NULL PRIMARY KEY, 
    name VARCHAR(20) NOT NULL, 
    address VARCHAR(20) NOT NULL, 
    credit DECIMAL NOT NULL
);
```
This table holds information about bidders, including their ID, name, address, and credit balance.

### 4. **Bid Table**
```sql
CREATE TABLE bid (
    bidNumber INT NOT NULL PRIMARY KEY,
    itemNumber INT NOT NULL,
    bidderNumber INT NOT NULL,
    bidDate DATE NOT NULL,
    bid INT NOT NULL,
    FOREIGN KEY (bidderNumber) REFERENCES bidder(bidderNumber),
    FOREIGN KEY (itemNumber) REFERENCES item(itemNumber)
);
```
This table records bids placed by bidders on items, tracking bid number, item, bidder, bid date, and bid amount.

## Queries
### 1. **Retrieve All Bidders and Their Bids**
```sql
SELECT 
    bidder.name AS bidder_name, 
    bid.itemNumber AS item_id, 
    bid.bidDate AS bid_date, 
    bid.bid AS bid_amount
FROM 
    bidder 
INNER JOIN 
    bid 
ON 
    bid.bidderNumber = bidder.bidderNumber;
```
This query fetches the bidders' names, item IDs, bid dates, and bid amounts.

### 2. **Count the Number of Bids per Item**
```sql
SELECT 
    item.name AS item_name, 
    COUNT(bid.bid) AS number_of_bids
FROM 
    item 
LEFT JOIN 
    bid 
ON 
    bid.itemNumber = item.itemNumber 
GROUP BY 
    item.name;
```
This query retrieves the total number of bids for each auction item.

## Views and Triggers
### 3. **Creating a View for Active Biddings**
```sql
CREATE VIEW active_biddings AS
SELECT 
    item.itemNumber AS item_number, 
    MAX(bid.bid) AS highest_bid
FROM 
    bid 
INNER JOIN 
    item 
ON 
    bid.itemNumber = item.itemNumber 
WHERE 
    bid.acceptedBid IS NULL 
    AND bid.bidDate > CURDATE() 
GROUP BY 
    item.itemNumber;
```
This view displays active biddings with the item number and the current highest bid.

### 4. **Trigger to Extend Auction End Date**
```sql
DROP TRIGGER IF EXISTS update_end_date;
DELIMITER $$
CREATE TRIGGER update_end_date
AFTER INSERT ON bid
FOR EACH ROW
BEGIN
    IF NEW.bidDate = (SELECT endDate FROM item WHERE itemNumber = NEW.itemNumber) THEN
        UPDATE item 
        SET endDate = ADDDATE(endDate, 1) 
        WHERE itemNumber = NEW.itemNumber;
    END IF;
END$$
DELIMITER ;
```
This trigger automatically extends an auction's end date by one day if a bid is placed on the end date.

## Functions
### 5. **Calculating Company Revenue**
```sql
DROP FUNCTION IF EXISTS calculate_revenue;
DELIMITER $$
CREATE FUNCTION calculate_revenue(xBidNumber INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE revenue DECIMAL(10, 2);
    DECLARE final_bid DECIMAL(10, 2);
    
    SELECT bid 
    INTO final_bid 
    FROM bid 
    WHERE bidNumber = xBidNumber;

    IF final_bid < 1000 THEN
        SET revenue = final_bid * 0.20;
    ELSE
        SET revenue = final_bid * 0.10;
    END IF;

    RETURN revenue;
END$$
DELIMITER ;
```
This function calculates the company's revenue for completed bids, charging 20% for bids under 1000 SEK and 10% otherwise.

## Comprehensive Bidder-Item Query
```sql
SELECT 
    bidder.name AS bidder_name, 
    item.name AS item_name, 
    bid.bid AS bid_amount
FROM 
    bidder 
LEFT JOIN 
    bid 
ON 
    bid.bidderNumber = bidder.bidderNumber 
LEFT JOIN 
    item 
ON 
    bid.itemNumber = item.itemNumber;
```
This query lists all bidders, the items they bid on, and their bid amounts, including bidders who haven't placed any bids.

## Sample Data
The script includes predefined sample data for `item`, `bidder`, and `bid` tables, allowing easy testing of queries and logic.

## Conclusion
This SQL project manages an auction system by storing bidders, items, and bids, while implementing queries, views, triggers, and functions to support bidding operations efficiently.
