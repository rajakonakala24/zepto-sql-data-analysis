-- ============================================================
-- 03. CREATE CLEAN TABLE — MySQL 8.0
-- Raw table remains unchanged. Re-running recreates clean_products.
-- ============================================================

USE zepto_analysis;

DROP TABLE IF EXISTS clean_products;

CREATE TABLE clean_products (
    sku_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp_inr DECIMAL(10,2),
    discount_percent DECIMAL(7,2),
    available_quantity INT,
    discounted_selling_price_inr DECIMAL(10,2),
    weight_in_gms INT,
    out_of_stock BOOLEAN,
    source_quantity INT
);

-- Convert paise to INR once while inserting into the clean table.
-- Exclude invalid prices and invalid stock-status values.
-- Zero weight is retained for transparency.
INSERT INTO clean_products (
    sku_id, category, name, mrp_inr, discount_percent,
    available_quantity, discounted_selling_price_inr,
    weight_in_gms, out_of_stock, source_quantity
)
SELECT
    raw_id,
    category,
    name,
    mrp / 100.0,
    discountPercent,
    availableQuantity,
    discountedSellingPrice / 100.0,
    weightInGms,
    CASE
        WHEN UPPER(TRIM(outOfStock)) = 'TRUE' THEN TRUE
        WHEN UPPER(TRIM(outOfStock)) = 'FALSE' THEN FALSE
    END,
    quantity
FROM raw_products
WHERE mrp > 0
  AND discountedSellingPrice > 0
  AND UPPER(TRIM(outOfStock)) IN ('TRUE', 'FALSE')
  AND name IS NOT NULL;

-- Review the clean table.
SELECT COUNT(*) AS clean_row_count
FROM clean_products;

SELECT *
FROM clean_products
ORDER BY sku_id
LIMIT 10;
