/* ================================================================
   Project: Data Warehouse Analytics Setup
   Steps Performed:
     1. Drop existing database (if any)
     2. Create new database: DataWarehouseAnalytics
     3. Create schema: gold
     4. Create dimension & fact tables
     5. Load data from CSV files
   ----------------------------------------------------------------
   ⚠ CAUTION:
   This script will completely remove the database [DataWarehouseAnalytics] 
   if it already exists. Make sure to backup any data before running.
   ================================================================ */

-- Step 1: Switch to master before drop/create
USE master;
GO

-- Step 2: Drop the database if already present
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics 
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Step 3: Create fresh database
CREATE DATABASE DataWarehouseAnalytics;
GO

-- Use the new DB
USE DataWarehouseAnalytics;
GO

-- Step 4: Create schema gold
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC ('CREATE SCHEMA gold');
END;
GO

/* ================================================================
   Create Dimension & Fact Tables
   ================================================================ */

-- Customers Dimension
CREATE TABLE gold.dim_customers
(
    customer_key     INT,
    customer_id      INT,
    customer_number  NVARCHAR(50),
    first_name       NVARCHAR(50),
    last_name        NVARCHAR(50),
    country          NVARCHAR(50),
    marital_status   NVARCHAR(50),
    gender           NVARCHAR(50),
    birthdate        DATE,
    create_date      DATE
);
GO

-- Products Dimension
CREATE TABLE gold.dim_products
(
    product_key     INT,
    product_id      INT,
    product_number  NVARCHAR(50),
    product_name    NVARCHAR(50),
    category_id     NVARCHAR(50),
    category        NVARCHAR(50),
    subcategory     NVARCHAR(50),
    maintenance     NVARCHAR(50),
    cost            INT,
    product_line    NVARCHAR(50),
    start_date      DATE
);
GO

-- Sales Fact Table
CREATE TABLE gold.fact_sales
(
    order_number   NVARCHAR(50),
    product_key    INT,
    customer_key   INT,
    order_date     DATE,
    shipping_date  DATE,
    due_date       DATE,
    sales_amount   INT,
    quantity       TINYINT,
    price          INT
);
GO

/* ================================================================
   Load Data into Tables
   ================================================================ */

-- Load Customers Data
TRUNCATE TABLE gold.dim_customers;
BULK INSERT gold.dim_customers
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.dim_customers.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

-- Load Products Data
TRUNCATE TABLE gold.dim_products;
BULK INSERT gold.dim_products
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.dim_products.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

-- Load Sales Data
TRUNCATE TABLE gold.fact_sales;
BULK INSERT gold.fact_sales
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.fact_sales.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO
