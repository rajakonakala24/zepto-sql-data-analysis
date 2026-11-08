# Dataset profile and verified observations

These observations were calculated from the supplied CSV file with Python/pandas. They are descriptive checks of the file, **not MySQL execution results**. The SQL scripts are provided for you to run in MySQL 8.0.

## Dataset profile

- Source file: `dataset/zepto_products.csv`
- Rows: **3,732**
- Columns: **9**
- Distinct categories: **14**
- Distinct product names: **1,681**
- Missing values across all source columns: **0**
- Out-of-stock rows: **453 (12.14%)**
- In-stock rows: **3,279**
- Repeated product-name groups: **1,214**
- Rows belonging to a repeated product name: **3,265**

Repeated product names are not automatically duplicates. They may represent variants or separate source rows; inspect all attributes before removing anything.

## Data quality observations

- Rows with MRP <= 0 or discounted selling price <= 0: **1**
- Rows with zero weight: **4**
- The provided CSV contains no null values in its nine columns.
- The source prices appear to be in paise (for example, 2500 corresponds to ₹25.00). The MySQL cleaning script converts them to rupees by dividing by 100.
- The source contains `availableQuantity` and `outOfStock`, not completed orders or transaction dates. Therefore, inventory value is an estimate, not realized sales revenue.

## Highest average discount categories (calculated from raw CSV)

| Category | Average discount (%) |
|---|---:|
| Fruits & Vegetables | 15.46 |
| Meats, Fish & Eggs | 11.03 |
| Ice Cream & Desserts | 8.32 |
| Packaged Food | 8.32 |
| Chocolates & Candies | 8.32 |

## Interpretation cautions

1. `availableQuantity` is treated as the available stock count for inventory estimates.
2. `quantity` is retained as supplied; its business meaning is not defined in the CSV metadata.
3. `sku_id` in the SQL clean table is based on the generated `raw_id`; it is not a source SKU identifier.
4. Zero-weight rows are retained in the cleaned table, but excluded from price-per-gram calculations.
5. MySQL outputs should be run and captured from MySQL Workbench before adding screenshots or claiming SQL execution/performance results.
