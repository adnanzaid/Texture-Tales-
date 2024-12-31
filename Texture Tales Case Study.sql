create database cs4;
use cs4;


## 1. What was the total quantity sold for all products?
select details.product_name as prod_name , sum(sales.qty) as total_quantity
from sales join product_details as details 
on sales.prod_id = details.product_id
group by prod_name
order by total_quantity desc;

##2. What is the total generated revenue for all products before discounts?

-- there is always use sum() function when we hear total
-- revenue = price * qty

select sum(price*qty) as total_revenue
from sales;

## 3.What was the total discount amount for all products?

-- dividing by 100 we getting the value in percentage

select sum(price*qty*discount)/100 as total_discount from sales;

## 4.How many unique transactions were there?
select count(distinct txn_id) from sales;

## 5. What are the average unique products purchased in each transaction?

-- average represents single output value in sql


with average_products as (select  txn_id  , count(distinct prod_id) as unique_products
from sales 
group by txn_id)

select round(avg(unique_products)) as avg_unique_products from average_products;

## 6.What is the average discount value per transaction?

with average_discount as (
select txn_id , sum(qty*price*discount)/100 as total_discount
from sales
group by txn_id)

select round(avg(total_discount)) as average_discount_value
from average_discount;


## 7. What is the average revenue for member transactions and non-member transactions?
with member_revenues as (
select member , txn_id , sum(price*qty) as total_revenue
from sales
group by member , txn_id )

select member ,  round(avg(total_revenue),2)  as average_revenue_for_member 
from member_revenues
group by member;

## 8. What are the top 3 products by total revenue before discount?

-- revenue formula -> sum(s.qty*s.price)

select pd.product_name as prod_name , sum(s.qty*s.price) as revenue 
from sales s join product_details pd 
on s.prod_id = pd.product_id
group by prod_name
order by revenue desc
limit 3;

## 9.What are the total quantity, revenue and discount for each segment?
select pd.segment_id as segment_id,
       pd.segment_name as segment,
	   sum(s.qty) as total_quantity,
       sum(s.qty*s.price) as total_revenue,
       (sum(s.qty*s.price*s.discount)/100) as total_discount
from sales s join product_details pd 
on s.prod_id = pd.product_id
group by segment_id , segment;

## 10.What is the top selling product for each segment?
with top_selling_product as (select pd.segment_id as segment_id,
       pd.segment_name as segment,
       pd.product_name as product,
       sum(s.qty) as quantity_sold
from sales s join product_details pd
on s.prod_id = pd.product_id
group by segment_id , segment , product
)

select segment_id ,  segment , product , quantity_sold as product_quantity
from top_selling_product
order by product_quantity desc
limit 5;

## 11.What are the total quantity, revenue and discount for each category?

select pd.category_id as category_id, 
pd.category_name as category_name, 
sum(s.qty) as total_quantity ,
sum(s.price*s.qty) as revenue , 
sum(s.price*s.qty*s.discount)/100 as discount
from sales s join product_details pd
on s.prod_id = pd.product_id
group by category_id , category_name;


## 12.What is the top selling product for each category?
with top_selling_product_category as
(select pd.product_id as prod_id ,
 pd.product_name as prod_name,
 pd.category_id  as cat_id,
 pd.category_name as cat_name,
 sum(s.qty) as quantity_sold
 from sales s join product_details pd 
 on s.prod_id = pd.product_id 
 group by prod_id , prod_name , cat_id , cat_name)
 
 select cat_id , cat_name ,prod_id , prod_name ,  max(quantity_sold) as sold_quant
 from top_selling_product_category
 group by cat_id , cat_name ,prod_id , prod_name 
 order by sold_quant desc
 limit 5;




