use superstore

--1. Display all information of customer.
select * from tbl_customer

--2. Display customer name, customer id and customer segment. 
select [Customer ID],[Customer Name],Segment from tbl_customer

select * from tbl_address
--3. Display customer details of Home Office segment
select * from tbl_customer where Segment= 'Home office'

--4.Display customer id and customer name whose belong to Massachusetts state
select [Customer ID], [Customer Name],State from tbl_customer tbl join
tbl_address tadd on tbl.address_id=tadd.address_id
where State='Massachusetts'

--5.Display all customer information whose name starts with A
select * from tbl_customer where [Customer Name] like 'A%'

--6.Display all customer information whose name end with A
select * from tbl_customer where [Customer Name] like '%A'

--7.Display all customer name whose name contains letter A at 3rd position from start
select [Customer Name] from tbl_customer where  [Customer Name] like '__A%'

select * from tbl_product
--8.Display all product information in Descending order
select * from tbl_product 
order by [Product Name] desc

select * from tbl_order
--9.Display the lowest profit order
select [Order ID],[Order Date],[Ship Date],Profit 
from tbl_order where
Profit in(select MIN(Profit) from tbl_order)

--10.Display lowest profit order in the month June 2018
select [Order ID],[Order Date],[Ship Date],Profit from tbl_order 
where Profit in(select MIN(Profit) from tbl_order 
where [Order Date]
between '2018-06-01' and '2018-06-30')

--11.Display highest profit order in year 2021
select Profit,YEAR([Order Date]) as year from tbl_order 
where Profit in(select MAX(profit)
from tbl_order where YEAR([Order Date])='2021')

--12.Display average sales for each month for 2020
select MONTH([Order Date])AS MONTH,AVG(sales) as Average_sales,YEAR([Order Date])as YEAR 
from tbl_order	
where YEAR([Order Date])='2020'
group by MONTH([Order Date]),YEAR([Order Date])
order by MONTH asc

--13. display current month total sales
select SUM(Sales) as total_sales
from tbl_order where [Order Date]=GETDATE()

select SUM(sales) as total_sales
from tbl_order
where YEAR([Order Date])='2018'

select * from tbl_customer
select * from tbl_address
--14.Display customer name with customer city
select [Customer Name],City 
from 
	tbl_customer tbl join tbl_address tadd
on 
	tbl.address_id=tadd.address_id
group by City,[Customer Name]

--15.Display customer details belong to East region.
select * from tbl_customer tbl join tbl_address tadd
on tbl.address_id=tadd.address_id
where tadd.Region='east'

select * from tbl_customer
select * from tbl_order
--16.Display customer name with segment details, 
--who placed order in the month of June 2020
select [Customer Name],Segment,[Order Date] 
from 
	tbl_customer tbl join tbl_order tbo
on 
	tbl.[Customer ID]=tbo.[Customer ID]
where 
	MONTH([Order Date])='6' and YEAR([Order Date])='2020'

select * from tbl_customer
select * from tbl_product
select * from tbl_order
--17.Display the customer and product information for the year 2020
select [Customer Name],tbp.[Product ID],tbp.Category,
	  tbp.[Sub-Category],tbp.[Product Name],YEAR([Order Date]) as year
from 
	tbl_customer tbl join tbl_order tbo
on 
	tbl.[Customer ID]=tbo.[Customer ID] join tbl_product tbp 
on
	tbo.[Product ID]=tbp.[Product ID]
where 
	YEAR([Order Date])='2020'

select * from tbl_address
select * from tbl_order
--18.Display region wise sales, profit, discount
select 
		Region,
	sum(sales) as sales,
	sum(Profit) as profit,
	sum(discount) as discount
from tbl_order,tbl_address
group by region
	
select * from tbl_order
select * from tbl_customer
--19.Display segment wise total orders for each year
select 
	YEAR([Order Date]) as Year_wise,
	tbc.Segment,
	COUNT([Order ID]) as Total_Orders
from 
	tbl_order tbo join tbl_customer tbc
	on
	tbo.[Customer ID]=tbc.[Customer ID]
group by YEAR([Order Date]),tbc.Segment
order by Year_wise asc,Segment asc

--20.Display customer count by each region
select * from tbl_customer
select * from tbl_address
select 
	tadd.Region,
	COUNT([Customer ID]) as Total_Customers
from 
	tbl_customer tbc join tbl_address tadd 
on	tbc.address_id=tadd.address_id
group by tadd.Region

--21.Display total sales by category 
select * from tbl_order
select * from tbl_product

select 
	Category,
	Round(SUM(Sales),2) as Total_Sales
from 
	tbl_order tbo join tbl_product tbp
on 
	tbo.[Product ID]=tbp.[Product ID]
group by Category

--22.Display total sales by category having sales greater than 1000
select 
	Category,
	SUM(Sales) as Total_Sales
from
	tbl_order tbo join tbl_product tbp
on
	tbo.[Product ID]=tbp.[Product ID]
where Sales>1000
group by Category