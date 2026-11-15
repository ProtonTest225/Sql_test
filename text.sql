--create database hotel;
use hotel;
 create table rooms (
 room_id int identity(1,1) primary key,
 room_number int,
 room_type varchar(50),
 price_per_night int,
 status varchar(50)
 )
 create table Reservation (
 Reservation_id int identity(1,1) primary key,
 Guest_name varchar(255),
 r_id int ,
 check_in_date date,
 check_out_date date,
 book_status varchar(50),
 foreign key (r_id) references rooms(room_id)
 )
 create table Reservation_log(
 LogID int identity(1,1) primary key,
 Reservation_id int ,
 oldCheckInDate date,
 NewCheckInDate date,
 oldCheckOutDate date,
 NewCheckOutDate date,
 UpdatedOn datetime default current_timestamp
 )
 create table CancelledReservations(
 CancelId int identity(1,1) primary key,
 ReservationId int,
 GuestName varchar(50),
 Room_id int ,
 Canceldate date
 )



 create trigger prevent_double on Reservation instead of insert 
 as 
 begin
 if exists (select * from inserted i join Reservation r on r.Reservation_id = i.Reservation_id)
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




