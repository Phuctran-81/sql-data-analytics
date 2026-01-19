/*
==============================================================================
Part - to - Whole Analysis
==============================================================================
Purpose:
	- To compare performance or metrics across dimensions or time periods.
	- To evaluate differences between categories.
	- Useful for A/B testing or regional comparisons.
SQL Functions Used:
	- SUM (), AVG(): Aggregates values for comparison.
	- Window functions: SUM () OVER () for total calculation.
==============================================================================
*/

-- Which categories contribute the most to overall sales ?
WITH cte_overal_sales AS (
SELECT
category,
SUM (sales_amount) total_sales
FROM goldd.fact_sales f
LEFT JOIN goldd.dim_products p
ON f.product_key = p.product_key
GROUP BY category )
SELECT
category,
SUM (total_sales) OVER () overal_sales,
CONCAT (ROUND(CAST (total_sales AS FLOAT)/ SUM (total_sales) OVER () * 100,2), ' ', '%') contribute_percent
FROM cte_overal_sales 
