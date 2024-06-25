-- AVG
SELECT c.name AS category_name,
f.title AS movie_name,
f.rental_duration,
AVG(f.rental_duration) OVER(PARTITION BY c.name) AS avg_rental_duration
FROM film_category fc
JOIN film f ON fc.film_id = f.film_id
JOIN category c ON fc.category_id = c.category_id
ORDER BY avg_rental_duration DESC, rental_duration DESC;

--MAX
SELECT city_id,
MAX(last_update) OVER (PARTITION BY city_id) AS last_city_update
FROM address;

--MIN
SELECT store_id,
MIN(create_date) OVER (PARTITION BY store_id) AS earliest_customer
FROM customer;

--SUM
SELECT category_id,
SUM(replacement_cost) OVER (PARTITION BY category_id) AS total_cost
FROM film_category fc JOIN film f ON fc.film_id = f.film_id;

SELECT customer_id, f.title,
SUM(rental_rate) OVER (PARTITION BY customer_id) AS cumulative_rental_income
FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id;

--COUNT
SELECT staff_id,
COUNT(customer_id) OVER (PARTITION BY staff_id) AS rental_count
FROM rental;

-- RANK
SELECT actor_id,
COUNT(film_id) AS film_count,
RANK() OVER (ORDER BY COUNT(film_id) DESC) AS actor_rank
FROM film_actor
GROUP BY actor_id;

-- DENSE_RANK
SELECT actor_id,
COUNT(film_id) AS film_count,
DENSE_RANK() OVER (ORDER BY COUNT(film_id) DESC) AS actor_rank
FROM film_actor
GROUP BY actor_id;

-- NTILE
SELECT actor_id,
NTILE(4) OVER (ORDER BY COUNT(film_id) DESC) AS actor_ntile
FROM film_actor
GROUP BY actor_id;

-- ROW_NUMBER
SELECT actor_id,
ROW_NUMBER() OVER (ORDER BY COUNT(film_id) DESC) AS actor_row_number
FROM film_actor
GROUP BY actor_id;

-- CUME_DIST
SELECT rental_id, staff_id, rental_period,
CUME_DIST() OVER (PARTITION BY staff_id ORDER BY rental_period) AS cume_dist
FROM rental;

-- FIRST_VALUE
SELECT inventory_id, film_id,
FIRST_VALUE(last_update) OVER (PARTITION BY film_id ORDER BY last_update) AS first_update
FROM inventory;

-- LAST_VALUE
SELECT city_id, city,
LAST_VALUE(last_update) OVER (PARTITION BY city_id ORDER BY last_update RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_update
FROM city;

-- LAG, LEAD
SELECT rental_id, rental_period,
LAG(rental_period) OVER (ORDER BY rental_id) AS prev_rental_period,
LEAD(rental_period) OVER (ORDER BY rental_id) AS next_rental_period
FROM rental;

-- NTH_VALUE
SELECT country_id, city_id, city,
NTH_VALUE(city, 3) OVER (PARTITION BY country_id ORDER BY city_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS third_city
FROM city;