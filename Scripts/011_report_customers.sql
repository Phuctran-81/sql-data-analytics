/*
==============================================================================
Customer Report
==============================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics:
		- Total orders.
		- Total sales.
		- Total quantity purchaseed.
		- Total Products.
		- Lifespan (in months)
	4. Calculates valuable KIPs:
		- recency (months since last order)
		- average order value.
		- average monthly spend
==============================================================================
*/

WITH cte_customer_sales_info AS (
SELECT
f.customer_key,
product_key,
customer_firstname,
customer_lastname,
customer_gender,
customer_birthday,
cntry,
order_number,
order_date,
sales_amount,
quantity
FROM goldd.fact_sales f
LEFT JOIN goldd.dim_customers c
ON f.customer_key = c.customer_key)

SELECT 
	COUNT (order_number) total_orders,
	SUM (sales_amount) total_sales,
	SUM (quantity) total_quantity,
	COUNT (DISTINCT product_key) total_product,
	DATEDIFF (MONTH, MIN (order_date),'2014-01-28') lifespan,
	CASE 
		WHEN DATEDIFF (MONTH, MIN (order_date),'2014-01-28') >= 12 AND SUM(sales_amount) > 5000 THEN 'VIP'
		WHEN DATEDIFF (MONTH, MIN (order_date),'2014-01-28') >= 12 AND SUM(sales_amount) <= 5000 THEN 'Regular'
		ELSE 'New'
	END customer_segments,
CASE 
	WHEN DATEDIFF (YEAR, customer_birthday, '2014-01-28') BETWEEN 70 AND 98 THEN '70-98'
	WHEN DATEDIFF (YEAR, customer_birthday, '2014-01-28') BETWEEN 50 AND 69 THEN '50-69'
	WHEN DATEDIFF (YEAR, customer_birthday, '2014-01-28') BETWEEN 28 AND 49 THEN '28-49'
END age_groups,
DATEDIFF (MONTH, MAX(order_date), '2014-01-28') recency,
CASE WHEN DATEDIFF (MONTH, MIN (order_date),'2014-01-28') = 0 THEN SUM (sales_amount)
	ELSE SUM (sales_amount) / DATEDIFF (MONTH, MIN (order_date),'2014-01-28') 
END avg_monthly_spend,
SUM (sales_amount) / COUNT (order_number) avg_order_value
FROM cte_customer_sales_info
GROUP BY customer_key, customer_birthday;
