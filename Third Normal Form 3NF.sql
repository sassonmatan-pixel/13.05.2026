--Third Normal Form 3NF

--1.Check: is this table in 1NF? Explain why.
-- no problem 1nf its save the ruls of 1NF

--2.Check: is this table in 2NF? Explain why (single-column PK).
-- no problem with 2NF rulse this table save for corect single-column PK

--3.Identify all transitive dependencies in the table.
-- publisher_id --> publisher_name --> publisher_city
-- author_id --> author_name

--4.Design a 3NF schema with tables: books, authors, publishers.
--5.Write CREATE TABLE statements for all three tables with proper PKs and FKs.
DROP TABLE books;
DROP TABLE publishers;
DROP TABLE authors;

CREATE TABLE publishers(
	id TEXT PRIMARY KEY,
	publisher_name TEXT NOT NULL,
	publisher_city TEXT
);

CREATE TABLE authors(
	id TEXT PRIMARY KEY,
	author_name TEXT
);

CREATE TABLE books(
	isbn TEXT PRIMARY KEY,
	title TEXT,
	author_id TEXT,
	publisher_id TEXT,
	FOREIGN KEY (publisher_id) REFERENCES publishers(id),
	FOREIGN KEY (author_id) REFERENCES authors(id)
	ON DELETE CASCADE
);

--6.Insert the original data into the normalized tables.
INSERT INTO publishers(id, publisher_name, publisher_city)
VALUES
	('P1', 'TechPress', 'New York'),
	('P2', 'DataBooks', 'Paris');

INSERT INTO authors(id, author_name)
VALUES
	('A1', 'Jane Doe'),
	('A2', 'John Smith');

INSERT INTO books(isbn, title, author_id, publisher_id)
VALUES
	('978-1', 'SQL Mastery', 'A1', 'P1'),
	('978-2', 'Python Pro', 'A2', 'P1'),
	('978-3', 'Data Viz', 'A1', 'P2');

--7.Write a query to reproduce all original columns using JOINs.
SELECT
	b.isbn,
	b.title,
	a.*,
	p.*
FROM books b
JOIN publishers p ON b.publisher_id = p.id
JOIN authors a ON b.author_id = a.id;

--8.Bonus: Change Jane Doe's name to "Jane Doe-Smith" — how many rows change in the 3NF vs original schema?
UPDATE authors
SET author_name = 'Jane Doe-Smith'
WHERE author_name = 'Jane Doe';

2 change 3nf
1 change original
