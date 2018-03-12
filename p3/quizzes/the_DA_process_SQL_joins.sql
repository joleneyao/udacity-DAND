## SQL Joins ##

# Your First Join Quiz #
"""
Try pulling all the data from the accounts table, and all the data from the
# orders table. Notice this result is the same as if you switched the tables
in the FROM and JOIN. Additionally, which side of the = a column is listed
doesn't matter.
"""
SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

"""
Try pulling standard_qty, gloss_qty, and poster_qty from the orders table,
and the website and the primary_poc from the accounts table. Notice that we
need to specify every table a column comes from in the SELECT statement
"""
SELECT orders.standard_qty, orders.gloss_qty,
       orders.poster_qty,  accounts.website,
       accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
--------------------------------------------------------------------------------
# Quiz: JOIN Questions Part 1 #
"""
Provide a table for all web_events associated with account name of Walmart.
There should be three columns. Be sure to include the primary_poc, time of
the event, and the channel for each event. Additionally, you might choose to
add a fourth column to assure only Walmart events were chosen.
"""
SELECT a.name, a.primary_poc, w.channel, w.occurred_at
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE name IN ('Walmart');
"""
Provide a table that provides the region for each sales_rep along with their
associated accounts. Your final table should include three columns: the region
name, the sales rep name, and the account name. Sort the accounts
alphabetically (A-Z) according to account name.
"""
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;
"""
Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. Your final
table should have 3 columns: region name, account name, and unit price. A few
accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing
by zero. **The JOIN and ON are based off of PK and FKs diagram not shown here**
"""
SELECT r.name region, a.name account,
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;
--------------------------------------------------------------------------------
# Quiz Last Check #
"""
Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for the Midwest region. Your final table
should include three columns: the region name, the sales rep name, and the
account name. Sort the accounts alphabetically (A-Z) according to account name.
"""
SELECT a.name account, s.name rep, r.name region
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
WHERE r.name = 'Midwest'
ORDER BY a.name;
"""
Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for accounts where the sales rep has a first
name starting with S and in the Midwest region. Your final table should include
three columns: the region name, the sales rep name, and the account name. Sort
the accounts alphabetically (A-Z) according to account name.
"""
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;
"""
Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for accounts where the sales rep has a last
name starting with K and in the Midwest region. Your final table should include
three columns: the region name, the sales rep name, and the account name. Sort
the accounts alphabetically (A-Z) according to account name.
"""
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;
"""
Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. However, you
should only provide the results if the standard order quantity exceeds 100. Your
final table should have 3 columns: region name, account name, and unit price. In
order to avoid a division by zero error, adding .01 to the denominator here is
helpful total_amt_usd/(total+0.01).
"""
SELECT r.name region, a.name account,
		o.total_amt_usd/(total+0.01) unit_price
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100;
"""
Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. However, you
should only provide the results if the standard order quantity exceeds 100 and
the poster order quantity exceeds 50. Your final table should have 3 columns:
region name, account name, and unit price. Sort for the smallest unit price
first. In order to avoid a division by zero error, adding .01 to the denominator
here is helpful (total_amt_usd/(total+0.01).
"""
SELECT r.name region, a.name account,
		o.total_amt_usd/(total+0.01) unit_price
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;
"""
Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. However, you
should only provide the results if the standard order quantity exceeds 100 and
the poster order quantity exceeds 50. Your final table should have 3 columns:
region name, account name, and unit price. Sort for the largest unit price
first. In order to avoid a division by zero error, adding .01 to the denominator
here is helpful (total_amt_usd/(total+0.01).
"""
SELECT r.name region, a.name account,
		o.total_amt_usd/(total+0.01) unit_price
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;
"""
What are the different channels used by account id 1001? Your final table should
have only 2 columns: account name and the different channels. You can try SELECT
DISTINCT to narrow down the results to only the unique values.
"""
SELECT a.name, w.channel
FROM accounts a
RIGHT JOIN web_events w
ON w.account_id = a.id
WHERE w.account_id = '1001';
OR
SELECT DISTINCT a.name, w.channel
FROM accounts a
RIGHT JOIN web_events w
ON a.id = w.account_id
WHERE a.id = '1001';
"""
Find all the orders that occurred in 2015. Your final table should have 4
columns: occurred_at, account name, order total, and order total_amt_usd.
*NOTE: Only use JOIN on columns you need to use functions (like, between, in,
etc..)!
"""
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;
