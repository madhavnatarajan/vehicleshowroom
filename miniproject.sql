drop database if exists vehicleshowroom;
create database vehicleshowroom;
\c vehicleshowroom;
drop table if exists customer_contact cascade;

/*drop table if exists classroom cascade;
drop table if exists department cascade;
drop table  if exists course cascade;
drop table  if exists instructor cascade;
drop table  if exists section cascade;
drop table  if exists teaches cascade;
drop table if exists  student cascade;
drop table if exists  takes cascade;
drop table if exists  advisor cascade;
drop table if exists  time_slot cascade;
drop table if exists  prereq cascade;*/

create table admin (
adminname varchar(15),
adminid varchar(10), 
passwrd varchar(7), 
username varchar(7),
stats varchar(20),
contactno int, 
lastlogin TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
primary key (adminid) 
);

create table dealer(
dealerID varchar(10),
username varchar(10),
lastlogin TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
passwrd varchar(7),
name varchar(15),
image varchar(15),
companyname varchar(30),
contactno int,
adminid varchar(10),
address varchar(50),
primary key(dealerID),
foreign key (adminid) references admin on delete set null
);

alter table dealer
drop column lastlogin;

create table vehicle(
vehicletype varchar(10),
vehicleID varchar(20),
vehiclemodel varchar(30),
stats varchar(15),
dealerID varchar(10),
vehiclecost int,
vehiclename varchar(20),
description varchar(20),
primary key(vehicleID),
unique (vehicleID),
foreign key (dealerID) references dealer on update cascade
);

alter table vehicle
add check (vehiclecost>0);

create table image(
defaultimage varchar(15),
vehicleID varchar(20),
imageID varchar(20),
imageName varchar(30),
imagePath varchar(50),
primary key (imageID),
unique (imageID),
foreign key (vehicleID) references vehicle on update cascade
);

create table showroom(
showroomID int,
dealerID varchar(10),
showroomName varchar(10),
imageID varchar(10),
contactno int,
address varchar(50),
primary key (showroomID),
unique (showroomID),
foreign key (dealerID) references dealer on update cascade,
foreign key (imageID) references image on delete set null
);

create table customer(
custid varchar(10),
fname varchar(25) not null,
lname varchar(25),
contactno int,
emailid varchar(30),
passwrd varchar(7),
address varchar(50),
gender varchar(10),
createdat date,
stats varchar(30) check (stats in ('item_finalising', 'item_shortlisted', 'paid')), 
primary key (custid)
);

create table sales(
salesid varchar(10),
vehicleID varchar(10),
custid varchar(10),
showroomid varchar(10),
cost decimal(10,2) check (cost>0),
ord_date date,
delv_date date default null,
description varchar(30),
stats varchar(20) check (stats in ('packaged', 'shipped', 'delivered')),
primary key (salesid),
foreign key (vehicleID) references vehicle on update cascade,
foreign key (custid) references customer on delete set null
);

create view showroomview as 
select s.showroomName,s.showroomID,v.vehiclename,v.vehiclemodel,v.vehiclecost 
from showroom s,vehicle v;

create table customer_contact(
custid varchar(10),
contactno int,
primary key (custid, contactno),
foreign key (custid) references customer on delete set null
);

