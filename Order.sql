
create table SALESMAN 
(
Salesman_id int, 
Name varchar(30),
City varchar(15), 
Commission varchar(10),
primary key(Salesman_id)
);


insert into SALESMAN values (1000,  'JOHN','BANGALORE','25 %');
insert into SALESMAN values (2000,  'RAVI','BANGALORE','20 %');
insert into SALESMAN values (3000,  'KUMAR','MYSORE','15 %');
insert into SALESMAN values (4000,  'SMITH','DELHI','30 %');
insert into SALESMAN values (5000,  'HARSHA','HYDERABAD','15 %');


create table CUSTOMER 
(
 Customer_id int, 
 Cust_Name varchar(30), 
 City varchar(15),
 Grade int,
 Salesman_id int,
 primary key(Customer_id),
 foreign key(Salesman_id) references SALESMAN(Salesman_id) delete on cascade
 );
 
 

insert into CUSTOMER values (10, 'PREETHI','BANGALORE', 100, 1000);
insert into CUSTOMER values (11, 'VIVEK','MANGALORE', 300, 1000);
insert into CUSTOMER values (12, 'BHASKAR','CHENNAI', 400, 2000);
insert into CUSTOMER values (13, 'CHETHAN','BANGALORE', 200, 2000);
insert into CUSTOMER values (14, 'MAMATHA','BANGALORE', 400, 3000);


create table ORDERS 
(
Ord_No int, 
Purchase_Amt real, 
Ord_Date date,
Customer_id int, 
Salesman_id int,
primary key(Ord_No),
foreign key(Customer_id) references CUSTOMER(Customer_id) delete on cascade,
foreign key(Salesman_id) references SALESMAN(Salesman_id) delte on cascade
);

insert into ORDERS values (50, 5000,  '04-MAY-17', 10, 1000);
insert into ORDERS values (51, 450,  '20-JAN-17', 10, 2000);
insert into ORDERS values (52, 1000,  '24-FEB-17', 13, 2000);
insert into ORDERS values (53, 3500,  '13-APR-17', 14, 3000);
insert into ORDERS values (54, 550,   '09-MAR-17', 12, 2000);

/*QUERIES*/

/*1. Count the customers with grades above Bangalore’s average.*/

select  count (distinct customer_id) as Number_Of_Employees,grade
from CUSTOMER
group by grade
having grade > (select avg(grade)
from CUSTOMER
where city='BANGALORE');

/*

NUMBER_OF_EMPLOYEES	GRADE
2                	400
1               	300

*/


/*2. Find the name and numbers of all salesmen who had more than one customer.*/

select name,salesman_id
from SALESMAN S
where 1 < (select count (*)
FROM CUSTOMER
WHERE salesman_id=S.salesman_id);

/*

NAME	SALESMAN_ID
JOHN	1000
RAVI	2000

*/


/*3. List all salesmen and indicate those who have and don’t have customers in their cities*/

select S.salesman_id, name, cust_name, commission
from SALESMAN S, CUSTOMER C
where S.CITY = C.CITY
union
select salesman_id, NAME, 'No Customer', commission
from SALESMAN
where NOT city = 
any(select city
    from CUSTOMER);
    
/*

SALESMAN_ID	NAME	CUST_NAME	COMMISSION
1000	    JOHN	CHETHAN	        25 %
1000    	JOHN	MAMATHA	        25 %
1000    	JOHN	PREETHI	        25 %
2000	    RAVI	CHETHAN	        20 %
2000	    RAVI	MAMATHA	        20 %
2000	    RAVI	PREETHI	        20 %
3000	    KUMAR	No Customer	15 %
4000	    SMITH	No Customer	30 %
5000	    HARSHA	No Customer	15 %

*/


/*4. Create a view that finds the salesman who has the customer with the highest order of a day.*/

create view H_O_SALESEMAN AS
select B.ord_date, A.salesman_id, A.name
from SALESMAN A, ORDERS B
where A.salesman_id = B.salesman_id
and B.purchase_amt=(select max (purchase_amt)
                    from ORDERS C
                    where C.ord_date = B.ord_date);
                    
select * from H_O_SALESEMAN;

/*

ORD_DATE	SALESMAN_ID	NAME
04-MAY-17	1000    	JOHN
20-JAN-17	2000	        RAVI
24-FEB-17	2000    	RAVI
13-APR-17	3000    	KUMAR
09-MAR-17	2000	        RAVI

*/

/*5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must
also be deleted.*/

delete from SALESMAN
where salesman_id=1000;

select * from SALESMAN;

/*

SALESMAN_ID	NAME	CITY	     COMMISSION
2000	        RAVI	BANGALORE    20 %
3000	        KUMAR	MYSORE	     15 %
4000	        SMITH	DELHI  	     30 %
5000	        HARSHA	HYDERABAD    15 %

*/