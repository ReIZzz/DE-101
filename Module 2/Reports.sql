-- Reports of Superstore

-- based on loaded data from *.xls (1st module of the best course Data Engineering [DE -101])
-- https://datalearn.ru



select 
	extract(year from order_date) as year,
	to_char(order_date, 'Month') as month,
	round(SUM(sales), 2) as Total_revenue,
	round(SUM(profit), 2) as Total_profit,
	round(round(SUM(profit), 2)/round(SUM(sales), 2) * 100, 0) as profitability
from orders o
group by 1, 2
order by 1 desc, to_date(to_char(order_date, 'Month'), 'month');


-- Sales & Profit by Product Category & Subcategory 
select
	category,
	subcategory,
	round(SUM(sales), 2) as Total_revenue,
	round(SUM(profit), 2) as Total_profit
from orders o
group by category, subcategory
order by 1, 2;


-- Profit per Order
select region, order_id, round(SUM(profit), 2) as Total_profit, count(order_id)
from orders o
group by region, order_id
order by 1, 3 desc;


-- Sales and Profit by Customer
select 
	customer_name,
	round(SUM(sales), 2) as Total_revenue,
	round(SUM(profit), 2) as Total_profit
from orders o 
group by customer_name;


-- Sales per Region & State
select 
	region,
	state,
	round(SUM(sales), 2) as Total_revenue
from orders o 
group by region, state
order by region, state;


-- Avg. Discount by Category
select
	category,
	ROUND(AVG(discount)*100, 1) as Average_Discount
from
	orders o
group by 1
order by Average_Discount desc;

	
-- Monthly Sales by Segment & by Category
select
	segment,
	category,
	round(SUM(sales), 2) as Total_revenue
from orders o
group by 1, 2
order by 3 desc;