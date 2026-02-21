USE MyDatabase

DROP TABLE IF EXISTS dbo.parts;
CREATE TABLE dbo.parts (
	part_id INT PRIMARY KEY NOT NULL IDENTITY(1,1), 
	part_name VARCHAR(20),
	part_model VARCHAR(20),
	part_price INT
	);

INSERT INTO dbo.parts VALUES ('wheel','m345',345),('door','d657',300),('windshield','w987',400),('seat','s8467',256),('radio','r9348',140);



DROP TABLE IF EXISTS dbo.cars
CREATE TABLE dbo.cars (
	car_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	car_brand VARCHAR(20),
	car_model VARCHAR(20),
	part_id INT
	);

INSERT INTO dbo.cars VALUES 
  ('Nissan','Altima','4')
, ('Nissan','Altima','1')
, ('Nissan','Altima','5')
, ('Nissan','Altima','3')
, ('Porche','Panamera','1')
, ('Porche','Panamera','5')
, ('Porche','Panamera','5')
, ('Porche','Panamera','2')
, ('Audi','A6','1')
, ('Audi','A8','2')
, ('Audi','A8','3');

SELECT * FROM dbo.cars
SELECT * FROM dbo.parts

SELECT C.car_brand, max_part_price = max(P.part_price) 
FROM dbo.cars C
JOIN dbo.parts P ON C.part_id = P.part_id
GROUP BY car_brand