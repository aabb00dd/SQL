# Bid Database SQL Scripts

## Summary
This project provides SQL scripts to manage an auction bidding system. It defines tables for storing items, bidders, and bids, and includes queries to retrieve bidding data, a view for active auctions, a trigger to extend auction deadlines, and a function to calculate company revenue.

## How the Code Works
### 1. **Database and Tables**
- Creates the `Bid` database and selects it for use.
- Defines the `item` table to store auction items.
- Defines the `bidder` table to store bidder details.
- Defines the `bid` table to store bid records, linking items and bidders.

### 2. **Data Insertion**
- Populates the `item`, `bidder`, and `bid` tables with sample data for testing queries.

### 3. **Retrieving Bidding Data**
- Lists all bidders and their bids with item details.
- Counts the number of bids for each auction item.
- Shows bidders, items they have bid on, and their bid amounts, including bidders who haven't placed any bids.

### 4. **Creating a View for Active Auctions**
- Creates a `VIEW` showing active auctions with the highest current bid.

### 5. **Auction End Date Trigger**
- Implements a `TRIGGER` to extend an auction’s end date by one day if a bid is placed on the last day.

### 6. **Calculating Company Revenue**
- Defines a `FUNCTION` to compute revenue based on bid amounts:
  - 20% commission for bids under 1000 SEK.
  - 10% commission for bids 1000 SEK or more.
