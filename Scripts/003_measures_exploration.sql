/*
==============================================================================================
Measure Exploration (Key Metrics)
==============================================================================================
Purpose:
	- To calculate aggregated metrics (e.g., totals, averages) for quick insights.
	- To identify overall trends or spot anomalies.

SQL Functions Used:
	- COUNT(), SUM(), AVG ()
==============================================================================================
*/
/*
==============================================================================================
Generate a report that shows all key metrics of the business
==============================================================================================
*/
-- Find the Total sales
SELECT
	'Total Sales' AS measure_name,
	SUM (sales_amount) AS measure_value
FROM goldd.fact_sales

UNION ALL
-- Find how many items are sold.
SELECT
	'total items' AS measure_name,
	SUM(quantity) AS measure_value
FROM goldd.fact_sales

UNION ALL
-- Find the average selling price.
SELECT 
	'Average selling Price' AS measure_name,
	SUM(sales_amount)/ SUM (quantity) AS measure_value
FROM goldd.fact_sales

UNION ALL
-- Find the total number of orders
SELECT 
	'Total Orders' AS measure_name,
	COUNT (DISTINCT order_number) AS measure_value
FROM goldd.fact_sales

UNION ALL
-- Find the total number of products
SELECT 
	'Total Products' AS measure_name,
	COUNT (DISTINCT product_id) measure_value
FROM goldd.dim_products

UNION ALL
-- Find the total number of customers.
SELECT
	'Total Customers' AS measure_name,
	COUNT (customer_key) AS measure_value
FROM goldd.dim_customers

UNION ALL
-- Find the total number of customers that has placed an order
SELECT
	'Total Customer Ordering' AS measure_name,
	COUNT (DISTINCT customer_key) AS measure_value
FROM goldd.fact_sales
WHERE order_number IS NOT NULL;
