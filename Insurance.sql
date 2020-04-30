create database INSURANCE;
use INSURANCE;
create table PERSON(
driver_id varchar(10),
name varchar(30),
address varchar(50),
PRIMARY KEY (driver_id));
desc PERSON;
insert into PERSON values("A01","Richard","Srinivas nagar"),("A02","Pradeep","Rajaji nagar"),("A03","Smith","Ashok nagar"),("A04","Venu","NR colony"),("A05","John","Hanumanth nagar");
select * from PERSON;
create table CAR(
reg_num varchar(10),
model varchar(30),
year int,
primary key (reg_num));
insert into CAR values("KA052250","Indica",1990),("KA0311181","Lancer",1957),("KA095477","Toyota",1998),("KA053408","Honda",2008),("KA041702","Audi",2005);
select * from CAR;
update CAR set reg_num="KA031181" where reg_num="KA0311181";
create table OWNS(
driver_id varchar(10),
reg_num varchar(10),
primary key (driver_id,reg_num),
foreign key (driver_id) references PERSON(driver_id),
foreign key (reg_num) references CAR(reg_num));
insert into OWNS values("A01","KA052250"),("A02","KA053408"),("A03","KA031181"),("A04","KA095477"),("A05","KA041702");
select * from OWNS;
create table ACCIDENT(
report_num int,
accident_date date,
location varchar(50),
primary key(report_num));
insert into ACCIDENT values(11,"2003-01-01","Mysore road");
insert into ACCIDENT values(12,"2004-02-02","South end circle"),(13,"2003-01-21","Bull temple road"),(14,"2008-02-17","Mysore road"),(15,"2005-03-04","Kanakpura road");
select * from ACCIDENT;
create table PARTICIPATED(
driver_id varchar(10),
reg_num varchar(10),
report_num int,
damage_amount int,
primary key (driver_id,reg_num,report_num),
foreign key (driver_id) references PERSON(driver_id),
foreign key (reg_num) references CAR(reg_num),
foreign key (report_num) references ACCIDENT(report_num));
insert into PARTICIPATED values("A01","KA052250",11,10000),("A02","KA053408",12,50000),("A03","KA095477",13,25000),("A04","KA031181",14,3000),("A05","KA041702",15,5000);
select * from PARTICIPATED;


/*
iii)Demonstrate how you
a.Update the damage amount to 25000 for the car with a specific reg-num(example 'K
A053408') for which the accident report number was 12.
*/

update PARTICIPATED 
set damage_amount=25000 
where reg_num="KA053408" AND report_num=12;
select * from PARTICIPATED;

/*
PARTICIPATED
A01	KA052250	11	10000
A02	KA053408	12	25000
A03	KA095477	13	25000
A04	KA031181	14	3000
A05	KA041702	15	5000
*/


/*b.Add a new accident to the database.*/
insert into ACCIDENT values(16,"2018-02-20","JP nagar");
select * from ACCIDENT;

/*
ACCIDENT
11	2003-01-01	Mysore road
12	2004-02-02	South end circle
13	2003-01-21	Bull temple road
14	2008-02-17	Mysore road
15	2005-03-04	Kanakpura road
16	2018-02-20	JP nagar
*/

/*iv)Find the total number of people who owned cars that involved in accidents in 2008.*/

select count(distinct driver_id) CNT 
from PARTICIPATED,ACCIDENT 
where PARTICIPATED.report_num=ACCIDENT.report_num AND accident_date like '2008%';

/*
CNT-1
*/

/*v)Find the number of accidents in which cars belonging to a specific model (example )were
involved.*/

select count(distinct model) COT
 from PARTICIPATED,
CAR where PARTICIPATED.reg_num=CAR.reg_num AND CAR.model="Audi";

/*
COT-1
*/

