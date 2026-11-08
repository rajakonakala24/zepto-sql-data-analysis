# Zepto Product & Inventory Analysis — MySQL 8.0

An end-to-end SQL portfolio project exploring product pricing, discounts, stock availability, product weights, and estimated inventory value using **MySQL 8.0**.

> **Scope note:** The supplied file is a product and inventory snapshot. It does not contain completed orders, transaction dates, customers, or order-level sales. Calculations using `discountedSellingPrice * availableQuantity` are therefore **estimated inventory value**, not realized sales revenue.

## Project objectives

- Import and preserve the original CSV data.
- Explore product categories, stock status, prices, discounts, and repeated product names.
- Clean invalid price records without modifying the raw table.
- Convert source prices from paise to Indian rupees (INR) in a reproducible way.
- Answer business questions using aggregation, `CASE`, subqueries, CTEs, and window functions.
- Validate the cleaned dataset.

## Dataset

`dataset/zepto_products.csv`

The supplied CSV has 3,732 rows and 9 source columns.

| Column | Meaning used in this project |
|---|---|
| `Category` | Product category |
| `name` | Product name |
| `mrp` | Listed price; source values interpreted as paise |
| `discountPercent` | Discount percentage |
| `availableQuantity` | Available stock quantity |
| `discountedSellingPrice` | Discounted selling price; source values interpreted as paise |
| `weightInGms` | Product weight in grams |
| `outOfStock` | Source stock-status text (`TRUE` / `FALSE`) |
| `quantity` | Retained as supplied; exact business meaning is not defined in source metadata |

## Repository structure

```text
Zepto-MySQL-Portfolio/
├── README.md
├── dataset/
│   └── zepto_products.csv
├── sql/
│   ├── 01_setup_and_import.sql
│   ├── 02_exploratory_data_analysis.sql
│   ├── 03_create_clean_table.sql
│   ├── 04_business_analysis.sql
│   └── 05_validation_checks.sql
└── insights/
    └── dataset_profile.md
```

## Requirements

- MySQL Server 8.0
- MySQL Workbench 8.0 (recommended)
- Git and a GitHub account (for publishing the portfolio)

## How to run in MySQL Workbench

### Step 1 — Create the database and raw table

Open `sql/01_setup_and_import.sql` in MySQL Workbench and execute it. It creates the `zepto_analysis` database and an empty `raw_products` table.

### Step 2 — Import the CSV

Recommended beginner-friendly method:

1. In MySQL Workbench, refresh the Schemas panel.
2. Expand `zepto_analysis` → `Tables`.
3. Right-click `raw_products` and choose **Table Data Import Wizard**.
4. Select `dataset/zepto_products.csv`.
5. Choose comma as the delimiter and confirm that the first row contains column names.
6. Map the nine CSV columns to the matching columns in `raw_products`. Do not map `raw_id`; it is generated automatically.
7. Finish the import and confirm that 3,732 rows were imported.

Alternatively, enable `LOCAL INFILE` on your MySQL client/server and edit the file path in the optional `LOAD DATA LOCAL INFILE` section at the bottom of `01_setup_and_import.sql`. The file path must be a path on your own computer.

### Step 3 — Run scripts in order

1. `02_exploratory_data_analysis.sql`
2. `03_create_clean_table.sql`
3. `05_validation_checks.sql`
4. `04_business_analysis.sql`

Execute each script in MySQL Workbench. Review the result grids and save genuine screenshots for the GitHub README.

## Cleaning decisions

- `raw_products` preserves the imported source values.
- The clean table excludes rows where MRP or discounted selling price is non-positive.
- Source prices are interpreted as paise and divided by 100 to store INR in `clean_products`.
- Zero-weight records are retained, but excluded from price-per-gram calculations.
- Repeated product names are not automatically deleted. They may represent variants or separate source records.
- `sku_id` in `clean_products` is a generated row identifier based on `raw_id`; it is not a source SKU identifier.
- Unknown or invalid `outOfStock` values are not silently converted into `FALSE`.

## Key business questions

The SQL scripts answer questions including:

1. How many records and products are present?
2. How many products belong to each category?
3. What is the in-stock versus out-of-stock split?
4. Which product names appear across multiple source rows?
5. Which products have the highest discount percentages?
6. Which out-of-stock products have an MRP above the overall average?
7. What is the estimated inventory value by category and overall?
8. Which products have MRP above ₹500 and discounts below 10%?
9. Which categories have the highest average discount?
10. Which products offer the lowest price per gram among products weighing at least 100 g?
11. How can products be grouped by weight?
12. What is the total estimated inventory weight by category?
13. Which products have discounts above their category average? (CTE)
14. What is each product's discount rank within its category? (window function)

## Important interpretation

`SUM(discounted_selling_price_inr * available_quantity)` estimates the value of currently available inventory at the discounted price. It is **not sales revenue**. The dataset does not contain sales transactions.

## Reproducibility and reruns

- Re-running `01_setup_and_import.sql` does not delete imported raw data.
- Before importing the CSV again, run `TRUNCATE TABLE zepto_analysis.raw_products;` to avoid duplicate imports.
- Re-running `03_create_clean_table.sql` recreates only `clean_products`; it does not modify `raw_products`.
- Do not run the price conversion against the raw table. Conversion is performed in the `INSERT ... SELECT` that builds the clean table.

## Reference and attribution

This project was developed as an improved learning and portfolio version using the public Zepto SQL analysis repository as a learning reference:
https://github.com/amlanmohanty/zepto-SQL-data-analysis-project

The dataset supplied for this project is included in `dataset/`. Review the reference repository's license and dataset terms before reusing any of its code or assets. The SQL scripts and project documentation here should be presented as your own work only after you understand, execute, and verify them.

## Author's execution checklist

- [ ] Import the CSV into `raw_products`.
- [ ] Confirm the raw row count is 3,732.
- [ ] Run all SQL scripts in order.
- [ ] Review validation results.
- [ ] Capture screenshots from your own MySQL Workbench session.
- [ ] Add your own observations based on actual query outputs.
- [ ] Push the project to your GitHub repository.
