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

SELECT c.country, AVG(c.score)
  FROM dbo.customers C
 GROUP BY c.country

SELECT *
  FROM dbo.customers;

SELECT c.country, '-|||-' AS '-|||-',AVG(score) AS avg_score
  FROM customers c
 WHERE c.score != 0
 GROUP BY c.country
HAVING AVG(score) > 430

--//////////////////////////////#
DROP TABLE IF EXISTS dbo.persons;
CREATE TABLE persons (
	id INT NOT NULL,
	person_name VARCHAR(20) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL
	CONSTRAINT pk_persons PRIMARY KEY (id)
);

SELECT  * FROM dbo.persons;

ALTER TABLE dbo.persons
  ADD email VARCHAR(50) NOT NULL;

SELECT  * FROM dbo.persons;

ALTER TABLE dbo.persons
 DROP COLUMN phone;

-- 
INSERT INTO dbo.persons 
VALUES 
	  --(1, 'Jane', '2/7/1999', 23424152134)
	 (2, 'Alex', '7/22/1960', 20394850799)
	, (3, 'Helen', '1/8/1990', 20093478500)
	, (4, 'Desmond', '9/9/1989', 3475732134);

INSERT dbo.persons (id, person_name, phone)
VALUES (5, 'Ely', 03947509245);

--Insert output of SELECT into NEW table.
INSERT dbo.persons (id, person_name, phone)
SELECT c.id, c.first_name, 'unknown'
  FROM dbo.customers c;

UPDATE dbo.persons
   SET person_name = 'George'
 WHERE id = 3;

/*SELECT person_name
  FROM dbo.persons
 WHERE id = 3;*/

SELECT  * FROM dbo.persons;

 UPDATE dbo.persons
	SET birth_date = '2/4/2000', phone = 238047987
  WHERE id = 4;



ALTER TABLE dbo.persons
 ADD score INT

ALTER TABLE dbo.persons
 DROP COLUMN occupation


----------------------------------------------------
UPDATE dbo.persons
   SET score = 0
 WHERE score IS NULL

UPDATE dbo.persons
   SET score = NULL
 WHERE score = 0
----------------------------------------------------



SELECT * 
  FROM dbo.persons
