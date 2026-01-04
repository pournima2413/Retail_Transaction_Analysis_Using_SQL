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
1. Database Setup
Database Creation: The project starts by creating a database named p1_retail_db.
Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

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
```


## 2. Data Exploration & Cleaning
Record Count: Determine the total number of records in the dataset.
Customer Count: Find out how many unique customers are in the dataset.
Category Count: Identify all unique product categories in the dataset.
Null Value Check: Check for any null values in the dataset and delete records with missing data.
```sql
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

```
## 3. Data Analysis & Findings
The following SQL queries were developed to answer specific business questions:

--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
```sql 
select * from retail_sales
where sale_date = '2022-11-05';
```
-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
```sql
select * from retail_sales
where category = 'Clothing' 
and TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
and quantity >= 4 ;
```

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.:
```sql
select  category, sum(total_sale) as total_sales 
from retail_sales
group by category;
```

-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
```sql
select  round(avg(age),0) as average_age 
from retail_sales
where category = 'Beauty';
```

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
```sql
select * from retail_sales
where total_sale > 1000; 
```

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
```sql
select category,
    gender,
    count(*) as Total_transaction
from retail_sales
group by category, gender;

```

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
```sql
Select year,
    month, 
    average_sale
from 
(	select 
		extract(YEAR FROM sale_date) as year,
		extract(MONTH FROM sale_date) as month,
		avg(total_sale) as average_sale,
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) DESC) as rank
		FROM retail_sales
		group by 1,2
) as t1
where rank = 1;
```

-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select customer_id,
sum(total_sale) as total_sales from retail_sales
group by 1
order by 2 desc 
limit 5;
```
-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
```sql
select count(distinct customer_id) as unique_cust, category
from retail_sales
group by 2;
```
-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
```sql
With hourly_sales
as(
select *,
	case
		When extract(Hour from sale_time) < 12 Then 'Morning'
		when extract(Hour from sale_time) between 12 and 17 then 'Afternoon'
		else
		'Evening'
		end as shift
from retail_sales
)
select shift,
count(*) as total_orders
from hourly_sales
group by shift;
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
