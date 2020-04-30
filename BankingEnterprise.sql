
create table Branch(
branch_name varchar(30),
branch_city varchar(10),
asssets real,
primary key (branch_name));

insert into Branch values('SBI_Chamrajpet','Bangalore',50000);
insert into Branch values('SBI_ResidencyRoad','Bangalore',10000);
insert into Branch values('SBI_ShivajiRoad','Bombay',20000);
insert into Branch values('SBI_ParliamentRoad','Delhi',10000);
insert into Branch values('SBI_Jantarmantar','Delhi',20000);

create table BankAccount(
accno int,
branch_name varchar(30),
balance real,
primary key(accno),
foreign key(branch_name) references Branch(branch_name));

insert into BankAccount values(1,'SBI_Chamrajpet',2000);
insert into BankAccount values(2,'SBI_ResidencyRoad',5000);
insert into BankAccount values(3,'SBI_ShivajiRoad',6000);
insert into BankAccount values(4,'SBI_ParliamentRoad',9000);
insert into BankAccount values(5,'SBI_Jantarmantar',8000);
insert into BankAccount values(6,'SBI_ShivajiRoad',4000);
insert into BankAccount values(8,'SBI_ResidencyRoad',4000);
insert into BankAccount values(9,'SBI_ParliamentRoad',3000);
insert into BankAccount values(10,'SBI_ResidencyRoad',5000);
insert into BankAccount values(11,'SBI_Jantarmantar',2000);

create table BankCustomer(
customer_name varchar(30),
customer_street varchar(30),
customer_city varchar(10),
primary key (customer_name));

insert into BankCustomer values('Avinash','Bull temple road','Bangalore');
insert into BankCustomer values('Dinesh','Bannergatta road','Bangalore');
insert into BankCustomer values('Mohan','National college road','Bangalore');
insert into BankCustomer values('Nikhil','Akbar road','Delhi');
insert into BankCustomer values('Ravi','Prithviraj road','Delhi');

create table Depositer(
customer_name varchar(30),
accno int,
primary key(customer_name,accno),
foreign key(customer_name) references BankCustomer(customer_name),
foreign key(accno) references BankAccount(accno));

insert into Depositer values('Avinash',1);
insert into Depositer values('Dinesh',2);
insert into Depositer values('Nikhil',4);
insert into Depositer values('Ravi',5);
insert into Depositer values('Avinash',8);
insert into Depositer values('Nikhil',9);
insert into Depositer values('Dinesh',10);
insert into Depositer values('Nikhil',11);

create table Loan(
loan_number int,
branch_name varchar(30),
amount real,
primary key(loan_number),
foreign key (branch_name) references Branch(branch_name));

insert into Loan values(1,'SBI_Chamrajpet',1000);
insert into Loan values(2,'SBI_ResidencyRoad',2000);
insert into Loan values(3,'SBI_ShivajiRoad',3000);
insert into Loan values(4,'SBI_ParliamentRoad',4000);
insert into Loan values(5,'SBI_Jantarmantar',5000);


/*iii. Find all the customers who have at least two accounts at the Main branch(Ex.SBI_ParliamentRoad)*/
select C.customer_name
from BankCustomer C
where exists(
select A.customer_name,count(A.customer_name)
from Depositer A,BankAccount B
where A.accno=B.accno and C.customer_name=A.customer_name and B.branch_name='SBI_ParliamentRoad'
group by A.customer_name
having count(A.customer_name)>=2);

/*
CUSTOMER_NAME
Nikhil
*/

/*iv. Find all the customers who have an account at all the branches located in a
specific city(Ex. Bangalore). */

select C.customer_name
from BankCustomer C 
where not exists
(
	select branch_name 
	from Branch
	where branch_city = 'Bangalore'
	minus
    select A.branch_name 
    from  BankAccount A,Depositer D
	where D.accno = A.accno and C.customer_name = D.customer_name 
	
);

/*
CUSTOMER_NAME
Avinash
*/


/*v. Demonstrate how you delete all account tuples at every branch located in
a specific city(Ex. Bombay).*/
delete from BankAccount 
where branch_name in 
(select branch_name 
 from Branch
 where branch_city='Bombay');
 
select * from BankAccount;


/*
ACCNO	BRANCH_NAME	BALANCE
1	SBI_Chamrajpet	2000
2	SBI_ResidencyRoad	5000
4	SBI_ParliamentRoad	9000
5	SBI_Jantarmantar	8000
8	SBI_ResidencyRoad	4000
9	SBI_ParliamentRoad	3000
10	SBI_ResidencyRoad	5000
11	SBI_Jantarmantar	2000
*/