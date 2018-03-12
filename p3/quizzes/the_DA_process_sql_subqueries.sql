## SQL Subqueries & Temporary Tables ##

# Quiz: Write Your First Subquery #
"""
Use the test environment below to find the number of events that occur for each
day for each channel.
"""
SELECT DATE_TRUNC('day', occurred_at) as day, channel, COUNT(*) event_count
FROM web_events
GROUP BY 1, 2
ORDER BY 3 DESC;
"""
Now create a subquery that provides all the data from your first query.
"""
SELECT *
FROM (SELECT DATE_TRUNC('day', occurred_at) as day, channel, COUNT(*) event_count
      FROM web_events
      GROUP BY 1, 2) sub;
"""
Now find the average number of events for each channel.
"""
SELECT channel, AVG(event_count) avg_event_count
FROM (SELECT DATE_TRUNC('day', occurred_at) as day, channel, COUNT(*) event_count
      FROM web_events
      GROUP BY 1, 2) sub
GROUP BY 1
ORDER BY 2 DESC;
--------------------------------------------------------------------------------
# QUIZ: More on Subqueries #
"""
Use DATE TRUNC to pull month level information about the first order placed
ever in the orders table.
"""
SELECT DATE_TRUNC('month', MIN(occurred_at))
FROM orders;
"""
Use the result of the previous query to find only the orders that took place
in the same month and year as the first order, and then pull the average for
each paper quantity in this month.
"""
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);
--------------------------------------------------------------------------------
# QUIZ: Subquery Mania #
"""
Provide the name of the sales_rep in each region with the largest amount of
total_amt_usd sales.
"""
SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
JOIN region r
ON r.id = s.region_id
GROUP BY 1, 2
ORDER BY 2 DESC;

SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1;

SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
    FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
            FROM sales_reps s
            JOIN accounts a
            ON a.sales_rep_id = s.id
            JOIN orders o
            ON o.account_id = a.id
            JOIN region r
            ON r.id = s.region_id
            GROUP BY 1, 2) t1
    GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
    FROM sales_reps s
    JOIN accounts a
    ON a.sales_rep_id = s.id
    JOIN orders o
    ON o.account_id = a.id
    JOIN region r
    ON r.id = s.region_id
    GROUP BY 1,2
    ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;
"""
For the region with the largest sales total_amt_usd, how many total orders
were placed?
"""
SELECT MAX(total_amt) total_amt
          FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd)
                      total_amt
                  FROM sales_reps s
                  JOIN accounts a
                  ON a.sales_rep_id = s.id
                  JOIN orders o
                  ON o.account_id = a.id
                  JOIN region r
                  ON r.id = s.region_id
                  GROUP BY 2) t1

          SELECT r.name, SUM(o.total) total_orders
          FROM sales_reps s
          JOIN accounts a
          ON a.sales_rep_id = s.id
          JOIN orders o
          ON o.account_id = a.id
          JOIN region r
          ON r.id = s.region_id
          GROUP BY r.name
          HAVING SUM(o.total_amt_usd) = (
                SELECT MAX(total_amt)
                FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
                        FROM sales_reps s
                        JOIN accounts a
                        ON a.sales_rep_id = s.id
                        JOIN orders o
                        ON o.account_id = a.id
                        JOIN region r
                        ON r.id = s.region_id
                        GROUP BY r.name) sub);
"""
For the name of the account that purchased the most (in total over their
lifetime as a customer) standard_qty paper, how many accounts still had more
in total purchases?
"""
SELECT a.name account, SUM(o.standard_qty) standard_ct, SUM(o.total) total
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT total
FROM (SELECT a.name account, SUM(o.standard_qty) standard_ct, SUM(o.total) total
      FROM accounts a
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 1) inner_tab

SELECT COUNT(*)
FROM (SELECT a.name account
      FROM accounts a
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY 1
      HAVING SUM(o.total) > (SELECT total
                             FROM (SELECT a.name account, SUM(o.standard_qty) standard_ct, SUM(o.total) total
                                   FROM accounts a
                                   JOIN orders o
                                   ON a.id = o.account_id
                                   GROUP BY 1
                                   ORDER BY 2 DESC
                                   LIMIT 1) inner_tab) )counter_tab
"""
For the customer that spent the most (in total over their lifetime as a
customer) total_amt_usd, how many web_events did they have for each channel?
"""
SELECT a.id customer, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT a.name, w.channel, COUNT(channel)
FROM web_events w
JOIN accounts a
ON w.account_id = a.id AND a.id = (SELECT customer
                      FROM
                      (SELECT a.id customer, SUM(o.total_amt_usd) total_spent
                      FROM accounts a
                      JOIN orders o
                      ON a.id = o.account_id
                      GROUP BY 1
                      ORDER BY 2 DESC
                      LIMIT 1)t1)
GROUP BY 1,2
ORDER BY 3 DESC;
"""
What is the lifetime average amount spent in terms of total_amt_usd for the
top 10 total spending accounts?
"""
SELECT a.name account, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY account
ORDER BY total_spent DESC
LIMIT 10;

SELECT account, AVG(total_spent) average_spent
FROM(SELECT a.name account, SUM(o.total_amt_usd) total_spent
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY account
    ORDER BY total_spent DESC
    LIMIT 10)sub
GROUP BY 1
LIMIT 10;
"""
What is the lifetime average amount spent in terms of total_amt_usd for only
the companies that spent more than the average of all orders.
"""
SELECT AVG(total_amt_usd)
FROM orders o;
--------------------------------------------------------------------------------
# QUIZ: WITH #
"""
Provide the name of the sales_rep in each region with the largest amount of
total_amt_usd sales.
"""
WITH t1 AS
(SELECT s.name rep_name, r.name region_name, SUM(total_amt_usd) total_amt
  FROM sales_reps s
  JOIN accounts a
  ON s.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id
  JOIN region r
  ON r.id = s.region_id
  GROUP BY 1, 2
  ORDER BY 2 DESC),
t2 AS
  (SELECT region_name, MAX(total_amt) total_amt
  FROM t1
  GROUP BY 1)

SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;
"""
For the region with the largest sales total_amt_usd, how many total orders
were placed?
"""
WITH t1 AS (
   SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY r.name),
t2 AS (
   SELECT MAX(total_amt)
   FROM t1)
SELECT r.name, SUM(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);
"""
For the name of the account that purchased the most (in total over their
lifetime as a customer) standard_qty paper, how many accounts still had more
in total purchases?
"""
WITH t1 AS (
  SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
  FROM accounts a
  JOIN orders o
  ON o.account_id = a.id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 1),
t2 AS (
  SELECT a.name
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total) > (SELECT total FROM t1))
SELECT COUNT(*)
FROM t2;
"""
For the customer that spent the most (in total over their lifetime as a
customer) total_amt_usd, how many web_events did they have for each channel?
"""
WITH t1 AS (
   SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id
   GROUP BY a.id, a.name
   ORDER BY 3 DESC
   LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;
"""
What is the lifetime average amount spent in terms of total_amt_usd for the
top 10 total spending accounts?
"""
WITH t1 AS (
   SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id
   GROUP BY a.id, a.name
   ORDER BY 3 DESC
   LIMIT 10)
SELECT AVG(tot_spent)
FROM t1;
"""
What is the lifetime average amount spent in terms of total_amt_usd for only
the companies that spent more than the average of all accounts.
"""
WITH t1 AS (
   SELECT AVG(o.total_amt_usd) avg_all
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id),
t2 AS (
   SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
   FROM orders o
   GROUP BY 1
   HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
FROM t2;
