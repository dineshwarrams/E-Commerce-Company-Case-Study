-- CASESTUDY
-- Data Analysis
use Ecommerce_cs;

# Identify the top 3 cities with the highest number of customers to determine key markets for targeted marketing and logistic optimization.

select
location ,
count(*) as number_of_customers
from Customers
group by location
order by number_of_customers desc limit 3;

#Determine the distribution of customers by the number of orders placed. 
#This insight will help in segmenting customers into one-time buyers, occasional shoppers, and regular customers for tailored marketing strategies.

SELECT
    T1.NumberOfOrders AS NumberOfOrders,
    COUNT(T1.customer_id) AS CustomerCount
FROM (
    SELECT
        customer_id,
        COUNT(order_id) AS NumberOfOrders
    FROM
        Orders
    GROUP BY
        customer_id
) AS T1
GROUP BY
    T1.NumberOfOrders
ORDER BY NumberOfOrders ASC;

#Identify products where the average purchase quantity per order is 2 but with a high total revenue, suggesting premium product trends.

select 
Product_Id,
avg(quantity) as AvgQuantity,
sum(quantity*price_per_unit) as TotalRevenue
from OrderDetails
group by Product_Id
having AvgQuantity =2
order by TotalRevenue desc;

# For each product category, calculate the unique number of customers purchasing from it. 
#This will help understand which categories have wider appeal across the customer base.

select
p.category,
count(distinct o.customer_id) as unique_customers
from orders o
join orderdetails od on o.order_id=od.order_id
join products p on od.product_id=p.product_id
group by p.category
order by unique_customers desc;

#Analyze the month-on-month percentage change in total sales to identify growth trends.

select
date_format(order_date,'%Y-%m') as Month,
sum(total_amount) as TotalSales,
round(((sum(total_amount)-lag(sum(total_amount))over(order by date_format(order_date,'%Y-%m')))
/lag(sum(total_amount))over(order by date_format(order_date,'%Y-%m')))*100,2) as PercentChange
from orders
group by Month
order by Month;

#Examine how the average order value changes month-on-month. Insights can guide pricing and promotional strategies to enhance order value.

with momavg as(
    select date_format(order_date,'%Y-%m') as Month,
    round(avg(total_amount),2) as AvgOrderValue
    from orders
    group by Month
) 
select
Month,
AvgOrderValue,
round((AvgOrderValue-lag(AvgOrderValue) over(order by Month)),2) as ChangeInValue
from momavg
group by Month
order by ChangeInValue desc;

#Based on sales data, identify products with the fastest turnover rates, suggesting high demand and the need for frequent restocking.

select
product_id,
count(*) as SalesFrequency
from OrderDetails
group by product_id
order by SalesFrequency desc limit 5;

#List products purchased by less than 40% of the customer base, indicating potential mismatches between inventory and customer interest.

select
p.Product_id,
p.Name,
count(distinct c.customer_id) as UniqueCustomerCount
from Products p
join OrderDetails od on p.Product_id=od.Product_id
join Orders o on od.order_id=o.order_id
join Customers c on o.customer_id=c.customer_id
group by p.Product_id,p.Name
HAVING UniqueCustomerCount < (SELECT COUNT(*) FROM Customers) * 0.40;

#Evaluate the month-on-month growth rate in the customer base to understand the effectiveness of marketing campaigns and market expansion efforts.

with firstpurchase as(
    select 
    customer_id,
    min(order_date) as firstpm
    from orders
    group by customer_id
)
select 
date_format(firstpm,'%Y-%m') as FirstPurchaseMonth,
count(customer_id) as TotalNewCustomers
from firstpurchase
group by FirstPurchaseMonth
order by FirstPurchaseMonth asc;


#Identify the months with the highest sales volume, aiding in planning for stock levels, marketing efforts, and staffing in anticipation of peak demand periods.

select
date_format(order_date,'%Y-%m') as Month,
sum(total_amount) as TotalSales
from orders
group by Month
order by TotalSales desc limit 3;
