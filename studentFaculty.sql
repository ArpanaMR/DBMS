create table Student (
snum int, 
sname varchar(20),
major varchar(20),
lvl varchar(20),
age int,
primary key(snum));

insert into Student values(1, 'John', 'CS', 'SR', 19);
insert into Student values (2, 'Smith', 'EC', 'JR', 20);
insert into Student values(3 , 'Jacob', 'CV', 'SO', 20);
insert into Student values(4, 'Tom ', 'CS', 'FR', 20);
insert into Student values(5, 'Rahul', 'CV', 'JR', 20);
insert into Student values(6, 'Rita', 'IS', 'SR', 21);
                          

create table Faculty(
fid int,
fname varchar(20),
deptid int,
primary key(fid));

insert into Faculty values(11, 'Harish', 1000);
insert into Faculty values(12, 'MV', 1000);
insert into Faculty values(13 , 'Mira', 1001);
insert into Faculty values(14, 'Shiva', 1002);
insert into Faculty values(15, 'Nupur', 1000);

update Faculty
set fid=14 where fname='Shiva';

create table Class(
cname varchar(30),
meetsat timestamp,
room varchar(30),
fid int,
primary key(cname),
foreign key (fid) references Faculty(fid));


insert into Class(cname,room,fid) values('class1', 'R1', 14);
insert into Class(cname,room,fid) values('class10','R128', 14);
insert into Class(cname,room,fid) values('class2', 'R2', 12);
insert into Class(cname,room,fid) values('class3', 'R3', 12);
insert into Class(cname,room,fid) values('class4','R4',  14);
insert into Class(cname,room,fid) values('class5','R3' ,15);
insert into Class(cname,room,fid) values('class6','R2',14);
insert into Class(cname,room,fid) values('class7', 'R3',14);
           
select * from Class;      

update Class
set meetsat=SYSTIMESTAMP where cname='class1';

update Class
set meetsat=SYSTIMESTAMP where cname='class10';

update Class
set meetsat=SYSTIMESTAMP where cname='class2';

update Class
set meetsat=SYSTIMESTAMP where cname='class3';

update Class
set meetsat=SYSTIMESTAMP where cname='class4';

update Class
set meetsat=SYSTIMESTAMP where cname='class5';

update Class
set meetsat=SYSTIMESTAMP where cname='class6';

update Class
set meetsat=SYSTIMESTAMP where cname='class7';

create table Enrolled(
snum int,
cname varchar(30),
primary key(snum,cname),
foreign key(snum) references Student(snum),
foreign key(cname) references Class(cname));


insert into Enrolled values(1, 'class1');
insert into Enrolled values(2, 'class1');
insert into Enrolled values(3, 'class3');
insert into Enrolled values(4, 'class3');
insert into Enrolled values(5, 'class4');
insert into Enrolled values(1, 'class5');
insert into Enrolled values(2, 'class5');
insert into Enrolled values(3, 'class5');
insert into Enrolled values(4,'class5');
insert into Enrolled values(5,'class5');


select * from Enrolled;

/*i. Find the names of all Juniors (level = JR) who are enrolled in a class taught by Shiva.*/
select distinct S.sname
from Student S,Enrolled E,Class C,Faculty F
where F.fname='Shiva' and S.lvl='JR' and S.snum=E.snum 
      and C.cname=E.cname and F.fid=C.Fid;

/*
SNAME
Rahul
Smith
*/


/*ii. Find the names of all classes that either meet in room R128 or have five or more
Students enrolled./

select cname
from Class
where room='R128' or
cname in ( select distinct cname 
		   from Enrolled
           group by cname
           having count(*)>=5);

/*
CNAME
class10
class5
*/


/*iii. Find the names of all students who are enrolled in two classes that meet at the same
time.*/
select sname
from Student
where snum in (select e1.snum 
		from Enrolled e1,Enrolled e2,Class c1,Class c2
                where e1.snum=e2.snum and e1.cname=c1.cname and
               e2.cname=c2.cname and e1.cname<>e2.cname and 
               c1.meetsat=c2.meetsat);


/*
SNAME
John
Smith
Jacob
Tom 
Rahul
*/

/*iv. Find the names of faculty members who teach in every room in which some class is
taught.*/

select F.fname
from Faculty F
where not exists
(select room
 from Class
 minus
 select distinct C.room 
 from Class C
 where C.fid=F.fid);

/*
FNAME
Shiva
*/

/*v. Find the names of faculty members for whom the combined enrollment of the courses
that they teach is less than five.*/

select distinct fname
from Faculty
where 5>(select count(Enrolled.snum)
		 from Enrolled,Class
		 where Enrolled.cname=Class.cname and Class.fid=Faculty.fid);


/*
FNAME
Mira
Shiva
Harish
MV
*/

/*vi. Find the names of students who are not enrolled in any class.*/
select sname
from Student
where snum not in (select snum
		   from Enrolled);

/*
SNAME
Rita
*/

/*vii. For each age value that appears in Students, find the level value that appears most often.
For example, if there are more FR level students aged 18 than SR, JR, or SO students
aged 18, you should print the pair (18, FR).*/
select S.age, S.lvl
from Student S
group by S.age, S.lvl
having S.lvl in (select s.lvl 
                 from Student s
                 where s.age = S.age
	         group by s.lvl, s.age
                 having count(*) >= all(select count(*)
		                        from Student s1
				        where s.age = s1.age
				        group by s1.lvl, s1.age));

/*
AGE	LVL
19	SR
20	JR
21	SR
*/