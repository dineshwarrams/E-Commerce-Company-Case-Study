create database Ecommerce_cs;

use Ecommerce_cs;

#removing unknown columns and date convertion

select * from orders_new;

-- customers
create table Customers_new as
select customer_id,name,location
from customers;

drop table customers;

alter table Customers_new
rename to customers;

-- orderdetails
create table orderdetails_new as
select order_id,product_id,quantity,price_per_unit
from orderdetails;

drop table orderdetails;

alter table orderdetails_new
rename to orderdetails;

-- orders
create table orders_new as
select order_id,cast(order_date as date) as order_date,customer_id,total_amount
from orders;

drop table orders;

alter table orders_new
rename to orders;

-- products

create table products_new as
select product_id,name,category,price
from products;

drop table products;

alter table products_new
rename to products;