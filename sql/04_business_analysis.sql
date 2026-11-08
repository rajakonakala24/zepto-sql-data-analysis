-- ============================================================
-- 04. BUSINESS ANALYSIS — MySQL 8.0
-- Run after creating clean_products.
-- ============================================================

USE zepto_analysis;

-- Q1. Top 10 products by discount percentage.
SELECT sku_id, name, category, mrp_inr, discount_percent
FROM clean_products
ORDER BY discount_percent DESC, name
LIMIT 10;

-- Q2. Out-of-stock products whose MRP is above the overall average.
-- Dynamic threshold: no hard-coded average price.
SELECT sku_id, name, mrp_inr
FROM clean_products
WHERE mrp_inr > (SELECT AVG(mrp_inr) FROM clean_products)
  AND out_of_stock = TRUE
ORDER BY mrp_inr DESC;

-- Q3. Estimated inventory value by category (NOT sales revenue).
SELECT
    category,
    ROUND(SUM(discounted_selling_price_inr * available_quantity), 2)
        AS estimated_inventory_value_inr
FROM clean_products
GROUP BY category
ORDER BY estimated_inventory_value_inr DESC;

-- Q4. Total estimated inventory value across all categories.
SELECT
    ROUND(SUM(discounted_selling_price_inr * available_quantity), 2)
        AS total_estimated_inventory_value_inr
FROM clean_products;

-- Q5. Products with MRP above ₹500 and discount below 10%.
SELECT sku_id, name, mrp_inr, discount_percent
FROM clean_products
WHERE mrp_inr > 500
  AND discount_percent < 10
ORDER BY mrp_inr DESC;

-- Q6. Five categories with the highest average discount.
SELECT
    category,
    ROUND(AVG(discount_percent), 2) AS average_discount_percent
FROM clean_products
GROUP BY category
ORDER BY average_discount_percent DESC
LIMIT 5;

-- Q7. Price per gram for products weighing at least 100 g.
-- NULLIF prevents division by zero; zero-weight rows are excluded.
SELECT
    sku_id,
    name,
    weight_in_gms,
    discounted_selling_price_inr,
    ROUND(discounted_selling_price_inr / NULLIF(weight_in_gms, 0), 4)
        AS price_per_gram_inr
FROM clean_products
WHERE weight_in_gms >= 100
ORDER BY price_per_gram_inr ASC;

-- Q8. Group products into weight categories.
SELECT
    sku_id,
    name,
    weight_in_gms,
    CASE
        WHEN weight_in_gms < 1000 THEN 'Low'
        WHEN weight_in_gms < 5000 THEN 'Medium'
        ELSE 'Bulk'
    END AS weight_category
FROM clean_products
ORDER BY weight_in_gms;

-- Q9. Estimated total inventory weight by category.
SELECT
    category,
    SUM(weight_in_gms * available_quantity) AS estimated_inventory_weight_g
FROM clean_products
GROUP BY category
ORDER BY estimated_inventory_weight_g DESC;

-- Q10. Best-value products: top discount percentage.
-- Keep separate source rows visible through sku_id.
SELECT sku_id, name, category, mrp_inr, discount_percent
FROM clean_products
ORDER BY discount_percent DESC
LIMIT 10;

-- Q11. CTE: products whose discount is above their own category average.
WITH category_discount AS (
    SELECT
        category,
        AVG(discount_percent) AS category_avg_discount
    FROM clean_products
    GROUP BY category
)
SELECT
    p.sku_id,
    p.name,
    p.category,
    p.discount_percent,
    ROUND(cd.category_avg_discount, 2) AS category_avg_discount
FROM clean_products AS p
JOIN category_discount AS cd
    ON p.category = cd.category
WHERE p.discount_percent > cd.category_avg_discount
ORDER BY p.category, p.discount_percent DESC;

-- Q12. Window function: rank products by discount within each category.
SELECT
    sku_id,
    name,
    category,
    discount_percent,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY discount_percent DESC
    ) AS discount_rank_in_category
FROM clean_products
ORDER BY category, discount_rank_in_category, name;

-- Q13. Category-level in-stock and out-of-stock summary.
SELECT
    category,
    COUNT(*) AS total_product_rows,
    SUM(out_of_stock = FALSE) AS in_stock_rows,
    SUM(out_of_stock = TRUE) AS out_of_stock_rows,
    ROUND(100.0 * SUM(out_of_stock = TRUE) / COUNT(*), 2)
        AS out_of_stock_percentage
FROM clean_products
GROUP BY category
ORDER BY out_of_stock_percentage DESC;

-- Q14. Product rows with the highest estimated inventory value.
SELECT
    sku_id,
    name,
    category,
    available_quantity,
    discounted_selling_price_inr,
    ROUND(discounted_selling_price_inr * available_quantity, 2)
        AS estimated_inventory_value_inr
FROM clean_products
ORDER BY estimated_inventory_value_inr DESC
LIMIT 10;
