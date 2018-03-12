## SQL Aggregations ##

# Quiz: Sum#
"""
Find the total amount of poster_qty paper ordered in the orders table.
"""
SELECT SUM(poster_qty) AS total_poster_sales
FROM orders;
"""
Find the total amount of standard_qty paper ordered in the orders table.
"""
SELECT SUM(standard_qty) AS total_standard_sales
FROM orders;
"""
Find the total dollar amount of sales using the total_amt_usd in the orders
table.
"""
SELECT SUM(total_amt_usd) AS total_dollar_sales
FROM orders;
"""
Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for
each order in the orders table. This should give a dollar amount for each order
in the table. Notice, this solution did not use an aggregate.
"""
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;
"""
Find the standard_amt_usd per unit of standard_qty paper. Your solution should
use both an aggregation and a mathematical operator.
Notice, this solution used both an aggregate and our mathematical operators
"""
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;
--------------------------------------------------------------------------------
"""
Functionally, MIN and MAX are similar to COUNT in that they can be used on
non-numerical columns. Depending on the column type, MIN will return the lowest
number, earliest date, or non-numerical value as early in the alphabet as
possible. As you might suspect, MAX does the opposite—it returns the highest
number, the latest date, or the non-numerical value closest alphabetically to
“Z.”
"""
# QUIZ: MIN, MAX, and AVG #
"""
When was the earliest order ever placed? You only need to return the date.
"""
SELECT MIN(occurred_at)
FROM web_events;
"""
Try performing the same query as in question 1 without using an aggregation
function.
"""
SELECT occurred_at
FROM web_events
ORDER BY occurred_at
LIMIT 1;
"""
When did the most recent (latest) web_event occur?
"""
SELECT MAX(occurred_at)
FROM web_events;
"""
Try to perform the result of the previous query without using an aggregation
function.
"""
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;
"""
Find the mean (AVERAGE) amount spent per order on each paper type, as well as
the mean amount of each paper type purchased per order. Your final answer
should have 6 values - one for each paper type for the average number of sales,
as well as the average amount.
"""
SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss,
           AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd,
           AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;
