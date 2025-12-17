-- Data cleaning
use Ecommerce_cs;

select order_id,count(*)
from orderdetails
group by order_id
having count(*)>1;

select* from customers;

select count(*)
from products
where category is null;