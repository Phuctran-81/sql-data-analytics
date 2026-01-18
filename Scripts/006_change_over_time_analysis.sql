/*
=====================================================================
Change Over Time Analysis
=====================================================================
Purpose:
	- To track trends, growth, and changes in key metrics over time.
	- For time-series analysis and identifing seasonality.
	- To measure growth or decline over specific periods.

SQL Functions Used:
	- Date Functions: YEAR (), MONTH().
	- Aggregate Functions: SUM(), COUNT().
=====================================================================
*/

-- Analysis sales performance over time
SELECT
YEAR (Order_date) year_sales,
MONTH (order_date) month_sales,
SUM (sales_amount) AS total_sales,
COUNT (DISTINCT order_number) AS total_order,
SUM (quantity) AS total_quantity
FROM goldd.fact_sales
GROUP BY YEAR (Order_date), MONTH (order_date)
ORDER BY YEAR (Order_date), MONTH (order_date)
