-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT 
    COUNT(*) AS number_of_copies 
FROM 
    inventory 
WHERE 
    film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

-- List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT 
    title, 
    length 
FROM 
    film 
WHERE 
    length > (SELECT AVG(length) FROM film);

-- Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT 
    a.first_name, 
    a.last_name 
FROM 
    actor a 
WHERE 
    a.actor_id IN (
        SELECT fa.actor_id 
        FROM film_actor fa 
        JOIN film f ON fa.film_id = f.film_id 
        WHERE f.title = 'Alone Trip'
    );

-- Identify all movies categorized as family films.
SELECT 
    f.title 
FROM 
    film f 
JOIN 
    film_category fc ON f.film_id = fc.film_id 
JOIN 
    category c ON fc.category_id = c.category_id 
WHERE 
    c.name = 'Family';

-- Retrieve the name and email of customers from Canada using both subqueries and joins.
-- Using subqueries
SELECT 
    first_name, 
    last_name, 
    email 
FROM 
    customer 
WHERE 
    address_id IN (
        SELECT address_id 
        FROM address 
        WHERE city_id IN (
            SELECT city_id 
            FROM city 
            WHERE country_id = (SELECT country_id FROM country WHERE country = 'Canada')
        )
    );

-- Using joins
SELECT 
    c.first_name, 
    c.last_name, 
    c.email 
FROM 
    customer c 
JOIN 
    address a ON c.address_id = a.address_id 
JOIN 
    city ci ON a.city_id = ci.city_id 
JOIN 
    country co ON ci.country_id = co.country_id 
WHERE 
    co.country = 'Canada';

-- Determine which films were starred by the most prolific actor in the Sakila database.
SELECT 
    f.title 
FROM 
    film f 
JOIN 
    film_actor fa ON f.film_id = fa.film_id 
WHERE 
    fa.actor_id = (
        SELECT actor_id 
        FROM film_actor 
        GROUP BY actor_id 
        ORDER BY COUNT(film_id) DESC 
        LIMIT 1
    );

-- Find the films rented by the most profitable customer in the Sakila database.
SELECT 
    f.title 
FROM 
    rental r 
JOIN 
    inventory i ON r.inventory_id = i.inventory_id 
JOIN 
    film f ON i.film_id = f.film_id 
WHERE 
    r.customer_id = (
        SELECT customer_id 
        FROM payment 
        GROUP BY customer_id 
        ORDER BY SUM(amount) DESC 
        LIMIT 1
    );

-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT 
    customer_id, 
    total_amount_spent 
FROM (
    SELECT 
        customer_id, 
        SUM(amount) AS total_amount_spent 
    FROM 
        payment 
    GROUP BY 
        customer_id
) AS customer_totals 
WHERE 
    total_amount_spent > (SELECT AVG(total_amount_spent) FROM (
        SELECT 
            SUM(amount) AS total_amount_spent 
        FROM 
            payment 
        GROUP BY 
            customer_id
    ) AS avg_totals);

