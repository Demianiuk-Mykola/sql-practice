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

UPDATE dbo.persons SET person_name = 'George'WHERE id = 3;

UPDATE A 
   SET person_name = 'George'  -- SELECT person_name
  from dbo.persons A
--JOIN dbo.customers C on a.id = c.id      -- in this format, very easy to add joins
 WHERE id = 3;

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

DECLARE @a1 VARCHAR(20) = 0, @a2 VARCHAR (20);    Set @a1 = 'aaa'; Set @a2= 'bbb'  -- it is the same
                                              Select @a1 = 'aaa', @a2= 'bbb'   --  as here
DECLARE @b int = NULL;
--Variables, Objects, Values, Refernce
CREATE TABLE #aaa (rid INT, rname VARCHAR(20));

-- in @a_0 we see real value (directly in memory), in @a_null we see refernce to memory where variable value will be assigned.
DECLARE @a_0 VARCHAR(20) = 0, @a_null VARCHAR (20); 
PRINT @a_0; PRINT ISNULL ( @a_null, 'my variable is NULL now');

SET @a_null = 'aaa';
PRINT 'What is value of my variable: ' + ISNULL ( @a_null, 'my variable is NULL now');

DECLARE @aaa TABLE (rId INT, rName VARCHAR(20));
SELECT * FROM @aaa;
DECLARE @rId int, @rName VARCHAR (20);    

SELECT @rId = rId, @rName = rName FROM @aaa;
PRINT ISNULL ( @rId, 'my variable is NULL now');

DECLARE @rId int, @rName VARCHAR (20); 
DECLARE @aaa TABLE (rId INT, rName VARCHAR(20))
INSERT INTO @aaa SELECT 1,'first record';
INSERT INTO @aaa SELECT 2,'second record';
SELECT 'All Records', * FROM @aaa;
SELECT Top 1 @rId = rId, @rName = rName FROM @aaa order by rID Asc ;  SELECT '1st record assigned/print out', @rId, @rName
SELECT TOP 1 @rId = rId, @rName = rName FROM @aaa ORDER BY rId Desc;  SELECT '2nd record assigned/print out', @rId, @rName
SELECT @rId = rId, @rName = rName FROM @aaa;                          SELECT 'Iterate all/print out last', @rId, @rName
-------------------------------------------------------------------------------------------
-- Schema creation and deletion (schema can be deleted when no tables are in)
CREATE SCHEMA Nik;
CREATE TABLE Nik.aaa (rid INT, rname VARCHAR(20));
CREATE TABLE aaa (rid INT, rname VARCHAR(20));
DROP TABLE Nik.aaa
DROP SCHEMA Nik;

SELECT * FROM sys.schemas


SELECT * FROM dbo.persons WHERE birth_date IS NULL;

DELETE FROM dbo.persons
WHERE birth_date IS NULL

-- If I want to see all objects in my database (One object = one record), select records from "sys.all_objects".
-- .
SELECT * FROM sys.all_objects

SELECT COUNT(1) FROM sys.all_objects

SELECT [type],[type_desc], COUNT(1) 
  FROM sys.all_objects
 GROUP BY [type], [type_desc]

------------------------------------------------------------------------
SELECT (sqrt(101)-sqrt(99)), sqrt(101), sqrt(99)

SELECT *
  FROM dbo.customers c
 WHERE c.score BETWEEN 100 AND 500

SELECT * FROM customers

SELECT *
  FROM customers
 WHERE first_name LIKE '%N'

 SELECT *
  FROM customers
 WHERE first_name LIKE '_a__%'
--------------------------------------------------
SELECT * FROM dbo.customers;
SELECT * FROM dbo.orders;


SELECT c.first_name, c.country, SUM(o.sales)
  FROM dbo.customers C
 INNER JOIN dbo.orders O ON
 c.id = o.customer_id
 GROUP BY c.first_name, c.country
--INSERT INTO dbo.orders VALUES (1005, 2, '2021-09-01', 22)

--LEFT
SELECT c.first_name, c.country, o.order_id
  FROM dbo.customers C
 LEFT JOIN dbo.orders O ON
 c.id = o.customer_id

--RIGHT
SELECT o.order_id, c.first_name, c.country 
  FROM dbo.customers C
 RIGHT JOIN dbo.orders O ON
 c.id = o.customer_id

-- Baraa tasks
--Get all customers along with their orders,
--including orders without without matching customers (LJ)
SELECT * FROM dbo.customers;
SELECT * FROM dbo.orders;

SELECT c.first_name, o.order_id, o.sales
  FROM dbo.customers C
  FULL JOIN dbo.orders O ON o.customer_id = c.id
