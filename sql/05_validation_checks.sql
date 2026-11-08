-- ============================================================
-- 05. VALIDATION CHECKS — MySQL 8.0
-- Run after creating clean_products.
-- ============================================================

USE zepto_analysis;

-- 1. Compare raw and clean row counts.
SELECT
    (SELECT COUNT(*) FROM raw_products) AS raw_rows,
    (SELECT COUNT(*) FROM clean_products) AS clean_rows,
    (SELECT COUNT(*) FROM raw_products)
      - (SELECT COUNT(*) FROM clean_products) AS excluded_rows;

-- 2. Clean table should contain no non-positive prices.
SELECT COUNT(*) AS invalid_price_rows
FROM clean_products
WHERE mrp_inr <= 0
   OR discounted_selling_price_inr <= 0;

-- 3. Check NULL values in required clean columns.
SELECT
    SUM(category IS NULL) AS null_category,
    SUM(name IS NULL) AS null_name,
    SUM(mrp_inr IS NULL) AS null_mrp,
    SUM(discounted_selling_price_inr IS NULL) AS null_selling_price,
    SUM(out_of_stock IS NULL) AS null_stock_status
FROM clean_products;

-- 4. Confirm source price conversion for a few records.
SELECT
    r.raw_id,
    r.mrp AS source_mrp_paise,
    c.mrp_inr AS clean_mrp_inr,
    r.discountedSellingPrice AS source_selling_price_paise,
    c.discounted_selling_price_inr AS clean_selling_price_inr
FROM raw_products AS r
JOIN clean_products AS c
    ON r.raw_id = c.sku_id
ORDER BY r.raw_id
LIMIT 10;

-- 5. Confirm zero-weight rows are retained.
SELECT COUNT(*) AS zero_weight_rows_retained
FROM clean_products
WHERE weight_in_gms = 0;

-- 6. Confirm stock-status values are valid in clean table.
SELECT DISTINCT out_of_stock
FROM clean_products;

-- 7. Check for negative stock or quantity values.
SELECT *
FROM clean_products
WHERE available_quantity < 0
   OR source_quantity < 0;

-- 8. Check repeated names; do not delete solely based on this result.
SELECT name, COUNT(*) AS source_rows
FROM clean_products
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY source_rows DESC;
