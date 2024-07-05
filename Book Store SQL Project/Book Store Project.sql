-- --------------------------------Easy--------------------------------------------------------------------

-- Q1 Which book is the most expensive, mention it's category and brand?

-- before discount
select product_name, list_price
from products
order by list_price DESC
limit 1;

-- after discount
select product_name,  oi.quantity, oi.list_price, oi.discount, round((oi.list_price-(oi.list_price*oi.discount)),2) as price_after_discount
from products as p
join order_items as oi
on p.product_id=oi.product_id
where oi.quantity=1
order by list_price DESC
limit 1;

-- -------------------------------------------------------------------------------------------------------------------

-- Q2 Which is the most bought book?
select product_name,  sum(oi.quantity) as total_quantity
from products as p
join order_items as oi
on p.product_id=oi.product_id
group by product_name
order by total_quantity DESC
limit 1;

-- ---------------------------------------------------------------------------------------------------------

-- Q3 3.	Who are the top 5 customers?
select c.customer_id, c.first_name, c.last_name, count(o.order_id) as times_ordered
from orders as o
join customers as c on o.customer_id=c.customer_id
group by c.customer_id, c.first_name, c.last_name 
order by times_ordered DESC;

-- --------------------------------------------------------------------------------------------------------

-- Q4 Create a view called "ContactList" that consists of a book's title, along with the brand name.
create view ContactList AS
(
	select product_name, b.brand_name
    from products as p
    join brands as b on p.brand_id=b.brand_id
    order by b.brand_name ASC
);
select * from ContactList;

-- ---------------------------------------------------------------------------------------------------------
-- ------------------------------------Moderate/Advanced----------------------------------------------------

-- Q5 What are the most expensive books according to category and brand name
with most_expensive_book as(
select p.product_name, c.category_name, b.brand_name, list_price,
row_number() over(partition by c.category_name, b.brand_name order by list_price DESC) as row_no
from products as p
join categories as c on p.category_id=c.category_id
join brands as b on p.brand_id=b.brand_id
order by p.product_name, c.category_name, b.brand_name ASC)
select * from most_expensive_book where row_no<=1;

-- ----------------------------------------------------------------------------------------------------------

-- Q6 What are the most popular books in each city?
with popular_by_city as(
select p.product_id, p.product_name, c.city, sum(oi.quantity) as quantity,
dense_rank() over(partition by c.city order by sum(oi.quantity) DESC) as rank_no
from customers as c 
join orders as o on c.customer_id=o.customer_id
join order_items as oi on o.order_id=oi.order_id
join products as p on oi.product_id=p.product_id
group by p.product_id, p.product_name, c.city)

select * from popular_by_city where rank_no<=1;

-- ----------------------------------------------------------------------------------------------------------

-- Q7 What books are least preferred by the readers according to category?
with preference_categroy AS
	(select c.category_name, product_name, sum(oi.quantity) as total_quantity,
	dense_rank() over(partition by c.category_name order by sum(oi.quantity) ASC) as rank_no
	from products as p
	join order_items as oi on p.product_id=oi.product_id
	join categories as c on p.category_id=c.category_id
	group by c.category_name, product_name)
select * from preference_categroy where rank_no<=1;

-- ---------------------------------------------------------------------------------------------------------
-- Q8 generate a hierarchical tree of the staff. For each employee showcase all the employee’s working 
--    under them (including themselves) 

with recursive hierarchy as
	(
		-- base query
        select staff_id, first_name, last_name, staff_id as reportee_id 
        from staffs
	
		union all
        
		-- recursive query
        select r.staff_id, r.first_name, r.last_name,  s.staff_id as reportee_id 
        from hierarchy as r
        join staffs as s
        on r. reportee_id=s.manager_id 
	)
select * from hierarchy
order by staff_id;

-- ---------------------------------------------------------------------------------------------------------

-- Q9 show staff details along with their managers name
with manager_detail as
(
select  staff_id as Manager_id, concat(first_name, " ", last_name ) as Manager_name
from staffs
) 
select s.staff_id, concat(s.first_name," ", s.last_name)as staff_name, s.manager_id, Manager_name, s.email as staff_email, s.phone as staff_phoneNo
from staffs as s
join manager_detail as md
on md.Manager_id=s.manager_id
order by manager_id, s.staff_id;

