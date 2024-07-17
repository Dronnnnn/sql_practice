-- AVG
SELECT c.name AS category_name,
f.title AS movie_name,
f.rental_duration,
AVG(f.rental_duration) OVER(PARTITION BY c.name) AS avg_rental_duration
FROM film_category fc
JOIN film f ON fc.film_id = f.film_id
JOIN category c ON fc.category_id = c.category_id
ORDER BY avg_rental_duration DESC, rental_duration DESC;

--MAX, MIN, SUM, COUNT, CUME_DIST, RANK, DENSE_RANK, NTILE, FIRST_VALUE, LAST_VALUE, NTH_VALUE, LAG, LEAD
WITH LengthStats AS (
    SELECT
        c.name,
        f.title,
        f.length,
        f.rental_rate,
        MAX(f.length) OVER (PARTITION BY c.name) AS max_length_in_category
    FROM film f
    JOIN film_category fc ON fc.film_id = f.film_id
    JOIN category c ON c.category_id = fc.category_id
)
SELECT *,
	MIN(rental_rate) FILTER(WHERE length = max_length_in_category)
		OVER (PARTITION BY name) AS min_price_for_max_length_in_category,
    SUM(rental_rate) OVER (PARTITION BY name) AS sum_price_in_category,
	COUNT(title) OVER (PARTITION BY name) AS num_filmes_in_category,
	RANK() OVER (PARTITION BY name ORDER BY rental_rate) AS rent_rank,
	DENSE_RANK() OVER (PARTITION BY name ORDER BY rental_rate) AS rent_dense_rank,
	CUME_DIST() OVER (PARTITION BY name ORDER BY rental_rate) AS cume_dist_rent,
	NTILE(4) OVER (PARTITION BY name ORDER BY rental_rate) AS ntile_rent,
	ROW_NUMBER() OVER (ORDER BY length DESC) AS length_row_number,
	FIRST_VALUE(length) OVER (PARTITION BY name ORDER BY length) AS first_value,
	LAST_VALUE(length) OVER (PARTITION BY name ORDER BY length DESC
							 RANGE BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING) AS last_value,
    NTH_VALUE(length, 3) OVER (PARTITION BY name ORDER BY length DESC
							   RANGE BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING) AS third_value,
	LAG(length) OVER (PARTITION BY name ORDER BY length) AS prev_length,
	LEAD(length) OVER (PARTITION BY name ORDER BY length) AS next_length
FROM LengthStats
ORDER BY name, rental_rate DESC;
