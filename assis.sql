create database hotel;
go
use hotel;
go
--drop database hotel
 create table rooms (
 room_id int identity(1,1) primary key,
 room_number int,
 room_type varchar(50),
 price_per_night int,
 status varchar(50)
 );
go
 create table Reservation (
 Reservation_id int identity(1,1) primary key,
 Guest_name varchar(255),
 r_id int unique not null,
 check_in_date date,
 check_out_date date,
 book_status varchar(50),
 foreign key (r_id) references rooms(room_id)
 );
go
 create table Reservation_log(
 LogID int identity(1,1) primary key,
 Reservation_id int ,
 oldCheckInDate date,
 NewCheckInDate date,
 oldCheckOutDate date,
 NewCheckOutDate date,
 UpdatedOn datetime default current_timestamp
 );
go
 create table CancelledReservations(
 CancelId int identity(1,1) primary key,
 ReservationId int,
 GuestName varchar(50),
 Room_id int ,
 Canceldate date
 );
go

   


 create trigger prevent_double on Reservation instead of insert 
 as 
 begin
 if exists (select * from inserted i join Reservation r on r.r_id = i.r_id where r.check_in_date=i.check_in_date)
 begin
 print 'Room is already reserved for selected dates';
 end
else 
begin 
insert into Reservation (Guest_name
      ,r_id
      ,check_in_date
      ,check_out_date
      ,book_status) select Guest_name
      ,r_id
      ,check_in_date
      ,check_out_date
      ,book_status
	  from inserted
end
 end;

 --drop trigger prevent_double


go
create trigger reslog on Reservation after update as 
begin 
if update(check_in_date) or update(check_out_date)
begin
  insert into Reservation_log (Reservation_id,oldCheckInDate,NewCheckInDate,oldCheckOutDate,NewCheckOutDate) select i.Reservation_id,d.check_in_date,i.check_in_date,d.check_out_date,i.check_out_date from inserted i join deleted d on i.Reservation_id=d.Reservation_id
  end;
end;

--drop trigger reslog

go
create trigger canResLog on Reservation after delete as 
begin

insert into CancelledReservations (ReservationId,GuestName,room_id,Canceldate) select Reservation_id,Guest_name,r_id,current_timestamp from deleted
  
end;




go
insert into rooms (room_number,room_type,price_per_night) values (101,'Suite',29000),(201,'Suite',29000),(301,'Suite',29000),(401,'regular',18000),(401,'regular',18000)

go
insert into Reservation (Guest_name,r_id,check_in_date,check_out_date,book_status) values ('Meer',1,'2026-11-17' ,'2026-11-27','Occupied'),('Billu',2,'2026-11-17' ,'2026-11-27','Occupied'),('Ali',3,'2026-11-17' ,'2026-12-29','Occupied'),('Rehan',4,'2026-11-17' ,'2026-11-27','Occupied'),('Hadi',5,'2026-11-17' ,'2026-11-27','Occupied');
go
update Reservation set check_in_date ='2026-11-12' where Reservation_id = 2
go
delete from Reservation where Reservation_id=6