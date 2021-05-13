-- JOINS --
-- 1 
SELECT * 
FROM invoice AS i
JOIN invoice_line AS il ON i.invoice_id = il.invoice_id
WHERE il.unit_price > 0.99;

-- 2
SELECT i.invoice_date, c.first_name, c.last_name, i.total
FROM invoice AS i
JOIN customer AS c
ON i.customer_id = c.customer_id;

-- 3
SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer AS c
JOIN employee AS e
ON c.support_rep_id = e.employee_id;

-- 4
SELECT al.title, ar.name
FROM album AS al
JOIN artist AS ar
ON al.artist_id = ar.artist_id;

-- 5
SELECT pt.track_id
FROM playlist_track AS pt
JOIN playlist AS pl ON pt.playlist_id = pl.playlist_id
WHERE pl.name = 'Music';

-- 6
SELECT t.name
FROM track AS t
JOIN playlist_track AS pt ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;

-- 7
SELECT t.name, p.name
FROM track AS t
JOIN playlist_track AS pt ON t.track_id = pt.track_id
JOIN playlist AS p ON p.playlist_id = pt.playlist_id;

-- 8
SELECT t.name, a.title
FROM track AS t
JOIN album AS a ON t.album_id = a.album_id
JOIN genre AS g on t.genre_id = g.genre_id
WHERE g.name = 'Alternative & Punk';

-- JOINS Black Diamond
SELECT t.name, g.name, a.title, ar.name
FROM track AS t
JOIN genre AS g ON t.genre_id = g.genre_id
JOIN album AS a ON t.album_id = a.album_id
JOIN artist AS ar ON a.artist_id = ar.artist_id
JOIN playlist_track AS pt ON t.track_id = pt.track_id
JOIN playlist AS pl ON pt.playlist_id = pl.playlist_id
WHERE pl.name = 'Music';

-- NESTED QUERIES
-- 1
SELECT *
FROM invoice AS i
WHERE i.invoice_id 
IN (
  SELECT il.invoice_id
  FROM invoice_line AS il
  WHERE il.unit_price > 0.99
);

-- 2
SELECT *
FROM playlist_track as pt
WHERE pt.playlist_id
IN (
  SELECT pl.playlist_id
  FROM playlist AS pl
  WHERE pl.name = 'Music'
);

-- 3
SELECT t.name
FROM track AS t
WHERE t.track_id
IN (
	SELECT pt.track_id
  FROM playlist_track AS pt
  WHERE pt.playlist_id = 5
);

-- 4
SELECT * 
FROM track AS t
WHERE t.genre_id 
IN (
	SELECT g.genre_id
  FROM genre AS g
  WHERE g.name = 'Comedy'
);

-- 5
SELECT * 
FROM track AS t
WHERE t.album_id
IN (
	SELECT a.album_id
  FROM album AS a
  WHERE a.title = 'Fireball'
);

-- 6
SELECT * 
FROM track as t
WHERE t.album_id
IN (
	SELECT a.album_id
  FROM album AS a
  WHERE a.artist_id
  IN (
  	SELECT ar.artist_id
    FROM artist AS ar
    WHERE ar.name = 'Queen'
  )
);

-- UPDATING ROWS
-- 1
UPDATE customer
SET fax = null
WHERE fax IS NOT null;

-- 2
UPDATE customer
SET company = 'Self'
WHERE company IS null;

--3
UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

-- 4
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';

-- 5
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id 
IN (
	SELECT genre_id
  FROM genre
  WHERE name = 'Metal'
) AND composer IS null;

-- GROUP BY
-- 1
SELECT COUNT(*), g.name
FROM track AS t
JOIN genre AS g ON t.genre_id = g.genre_id
GROUP BY g.name;

-- 2
SELECT COUNT(*), g.name
FROM track AS t
JOIN genre AS g ON t.genre_id = g.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;

-- 3
SELECT ar.name, COUNT(*)
FROM artist AS ar
JOIN album AS al ON ar.artist_id = al.artist_id
GROUP BY ar.name;

-- USE DISTINCT
-- 1
SELECT DISTINCT composer
FROM track;

-- 2
SELECT DISTINCT billing_postal_code
FROM invoice;

-- 3
SELECT DISTINCT company
FROM customer;

-- DELETE ROWS
-- 1
DELETE FROM practice_delete
WHERE type = 'bronze';

-- 2
DELETE FROM practice_delete
WHERE type = 'silver';

-- 3
DELETE FROM practice_delete
WHERE value = 150;

-- eCommerce Simulation
-- SEED
CREATE TABLE users(
    users_id SERIAL PRIMARY KEY, 
    name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE products(
    products_id SERIAL PRIMARY KEY, 
    name VARCHAR(100),
    price INT
);

CREATE TABLE orders(
    orders_id SERIAL PRIMARY KEY,
    products_id INT REFERENCES products(products_id)
);

-- INSERT DATA
INSERT INTO users
(name, email)
VALUES
('Joe', 'joeschmo@email.com'),
('Molly', 'gollymizmolly@email.com'),
('Hogarth', 'irongiant1@email.com');

INSERT INTO products
(name, price)
VALUES
('Zelda Video Game', 60),
('Tesla', 75000),
('Nut Roll', 2);

INSERT INTO orders
(products_id)
VALUES
(1),
(2),
(3);

-- QUERIES
SELECT *
FROM products AS p
JOIN orders AS o ON p.products_id = o.products_id
WHERE o.orders_id = 1;

SELECT *
FROM orders

SELECT SUM(p.price)
FROM products AS p
JOIN orders AS o ON p.products_id = o.products_id
WHERE o.orders_id = 2

-- FOREIGN KEY

ALTER TABLE users
ADD COLUMN orders_id REFERENCES orders(orders_id);

UPDATE users
SET orders_id = 1
WHERE users_id = 1;

UPDATE users
SET orders_id = 2
WHERE users_id = 2;

UPDATE users
SET orders_id = 3
WHERE users_id = 3;

-- QUERIES
SELECT *
FROM orders AS o
JOIN users AS u ON o.orders_id = u.orders_id
WHERE u.users_id = 1;

SELECT COUNT(*)
FROM orders AS o
JOIN users AS u ON o.orders_id = u.orders_id
WHERE u.users_id = 1;

-- BLACK DIAMOND
SELECT SUM(p.price), u.name
FROM orders AS o
JOIN users AS u ON o.orders_id = u.orders_id
JOIN products AS p ON o.products_id = p.products_id
GROUP BY u.name;