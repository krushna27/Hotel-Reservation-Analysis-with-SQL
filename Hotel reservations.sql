--  create new database
create database Hotel;
show databases;
-- hotel database for further used
use hotel;

show table status;
show tables;

-- rename the table name
alter table `hotel reservation dataset` rename to Hotelr;

select * from hotelr;

-- QUESTIONS 
-- 1.  What is the total number of reservations in the dataset
select count(booking_id) from hotelr;
--  Result - so there is total 700 reservations in dataset


-- 2. Which meal plan is the most popular among guests?

SELECT type_of_meal_plan, COUNT(type_of_meal_plan) AS num_reservations
FROM Hotelr
GROUP BY type_of_meal_plan
ORDER BY num_reservations DESC
LIMIT 1;

-- Result - so most popular meal plan for guests are "meal plan 1" with 527 reservation 
 
 
 
 -- 3. What is the average price per room for reservations involving children?
 select avg(avg_price_per_room) as average_price_for_children from hotelr where no_of_children > 0 ;
 -- Result -average price per room for reservations involving children is 144.568
 
-- 4. How many reservations were made for the year 20XX (replace XX with the desired year)
# creating a new column for year or arrival
alter table hotelr add column booking_year int;

# extrating year from arrival_date into booking_year
update hotelr set booking_year = year(STR_TO_DATE(arrival_date, '%d-%m-%Y'));

select * from hotelr;

select booking_year,count(*) as Number_reservation from hotelr
where booking_year = 2018;
-- Result - so in year 2018 over 577 reservation as been made


-- 5. What is the most commonly booked room type?    

select room_type_reserved,count(room_type_reserved) as commonly_booked from hotelr group by  room_type_reserved
order by commonly_booked desc limit 1;

-- Result - so the most commonly used room type is "Room_Type1" with 534 bookings


-- 6.   How many reservations fall on a weekend (no_of_weekend_nights > 0)?
select count(*) from hotelr where no_of_weekend_nights > 0;

-- Result - On Weekend 383 reservation as been done

-- 7. What is the highest and lowest lead time for reservations?
select max(lead_time) as Highest_lead_time , min(lead_time) as lowest_lead_time from hotelr;

-- Result - highest and lowest lead time for reservations is 443 and 0

-- 8.  What is the most common market segment type for reservations?
select * from hotelr;
select market_segment_type,count(market_segment_type) as segment_type from hotelr group by market_segment_type order by segment_type desc limit 3;

-- Result - so the most common market segment type for reservation is "Online" with over 518 reservation , follow by offline and corporate which is 140 and 27 

 
-- 9. How many reservations have a booking status of "Confirmed"?
select * from hotelr;
select booking_status,count(booking_status) as Booking_confirmed from hotelr where booking_status = "Not_Canceled";

# create a new column for this
ALTER TABLE Hotelr
ADD COLUMN confirmation_status VARCHAR(20);


update  hotelr
set confirmation_status = case when booking_status = 'Not_Canceled' then 'Confirmed'
else 'Not Confirmed'
end;

select confirmation_status,count(confirmation_status) as Booking_confirmed from hotelr where confirmation_status = "Confirmed";

-- Result -  from the query we found that reservation who's booking_status is "Confirmed" are 493.


-- 10. What is the total number of adults and children across all reservations?
select * from hotelr;

select sum(no_of_adults) as Adult_sum, sum(no_of_children) as Children_sum
from hotelr;

--  Result - Total sum of Adult in table are 1316 and total number of children are 69


-- 11.  What is the average number of weekend nights for reservations involving children?
select round(avg(no_of_weekend_nights),1) from hotelr where no_of_children > 0;

-- Result -  average number of weekend nights for reservations involving children is 1.0


-- 12. How many reservations were made in each month of the year?
select * from hotelr;

# creating a new column for month of arrival
alter table hotelr add column booking_month int;

# extrating year from arrival_date into booking_year
update hotelr set booking_month = month(STR_TO_DATE(arrival_date, '%d-%m-%Y'));

select booking_year,booking_month , count(*) as Number_reservation from hotelr
group by booking_month,booking_year
order by number_reservation desc;

-- Result - highest number of reservation are made on 6th month of 2018 which is 84


-- 13 - What is the average number of nights (both weekend and weekday) spent by guests for each room type?

select room_type_reserved, avg(no_of_weekend_nights + no_of_week_nights) as avg_no_night_spend from hotelr
group by room_type_reserved;

-- Result 
-- Room_Type 4	3.8000
-- Room_Type 2	3.0000
-- Room_Type 6	3.6111


-- 14 - For reservations involving children, what is the most common room type, and what is the average price for that room type?
select * from hotelr;

    
    
    WITH ChildrenReservations AS (
    SELECT room_type_reserved
    FROM Hotelr
    WHERE no_of_children > 0
    GROUP BY room_type_reserved
    ORDER BY COUNT(*) DESC
    LIMIT 1
)

SELECT cr.room_type_reserved, AVG(hr.avg_price_per_room) AS average_price
FROM ChildrenReservations cr
JOIN Hotelr hr ON cr.room_type_reserved = hr.room_type_reserved
GROUP BY cr.room_type_reserved;


-- Result - Most Common room type and avg price for that is "room_type_1" and price is "96.90"


-- 15. Find the market segment type that generates the highest average price per room.

select * from hotelr;
select market_segment_type , max(avg_price_per_room) as highest_average_price from hotelr ;
