create database Supplierdb;
use Supplierdb;

create table Supplier(
sid int,
sname varchar(30),
city varchar(30),
primary key(sid));


create table Parts(
pid int,
pname varchar(30),
color varchar(30),
primary key(pid));

create table Catalog(
sid int,
pid int,
cost int,
primary key(sid,pid),
foreign key (sid) references Supplier(sid),
foreign key (pid) references Parts(pid));

insert into Supplier values(10001,'Acme Widget','Bangalore');
insert into Supplier values(10002,'Johns','Kolkata');
insert into Supplier values(10003,'Vimal','Mumbai');
insert into Supplier values(10004,'Reliance','Delhi');

insert into Parts values(20001,'Book','Red');
insert into Parts values(20002,'Pen','Red');
insert into Parts values(20003,'pencil','Green');
insert into Parts values(20004,'Mobile','Green');
insert into Parts values(20005,'Charger','Black');

insert into Catalog values(10001,20001,10);
insert into Catalog values(10001,20002,10);
insert into Catalog values(10001,20003,30);
insert into Catalog values(10001,20004,10);
insert into Catalog values(10001,20005,10);
insert into Catalog values(10002,20001,10);
insert into Catalog values(10002,20002,20);
insert into Catalog values(10003,20003,30);
insert into Catalog values(10004,20003,40);


/*i) Find the pnames of parts for which there is some supplier.*/

select distinct pname 
from Parts p, Catalog c
where p.pid=c.pid;

/*
PNAME
Book
pencil
Mobile
Charger
Pen
*/


/*ii) Find the snames of suppliers who supply every part.*/
select S.sname
from Supplier S
where not exists
(
(select P.pid from Parts P) 
minus 
(select C.pid from Catalog C where C.sid = S.sid)
);

/*
SNAME
Acme Widget
*/

/*iii) Find the snames of suppliers who supply every red part.*/
select S.sname
from Supplier S
where not exists
(
  (select P.pid from Parts P) 
  minus
  (select C.pid from Catalog C where C.sid = S.sid)
 );

/*
SNAME
Acme Widget
Johns
*/

/*iv) Find the pnames of parts supplied by Acme Widget Suppliers and by no one else.*/
select pname
from Parts,Catalog,Supplier
where Catalog.pid=Parts.pid and Catalog.sid=Supplier.sid 
and Supplier.sname='Acme Widget' and Catalog.pid not in (select c.pid from Catalog c ,Supplier s
							where s.sid=c.sid and s.sname<>'Acme Widget');

/*
PNAME
Mobile
Charger
*/

/*v) Find the sids of suppliers who charge more for some part than the average cost of that part
(averaged over all the suppliers who supply that part).*/

select sid
from Catalog c
where c.cost>( select avg(c1.cost)
		from Catalog c1
		where c.pid=c1.pid);

/*
SID
10001
10002
10003
10004
*/

/*vi) For each part, find the sname of the supplier who charges the most for that part.*/

select P.pid, S.sname
from Parts P, Supplier S, Catalog C
where C.pid = P.pid and C.sid = S.sid and
C.cost = (select max(c.cost)
          from Catalog c
          where c.pid = P.pid)
          order by P.pid asc;


/*
PID	SNAME
20001	Acme Widget
20001	Johns
20002	Johns
20003	Reliance
20004	Acme Widget
20005	Acme Widget
*/
