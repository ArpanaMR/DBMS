create table FLIGHTS
  (
  flno int,
  ffrom varchar(15),
  tto varchar(15),
  distance int,
  departs timestamp,
  arrives timestamp,
  price int,
  primary key(flno)
  );
  

insert into FLIGHTS values(101,'Bangalore','Delhi',2500,TIMESTAMP '2015-05-23 07:15:31',TIMESTAMP '2015-05-23 17:15:31',5000);
insert into FLIGHTS values(102,'Bangalore','Lucknow',3000,TIMESTAMP '2015-05-13 07:15:31',TIMESTAMP '2015-05-13 11:15:31',6000);
insert into FLIGHTS values(103,'Lucknow','Delhi',500,TIMESTAMP '2015-05-13 12:15:31',TIMESTAMP ' 2015-05-13 17:15:31',3000);
insert into FLIGHTS values(107,'Bangalore','Frankfurt',8000,TIMESTAMP '2015-05-13  07:15:31',TIMESTAMP '2015-05-13 22:15:31',60000);
insert into FLIGHTS values(104,'Bangalore','Frankfurt',8500,TIMESTAMP '2015-05-13 07:15:31',TIMESTAMP '2015-05-13 23:15:31',75000);
insert into FLIGHTS values(105,'Kolkata','Delhi',3400,TIMESTAMP '2015-05-13 07:15:31',TIMESTAMP  '2015-05-13 09:15:31',7000);


  
create table AIRCRAFT
  (
  aid  int,
  aname varchar(10),
  cruisingrange int,
  primary key(aid)
  );



insert into AIRCRAFT values(101,'747',3000);
insert into AIRCRAFT values(102,'Boeing',900);
insert into AIRCRAFT values(103,'647',800);
insert into AIRCRAFT values(104,'Dreamliner',10000);
insert into AIRCRAFT values(105,'Boeing',3500);
insert into AIRCRAFT values(106,'707',1500);
insert into AIRCRAFT values(107,'Dream', 120000);


create table EMPLOYEES
  (eid int,
  ename varchar(15),
  salary int,
  primary key(eid)
  );



insert into EMPLOYEES values(701,'Ankit',50000);
insert into EMPLOYEES values(702,'Kishna',100000);
insert into EMPLOYEES values(703,'Deepa',150000);
insert into EMPLOYEES values(704,'David',90000);
insert into EMPLOYEES values(705,'Rahul',40000);
insert into EMPLOYEES values(706,'Fatema',60000);
insert into EMPLOYEES values(707,'Gargi',90000);


create table CERTIFIED
  (
  eid int,
  aid int,
  primary key (eid,aid),
  foreign key (eid) references EMPLOYEES(eid),
  foreign key (aid) references AIRCRAFT(aid)
  );


insert into CERTIFIED values(701,101);
insert into CERTIFIED values(701,102);
insert into CERTIFIED values(701,106);
insert into CERTIFIED values(701,105);
insert into CERTIFIED values(702,104);
insert into CERTIFIED values(703,104);
insert into CERTIFIED values(704,104);
insert into CERTIFIED values(702,107);
insert into CERTIFIED values(703,107);
insert into CERTIFIED values(704,107);
insert into CERTIFIED values(702,101);
insert into CERTIFIED values(703,105);
insert into CERTIFIED values(704,105);
insert into CERTIFIED values(705,103);


/*Queries*/

/*i. Find the names of aircraft such that all pilots certified to operate them have salaries
more than Rs.80,000.*/

SELECT DISTINCT A.aname
FROM Aircraft A
WHERE A.Aid IN (SELECT C.aid
FROM Certified C, Employees E
WHERE C.eid = E.eid AND
NOT EXISTS ( SELECT *
FROM Employees E1
WHERE E1.eid = E.eid AND E1.salary <80000 ));

/*
ANAME
Dreamliner
747
Boeing
Dream
*/


/*ii. For each pilot who is certified for more than three aircrafts, find the eid and the
maximum cruisingrange of the aircraft for which she or he is certified.*/

select C.eid, max (A.cruisingrange)
from Certified C, Aircraft A
where C.aid = A.aid
group by C.eid
having count  (*) > 3;

/*
EID	MAX(A.CRUISINGRANGE)
701	3500
*/


/*iii. Find the names of pilots whose salary is less than the price of the cheapest route from
Bengaluru to Frankfurt.*/


select distinct E.ename
from Employees E
where E.salary <( select min(F.price) Minimum
                  from FLIGHTS F
                  where F.ffrom = 'Bangalore' and F.tto = 'Frankfurt' );


/*
ENAME
Ankit
Rahul
*/


/*iv. For all aircraft with cruisingrange over 1000 Kms, find the name of the aircraft and the
average salary of all pilots certified for this aircraft.*/


select Air.name, Air.AverageSalary
from ( select A.aid as Id, A.aname as Name, AVG (E.salary) AS AverageSalary
       from AIRCRAFT A, CERTIFIED C, EMPLOYEES E
       where A.aid = C.aid AND C.eid = E.eid AND A.cruisingrange > 1000
       group by A.aid, A.aname )  Air;

/*
NAME	    AVERAGESALARY
747	    75000
707	    50000
Dreamliner  113333.3333333333333333333333333333333333
Boeing	    96666.6666666666666666666666666666666667
Dream	    113333.3333333333333333333333333333333333
*/


/*v. Find the names of pilots certified for some Boeing aircraft.*/

select distinct E.ename
from EMPLOYEES E, CERTIFIED C, AIRCRAFT A
where E.eid = C.eid and C.aid = A.aid and A.aname like 'Boeing';

/*
ENAME
David
Ankit
Deepa
*/

/*vi. Find the aids of all aircraft that can be used on routes from Bengaluru to New Delhi.*/

select A.aid
from AIRCRAFT A
where A.cruisingrange >=( select min (F.distance)
		               	from FLIGHTS F
		            	where F.ffrom = 'Bangalore' and F.tto = 'Delhi' );


/*
AID
101
104
105
107
*/


/*vii. A customer wants to travel from Bangalore to Delhi with no more than two changes
of flight. List the choice of departure times from Bangalore if the customer wants to
arrive in New Delhi by 6 p.m.*/

select F.departs as DepartureTime
from FLIGHTS F
where F.flno 
in ( 
( select f.flno
 from Flights f
 where f.ffrom = 'Bangalore' and f.tto = 'Delhi'
 and extract(hour from f.arrives) < 18
)
 union
( 
 select f.flno
 from Flights f, Flights f1
 where f.ffrom = 'Bangalore' and f.tto <>'Delhi'
 and f.tto = f1.ffrom and f1.tto = 'Delhi'
 and f1.departs > f.arrives
 and extract(hour from f1.arrives) < 18
)
 union
( 
 select f.flno
 from Flights f, Flights f1, Flights f2
 where f.ffrom = 'Bangalore' and f.tto = f1.ffrom
 and f1.tto = F2.ffrom and f2.tto = 'Delhi'
 and f.tto <> 'Delhi' and f1.tto <> 'Delhi'
 and f1.departs > f.arrives and f2.departs > f1.arrives
 and extract(hour from F2.arrives) < 18)
);

/*
DEPARTURETIME
23-MAY-15 07.15.31.000000 AM
13-MAY-15 07.15.31.000000 AM
*/
