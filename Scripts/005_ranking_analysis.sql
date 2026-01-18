/*
========================================================================================
Ranking Analysis
========================================================================================
Purpose:
	- To rank items (e.g., products, customers) based on performance or other metrics.
	- To identify top performers or laggards.

SQL Functions used:
	- Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
	- Clause : GROUP BY, ORDER BY
========================================================================================
*/

-- Which 5 products Generating the highest revenue ?
SELECT TOP 5
	product_name,
	SUM (sales_amount) total_revenue
FROM goldd.fact_sales
GROUP BY product_name
ORDER BY SUM (sales_amount) DESC;

-- What are the 5 worst-performing products in terms of sales?
SELECT
	product_name,
	total_revenue
FROM (
		SELECT 
			product_name ,
			SUM (sales_amount) total_revenue,
			ROW_NUMBER () OVER (ORDER BY SUM(sales_amount) ASC) rank_product
		FROM goldd.fact_sales
		GROUP BY product_name )t
WHERE rank_product <=5

-- Find the top 10 customers who have generated the highest revenue
SELECT 
	customer_key,
	customer_firstname,
	customer_lastname,
	total_revenue
FROM (
	SELECT 
		s.customer_key,
		c.customer_firstname,
		c.customer_lastname,
		SUM (sales_amount) total_revenue,
		ROW_NUMBER () OVER (ORDER BY SUM (sales_amount) DESC) rank_customer
	FROM goldd.fact_sales s
	LEFT JOIN goldd.dim_customers c
	ON s.customer_key = c.customer_key
	GROUP BY s.customer_key, c.customer_firstname, c.customer_lastname)t
WHERE rank_customer <= 5

-- The 3 customers with the fewest orders placed
SELECT
	customer_key,
	customer_firstname,
	customer_lastname,
	total_orders
FROM (
		SELECT
			c.customer_key,
			c.customer_firstname,
			c.customer_lastname,
			COUNT (DISTINCT order_number) total_orders,
			ROW_NUMBER () OVER (ORDER BY COUNT (DISTINCT order_number) ASC) rank_customer
		FROM goldd.fact_sales s
		LEFT JOIN goldd.dim_customers c
		ON s.customer_key = c.customer_key
		GROUP BY c.customer_key, c.customer_firstname, c.customer_lastname)t
WHERE rank_customer <=3
