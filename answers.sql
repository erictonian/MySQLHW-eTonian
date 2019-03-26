-- Using sakila db
USE sakila;

-- 1a
SELECT first_name, last_name FROM actor;

-- 1b
ALTER TABLE actor ADD actor_name VARCHAR(50);
UPDATE actor SET actor_name = CONCAT(first_name, ' ', last_name);

-- 2a

SELECT actor_id, first_name, last_name FROM actor 
WHERE first_name = 'JOE';

-- 2b
SELECT actor_name FROM actor 
WHERE last_name LIKE '%GEN%';

-- 2c
SELECT first_name, last_name FROM actor 
WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor ADD description BLOB;

-- 3b
ALTER TABLE actor DROP description;

-- 4a
SELECT last_name, COUNT(*) FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(*) FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1;

-- 4c
UPDATE actor SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d
UPDATE actor SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a
SHOW CREATE TABLE address;
-- pasted result from above query:
-- CREATE TABLE `address` (
--   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
--   `address` varchar(50) NOT NULL,
--   `address2` varchar(50) DEFAULT NULL,
--   `district` varchar(20) NOT NULL,
--   `city_id` smallint(5) unsigned NOT NULL,
--   `postal_code` varchar(10) DEFAULT NULL,
--   `phone` varchar(20) NOT NULL,
--   `location` geometry NOT NULL,
--   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   PRIMARY KEY (`address_id`),
--   KEY `idx_fk_city_id` (`city_id`),
--   SPATIAL KEY `idx_location` (`location`),
--   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
-- ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

-- 6a
SELECT s.first_name, s.last_name, a.address
FROM address AS a
INNER JOIN staff AS s
ON a.address_id = s.address_id;

-- 6b
SELECT concat(s.first_name, ' ', s.last_name) AS 'Employee', 
	SUM(p.amount) AS 'Total Sales'
FROM staff AS s
JOIN payment AS p
ON s.staff_id = p.staff_id
GROUP BY s.staff_id;

-- 6c
SELECT f.title AS 'Film Title', COUNT(fa.actor_id) AS 'Actor Count'
FROM film AS f
INNER JOIN film_actor as fa
ON f.film_id = fa.film_id
GROUP BY f.film_id;

-- 6d
SELECT f.title AS 'Film Title', COUNT(i.inventory_id) AS 'Inventory Count'
FROM film as f
INNER JOIN inventory AS i
ON f.film_id = i.film_id
GROUP BY f.film_id
HAVING f.title = 'HUNCHBACK IMPOSSIBLE';

-- 6e
SELECT c.first_name, c.last_name, SUM(p.amount) AS 'Total Spent'
FROM customer AS c
INNER JOIN payment AS p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- 7a
SELECT title
FROM film
WHERE language_id IN
(
	SELECT language_id
	FROM language
	WHERE name = 'English'
)
AND title LIKE 'Q%' OR title LIKE 'K%';

-- 7b
SELECT actor_name
FROM actor
WHERE actor_id IN 
(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
    (
		SELECT film_id
        FROM film
        WHERE title = 'ALONE TRIP'
	)
);

-- 7c
SELECT cu.first_name, cu.last_name, cu.email
FROM customer AS cu
INNER JOIN address AS a
ON cu.address_id = a.address_id
INNER JOIN city as ci
ON a.city_id = ci.city_id
INNER JOIN country as co
ON ci.country_id = co.country_id
WHERE country = 'CANADA';

-- 7d
SELECT title
FROM film
WHERE film_id IN
(
	SELECT film_id
    FROM film_category
    WHERE category_id IN
    (
		SELECT category_id
        FROM category
        WHERE name = 'Family'
	)
);

-- 7e
SELECT f.title, COUNT(i.film_id) as 'Film Count'
FROM film AS f
INNER JOIN inventory as i
ON f.film_id = i.film_id
INNER JOIN rental as r
ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY `Film Count` DESC;

-- 7f
SELECT store.store_id, SUM(payment.amount) as 'Total Earnings'
FROM store
INNER JOIN staff
ON store.store_id = staff.staff_id
INNER JOIN payment
ON staff.staff_id = payment.staff_id
GROUP BY store.store_id;

-- 7g
SELECT s.store_id, ci.city, co.country
FROM store as s
INNER JOIN address as a
ON s.address_id = a.address_id
INNER JOIN city as ci
ON a.city_id = ci.city_id
INNER JOIN country as co
ON ci.country_id = co.country_id;

-- 7h
SELECT c.name, SUM(p.amount) as 'Gross Revenue'
FROM category as c
INNER JOIN film_category as fc
ON c.category_id = fc.category_id
INNER JOIN inventory as i
ON fc.film_id = i.film_id
INNER JOIN rental as r
ON i.inventory_id = r.inventory_id
INNER JOIN payment as p
ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY `Gross Revenue` DESC
LIMIT 5;

-- 8a
CREATE VIEW top_five_genres AS
SELECT c.name, SUM(p.amount) as 'Gross Revenue'
FROM category as c
INNER JOIN film_category as fc
ON c.category_id = fc.category_id
INNER JOIN inventory as i
ON fc.film_id = i.film_id
INNER JOIN rental as r
ON i.inventory_id = r.inventory_id
INNER JOIN payment as p
ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY `Gross Revenue` DESC
LIMIT 5;

-- 8b
SELECT * FROM top_five_genres;

-- 8c
DROP VIEW top_five_genres;