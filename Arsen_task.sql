USE MyDatabase

DROP TABLE IF EXISTS dbo.Keys;
GO

CREATE TABLE dbo.Keys (
    KeyVal CHAR (1) PRIMARY KEY NOT NULL,
    KeyCount INT
);

INSERT INTO dbo.Keys (KeyVal, KeyCount)
VALUES
('A', 30),
('B', 17),
('C', 13),
('D', 5);
--AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

DROP TABLE IF EXISTS dbo.KeyDetails;
GO

CREATE TABLE dbo.KeyDetails (
    KeyVal CHAR (1) NOT NULL,
    KeyD VARCHAR (2) NOT NULL
);

INSERT INTO dbo.KeyDetails(KeyVal, KeyD)
VALUES
('A', '1a'),
('A', '2a'),
('A', '3a'),
('A', '4a'),
('B', '1b'),
('B', '2b'),
('C', '1c'),
('C', '2c'),
('C', '3c'),
('D', '1d'),
('D', '2d'),
('D', '3d'),
('D', '4d'),
('D', '5d'),
('D', '6d');

--AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

SELECT *
  FROM dbo.Keys
SELECT *
  FROM dbo.KeyDetails
--aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
SELECT KeyDetails.KeyVal, KeyDetails.KeyD, Keys.KeyCount
  FROM dbo.Keys
 INNER JOIN dbo.KeyDetails ON Keys.KeyVal = KeyDetails.KeyVal

--aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

SELECT KeyDetails.KeyVal, KeyDetails.KeyD, COUNT(Keys.KeyCount) 
  FROM dbo.Keys
 INNER JOIN dbo.KeyDetails ON Keys.KeyVal = KeyDetails.KeyVal
 GROUP BY KeyDetails.KeyD, KeyDetails.KeyVal


SELECT KeyDetails.KeyVal, COUNT(KeyDetails.KeyVal)
  FROM KeyDetails
 GROUP BY KeyDetails.KeyVal