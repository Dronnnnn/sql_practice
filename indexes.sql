CREATE INDEX idx_film_actor_film_id ON film_actor (film_id);
CREATE INDEX idx_rental_customer_rental_date ON rental (customer_id, rental_period);