/*
==============================================================================
Data Segmentation Analysis
==============================================================================
Purpose:
	- To group data into meaningful categories for targeted insights.
	- For customer segmentation, product categorization, or regiona analysis

SQL Functions Used:
	- CASE: Defines custom segmentation logic.
	- GROUP BY: Group data into segments.
==============================================================================
*/

/*
Segment products into cost ranges and
count how many products fall into each segment */
WITH cte_segment_product AS (
SELECT 
product_key,
product_name,
product_cost,
CASE
	WHEN product_cost < 100 THEN 'below 100'
	WHEN product_cost <= 800 THEN '100 - 800'
	WHEN product_cost <= 1500 THEN '801 - 1500'
	ELSE 'above 1500'
END product_segments
FROM goldd.dim_products)

SELECT
product_segments,
COUNT (product_key) total_product
FROM cte_segment_product
GROUP BY product_segments ;

/*
Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than $5,000
	- Regular: Customers with at least 12 months of history but spending $5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group.
*/
WITH cte_segment_customer AS (
SELECT
	customer_key,
	CASE 
		WHEN DATEDIFF (MONTH, MIN (order_date),'2014-01-28') >= 12 AND SUM(sales_amount) > 5000 THEN 'VIP'
		WHEN DATEDIFF (MONTH, MIN (order_date),'2014-01-28') >= 12 AND SUM(sales_amount) <= 5000 THEN 'Regular'
		ELSE 'New'
	END customer_segments
FROM goldd.fact_sales
GROUP BY customer_key)

SELECT
	customer_segments,
	COUNT (customer_key) total_customer
FROM cte_segment_customer 
GROUP BY customer_segments
