--Second Normal Form 2NF

DROP TABLE Sales;
DROP TABLE orders;
DROP TABLE product;

--1.Identify which columns have partial dependencies and what they depend on.
--customer_name and product_name and unit_price

--2.Design a 2NF-compliant schema: customers, products, orders, order_items.
CREATE TABLE orders(
	id INTEGER PRIMARY KEY,
	customer_name TEXT
);

CREATE TABLE product(
	id INTEGER PRIMARY KEY,
	product_name TEXT,
	unit_price REAL
);

CREATE TABLE Sales(
	order_id INTEGER,
	product_id INTEGER,
	qty INTEGER,
	PRIMARY KEY (order_id, product_id),
	FOREIGN KEY (order_id) REFERENCES orders(id),
	FOREIGN KEY (product_id) REFERENCES product(id)
	ON DELETE CASCADE
	);

--4.Insert the data from the original table into your 2NF schema.
INSERT INTO orders (id, customer_name)
VALUES
	(1001, 'Alice'),
	(1002, 'bob');

INSERT INTO product (id, product_name, unit_price)
VALUES
	(42, 'Keyboard', 49.99),
	(77, 'Mouse', 29.99);

INSERT INTO Sales (order_id, product_id, qty)
VALUES
	(1001, 42, 2),
	(1001, 77, 1),
	(1002, 42, 1);


--5.Write a query to reproduce the original table's data using JOINs.
SELECT
	s.*,
	o.*,
	p.product_name,
	p.unit_price
FROM Sales s
JOIN orders o ON order_id = o.id
JOIN product p on product_id = p.id;

--6.Bonus: rename "Keyboard" to "Mechanical Keyboard" — in the bad table vs the 2NF table.
-- How many rows changed in each?
UPDATE product
SET product_name = 'Mechanical Keyboard'
WHERE  product_name = 'Keyboard';

SELECT
	s.*,
	o.*,
	p.product_name,
	p.unit_price
FROM Sales s
JOIN orders o ON order_id = o.id

--in the old table we need to change 2 coulms and with the new table just one
JOIN product p on product_id = p.id;