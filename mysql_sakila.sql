-- 1 All films with rating pg-13 and rental rate of 2.99 or lower
select * from sakila.film
where rating = 'PG-13' and rental_rate <= 2.99;

-- 2 Films with deleted scenes and film beginning with letter B
select title, special_features, release_year from sakila.film 
where special_features like '%Deleted Scenes%' and title like 'B%';

-- 3 All active customers
select c.customer_id, c.first_name, c.last_name, c.email from sakila.customer c 
where c.active = 1;
-- number of active customers
select count(*) from sakila.customer where active=1;

-- 4 Name of customers who rented movie on 26 July 2005
select r.rental_id, r.customer_id, concat(c.first_name, ' ',c.last_name) as customer_name, r.rental_date from sakila.rental r
inner join sakila.customer c
on r.customer_id = c.customer_id
where date(rental_date) = '2005-07-26'; 

-- 5 Distinct name of customers who rented movie on July 2005
select  distinct concat(c.first_name, ' ',c.last_name) as customer_name from sakila.rental r
inner join sakila.customer c
on r.customer_id = c.customer_id
where date(rental_date) = '2005-07-26' order by customer_name; 

-- 6 How many distinct last names in the data
select count(distinct last_name) from sakila.customer;

-- 7 How many movies rented on each day
select date(rental_date) as rental_date, count(rental_id) as No_of_movies from sakila.rental
group by date(rental_date)
order by date(rental_date);

-- busiest day
select date(rental_date) as rental_date, count(rental_id) as No_of_movies from sakila.rental
group by date(rental_date)
order by count(rental_id) desc limit 5;

-- least busiest day
select date(rental_date) as rental_date, count(rental_id) as No_of_movies from sakila.rental
group by date(rental_date)
order by count(rental_id) limit 5;

-- 8 All sci-fi films in our catalog
with cte as (select f.title, c.name, fc.film_id from sakila.category c
inner join sakila.film_category fc 
on c.category_id = fc.category_id 
inner join sakila.film f
on fc.film_id = f.film_id)
select * from cte where name='Sci-Fi';

-- 9 customers and how many movies they rented from us 
with cte as (select customer_id, count(rental_id) as number_of_movies from sakila.rental
group by customer_id)
select concat(c.first_name, ' ', c.last_name) as full_name, cte.number_of_movies from sakila.customer c
join cte on c.customer_id = cte.customer_id
order by cte.number_of_movies desc;


-- 10 which movies should we discontinue (less than 5 rentals in lifetime)
select i.film_id, f.title,count(*) as lifetime_rentals from sakila.rental r 
join sakila.inventory i
on r.inventory_id = i.inventory_id
join sakila.film f
on i.film_id = f.film_id
group by i.film_id
having count(*) < 5;

with low_rentals as 
	(select i.film_id, count(*)
	from sakila.rental r
    join sakila.inventory i on i.inventory_id = r.inventory_id
	group by i.film_id
	having count(*)<5)
select low_rentals.film_id, f.title
 from low_rentals
join sakila.film f on f.film_id = low_rentals.film_id;

-- 11 which movies have not been returned yet
with no_returns as (select i.film_id from sakila.rental r 
join sakila.inventory i on r.inventory_id = i.inventory_id
where r.return_date is null )
select f.title from no_returns nr
join sakila.film f on nr.film_id = f.film_id;

-- 12 how much money and rentals we make for store 1 by day
with store_rentals as (select r.rental_id, r.rental_date from sakila.rental r
join sakila.inventory i 
on r.inventory_id = i.inventory_id
where i.store_id = 1)
select date(sr.rental_date) as rental_date, count(sr.rental_id) as rentals , sum(p.amount) as total_amount from sakila.payment p
join store_rentals sr on sr.rental_id = p.rental_id
group by date(sr.rental_date)
order by sum(p.amount) desc;

-- how much money and rentals does each store make
with store_rentals as (select i.store_id,r.rental_id, r.rental_date from sakila.rental r
join sakila.inventory i 
on r.inventory_id = i.inventory_id)
select sr.store_id, count(sr.rental_id) as rentals , sum(p.amount) as total_amount, sum(p.amount)/count(sr.rental_id) as avg_amt_per_rental
 from sakila.payment p
join store_rentals sr on sr.rental_id = p.rental_id
group by sr.store_id
order by sr.store_id;

-- find movie names with max rental rate and rating R
select title, rental_rate, rating from sakila.film 
where rental_rate = (select max(rental_rate) from sakila.film) and rating= 'R';

-- find movie names with min rental rate and rating PG or PG-13
select title, rental_rate, rating from sakila.film 
where rental_rate = (select min(rental_rate) from sakila.film) and rating like 'PG%';

-- how many movies in each rating type
select rating, count(*) as num_of_movies from sakila.film
group by rating
order by count(*) desc;

-- how many films are there in each language
select l.name, count(f.title) as no_of_movies from sakila.language l
join sakila.film f on l.language_id = f.language_id
group by l.name
order by count(f.title) desc;

-- which staff has rented out the most movies
select r.staff_id, s.first_name,s.last_name,count(*) no_of_rentals from sakila.rental r
join sakila.staff s
on r.staff_id= s.staff_id
group by staff_id ;

-- how much money and rentals does each staff make
with staff_sales as 
	(select r.staff_id, count(r.rental_id) as no_of_movies, sum(p.amount) as total_sales from sakila.rental r
	join sakila.payment p
	on p.rental_id = r.rental_id
	group by r.staff_id)
select ss.staff_id, concat(s.first_name, ' ' , s.last_name) as staff_name, no_of_movies, total_sales, total_sales/no_of_movies as avg_rental
from staff_sales ss
join sakila.staff s 
on ss.staff_id = s.staff_id;

