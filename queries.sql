select a.activity_play_name as Play_Name, t.theatre_address as Theatre_Location, t.theatre_name as Theatre_Name, a.activity_date as _DATE_
from theatre t, activity a
where EXISTS(	select a.activity_date as _DATE_
				from activity a
				where a.activity_date > '2020-12-31') and t.theatre_address = a.activity_theatre_address;
--Theaters (activities) held after 2020.

select a.activity_play_name, a.activity_date, a.activity_id, t.theatre_name, t.theatre_address 
from theatre t, activity a
where a.activity_theatre_address = t.theatre_address and a.activity_theatre_address LIKE 'Ankara;%';
--Activities in Ankara (theater plays).

select tp.play_name as PlayName, tp.author as author
from theatre t, theatre_play tp, activity a
where a.activity_theatre_address = t.theatre_address and a.activity_play_name = tp.play_name and a.activity_theatre_address NOT LIKE 'Bursa;%';
--Theater plays that are not in Bursa.

SELECT COUNT(id), "ticket_price" , t.ticket_play_name as PlayName, a.activity_theatre_address as TheatreLocation
FROM ticket t, activity a
GROUP BY "ticket_price", t.ticket_play_name, a.activity_theatre_address, a.activity_play_name
HAVING t.ticket_price < 50 and a.activity_play_name = t.ticket_play_name;
--The number of tickets sold for less than 50 TL, the names of the theater plays and the address of the theater.

SELECT c.customer_name as CustomerFullname,c.birthday as CustomerBirthday
FROM customer c
ORDER BY c.birthday;
--Customers with their birthdays who bought tickets and stated their birthdays, sorted in ascending order.

SELECT customer_name as Customer_Name, birthday as Customer_Birthday, ticket_date
FROM customer
INNER JOIN ticket
			ON (customer.id = ticket.id);
--All customers.

SELECT *
FROM customer
INNER JOIN ticket
			ON (customer.id = ticket.id)
INNER JOIN activity
			ON ticket.ticket_date = activity.activity_date
			WHERE ticket.ticket_play_name = activity.activity_play_name
ORDER BY customer.customer_name ASC;
--All customers with their ticket's activites ordered by alphabetically.
		
SELECT t.theatre_name, r.room_id
	FROM theatre t
	FULL OUTER JOIN rooms r
		ON t.theatre_address = r.room_theatre_address
		ORDER BY t.theatre_name;
--theatre's rooms

SELECT a.fullname as ActorName, a.sex as Sex, age(a.birthday) as ActorAge, a.salary as Salary
FROM actors a
where a.salary = (
				select MIN(a.salary)
				from actors a
);
--Name, gender and age of the actor with the lowest salary.

SELECT a.fullname as ActorName, a.sex as Sex, age(a.birthday) as ActorAge
FROM actors a
ORDER BY a.fullname ASC;
--Actors in alphabetical order.

SELECT SUM("ticket_price") as TotalProfit
FROM ticket t;
--Income from tickets sold.


-- SPECIAL QUARRIES
--Total count of needed actor and actresses seperately for plays of 2019 Ankara and total count of actor and actresses of Ankara in 2019.
SELECT SUM(tp.total_actor) as Actors, SUM(tp.total_actress) as Actress, ac.activity_play_name as Play_Name, ac.activity_theatre_address as Address, ac.activity_date as Play_date
FROM theatre_play tp, activity ac
GROUP BY ac.activity_play_name, ac.activity_theatre_address, tp.play_name, ac.activity_date
HAVING ac.activity_play_name = tp.play_name and ac.activity_date > '2018-12-31' and ac.activity_date < '2020-01-01' and ac.activity_theatre_address LIKE 'Ankara;%';

--Play information (play name, theater name, player count, city name etc.)  of tour plays which was held in Ýstanbul in last year(2020).
--Tour play: A play that is played in a different city rather than the original city of that play for that year.
--i.e. If a play team from Ankara State theatre plays the play in Istanbul,Erzurum etc. This is a tour play.
SELECT ac.activity_play_name as Play_Name, tp.original_play_location as Original_Play_Location, t.theatre_name as Theatre_Name, ac.activity_theatre_address as TheatreAddress, ac.activity_date as Play_date, (tp.total_actor+tp.total_actress) as Total_Actor
FROM theatre_play tp, activity ac, theatre t
GROUP BY ac.activity_play_name, tp.original_play_location, ac.activity_theatre_address, tp.play_name, ac.activity_date, (tp.total_actor+tp.total_actress), t.theatre_name, t.theatre_address
HAVING t.theatre_address = ac.activity_theatre_address and ac.activity_play_name = tp.play_name and ac.activity_date > '2019-12-31' and ac.activity_date < '2021-01-01' and ac.activity_theatre_address LIKE 'Istanbul;%' and tp.original_play_location NOT LIKE 'Istanbul' and tp.original_play_location IS NOT NULL;




