Bid Database

Overview

This SQL script sets up a database named Bid to manage an auction system. The database includes tables for items, bidders, and bids, as well as queries, views, triggers, and functions to manage and analyze auction data.

Database Schema

Tables

item: Stores auction items.

itemNumber (Primary Key)

name

startingPrice

lastBidDate

acceptedBid

bidder: Stores bidders' information.

bidderNumber (Primary Key)

name

address

credit

bid: Stores bids placed on items.

bidNumber (Primary Key)

itemNumber (Foreign Key referencing item)

bidderNumber (Foreign Key referencing bidder)

bidDate

bid

Features

Data Queries

List of Bidders and Their Bids:

Displays bidder names, item IDs, bid dates, and bid amounts.

Number of Bids per Auction Item:

Shows item names and the number of bids received.

Views

active_biddings:

Displays currently active bidding with the highest bid amount for each item.

Triggers

update_end_date:

If a bid is placed on an item on its last bid date, the auction end date is extended by one day.

Functions

calculate_revenue(xBidNumber INT):

Calculates the company's revenue from completed bids:

20% commission for bids under 1000 SEK.

10% commission for bids above 1000 SEK.

Additional Queries

Bidders and Items They Have Bid On:

Shows all bidders, the items they bid on, and their bid amounts.

Ensures bidders with no bids are still included.

Usage

Execute the script in an SQL environment that supports MySQL.

Modify or extend the schema as needed for additional auction functionalities.

Requirements

MySQL database management system.

Basic SQL knowledge to modify and query data.

License

This project is for educational purposes and can be modified as needed.

