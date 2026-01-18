/*
=============================================================================
Cumulative Analysis
=============================================================================
Purpose:
	- To calculate running totals or moving averages for key metrics.
	- To track performance over time cumulatively.
	- Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
	- Window Functions: SUM () OVER ().
=============================================================================
*/

-- Calculate the total sales per month
-- And the running total of sales over time
SELECT 
	YEAR (order_date) AS year_sales,
	MONTH (order_date) AS month_sales,
	SUM (sales_amount) total_sales,
	SUM (SUM (sales_amount)) OVER (PARTITION BY YEAR (order_date) ORDER BY MONTH (order_date)) running_sales
FROM goldd.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR (order_date), MONTH (order_date)


