create database abc;
use abc;

#Creating tables
create table products (
    product_id int primary key,
    product varchar(50),
    category varchar(50),
    price decimal(10,2)
);

create table customers (
    customer_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    country varchar(50),
    score int
);

create table employees (
    employee_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    department varchar(50),
    birth_date date,
    gender char(1),
    salary int,
    manager_id int,
    emp_country varchar(30),
    foreign key (manager_id) references employees(employee_id)
);


create table orders (
    order_id int primary key,
    product_id int,
    customer_id int,
    sales_person_id int,
    order_date date,
    ship_date date,
    order_status varchar(20),
    ship_address varchar(255),
    bill_address varchar(255),
    quantity int,
    sales decimal(10,2),
    creation_time datetime(6),
    foreign key (product_id) references products(product_id),
    foreign key (customer_id) references customers(customer_id),
    foreign key (sales_person_id) references employees(employee_id)
);

#insert records
insert into products (product_id, product, category, price) values
(101, 'Bottle', 'Accessories', 10),
(102, 'Tire', 'Accessories', 15),
(103, 'Socks', 'Clothing', 20),
(104, 'Caps', 'Clothing', 25),
(105, 'Gloves', 'Clothing', 30);

insert into customers (customer_id, first_name, last_name, country, score) values
(1, 'Jossef', 'Goldberg', 'Germany', 350),
(2, 'Kevin', 'Brown', 'USA', 900),
(3, 'Mary', null, 'USA', 750),
(4, 'Mark', 'Schwarz', 'Germany', 500),
(5, 'Anna', 'Adams', 'USA', null);

insert into employees (employee_id, first_name, last_name,
 department, birth_date, gender, salary, manager_id, emp_country) values
(1, 'Frank', 'Lee', 'Marketing', '1988-12-05', 'M', 55000, null, 'Germany'),
(2, 'Kevin', 'Brown', 'Marketing', '1972-11-25', 'M', 65000, 1, 'USA'),
(3, 'Mary', null, 'Sales', '1986-01-05', 'F', 75000, 1, 'USA'),
(4, 'Michael', 'Ray', 'Sales', '1977-02-10', 'M', 90000, 2, 'Germany'),
(5, 'Carol', 'Baker', 'Sales', '1982-02-11', 'F', 55000, 3, 'USA');



insert into orders (
    order_id, product_id, customer_id, sales_person_id, order_date, ship_date,
    order_status, ship_address, bill_address, quantity, sales, creation_time
) values
(1, 101, 2, 3, '2025-01-01', '2025-01-05', 'Delivered', '9833 Mt. Dias Blv.', '1226 Shoe St.', 1, 10, '2025-01-01 12:34:56.000000'),
(2, 102, 3, 3, '2025-01-05', '2025-01-10', 'Shipped', '250 Race Court', null, 1, 15, '2025-01-05 23:22:04.000000'),
(3, 101, 1, 5, '2025-01-10', '2025-01-25', 'Delivered', '8157 W. Book', '8157 W. Book', 2, 20, '2025-01-10 18:24:08.000000'),
(4, 105, 1, 3, '2025-01-20', '2025-01-25', 'Shipped', '5724 Victory Lane', null, 2, 60, '2025-01-20 05:50:33.000000'),
(5, 104, 2, 5, '2025-02-01', '2025-02-05', 'Delivered', null, null, 1, 25, '2025-02-01 14:02:41.000000'),
(6, 104, 3, 5, '2025-02-05', '2025-02-10', 'Delivered', '1792 Belmont Rd.', null, 2, 50, '2025-02-06 15:34:57.000000'),
(7, 102, 1, 1, '2025-02-15', '2025-02-27', 'Delivered', '136 Balboa Court', null, 2, 30, '2025-02-16 06:22:01.000000'),
(8, 101, 4, 3, '2025-02-18', '2025-02-27', 'Shipped', '2947 Vine Lane', '4311 Clay Rd', 3, 90, '2025-02-18 10:45:22.000000'),
(9, 101, 2, 3, '2025-03-10', '2025-03-15', 'Shipped', '3768 Door Way', null, 2, 20, '2025-03-10 12:59:04.000000'),
(10, 102, 3, 5, '2025-03-15', '2025-03-20', 'Shipped', null, null, 0, 60, '2025-03-16 23:25:15.000000');

select first_name, country from customers;

select country from customers;
select distinct country from customers;

select * from customers order by score asc;
select * from customers order by score desc;
select * from customers order by country asc, score desc;

select * from customers where country = 'Germany';
select * from customers where score > 500;
select * from customers where score < 500;
select * from customers where score <= 500;
select * from customers where country != 'Germany';

select * from customers 
where country = 'germany' and score < 400;

select * from customers
where country = 'germamy' or score < 400;

select * from customers 
where not score < 400;

select * from customers 
where score between 100 and 500;

select * from customers 
where score >= 100 and score <= 500;

select * from customers 
where customer_id in (1, 2, 5);

select * from customers where first_name like 'm%';
select * from customers where first_name like '%n';
select * from customers where first_name like '%r%';
select * from customers where first_name like '__r%';

#inner join
select c.customer_id, c.first_name, o.order_id, o.quantity
from customers c 
inner join orders o
on c.customer_id = o.customer_id
where o.order_id is not null;

#left join
select c.customer_id, c.first_name, o.order_id, o.quantity
from customers c 
left join orders o
on c.customer_id = o.customer_id

#right join
select c.customer_id, c.first_name, o.order_id, o.quantity
from customers c
right join orders o
on c.customer_id = o.customer_id;


#full join
select c.customer_id, c.first_name, o.order_id, o.quantity
from customers c left join orders o on c.customer_id = o.customer_id
union
select c.customer_id, c.first_name, o.order_id, o.quantity
from customers c right join orders o on c.customer_id = o.customer_id
order by customer_id ,order_id;

#uninon
select first_name, last_name, country 
from customers  
union 
select first_name, last_name, emp_country
from employees;

#Aggregate functions
select count(*)as total_customers from employees;
select sum(score) as total_score from customers;
select sum(quantity) as total_quantity from orders;
select avg(quantity) as avg_quantity from customers;
select max(score) as max_score from customers;
select min(score) as min_score from customers;
select min(order_date) min_orderdate, max(order_date) as max_orderdate
from orders o;

#string functions
select concat(first_name,'_',last_name) as customername from customers;
select upper(concat(first_name,' ',last_name)) as customername from customers;
select TRIM(last_name) clean_last_name from customers;
select last_name, trim(last_name) as trim_last_name,length(trim(last_name)) as clean_len_last_name
from customers;
select last_name, substring(last_name,2,3) as sub_last_name FROM customers;

#Group by
select count(*) as total_customers, country
from customers 
group by country
order by count(*) asc;

select max(score) as max_score,country
from customers 
group by country;

#Having
select count(*) as total_customers ,country from customers 
group by country
having total_customers >1;

select count(*) as total_customers, country 
from customers
where country !='USA'
group by country
having count(*) >1;

#subqueries

#find all the orders placed from customers whose score higher than 500
SELECT *
FROM orders
WHERE customer_id IN (
    SELECT customer_id
    FROM customers
    WHERE score > 500
);

SELECT *
FROM orders AS o
WHERE EXISTS (
    SELECT 1
    FROM customers AS c
    WHERE c.customer_id = o.customer_id
      AND c.score > 500
);

