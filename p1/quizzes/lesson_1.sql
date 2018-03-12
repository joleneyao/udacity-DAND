### LIMITS
## Try it yourself below by writing a query that limits the response to only
## the first 15 rows and includes the occurred_at, account_id, and channel
## fields in the web_events table.
SELECT occured_at, account_id, channel
FROM web_events
LIMIT 15;


### ORDER BY
## Write a query to return the top 5 orders in terms of largest total_amt_usd.
## Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

## Write a query to return the bottom 20 orders in terms of least total. Include
## the id, account_id, and total.
SELECT id, account_id, total
FROM orders
ORDER BY total
LIMIT 20;

### ORDER BY PART II
## Write a query that returns the top 5 rows from orders ordered according to
## newest to oldest, but with the largest total_amt_usd for each date listed
## first for each date.
SELECT *
FROM orders
ORDER BY occurred_at DESC, total_amt_usd DESC
LIMIT 5;


### WHERE
## Pull the first 5 rows and all columns from the orders table that have a
## dollar amount of gloss_amt_usd greater than or equal to 1000.
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

## Pull the first 10 rows and all columns from the orders table that have a
## total_amt_usd less than 500.
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;


### WHERE NON-NUMERIC
## Filter the accounts table to include the company name, website, and the
## primary point of contact (primary_poc) for Exxon Mobil in the accounts table.
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil'
## Note: Commonly when we are using WHERE with non-numeric data fields, we
## use the LIKE, NOT, or IN operators

## LIKE Operator
## Use the accounts table to find:
## All the companies whose names start with 'C'.
SELECT name
FROM accounts
WHERE name LIKE 'C%';

## All companies whose names contain the string 'one' somewhere in the name.
SELECT name
FROM accounts
WHERE name LIKE '%one%';

## All companies whose names end with 's'.
SELECT name
FROM accounts
WHERE name LIKE '%s';

## IN Operator
## Use the accounts table to find the account name, primary_poc, and
## sales_rep_id for Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

## Use the web_events table to find all information regarding individuals who
## were contacted via the channel of organic or adwords.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

## NOT Operator
## The NOT operator is an extremely useful operator for working with the
## previous two operators we introduced: IN and LIKE. By specifying NOT LIKE
## or NOT IN, we can grab all of the rows that do not meet a particular
## criteria.
## Use the accounts table to find the account name, primary poc, and sales
## rep id for all stores except Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

## Use the accounts table to find:
## All the companies whose names do not start with 'C'.
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%';

## AND and BETWEEN Operators
## Write a query that returns all the orders where the standard_qty is over
## 1000, the poster_qty is 0, and the gloss_qty is 0.
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

## Using the accounts table find all the companies whose names do not start
## with 'C' and end with 's'.
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

## Use the web_events table to find all information regarding individuals who
## were contacted via organic or adwords and started their account at any
## point in 2016 sorted from newest to oldest.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01'
AND '2017-01-01'
ORDER BY occurred_at DESC;

## OR Operator
## Find list of orders ids where either gloss_qty or poster_qty is greater
## than 4000. Only include the id field in the resulting table.
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

## Write a query that returns a list of orders where the standard_qty is zero
## and either the gloss_qty or poster_qty is over 1000.
SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

## Find all the company names that start with a 'C' or 'W', and the primary
## contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
           AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
           AND primary_poc NOT LIKE '%eana%');

### Arithmetic operators
## Create a column that divides the standard_amt_usd by the standard_qty to find
## the unit price for standard paper for each order. Limit the results to the
## first 10 orders, and include the id and account_id fields.
SELECT id, account_id,standard_amt_usd / standard_qty AS unit_price
FROM orders
LIMIT 10;

## Write a query that finds the percentage of revenue that comes from poster
## paper for each order. You will need to use only the columns that end with
## _usd. (Try to do this without using the total column). Include the id and
## account_id fields.
SELECT id, account_id,
       poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd)
       AS post_per
FROM orders;
