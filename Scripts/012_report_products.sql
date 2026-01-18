/*
===============================================================================================
Product Report
===============================================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as prodcut name, category, subcategory and cost.
	2. Segments product by revenue to identify High-performers, Mid-Range, or Low-performers.
	3. Aggregates product-level metrics:
		- Total orders.
		- Total sales.
		- Total quantity sold.
		- Total customer (unique)
		- Lifespan (in months)
	4. Calculates valuable KIPs:
		- recency (months since last order)
		- average order revenue (AOR)
		- average monthly revenue
=================================================================================================
*/

WITH cte_product_info AS (
SELECT
f.product_key,
f.product_name,
category,
sub_category,
product_cost,
order_date,
order_number,
sales_amount,
quantity,
customer_key
FROM goldd.fact_sales f
LEFT JOIN goldd.dim_products p
ON p.product_key = f.product_key)

SELECT 
product_key,
product_name,
category,
sub_category,
COUNT (order_number) total_orders,
SUM (sales_amount) total_sales,
SUM (quantity) total_quantity,
COUNT (DISTINCT customer_key) total_customer,
DATEDIFF (MONTH, MIN(order_date), '2014-01-28') lifespan,
DATEDIFF (MONTH, MAX (order_date), '2014-01-28') recency,
CASE 
	WHEN DATEDIFF (MONTH, MIN(order_date), '2014-01-28') = 0 THEN SUM (sales_amount)
	ELSE ROUND (CAST (SUM (sales_amount) AS FLOAT)/DATEDIFF (MONTH, MIN(order_date), '2014-01-28'),2)
END avg_monthly_revenue,
ROUND (CAST (SUM (sales_amount) AS FLOAT) / COUNT (order_number),2) avg_order_value,
CASE 
	WHEN SUM (sales_amount) < 15000 THEN 'Low - performers'
	WHEN SUM (sales_amount) BETWEEN 15000 AND 40000 THEN 'Mid-range'
	WHEN SUM (sales_amount) > 40000 THEN 'High-performers'
END product_segments
FROM cte_product_info
GROUP BY product_key, product_name, sub_category, category ;
