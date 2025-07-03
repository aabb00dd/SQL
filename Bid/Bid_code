-- Write an SQL statement that shows the bidders and their bids on all items.
-- The result table should have the following columns: bidders name, items id, 
-- bids date, and the bid.
USE Bid;

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

-- Write an SQL statement that shows the number of bids on all auctions. 
-- The result table should have the following columns: items name, and the number of bids.

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

-- Create a view that shows each active bidding with the columns items number and current highest bid

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

-- Anders has a greedy view on auctions. If someone places a bid on an item on its end date, the end date should be moved forward by one day. 
-- Solve this with the help of a trigger on the Bid table.

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

-- Create a function that calculates the companys revenue for each completed bidding. 
-- The company takes 20% for completed auctions under 1000 SEK and 10% for the remaining.

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

-- Write an SQL statement that shows the bidders, the items they have bid on, and the bids they have made on each item. 
-- If a bidder has not placed any bids, they should still be included in the result.

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
