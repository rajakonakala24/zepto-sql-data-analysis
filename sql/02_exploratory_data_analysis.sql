-- ============================================================
-- 02. EXPLORATORY DATA ANALYSIS — MySQL 8.0
-- Run after importing the CSV into raw_products.
-- ============================================================

USE zepto_analysis;

-- 1. Total number of source rows.
SELECT COUNT(*) AS total_number_of_rows
FROM raw_products;

-- 2. Preview the first 10 rows.
SELECT *
FROM raw_products
ORDER BY raw_id
LIMIT 10;

-- 3. Check NULL values in all source columns.
SELECT
    SUM(category IS NULL) AS null_category,
    SUM(name IS NULL) AS null_name,
    SUM(mrp IS NULL) AS null_mrp,
    SUM(discountPercent IS NULL) AS null_discount_percent,
    SUM(availableQuantity IS NULL) AS null_available_quantity,
    SUM(discountedSellingPrice IS NULL) AS null_discounted_price,
    SUM(weightInGms IS NULL) AS null_weight,
    SUM(outOfStock IS NULL) AS null_out_of_stock,
    SUM(quantity IS NULL) AS null_quantity
FROM raw_products;

-- 4. Find repeated name/category groups.
-- Repeated names are not automatically duplicates.
SELECT name, category, COUNT(*) AS repeated_row_count
FROM raw_products
GROUP BY name, category
HAVING COUNT(*) > 1
ORDER BY repeated_row_count DESC, name;

-- 5. Inspect a few examples before deciding whether rows are duplicates.
SELECT *
FROM raw_products
WHERE name = 'Onion'
  AND category = 'Fruits & Vegetables'
ORDER BY raw_id;

SELECT *
FROM raw_products
WHERE name = 'Potato'
  AND category = 'Fruits & Vegetables'
ORDER BY raw_id;

-- 6. Number of source rows per category.
SELECT category, COUNT(*) AS product_rows
FROM raw_products
GROUP BY category
ORDER BY product_rows DESC;

-- 7. Distinct category names.
SELECT DISTINCT category
FROM raw_products
ORDER BY category;

-- 8. In-stock versus out-of-stock counts.
SELECT UPPER(TRIM(outOfStock)) AS stock_status, COUNT(*) AS row_count
FROM raw_products
GROUP BY UPPER(TRIM(outOfStock));

-- 9. Product names appearing in multiple source rows.
SELECT name, COUNT(*) AS number_of_source_rows
FROM raw_products
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY number_of_source_rows DESC, name;

-- 10. Rows with invalid/non-positive prices.
SELECT *
FROM raw_products
WHERE mrp <= 0
   OR discountedSellingPrice <= 0;

-- 11. Rows with zero or negative weights.
SELECT *
FROM raw_products
WHERE weightInGms <= 0;

-- 12. Check unexpected stock-status values.
SELECT DISTINCT outOfStock
FROM raw_products
WHERE UPPER(TRIM(outOfStock)) NOT IN ('TRUE', 'FALSE')
   OR outOfStock IS NULL;
