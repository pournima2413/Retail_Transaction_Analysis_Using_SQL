<div align="center">

# 🛒 Retail Sales Analysis using SQL

### *From raw transactions to real business decisions — purely with SQL*

---

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Database](https://img.shields.io/badge/Database-Retail%20Sales-FF6B35?style=for-the-badge&logo=databricks&logoColor=white)
![Analysis](https://img.shields.io/badge/Type-Business%20Analytics-6C3483?style=for-the-badge)
![Queries](https://img.shields.io/badge/Queries-10%20Business%20Questions-27AE60?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-14B8A6?style=for-the-badge)

---

*"Give me data and a SQL editor — I'll give you answers."*

</div>

---

## 〉 Why This Project

Every retail business sits on a goldmine of transaction data.
Most of it goes unanalysed. This project changes that.

Starting from a raw CSV of retail sales records — with no pre-built dashboards,
no drag-and-drop tools — this project answers **10 real business questions**
using nothing but SQL.

The workflow mirrors exactly what a data analyst does on the job:

```
Understand the data  →  Clean it  →  Explore it  →  Answer business questions  →  Report findings
```

---

## 〉 What This Project Demonstrates

```
◆  End-to-end SQL workflow — from database creation to business insight
◆  Translating vague business questions into precise SQL queries
◆  Writing clean, commented, production-readable SQL
◆  Data cleaning and NULL handling at the database level
◆  Advanced SQL — Window Functions, CTEs, CASE logic, Date functions
◆  Analytical thinking — not just querying, but interpreting results
```

---

## 〉 Database Schema

**Database:** `sql_project_p2` &nbsp;|&nbsp; **Table:** `retail_sales`

```sql
CREATE TABLE retail_sales (
    transaction_id   INT PRIMARY KEY,     -- Unique ID per transaction
    sale_date        DATE,                -- Date of purchase
    sale_time        TIME,                -- Time of purchase
    customer_id      INT,                 -- Unique customer identifier
    gender           VARCHAR(15),         -- Customer gender
    age              INT,                 -- Customer age
    category         VARCHAR(20),         -- Product category (Clothing, Beauty, etc.)
    quantity         INT,                 -- Units purchased
    price_per_unit   FLOAT,               -- Price per item
    cogs             FLOAT,               -- Cost of goods sold
    total_sale       FLOAT                -- Total transaction value
);
```

---

## 〉 SQL Skills Applied

<div align="center">

| Concept | Used For |
|:---|:---|
| `CREATE DATABASE / TABLE` | Schema setup and structure design |
| `WHERE` filters | Date, category, and value-based filtering |
| `SUM`, `AVG`, `COUNT` | Revenue, customer, and volume metrics |
| `GROUP BY`, `ORDER BY` | Category and customer-level aggregations |
| `CASE` statements | Shift classification (Morning / Afternoon / Evening) |
| `EXTRACT`, `TO_CHAR` | Year, month, and hour-level time analysis |
| `RANK()` | Window function — ranking months by average sales |
| `CTEs` | Modular, readable multi-step queries |
| `DISTINCT` | Unique customer counts per category |
| `IS NULL` / `DELETE` | Data cleaning and NULL removal |

</div>

---

## 〉 Phase 1 — Data Exploration & Cleaning

Before any analysis, the data was validated and cleaned.

```sql
-- How many records do we have?
SELECT COUNT(*) FROM retail_sales;

-- How many unique customers?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- What product categories exist?
SELECT DISTINCT category FROM retail_sales;
```

**Null value check across all columns:**

```sql
SELECT *
FROM retail_sales
WHERE sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```

**Remove records with missing data:**

```sql
DELETE FROM retail_sales
WHERE sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```

> **Why this matters:** Dirty data produces wrong answers. Cleaning first
> ensures every query downstream is working with complete, trustworthy records.

---

## 〉 Phase 2 — Business Questions & SQL Queries

### ❶ &nbsp; Sales on a Specific Date
**Business question:** *"Show me every transaction from November 5th, 2022."*

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```
> Use case: Investigating a spike or drop on a particular day.

---

### ❷ &nbsp; High-Quantity Clothing Sales in November 2022
**Business question:** *"Which clothing orders had 4+ units in November 2022?"*

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
```
> Use case: Identifying bulk buyers for loyalty or wholesale outreach.

---

### ❸ &nbsp; Total Revenue by Category
**Business question:** *"Which product category is making us the most money?"*

```sql
SELECT
    category,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC;
```
> Use case: Budget allocation and category-level investment decisions.

---

### ❹ &nbsp; Average Customer Age — Beauty Category
**Business question:** *"Who is our typical Beauty customer by age?"*

```sql
SELECT
    ROUND(AVG(age), 0) AS average_age
FROM retail_sales
WHERE category = 'Beauty';
```
> Use case: Targeting the right age segment in Beauty marketing campaigns.

---

### ❺ &nbsp; High-Value Transactions
**Business question:** *"Which transactions are premium purchases over $1,000?"*

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;
```
> Use case: Identifying VIP customers and high-margin transaction patterns.

---

### ❻ &nbsp; Transactions by Gender and Category
**Business question:** *"Do men and women shop differently across categories?"*

```sql
SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category, total_transactions DESC;
```
> Use case: Gender-specific marketing strategy and product range decisions.

---

### ❼ &nbsp; Best-Selling Month Per Year (Window Function)
**Business question:** *"Which single month each year had the highest average sale value?"*

```sql
SELECT year, month, average_sale
FROM (
    SELECT
        EXTRACT(YEAR  FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale)               AS average_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) AS ranked_months
WHERE rank = 1;
```
> Use case: Seasonal planning — stock up and staff up before peak months.
> Uses `RANK()` window function to find the top month within each year independently.

---

### ❽ &nbsp; Top 5 Customers by Spend
**Business question:** *"Who are our highest-value customers?"*

```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;
```
> Use case: VIP loyalty programme, personalised offers, retention focus.

---

### ❾ &nbsp; Unique Customers per Category
**Business question:** *"How many distinct customers does each category attract?"*

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;
```
> Use case: Understanding category reach and customer diversity per segment.

---

### ❿ &nbsp; Orders by Shift (Morning / Afternoon / Evening)
**Business question:** *"When during the day do customers shop most?"*

```sql
WITH hourly_sales AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12              THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift
ORDER BY total_orders DESC;
```
> Use case: Staff scheduling, shift-specific promotions, delivery timing.
> Uses a **CTE** to cleanly separate the shift logic from the aggregation.

---

## 〉 Key Findings

<div align="center">

| Finding | Detail | Business Action |
|:---|:---|:---|
| **Category Revenue** | One category significantly outperforms others | Prioritise stock and marketing spend there |
| **Peak Month** | Best-selling months identified per year | Plan inventory and promotions ahead of peak |
| **High-Value Transactions** | Subset of orders exceed $1,000 | Create VIP tier for these customers |
| **Shift Analysis** | Orders cluster in specific time windows | Align staff rosters to demand windows |
| **Gender Patterns** | Shopping behaviour differs by gender per category | Tailor category-level campaigns by gender |
| **Beauty Demographics** | Average age identified for Beauty shoppers | Design age-targeted Beauty promotions |

</div>

---

## 〉 Project Structure

```
Retail-Sales-Analysis-SQL/
│
├── database_setup.sql          ← CREATE DATABASE + CREATE TABLE
├── data_cleaning.sql           ← NULL checks and DELETE statements
├── analysis_queries.sql        ← All 10 business question queries
└── README.md
```

---

## 〉 How to Run

```sql
-- Step 1: Create the database
CREATE DATABASE sql_project_p2;

-- Step 2: Run database_setup.sql to create the table

-- Step 3: Import your CSV data into the retail_sales table
-- (Use pgAdmin Import Tool or COPY command)

-- Step 4: Run data_cleaning.sql to validate and clean records

-- Step 5: Run analysis_queries.sql to generate all insights
```

---

## 〉 What I Built and Learned

```txt
✅  Designed a relational database schema from scratch
✅  Wrote and executed 10 business-driven SQL queries end-to-end
✅  Applied Window Functions (RANK) for year-over-year ranking
✅  Used CTEs to write modular, readable multi-step logic
✅  Performed data cleaning at the database level — not in Excel
✅  Translated vague business questions into precise SQL logic
✅  Derived actionable recommendations from query outputs
✅  Documented code with inline comments for readability
```

---

<div align="center">

---

**Pournima Kamble**
MS Computer Science @ Cleveland State University (May 2026)
Seeking Data Analyst & Data Engineer roles · Available June 2026

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/pournimakamble)
[![GitHub](https://img.shields.io/badge/GitHub-pournima2413-333333?style=for-the-badge&logo=github&logoColor=white)](https://github.com/pournima2413)
[![Email](https://img.shields.io/badge/Email-Say%20Hello-EA4335?style=for-the-badge&logo=gmail&logoColor=white)](mailto:pournima2413@gmail.com)
[![Handshake](https://img.shields.io/badge/Handshake-Profile-E87722?style=for-the-badge&logo=handshake&logoColor=white)](https://app.joinhandshake.com/profiles/pournima24)

</div>
