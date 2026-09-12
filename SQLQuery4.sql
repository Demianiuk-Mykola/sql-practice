USE MyDatabase;

SELECT *
  FROM dbo.customers

SELECT TOP 2 first_name
FROM dbo.customers

SELECT c.country, count(1) AS "Total count"
  FROM dbo.customers C
 GROUP BY c.country

SELECT c.country, AVG(c.score)
  FROM dbo.customers C
 GROUP BY c.country


SELECT *
  FROM dbo.customers

SELECT c.country, '-|||-' AS '-|||-',AVG(score) AS avg_score
  FROM customers c
 WHERE c.score != 0
 GROUP BY c.country
HAVING AVG(score) > 430

--//////////////////////////////

CREATE TABLE persons (
	id INT NOT NULL,
	person_name VARCHAR(20) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL
	CONSTRAINT pk_persons PRIMARY KEY (id)
);

SELECT  * FROM dbo.persons;