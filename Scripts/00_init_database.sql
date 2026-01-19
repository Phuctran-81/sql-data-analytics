/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics'.
=============================================================
*/


USE master;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Create schemas
CREATE SCHEMA goldd;
GO

/*
=============================================================
Create table goldd.dim_customers
=============================================================
*/
CREATE TABLE goldd.dim_customers (
	customer_key INT,
	customer_id INT,
	customer_number NVARCHAR (30),
	customer_firstname NVARCHAR (30),
	customer_lastname NVARCHAR (30),
	customer_marital_status NVARCHAR (20),
	customer_gender NVARCHAR (20),
	customer_birthday DATE,
	cntry NVARCHAR (30),
	customer_create_date DATE
	);
GO

/*
=============================================================
Create table goldd.dim_products
=============================================================
*/
CREATE TABLE goldd.dim_products (
	product_key INT,
	product_id INT,
	category_id NVARCHAR (20),
	product_number NVARCHAR (20),
	product_name NVARCHAR (50),
	category NVARCHAR (30),
	sub_category NVARCHAR (30),
	product_line NVARCHAR (30),
	product_cost INT,
	maintenance NVARCHAR (10),
	product_start_date DATE,
	);
GO

/*
=============================================================
Create table goldd.fact_sales
=============================================================
*/
CREATE TABLE goldd.fact_sales (
	order_number NVARCHAR (30),
	product_key INT,
	customer_key INT,
	product_name NVARCHAR (50),
	sales_amount INT,
	quantity INT,
	price INT,
	order_date DATE,
	shipping_date DATE,
	due_date DATE
	);
GO

-- Truncating table prior to inserting data to table
TRUNCATE TABLE goldd.dim_customers;
GO
-- Insert data to table goldd.dim_customers
BULK INSERT goldd.dim_customers 
FROM 'C:\Users\phuct\Downloads\dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

-- Truncating table prior to inserting data to table
TRUNCATE TABLE goldd.dim_products;
GO
-- Insert data to table goldd.dim_products
BULK INSERT goldd.dim_products
FROM 'C:\Users\phuct\Downloads\dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
GO

-- Truncating table prior to inserting data to table
TRUNCATE TABLE goldd.fact_sales;
GO
-- Insert data to table goldd.fact_sales
BULK INSERT goldd.fact_sales
FROM 'C:\Users\phuct\Downloads\fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
GO
