
-- Q1  Who is the senior most employee based on job title?
select * from employee
order by levels desc
limit 1;

-- Q2 Which countries have the most Invoices?
select billing_country, count(invoice_id) as invoice_count
from invoice
group by billing_country
order by invoice_count DESC
limit 1 ;

-- Q3  What are top 3 values of total invoice?
select total
from invoice
order by total DESC
limit 3;

-- Q4  Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals Return both the city name & sum of all invoice totals
select * from invoice;

select billing_city, sum(total) as sum_of_all_invoice_total
from invoice
group by billing_city
order by sum_of_all_invoice_total DESC
limit 1;

-- Q5  Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money

select * from customer;

select c.customer_id, sum(total) as total_spent
from customer as c
join invoice as i
on c.customer_id=i.customer_id
group by c. customer_id
order by total_spent DESC
limit 1;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q6 Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A

select * from genre;

-- Method-1 -- not efficient as multiple joins were used which makes it slow
select distinct c.email, c.first_name, c.last_name
from customer as c
join invoice as i
on c.customer_id=i.customer_id
join invoice_line as il
on i.invoice_id=il.invoice_id
join track as t
on il.track_id = t.track_id
join genre as g
on t.genre_id=g.genre_id
where g.name like 'Rock'
-- group by c.first_name, c.last_name, c.email, g.name
order by c.email ASC;

-- Method-2 -- less joins hence optimal -- using subquery
select distinct email, first_name, last_name
from customer as c
join invoice as i
on c.customer_id=i.customer_id
join invoice_line as il
on i.invoice_id=il.invoice_id
where track_id in (select track_id from track  as t
					join genre as g
					on t.genre_id=g.genre_id
					where g.name like 'Rock')
order by email ASC;

-- -------------------------------------------------------------------------------------------------------------------

-- Q7  Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands

select artist.name as artist_name, count(distinct(track.track_id)) as total_track_count
from artist
join album2
on artist.artist_id=album2.artist_id
join track
on album2.album_id=track.album_id
where track.genre_id in (select genre_id from genre where name like 'Rock')
group by artist.name
order by total_track_count DESC
limit 10;

-- ----------------------------------------------------------------------------------------------------------------------

-- Q8 Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

select DISTINCT	name, milliseconds 
from track
where milliseconds > (select avg(milliseconds) from track) 
order by milliseconds DESC;

-- ---------------------------------------------------------------------------------------------------------------

-- Q9 Find how much amount spent by each customer on artists? 
-- Write a query to return customer name, artist name and total spent

select c.first_name, c.last_name, at.name, sum(i.total) as amount_spent
from customer as c
join invoice as i
on c.customer_id=i.invoice_id
join invoice_line as il
on i.invoice_id=il.invoice_id
join track as t
on il.track_id = t.track_id
join album2 as a
on t.album_id=a.album_id
join artist as at
on a.artist_id=at.artist_id
group by c.first_name, c.last_name, at.name;

-- -------------------------------------------------------------------------------------------------------------------------------------------------

-- Q10 write a query to find the best selling artist and how much money different customers has spent on it.
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album2 ON album2.album_id = track.album_id
	JOIN artist ON artist.artist_id = album2.artist_id
	GROUP BY artist.artist_id,artist.name 
	ORDER BY 3 DESC
    limit 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album2 alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY 5 DESC;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q11  We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. 
-- Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres

/* Method 1: Using CTE */

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country as country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY customer.country, genre.name, genre.genre_id
	ORDER BY customer.country ASC
)
SELECT * FROM popular_genre WHERE RowNo <= 1;


/* Method 2: : Using Recursive */
WITH RECURSIVE
	sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY customer.country, genre.name, genre.genre_id
		ORDER BY customer.country
	),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY 2
		ORDER BY 2)

SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	

-- Q12 Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and howmuch they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount

/* Method 1: using CTE */

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    rank() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RankNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY customer.customer_id,first_name,last_name,billing_country
		)
SELECT * FROM Customter_with_country WHERE RankNo <= 1;


/* Method 2: Using Recursive */
WITH RECURSIVE 
	customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 2,3 DESC),

	country_max_spending AS(
		SELECT billing_country,MAX(total_spending) AS max_spending
		FROM customter_with_country
		GROUP BY billing_country)

SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
FROM customter_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;


