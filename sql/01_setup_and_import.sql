
-- =====================================================
-- PROJECT: ZEPTO PRODUCT & INVENTORY ANALYSIS
-- DATABASE: MySQL 8.0
-- SCRIPT: DATABASE SETUP AND DATA IMPORT
-- =====================================================

-- Step 1: Select the database
CREATE DATABASE IF NOT EXISTS zepto_analysis;

USE zepto_analysis;


-- Step 2: Create the Zepto table
CREATE TABLE IF NOT EXISTS zepto (
    sku_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp DECIMAL(8,2),
    discountPercent DECIMAL(5,2),
    availableQuantity INT,
    discountedSellingPrice DECIMAL(8,2),
    weightInGms INT,
    outOfStock BOOLEAN,
    quantity INT
);


-- Step 3: Check table structure
DESC zepto;


-- Step 4: Import CSV data
LOAD DATA LOCAL INFILE
'C:/Users/konak/OneDrive/Desktop/my_da_projects/zepto/zepto_v1.csv'
INTO TABLE zepto
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(category, name, mrp, discountPercent,
 availableQuantity, discountedSellingPrice,
 weightInGms, outOfStock, quantity);


-- Step 5: Verify imported data

-- Total number of records
SELECT COUNT(*) AS total_records
FROM zepto;

-- Preview the first 10 records
SELECT *
FROM zepto
LIMIT 10;

-- Check distinct product categories
SELECT COUNT(DISTINCT category) AS total_categories
FROM zepto;

-- Check for NULL values
SELECT *
FROM zepto
WHERE category IS NULL
   OR name IS NULL
   OR mrp IS NULL
   OR discountedSellingPrice IS NULL;
