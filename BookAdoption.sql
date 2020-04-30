Create table Student 
(
 regno varchar(15) primary key,
 name varchar(15),
 major varchar(15),
 bdate date
);

insert into Student  values ('1pe11cs001','a','sr',date '1993-09-27');
insert into Student  values ('1pe11cs002','b','sr',date '1993-09-24');
insert into Student  values('1pe11cs003','c','sr',date '1993-11-27');
insert into Student  values('1pe11cs004','d','sr',date '1993-04-13');
insert into Student  values('1pe11cs005','e','jr',date '1994-08-24');

Create table course
(
 course# int primary key,
 cname varchar(15),
 dept varchar(15)
);

insert into course values (111,'OS','CSE');
insert into course values(112,'EC','CSE');
insert into course values(113,'SS','ISE');
insert into course values(114,'DBMS','CSE');
insert into course values(115,'SIGNALS','ECE');


Create table Text
(
 book_ISBN integer primary key,
 book_Title varchar(25),
 publisher varchar(15),
 author varchar(15)
);


insert into text values(10,'DATABASE SYSTEMS','PEARSON','SCHIELD');
insert into text values(900,'OPERATING SYS','PEARSON','LELAND');
insert into text values(901,'CIRCUITS','HALL INDIA','BOB');
insert into text values(902,'SYSTEM SOFTWARE','PETERSON','JACOB');
insert into text values(903,'SCHEDULING','PEARSON','PATIL');
insert into text values(904,'DATABASE SYSTEMS','PEARSON','JACOB');
insert into text values(905,'DATABASE MANAGER','PEARSON','BOB');
insert into text values(906,'SIGNALS','HALL INDIA','SUMIT');

Create table Enroll
(
 regno varchar(15) ,
 course# int,
 sem int,
 marks int,
  primary key(Regno, Course#,sem),
 foreign key (regno) references student (regno) on delete cascade,
  foreign key (course# ) references course(course#) on delete cascade
);
  
  
insert into enroll values('1pe11cs001',115,5,100);
insert into enroll values('1pe11cs002',114,5,100);
insert into enroll values('1pe11cs003',113,5,100);
insert into enroll values('1pe11cs004',111,5,100);
insert into enroll values('1pe11cs005',112,3,100);


  Create table Book_Adoption
  (
 Course# int,
 Sem int,
 Book_ISBN int,
 primary key (course#, Book_ISBN, sem),
 foreign key (course#) references course (course#) on delete cascade,
 foreign key (book_ISBN) references Text(book_ISBN) on delete cascade
 );

insert into book_adoption VALUES(111,5,900);
insert into book_adoption VALUES(111,5,903);
insert into book_adoption VALUES(111,5,904);
insert into book_adoption VALUES(112,3,901);
insert into book_adoption VALUES(113,3,10);
insert into book_adoption VALUES(114,5,905);
insert into book_adoption VALUES(113,5,902);
insert into book_adoption VALUES(115,3,906);

/* QUERIES */

/*iii. Demonstrate how you add a new text book to the database and make this book be adopted by
some department.*/

Insert into text values (20,'C++BASICS','V.V. KUMAR','Seema Chand');
Insert into Book_Adoption values(112,3,20);

select * from text;
select * from Book_Adoption;

/*

BOOK_ISBN	BOOK_TITLE      	PUBLISHER	AUTHOR
20      	C++BASICS       	V.V. KUMAR	Seema Chand
10      	DATABASE SYSTEMS	PEARSON  	SCHIELD
900     	OPERATING SYS   	PEARSON	    LELAND
901     	CIRCUITS	        HALL INDIA	BOB
902     	SYSTEM SOFTWARE  	PETERSON	JACOB
903     	SCHEDULING      	PEARSON  	PATIL
904     	DATABASE SYSTEMS	PEARSON	    JACOB
905     	DATABASE MANAGER	PEARSON	    BOB
906     	SIGNALS         	HALL INDIA	SUMIT


COURSE#	SEM	BOOK_ISBN
111   	5	900
111 	5	903
111	    5	904
112	    3	20
112	    3	901
113 	3	10
113 	5	902
114 	5	905
115 	3	906

*/

/*iv. Produce a list of text books (include Course #, Book-ISBN, Book-title) in the alphabetical order
for courses offered by the ‘CS’ department that use more than two books.*/

Select B.course# ,T.Book_isbn,T.book_title 
from course C , text T, Book_Adoption B
where C.Dept like 'CSE' and T.Book_ISBN =B.Book_ISBN
and C.course#=B.course# and
B.course# in(
Select course# from Book_Adoption
Group by Course# having count(course#) > 2)
Order by T.Book_Title  ;

/*
COURSE#	BOOK_ISBN	BOOK_TITLE
111	904	DATABASE SYSTEMS
111	900	OPERATING SYS
111	903	SCHEDULING
*/


/*v. List any department that has all its adopted books published by a specific publisher.*/

Select all dept
from course
Where course# in (select course#
from book_adoption
where book_Isbn in(select book_Isbn 
from text
where publisher = 'HALL INDIA')
);

/*

DEPT
CSE
ECE
*/
