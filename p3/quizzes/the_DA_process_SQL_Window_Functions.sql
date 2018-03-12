## [Advanced] SQL Window Functions ##

# Windown I Functions Quiz #
"""
Using Derek's previous video as an example, create another running total.
This time, create a running total of standard_amt_usd (in the orders table)
over order time with no date truncation. Your final table should have two
columns: one with the amount being added for each new row, and a second with
the running total.
"""
SELECT standard_amt_usd,
       SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders;
--------------------------------------------------------------------------------
"""
Now, modify your query from the previous quiz to include partitions. Still
create a running total of standard_amt_usd (in the orders table) over order
time, but this time, date truncate occurred_at by year and partition by that
same year-truncated occurred_at variable. Your final table should have three
columns: One with the amount being added for each row, one for the truncated
date, and a final columns with the running total within each year.
"""
SELECT standard_amt_usd,
		   DATE_TRUNC('year', occurred_at) AS year,
       SUM(standard_amt_usd) OVER(PARTITION BY DATE_TRUNC('year', occurred_at)
       ORDER BY occurred_at) AS running_total
FROM orders;
--------------------------------------------------------------------------------
"""
Select the id, account_id, and total variable from the orders table, then
create a column called total_rank that ranks this total amount of paper
ordered (from highest to lowest) for each account using a partition. Your
final table should have these four columns.
"""
SELECT id,
       account_id,
       total,
	     RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;
--------------------------------------------------------------------------------
# Aggregates in Window Functions with and without ORDER BY #
"""
The ORDER BY clause is one of two clauses integral to window functions. The
ORDER and PARTITION define what is referred to as the “window”—the ordered
subset of data over which calculations are made. Removing ORDER BY just leaves
an unordered partition; in our query's case, each column's value is simply an
aggregation (e.g. sum, count, average, minimum, or maximum) of all the
standard_qty values in its respective account_id.
"""
# Aliases for Multiple Window Functions #
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS
       (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))
--------------------------------------------------------------------------------
# Comparing a Row to a Previous Row Quiz #
"""
In the previous video, Derek outlines how to compare a row to a previous or
subsequent row. This technique can be useful when analyzing time-based events.
Imagine you're an analyst at Parch & Posey and you want to determine how the
current order's total revenue (i.e. from sales of all types of paper) revenue
compares to the next order's total revenue.
Modify Derek's query from the previous video in the SQL Explorer below to
perform this analysis. You'll need to use occurred_at and total_amt_usd in
the orders table along with LEAD to do so. In your query results, there should
be four columns: occurred_at, total_amt_usd, lead, and lead_difference.
"""
SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd
       AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders
 GROUP BY 1
) sub
--------------------------------------------------------------------------------
# Percentiles Quiz #
"""
Use the NTILE functionality to divide the accounts into 4 levels in terms of
the amount of standard_qty for their orders. Your resulting table should have
the account_id, the occurred_at time for each order, the total amount of
standard_qty paper purchased, and one of four levels in a standard_quartile
column.
"""
SELECT id,
	     account_id,
	     occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty)
       AS standard_quartile
FROM orders
ORDER BY 2 DESC;
"""
Use the NTILE functionality to divide the accounts into two levels in terms of
the amount of gloss_qty for their orders. Your resulting table should have the
account_id, the occurred_at time for each order, the total amount of gloss_qty
paper purchased, and one of two levels in a gloss_half column.
"""
SELECT id,
	   account_id,
	   occurred_at,
       gloss_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY 2 DESC;
"""
Use the NTILE functionality to divide the accounts into 100 levels in terms of
the amount of total_amt_usd for their orders. Your resulting table should have
the account_id, the occurred_at time for each order, the total amount of
total_amt_usd paper purchased, and one of 100 levels in a total_percentile
column.
"""
SELECT id,
	     account_id,
	     occurred_at,
       total_amt_usd,
       NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd)
       AS total_percentile
FROM orders
ORDER BY 2 DESC;
