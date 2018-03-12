## Advanced SQL JOINs and Performance Tuning ##

# REVIEW #
"""INNER JOIN"""
SELECT column_name(s)
FROM Table_A
INNER JOIN Table_B ON Table_A.column_name = Table_B.column_name;
"""LEFT JOIN"""
SELECT column_name(s)
FROM Table_A
LEFT JOIN Table_B ON Table_A.column_name = Table_B.column_name;
"""RIGHT JOIN"""
SELECT column_name(s)
FROM Table_A
RIGHT JOIN Table_B ON Table_A.column_name = Table_B.column_name;
"""FULL OUTER JOIN"""
SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;
"""UNMATCHED COLUMNS ONLY"""
SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;
WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL
(NOTE: FULL OUTER JOINs are very rare in the real world!)
--------------------------------------------------------------------------------
# Quiz: FULL OUTER JOIN #
(Finding Matched and Unmatched Rows with FULL OUTER JOIN)
"""
You’re not likely to use FULL JOIN (which can also be written as FULL OUTER
JOIN) too often, but the syntax is worth practicing anyway. LEFT JOIN and
RIGHT JOIN each return unmatched rows from one of the tables—FULL JOIN returns
unmatched rows from both tables. FULL JOIN is commonly used in conjunction
with aggregations to understand the amount of overlap between two tables.

Say you're an analyst at Parch & Posey and you want to see:
- each account who has a sales rep and each sales rep that has an account (all
  of the columns in these returned rows will be full)
- but also each account that does not have a sales rep and each sales rep that
  does not have an account (some of the columns in these returned rows will
  be empty)
"""
SELECT a.*
FROM accounts a
FULL OUTER JOIN sales_reps s ON a.sales_rep_id = s.id;

SELECT a.*
FROM accounts a
FULL OUTER JOIN sales_reps s ON a.sales_rep_id = s.id
WHERE a.sales_rep_id IS NULL OR s.id IS NULL;
--------------------------------------------------------------------------------
# QUIZ: JOINs with Comparison Operators #

"""
Inequality operators (a.k.a. comparison operators) don't only need to be date
times or numbers, they also work on strings! You'll see how this works by
completing the following quiz, which will also reinforce the concept of joining
with comparison operators.
In the following SQL Explorer, write a query that left joins the accounts table
and the sales_reps tables on each sale rep's ID number and joins it using the
< comparison operator on accounts.primary_poc and sales_reps.name, like so:

accounts.primary_poc < sales_reps.name

The query results should be a table with three columns: the account name
(e.g. Johnson Controls), the primary contact name (e.g. Cammy Sosnowski),
and the sales representative's name (e.g. Samuel Racine). Then answer the
subsequent multiple choice question.
"""
SELECT a.name as account_name,
       a.primary_poc as poc_name,
       s.name as sales_rep_name
  FROM accounts a
  LEFT JOIN sales_reps s
    ON a.sales_rep_id = s.id
   AND a.primary_poc < s.name;
--------------------------------------------------------------------------------
# QUIZ: Self JOINs #
"""
One of the most common use cases for self JOINs is in cases where two events
occurred, one after another. As you may have noticed in the previous video,
using inequalities in conjunction with self JOINs is common.
Modify the query from the previous video, which is pre-populated in the SQL
Explorer below, to perform the same interval analysis except for the web_events
table. Also:
- change the interval to 1 day to find web events that occur within one after
  another within one day
- add a column for the channel variable in both instances of the table in your
  query
You can find more on the types of INTERVALS (and other date related
functionality) in the Postgres documentation here.
"""
SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w1.channel AS w1_channel,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at,
       w2.channel AS w2_channel
  FROM web_events w1
 LEFT JOIN web_events w2
   ON w1.account_id = w2.account_id
  AND w1.occurred_at > w2.occurred_at
  AND w1.occurred_at <= w2.occurred_at + INTERVAL '1 day'
ORDER BY w1.account_id, w2.occurred_at
--------------------------------------------------------------------------------
# QUIZZES: UNION #

# Notes for UNION / UNION ALL #
"""
SQL's two strict rules for appending data:
1. Both tables must have the same number of columns.
2. Those columns must have the same data types in the same order as the first
   table.
A common misconception is that column names have to be the same. Column names,
in fact, don't need to be the same to append two tables but you will find that
they typically are.
"""

(Appending Data via UNION)
"""
Write a query that uses UNION ALL on two instances (and selecting all columns)
of the accounts table. Then inspect the results and answer the subsequent quiz.
"""
SELECT *
FROM accounts

UNION ALL

SELECT *
FROM accounts;

(Pretreating Tables before doing a UNION)
"""
Add a WHERE clause to each of the tables that you unioned in the query above,
filtering the first table where name equals Walmart and filtering the second
table where name equals Disney. Inspect the results then answer the subsequent
quiz.
"""
SELECT *
FROM accounts a
WHERE a.name = 'Walmart'

UNION ALL

SELECT *
FROM accounts a
WHERE a.name = 'Disney';
"""
The above query can also be written as:
"""
SELECT *
FROM accounts a
WHERE a.name = 'Walmart' OR a.name = 'Disney'

(Performing Operations on a Combined Dataset)
"""
Perform the union in your first query (under the Appending Data via UNION
header) in a common table expression and name it double_accounts. Then do a
COUNT the number of times a name appears in the double_accounts table. If you
do this correctly, your query results should have a count of 2 for each name.
"""
WITH double_accounts AS(
SELECT *
FROM accounts

UNION ALL

SELECT *
FROM accounts)
SELECT name,
	     COUNT(*)AS name_count
FROM double_accounts
GROUP BY 1
ORDER BY 2 DESC;
--------------------------------------------------------------------------------
# Performance Tuning 1 Notes #

One way to make a query run faster is to reduce the number of calculations that
need to be performed. Some of the high-level things that will affect the number
of calculations a given query will make include:
- Table size
- Joins
- Aggregations

Query runtime is also dependent on some things that you can’t really control
related to the database itself:
- Other users running queries concurrently on the database
- Database software and optimization (e.g. Postgres is optimized differently
  than Redshift)

Performance Tuning with LIMIT
- If you have time series data, limiting to a small time window can make your
  queries run more quickly
- Testing your data on a subset of data, finalizing your query, then removing
  the subset limitation is a sound strategy
- When working with subqueries, limiting the amount of data youre working with
  in the place where it will be executed first will have the maximum impact
  on query run time.
--------------------------------------------------------------------------------
