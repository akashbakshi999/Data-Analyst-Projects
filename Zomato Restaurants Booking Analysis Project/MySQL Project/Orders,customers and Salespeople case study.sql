
#---------------------------------------------Orders, Customers and Salespeople---------------------------------------------------------------------------------------

use zomato_analytics;
 
#Question 1

create table Salespeople (
snum int primary key, sname varchar(20),
city varchar(30),comm float);

desc Salespeople;

insert into Salespeople values
(1001,'Peel','London',0.12),
(1002,'Serres','San Jose',0.13),
(1003,'Axelord','New York',0.10),
(1004,'Motika','London',0.11),
(1007,'Rafkin','Barcelona',0.15);

select * from salespeople;

# Question 2

create table customers (
cust_num int, cname varchar(20),
city varchar(20),rating int, snum int);

insert into customers values
(2001,'Hoffman','London',100,1001),
(2002,'Giovanne','Rome', 200, 1003),
(2003,'Liu','San Jose',300,1002),
(2004,'Grass','Berlin',100,1002),
(2006,'Clemens','London',300,1007),
(2007,'Pereira','Rome',100,1004),
(2008,'James','London',200,1007);

select * from customers;

# Question 3


create table orders (
`ord_num` int primary key, amount float, `ord_date` date, cnum int, snum int);

insert into orders values
(3001,18.69,'1994-10-03',2008,1007),
(3002,1900.10,'1994-10-03',2007,1004),
(3003,767.19,'1994-10-03',2001,1001),
(3005,5160.45,'1994-10-03',2003,1002),
(3006,1098.16,'1994-10-04',2008,1007),
(3007,75.75,'1994-10-05',2004,1002),
(3008,4723,'1994-10-05',2006,1001),
(3009,1713.23,'1994-10-04',2002,1003),
(3010,1309.95,'1994-10-06',2004,1002),
(3011,9891.88,'1994-10-06',2006,1001);

select * from orders;


#Question 4

# Write a query to match the salespeople to the customers according to the city they are living?

select * from 
salespeople join customers 
on salespeople.snum=customers.snum
where salespeople.city=customers.city;


#Question 5

# Write a query to select the names of customers and the salespersons who are providing service to them?

select cname as customer, sname as salesperson from
salespeople join customers 
on salespeople.snum=customers.snum;

#or 

select customers.cname,salespeople.sname from
salespeople join customers 
on salespeople.snum=customers.snum
where salespeople.city=customers.city;


#Question 6

# Write a query to find out all orders by customers not located in the same cities as that of their salespeople?

select a.ord_num, b.cname as customer,b.city as `customer_city`,
c.sname as salesperson,c.city as `salesperson_city`
from 
orders as a join customers as b
on a.cnum=b.cust_num
join 
salespeople as c
on b.snum=c.snum
where b.city!=c.city;


#Question 7

# Write a query that lists each order number followed by name of customer who made that order?

select a.ord_num as `order_number`, b.cname as customer
from
orders as a join customers as b
on a.cnum=b.cust_num;


#Question 8

#	Write a query that finds all pairs of customers having the same rating?

select * from customers;

select cname as customer, rating from
(select *, dense_rank() over(partition by rating) as `rank_by_rating`
from customers)a;

#or 

select cname as customer, rating
from customers
where rating=300;


#Question 9

# Write a query to find out all pairs of customers served by a single salesperson?

select cname as customer, snum as salesperson_id from customers where snum in
(select snum from customers group by snum having count(*) > 1);

#or 

#To find duplicate columns of a column 

select snum from customers
group by snum having count(*)>1;


#Question 10

# Write a query that produces all pairs of salespeople who are living in same city?
select * from salespeople;

select sname as salesperson, city from salespeople where city in
(select city from salespeople group by city having count(*) > 1);


#Question 11

# Write a Query to find all orders credited to the same salesperson who services Customer 2008?

select* from customers;
select * from orders;
select * from salespeople;

select snum, ord_num from
(select a.cust_num,a.snum,b.ord_num from customers as a join orders as b
on a.snum=b.snum)lev1
where cust_num=2008;


#Question 12

# Write a Query to find out all orders that are greater than the average for Oct 4th?

select * from orders
where amount >
(select avg(amount) from orders where ord_date='1994-10-04');


#Question 13

# Write a Query to find all orders attributed to salespeople in London?

select a.snum,a.sname,a.city,b.ord_num from 
salespeople as a join orders as b
on a.snum=b.snum
where city='London';


#Question 14

# Write a query to find all the customers whose cnum is 1000 above the snum of Serres?

select * from customers;

select cust_num as cust_id, cname as customer, snum as sales_person_id
from customers
where cust_num-snum>1000;


#Question 15

# Write a query to count customers with ratings above San Jose’s average rating?

select count(cname) no_of_customers
from customers
where rating >
(select avg(Rating)
from customers
where city='San Jose');

#cross_check

select count(cname) no_of_customers
from customers
where rating >
(select avg(Rating)
from customers
where city='London');


#Question 16

# Write a query to show each salesperson with multiple customers?

select salesperson_id, salespeople.sname as salesperson, cust_id, customer from
(select snum as salesperson_id, cname as customer,cust_num as cust_id 
from customers where snum in
(select snum from customers group by snum having count(*) > 1))a
join
salespeople
on a.salesperson_id=salespeople.snum;