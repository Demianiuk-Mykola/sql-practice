SELECT first_name, country  
  FROM dbo.customers
 WHERE score > 500

SELECT first_name, id, score
From dbo.customers
WHERE country = 'Germany'

SELECT *
FROM dbo.customers

SELECT *
From dbo.customers
ORDER BY score DESC

SELECT COUNT(first_name) as 'amount of customers from', country as 'Country'
From dbo.customers
GROUP BY country

SELECT
	country,
	AVG(score) as average
FROM dbo.customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430

SELECT DISTINCT country
FROM dbo.customers

SELECT *
FROM dbo.orders
ORDER BY order_date DESC

SELECT DISTINCT TOP 5
	country,
	SUM(score)
  FROM dbo.customers
 WHERE country = 'Germany'
 GROUP BY country
HAVING SUM(score) > 400
 ORDER BY country


CREATE TABLE persons (
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR (15) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
)

SELECT * FROM persons
SELECT * FROM dbo.customers

INSERT INTO persons (id,person_name, birth_date,phone)
VALUES
	(1,'Jake', '1992-04-12', 2345433456),
	(2,'Alice', '1990-05-28', 30574829853)

DROP TABLE persons

INSERT INTO persons (id, person_name, birth_date, phone)
	SELECT
	id,
	first_name,
	NULL,
	'Unknown'
	FROM customers
