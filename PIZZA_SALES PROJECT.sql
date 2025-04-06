USE PIZZA_SALES 
select * from order_details
select * from orders
select * from pizza_types
select * from pizzas

alter table pizzas alter column price float

--1) retrive the total number of ordered placed

select 
      COUNT(order_id) as Total_Orders 
from orders

--2)calculate total revenue generatd from pizza sales.

select 
     round(sum(p.price * od.quantity),2) as Total_Revenue 
from pizzas p join order_details od on p.pizza_id=od.pizza_id

-- 3) Identify the highest price pizza
select 
     top 1 p.price as Highest_price_pizza, pt.name
from pizza_types pt join pizzas p on
pt.pizza_type_id= p.pizza_type_id
     order by p.price desc

/*select pt.name,
MAX(p.price) as highest_price_pizza 
from pizzas p join pizza_types pt on
p.pizza_type_id=pt.pizza_type_id
group by pt.name*/

-- 4) identify most commom pizza sized ordered

select pizzas.size, 
	   COUNT(order_details_id)as order_count 
	   from order_details join pizzas 
	   on order_details.pizza_id= pizzas.pizza_id
group by pizzas.size
order by order_count desc

-- 5) list the top 5 most ordered pizzas types along with their quantities

select top 5 pizza_types.name,
	  sum(quantity) as Total_quantity
	  from pizza_types join pizzas 
	  on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
      on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by Total_quantity desc

alter table order_details alter column quantity int

--6)join the necessary tables to find the total quantity of 
--each pizza catrgory ordered

select category,
	SUM(quantity) as Total_quantity
from order_details join pizzas 
	on order_details.pizza_id=pizzas.pizza_id
	join pizza_types 
	on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by category 
order by Total_quantity desc

-- 7) determine the distribution of orders by hour of the day.

select datepart(HOUR,time) as hour, 
       COUNT(order_id) as order_count 
from orders
group by DATEPART(HOUR,time)
order by hour asc

-- 8) join the relevant tables to find the category wise 
--distribution of pizzas

select category, 
       COUNT(name) 
from pizza_types 
       group by category

-- 9) group the orders by date and calculate the average  
--number of pizzas ordered per day.

select AVG(Total_pizzas) as Avg_pizza_ordered_per_day 
from
(select date, 
       SUM(quantity) as Total_pizzas
from orders join order_details 
       on orders.order_id=order_details.order_id
group by date) as order_quantity

--10) Determine the top 3 most ordered pizza types based 
--on revenue.

select top 3 name,
		SUM(price* quantity) as Total_revenue
from pizza_types 
join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by name
order by Total_revenue desc

--11) calculate the percentage contribution of 
--each pizza type to total revenue

select pizza_types.category,
	SUM(order_details.quantity*pizzas.price)/
   (select SUM(order_details.quantity*pizzas.price)as Total_sales 
from order_details join pizzas 
	on order_details.pizza_id=pizzas.pizza_id)*100 as Revenue_percent
from pizza_types join pizzas 
	on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category
order by Revenue_percent desc

-- 12) Analyze the cumulative revenue generated over time

select date,
	sum(revenue) over(order by date) as cumulative_revenue 
	from(select date,
		 SUM(quantity * price) as revenue
			from orders join order_details
		on orders.order_id= order_details.order_id
		join pizzas on order_details.pizza_id= pizzas.pizza_id
		group by date) as sales

--13) determine the top 3 most ordered pizza types based 
--on revenue for each pizza category

select category, name,revenue from
	(select category,name,revenue,rank() over 
	(partition by category order by revenue desc)
as rn from
		(select name,category,
		SUM(quantity* price) as revenue
from pizza_types join pizzas 
	on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
	on order_details.pizza_id=pizzas.pizza_id
group by name,category)as a) as b
where rn<=3