"""
Via the video, you might be interested in how to calculate the MEDIAN. Though
this is more advanced than what we have covered so far try finding - what is
the MEDIAN total_usd spent on all orders?
"""
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;
--------------------------------------------------------------------------------
# QUIZ: GROUP BY #
"""
- GROUP BY can be used to aggregate data within subsets of the data. For example,
grouping for different accounts, different regions, or different sales
representatives.
- Any column in the SELECT statement that is not within an aggregator must be
in the GROUP BY clause.
- The GROUP BY always goes between WHERE and ORDER BY.
- ORDER BY works like SORT in spreadsheet software.
"""
"""
Which account (by name) placed the earliest order? Your solution should have
the account name and the date of the order.
"""
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;
"""
Find the total sales in usd for each account. You should include two columns -
the total sales for each company's orders in usd and the company name.
"""
SELECT a.name, SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;
"""
Via what channel did the most recent (latest) web_event occur, which account was
associated with this web_event? Your query should return only three values - the
date, channel, and account name.
"""
SELECT a.name account, w.channel, w.occurred_at date
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;
"""
Find the total number of times each type of channel from the web_events was used.
Your final table should have two columns - the channel and the number of times
the channel was used.
"""
SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel;
"""
Who was the primary contact associated with the earliest web_event?
"""
SELECT w.channel, a.primary_poc, w.occurred_at
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;
"""
What was the smallest order placed by each account in terms of total usd.
Provide only two columns - the account name and the total usd. Order from
smallest dollar amounts to largest.
"""
SELECT a.name account, MIN(o.total_amt_usd) smallest_order
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;
"""
Find the number of sales reps in each region. Your final table should have two
columns - the region and the number of sales_reps. Order from fewest reps to
most reps.
"""
SELECT r.name region, COUNT(s.region_id) sales_reps
FROM sales_reps s
JOIN region r
ON r.id = s.region_id
GROUP BY region
ORDER BY sales_reps;
--------------------------------------------------------------------------------
## QUIZ: GROUP BY Part II ##
"""
For each account, determine the average amount of each type of paper they
purchased across their orders. Your result should have four columns - one
for the account name and one for the average quantity purchased for each of
the paper types for each account.
"""
SELECT a.name account, AVG(o.standard_qty) standard_avg, AVG(o.gloss_qty)
gloss_avg, AVG(o.poster_qty) poster_avg
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY account;
"""
For each account, determine the average amount spent per order on each paper
type. Your result should have four columns - one for the account name and one
for the average amount spent on each paper type.
"""
SELECT a.name account, AVG(o.standard_amt_usd) standard_avg,
AVG(o.gloss_amt_usd) gloss_avg, AVG(o.poster_amt_usd) poster_avg
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY account;
"""
Determine the number of times a particular channel was used in the web_events
table for each sales rep. Your final table should have three columns - the name
of the sales rep, the channel, and the number of occurrences. Order your table
with the highest number of occurrences first.
"""
SELECT s.name sales_rep, w.channel channel, COUNT(*) num_occurrences
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY sales_rep, channel
ORDER BY num_occurrences DESC;
"""
Determine the number of times a particular channel was used in the web_events
table for each region. Your final table should have three columns - the region
name, the channel, and the number of occurrences. Order your table with the
highest number of occurrences first.
"""
SELECT r.name region, w.channel channel, COUNT(*) num_occurrences
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
GROUP BY region, channel
ORDER BY num_occurrences DESC;
--------------------------------------------------------------------------------
## QUIZ: DISTINCT ##
"""
Use DISTINCT to test if there are any accounts associated with more than one
region.
"""
SELECT a.id as "account id", r.id as "region id",
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;
"""
Have any sales reps worked on more than one account?
"""
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;
--------------------------------------------------------------------------------
## QUIZ: HAVING ##
"""
How many of the sales reps have more than 5 accounts that they manage?
"""
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;
"""
How many accounts have more than 20 orders?
"""
SELECT a.name, a.id, COUNT(*) num_orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name, a.id
HAVING COUNT(*) > 20
ORDER BY num_orders;
"""
Which account has the most orders?
"""
SELECT a.name, a.id, COUNT(*) num_orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name, a.id
ORDER BY num_orders DESC
LIMIT 1;
"""
How many accounts spent more than 30,000 usd total across all orders?
"""
SELECT a.name, a.id, SUM(o.total_amt_usd) total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name, a.id
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;
"""
How many accounts spent less than 1,000 usd total across all orders?
"""
SELECT a.name, a.id, SUM(o.total_amt_usd) total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name, a.id
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;
"""
Which account has spent the most with us?
"""
SELECT a.name, a.id, SUM(o.total_amt_usd) total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name, a.id
ORDER BY total_spent DESC
LIMIT 1;
"""
Which account has spent the least with us?
"""
SELECT a.name, a.id, SUM(o.total_amt_usd) total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name, a.id
ORDER BY total_spent
LIMIT 1;
"""
Which accounts used facebook as a channel to contact customers more than 6 times?
"""
SELECT a.id, a.name, w.channel, COUNT(*) number
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY number;
"""
Which account used facebook most as a channel?
"""
SELECT a.id, a.name, w.channel, COUNT(*) number
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY number DESC
LIMIT 1;
"""
Which channel was most frequently used by most accounts?
"""
SELECT a.id, w.account_id, a.name, w.channel, COUNT(*) counts
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
GROUP BY a.id, a.name, w.account_id, w.channel
ORDER BY counts DESC;
--------------------------------------------------------------------------------
## QUIZ: DATE functions ##
"""
Find the sales in terms of total dollars for all orders in each year, ordered
from greatest to least. Do you notice any trends in the yearly sales totals?
"""
SELECT DATE_PART('year', o.occurred_at), SUM(o.total_amt_usd)
FROM orders o
GROUP BY 1
ORDER BY 2 DESC;
"""
Which month did Parch & Posey have the greatest sales in terms of total dollars?
Are all months evenly represented by the dataset?
"""
SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;
"""
Which year did Parch & Posey have the greatest sales in terms of total number
of orders? Are all years evenly represented by the dataset?
"""
SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
"""
Which month did Parch & Posey have the greatest sales in terms of total number
of orders? Are all months evenly represented by the dataset?
"""
SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;
"""
In which month of which year did Walmart spend the most on gloss paper in
terms of dollars?
"""
SELECT DATE_TRUNC('month', o.occurred_at), SUM(o.gloss_amt_usd) total_gloss_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
--------------------------------------------------------------------------------
## QUIZ: CASE ##
"""
We would like to understand 3 different levels of customers based on the amount
associated with their purchases. The top branch includes anyone with a Lifetime
Value (total sales of all orders) greater than 200,000 usd. The second branch
is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000
usd. Provide a table that includes the level associated with each account. You
should provide the account name, the total sales of all orders for the customer,
and the level. Order with the top spending customers listed first.
"""
SELECT a.name, SUM(o.total_amt_usd),
	   CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top'
            WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd) <=
                 200000 THEN 'middle'
            ELSE 'low' END AS level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY 2 DESC;
"""
We would now like to perform a similar calculation to the first, but we want to
obtain the total amount spent by customers only in 2016 and 2017. Keep the same
levels as in the previous question. Order with the top spending customers
listed first.
"""
SELECT a.name, SUM(o.total_amt_usd),
	   CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top'
            WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd)
                 <= 200000 THEN 'middle'
            ELSE 'low' END AS level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE  occurred_at > '2015-12-31'
GROUP BY a.name,  DATE_PART('year', o.occurred_at)
ORDER BY 2 DESC;
"""
We would like to identify top performing sales reps, which are sales reps
associated with more than 200 orders. Create a table with the sales rep name,
the total number of orders, and a column with top or not depending on if they
have more than 200 orders. Place the top sales people first in your final table.
"""
SELECT s.name, COUNT(o.account_id),
		CASE WHEN COUNT(o.account_id) > 200 THEN 'top'
        	 ELSE 'not' END AS level
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
GROUP BY s.name
ORDER BY 2 DESC;
"""
The previous didn't account for the middle, nor the dollar amount associated
with the sales. Management decides they want to see these characteristics
represented as well. We would like to identify top performing sales reps,
which are sales reps associated with more than 200 orders or more than 750000
in total sales. The middle group has any rep with more than 150 orders or
500000 in sales. Create a table with the sales rep name, the total number of
orders, total sales across all orders, and a column with top, middle, or low
depending on this criteria. Place the top sales people based on dollar amount
of sales first in your final table. You might see a few upset sales people by
this criteria!
"""
SELECT s.name, COUNT(o.account_id) orders_total,
	   CASE WHEN COUNT(o.account_id) > 200 OR SUM(o.total_amt_usd) > 750000
            THEN 'top'
        	WHEN COUNT(o.account_id) >150 OR SUM(o.total_amt_usd) > 500000
            THEN 'middle'
			ELSE 'low' END AS sales_rep_level
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
GROUP BY s.name
ORDER BY 3 DESC;
