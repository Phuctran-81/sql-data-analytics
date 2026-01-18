/*
===============================================================
Dimension Exploration
===============================================================
Purpose:
	- To explore the structure of dimension tables.

SQL Functions Used:
	- DISTINCT
	- ORDER BY
===============================================================
*/
-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT
	cntry
FROM goldd.dim_customers
ORDER BY cntry;

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT
	category,
	sub_category,
	product_name
FROM goldd.dim_products
ORDER BY category, sub_category, product_name;
