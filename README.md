# Retail Sales Analysis using SQL

## Project Overview

This project analyzes retail sales transaction data using SQL to understand sales performance, customer behavior, and time-based trends. The focus of this project is to apply SQL concepts in a real-world analytical workflow and strengthen the ability to transform raw data into meaningful business insights.

The project includes database design, data validation, exploratory analysis, and analytical SQL queries that answer practical business questions.

---

## What This Project Demonstrates

- End-to-end SQL-based data analysis
- Translating business questions into SQL queries
- Writing clean, readable, and structured SQL
- Applying analytical thinking to extract insights from data

---

## Skills & Concepts Applied

### SQL
- Database and table creation
- Data types and constraints
- Filtering using `WHERE`
- Aggregations: `SUM`, `AVG`, `COUNT`
- Grouping and ordering results
- Conditional logic using `CASE`
- Date and time functions (`EXTRACT`, `TO_CHAR`)
- Window functions (`RANK`)
- Common Table Expressions (CTEs)
- Data cleaning and NULL handling

### Analytics
- Data exploration and validation
- Customer segmentation
- Category-level performance analysis
- Time-based trend analysis
- Shift-wise sales analysis

---

## Database Information

- **Database Name:** `sql_project_p2`
- **Table Name:** `retail_sales`

---

## Project Structure
Retail-Sales-Analysis-SQL
├── database_setup.sql
├── data_cleaning.sql
├── analysis_queries.sql
└── README.md


---

## Database Setup

```sql
CREATE DATABASE sql_project_p2;

CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(20),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
## Data Exploration & Cleaning
SELECT COUNT(*) FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

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


## Data Analysis

-- Sales on a specific date
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Clothing sales in Nov 2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;

-- Total sales per category
SELECT category,
       SUM(total_sale) AS total_sales,
       COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Average age of Beauty category customers
SELECT ROUND(AVG(age), 0) AS average_age
FROM retail_sales
WHERE category = 'Beauty';

-- High-value transactions
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Transactions by gender and category
SELECT category,
       gender,
       COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender;

-- Best-selling month in each year
SELECT year, month, avg_sale
FROM (
    SELECT EXTRACT(YEAR FROM sale_date) AS year,
           EXTRACT(MONTH FROM sale_date) AS month,
           AVG(total_sale) AS avg_sale,
           RANK() OVER (
               PARTITION BY EXTRACT(YEAR FROM sale_date)
               ORDER BY AVG(total_sale) DESC
           ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) t
WHERE rank = 1;

-- Top 5 customers by total sales
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Unique customers per category
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Sales by shift
WITH hourly_sales AS (
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift,
       COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift

```

## Findings

- **Customer Demographics:**  
  The dataset contains customers across multiple age groups, with purchasing activity spread across different product categories such as Clothing and Beauty.

- **High-Value Transactions:**  
  A subset of transactions recorded total sales greater than 1000, indicating the presence of premium or high-value purchases.

- **Sales Trends:**  
  Monthly sales analysis reveals noticeable variations over time, helping identify peak-performing periods and potential seasonality.

- **Customer Insights:**  
  The analysis highlights top-spending customers and identifies product categories that attract higher customer engagement.

---

## Reports Generated

- **Sales Summary:**  
  Aggregated insights covering total sales, customer demographics, and category-level performance.

- **Trend Analysis:**  
  Time-based insights analyzing sales behavior across months, years, and daily shifts (morning, afternoon, evening).

- **Customer Insights:**  
  Reports identifying high-value customers and the number of unique customers purchasing from each category.

---

## Conclusion

This project demonstrates the practical application of SQL in analyzing retail sales data through database design, data validation, exploratory analysis, and business-focused queries.  
By working through real-world analytical scenarios, the project strengthens skills in SQL querying, data-driven reasoning, and translating business questions into actionable insights.

The outcomes of this analysis can support better decision-making by improving understanding of sales patterns, customer behavior, and product performance.

## Connect with Me

LinkedIn: https://www.linkedin.com/in/pournima-kamble

Handshake: https://app.joinhandshake.com/profiles/pournima24
