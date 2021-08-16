/* Query 1 -How much stock is held hence how popular are different categories */
WITH film_and_cat AS (
	SELECT film.film_id as film_id, category.name as Film_Category
	fROM film
	JOIN film_category
	ON film.film_id = film_category.film_id
	JOIN category
	ON film_category.category_id = category.category_id
)

SELECT Film_Category, COUNT(inventory_id)
FROM inventory
JOIN film_and_cat
ON film_and_cat.film_id = inventory.film_id
GROUP BY Film_Category
ORDER  BY 2 DESC;




/* Query 2 - The Replacement cost per category */
SELECT round(avg(film.replacement_cost),2) as Average_Replacement_Cost, category.name as Film_Category
fROM film
JOIN film_category
ON film.film_id = film_category.film_id
JOIN category
ON film_category.category_id = category.category_id
GROUP BY 2
ORDER BY 1 DESC;



/* Query 3 - Cities with number of highest rentals */
WITH rentals_cities AS (
	SELECT rental.rental_id, address.city_id
	FROM rental
	JOIN customer
	ON rental.customer_id = customer.customer_id
	JOIN address
	ON customer.address_id = address.address_id
	)

SELECT city, COUNT(rental_id) 
FROM city
JOIN rentals_cities
ON city.city_id = rentals_cities.city_id
GROUP BY city
ORDER BY 2 DESC
LIMIT 10;




/* Query 4 - How long each Adam's film is rented for compared to previous */
WITH actors AS (
SELECT actor.first_name||' '||actor.last_name AS actor_name, film_actor.film_id 
FROM actor
JOIN film_actor
ON film_actor.actor_id = actor.actor_id
WHERE actor.first_name < 'Ae'
)

SELECT actors.actor_name, film.rental_duration,
ROUND(AVG(film.rental_duration) OVER (PARTITION  BY actors.actor_name),1) AS avg_rental_dur
FROM film
JOIN actors
ON film.film_id = actors.film_id;