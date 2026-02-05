CREATE DATABASE db1;
USE db1;
CREATE DATABASE db2;
USE db2;
CREATE TABLE tb2 (
	id INT PRIMARY KEY,
	name VARCHAR(20)
);

----------------------------------------
-- List name of DB I am currently in
SELECT DB_NAME() AS current_database;

-- List all tables in current DB
SELECT name AS tables_in_database
FROM sys.tables;
----------------------------------------

CREATE TABLE tb4 (
	id INT PRIMARY KEY,
	name VARCHAR(20)
);


-- Comment
/*
DROP TABLE tb1, tb4;
*/
