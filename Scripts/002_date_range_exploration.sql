/*
================================================================
Date Range Exploration
================================================================
Purpose:
	- To determine the temporal boundaries of key data points.
	- To understand the range of historical data.

SQL Functions Used:
	- MIN(), MAX(), DATEDIFF()
================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT
	MIN (order_date) first_order_date,
	MAX (order_date) last_order_date,
	DATEDIFF (MONTH, MIN (order_date), MAX (order_date)) total_duration
FROM goldd.fact_sales;


-- Find the youngest and oldest customer based on birthday.
WITH cte_customer_rank AS
(
SELECT
	customer_id,
	customer_firstname,
	customer_lastname,
	customer_birthday,
	DENSE_RANK () OVER (ORDER BY customer_birthday DESC) AS Youngest,
	DENSE_RANK () OVER (ORDER BY customer_birthday ASC) AS oldest
FROM goldd.dim_customers 
WHERE customer_birthday IS NOT NULL)
SELECT 
	customer_id,
	customer_firstname,
	customer_lastname,
	customer_birthday,
	CASE WHEN oldest = 1 THEN 'oldest'
		WHEN youngest = 1 THEN 'youngest'
	END customer_category
FROM cte_customer_rank
WHERE oldest = 1 or youngest = 1
