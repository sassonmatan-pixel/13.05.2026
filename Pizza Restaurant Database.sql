DROP TABLE IF EXISTS pizzas_toppings;
DROP TABLE IF EXISTS toppings;
DROP TABLE IF EXISTS pizzas_orders;
DROP TABLE IF EXISTS pizzas;
DROP TABLE IF EXISTS order_drinks;
DROP TABLE IF EXISTS drinks;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers(
	id INTEGER PRIMARY KEY,
	name TEXT NOT NULL
);

CREATE TABLE orders(
	id INTEGER PRIMARY KEY ,
	number_order INTEGER NOT NULL UNIQUE,
	id_customers INTEGER NOT NULL,
	FOREIGN KEY (id_customers) REFERENCES customers(id)
);

CREATE TABLE toppings(
	code_id TEXT PRIMARY KEY,
	topping TEXT NOT NULL,
	price REAL NOT NULL CHECK (price >= 0)
);

CREATE TABLE pizzas(
	code_id TEXT PRIMARY KEY,
	size TEXT NOT NULL,
	price REAL NOT NULL CHECK (price >= 0)
);

CREATE TABLE drinks(
	code_id TEXT PRIMARY KEY,
	drink_name TEXT NOT NULL,
	price REAL NOT NULL CHECK (price >= 0)
);

CREATE TABLE pizzas_toppings(
	topping_id TEXT NOT NULL,
	pizza_id TEXT NOT NULL,
	PRIMARY KEY (topping_id, pizza_id),
	FOREIGN KEY (topping_id) REFERENCES toppings(code_id),
	FOREIGN KEY (pizza_id) REFERENCES pizzas(code_id)
);

CREATE TABLE pizzas_orders(
	number_order INTEGER NOT NULL,
	pizza_id TEXT NOT NULL,
	PRIMARY KEY (number_order, pizza_id),
	FOREIGN KEY (number_order) REFERENCES orders(number_order),
	FOREIGN KEY (pizza_id) REFERENCES pizzas(code_id)
);

CREATE TABLE order_drinks(
	number_order INTEGER NOT NULL,
	drink_id TEXT NOT NULL,
	PRIMARY KEY (number_order, drink_id),
	FOREIGN KEY (number_order) REFERENCES orders(number_order),
	FOREIGN KEY (drink_id) REFERENCES drinks(code_id)
);

INSERT INTO toppings (code_id, topping, price) VALUES
('T1', 'Mushrooms', 5.0),
('T2', 'Onions', 4.0),
('T3', 'Olives', 4.5),
('T4', 'Extra Cheese', 6.0),
('T5', 'Pepperoni', 7.0),
('T6', 'None', 0);

INSERT INTO pizzas (code_id, size, price) VALUES
('P1', 'Small', 40.0),
('P2', 'Medium', 50.0),
('P3', 'Large', 60.0);

INSERT INTO drinks (code_id, drink_name, price) VALUES
('D1', 'Water', 8.0),
('D2', 'Cola', 10.0),
('D3', 'Fanta', 10.0),
('D4', 'Apple Juice', 11.0),
('D5', 'Paulaner', 15.0);

INSERT INTO customers (id, name) VALUES
(1, 'Matan'),
(2, 'Daniel'),
(3, 'Orpaz');

INSERT INTO orders (id, number_order, id_customers) VALUES
(1, 1001, 1),
(2, 1002, 2),
(3, 1003, 3),
(4, 1004, 1);

INSERT INTO pizzas_orders (number_order, pizza_id) VALUES
(1001, 'P3'),
(1002, 'P2'),
(1003, 'P1'),
(1004, 'P3');

INSERT INTO pizzas_toppings (topping_id, pizza_id) VALUES
('T1', 'P3'),
('T3', 'P3'),
('T5', 'P2');

INSERT INTO order_drinks (number_order, drink_id) VALUES
(1001, 'D2'),
(1001, 'D5'),
(1002, 'D1');


SELECT
    o.number_order AS Order_Number,
    c.name AS Customer_Name,
    p.size AS Pizza_Size,
    GROUP_CONCAT(DISTINCT t.topping) AS Toppings,
    GROUP_CONCAT(DISTINCT d.drink_name) AS Drinks,
    (
        COALESCE(p.price, 0) +
        COALESCE(SUM(DISTINCT t.price), 0) +
        COALESCE(SUM(DISTINCT d.price), 0)
    ) AS Total_Price
FROM orders o
JOIN customers c ON o.id_customers = c.id
LEFT JOIN pizzas_orders po ON o.number_order = po.number_order
LEFT JOIN pizzas p ON po.pizza_id = p.code_id
LEFT JOIN pizzas_toppings pt ON p.code_id = pt.pizza_id
LEFT JOIN toppings t ON pt.topping_id = t.code_id
LEFT JOIN order_drinks od ON o.number_order = od.number_order
LEFT JOIN drinks d ON od.drink_id = d.code_id
GROUP BY o.number_order, c.name, p.size, p.price;