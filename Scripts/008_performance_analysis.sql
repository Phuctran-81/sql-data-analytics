/*
================================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
================================================================================
Purpose:
	- To measure the performance of products, customers, or regions over time.
	- For benchmarking and identifying high-performing entities.
	- To track yearly trends and growth.

SQL Functions Used:
	- LAG (): Accesses data from previous rows.
	- AVG() OVER(): Compute average values within partitions.
	- CASE: Defines conditional logic for trend analysis.
================================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of all product and the privious year's sales */
WITH cte_avg_sales AS (
	SELECT 
		product_key,
		product_name,
		YEAR (order_date) AS year_sales,
		SUM (sales_amount) AS current_sales
	FROM goldd.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY YEAR (order_date),product_key, product_name )

SELECT
	year_sales,
	product_key,
	product_name,
	current_sales,
	LAG (current_sales) OVER (PARTITION BY product_key ORDER BY year_sales) previous_sales,
	AVG (current_sales) OVER (PARTITION BY year_sales) overal_avg_sales,
	current_sales - AVG (current_sales) OVER (PARTITION BY year_sales) AS diff_avg,

	CASE 
		WHEN current_sales - AVG (current_sales) OVER (PARTITION BY year_sales) > 0 THEN 'above avg'
		WHEN current_sales - AVG (current_sales) OVER (PARTITION BY year_sales) < 0 THEN 'below avg'
		ELSE 'equal avg'
	END change_vs_avg,
  -- Year over Year Analysis
	current_sales - LAG (current_sales) OVER (PARTITION BY product_key ORDER BY year_sales) AS diff_previous_sales,
	CASE
		WHEN current_sales - LAG (current_sales) OVER (PARTITION BY product_key ORDER BY year_sales) > 0 THEN 'increase'
		WHEN current_sales - LAG (current_sales) OVER (PARTITION BY product_key ORDER BY year_sales) < 0 THEN 'decrease'
		WHEN current_sales - LAG (current_sales) OVER (PARTITION BY product_key ORDER BY year_sales) = 0 THEN 'unchange'
		ELSE 'no data from previous year'
	END change_vs_py_sales
FROM cte_avg_sales

