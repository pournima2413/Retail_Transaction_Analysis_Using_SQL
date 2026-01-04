
drop table if exists retail_sales;

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
	cogs float,
    total_sale FLOAT
);

select count(*) from retail_sales;

select * from retail_sales;

--- Data Cleaning

select * from retail_sales
where transaction_id is null
or
sale_date is null
or 
sale_time is null
or
gender is null
or 
category is null
or 
quantity is null
or
cogs is null
or
total_sale is null
;

--
delete from retail_sales
where sale_date is null
or 
sale_time is null
or
gender is null
or 
category is null
or 
quantity is null
or
cogs is null
or
total_sale is null
;

-- Data Exploration
-- How many unique sales we have?

select count(*) as total_sales from retail_sales;

-- How many unique customers we have?
select count(distinct customer_id) as total_customers from retail_sales;

-- How many unique category we have?
select count(distinct category) as total_category from retail_sales;

-- Which unique category we have? 
select distinct category as unique_category from retail_sales;

---Data Analysis

-- Q.1 Write an SQl query to retrieve all columns or sales made on '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 write a SQL query to retrieve all transaction where the category is clothing and 
-- quantitly sold is more than 10 in the month of Nov-2022?

select * from retail_sales
where category = 'Clothing' 
and TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
and quantity >= 4 ;

-- Q.3 Write a sql query to calculate total sales for each category

select  category, sum(total_sale) as total_sales 
from retail_sales
group by category;


-- Q.4 write a sql query to find he average age of customers who purchased items from the 'Beauty' category

select  round(avg(age),0) as average_age 
from retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL Query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000; 

-- Q.6 Write an sql query to find the total number of transactions made by each gender in each category.
select category,
gender,
count(*) as Total_transaction
from retail_sales
group by category, gender;


-- Q7. write a sql query o calculate the average sale for each month. 
-- Find out best selling month in each year
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

--order by 1, 3 DESC;

-- Q.8  Write an sql query to find the top5 customers based on the highest total sales
select customer_id,
sum(total_sale) as total_sales from retail_sales
group by 1
order by 2 desc 
limit 5;

-- Q.9 Write an sql query to find an number of unique customers who purchased items from each category

select count(distinct customer_id) as unique_cust, category
from retail_sales
group by 2;

-- Q 10. Write a Sql query to create each shift and number of orders
-- Example ... Morning <=12, Afternoon between 12 and 17, Evening >=17
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

---End 


