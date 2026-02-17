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

Lbl_Ins:

INSERT INTO dbo.KeyDetails(KeyVal, KeyD)
VALUES
('A', 'aa'),
('A', 'ss'),
('A', 'zz'),
('A', 'qq'),
('B', 'dd'),
('B', 'ff'),
('C', 'gg'),
('C', 'hh'),
('C', 'jj'),
('D', 'kk'),
('D', 'll'),
('D', 'mm'),
('D', 'rr'),
('D', 'rr'),
('D', 'pp');

--AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
SELECT * FROM dbo.Keys K
SELECT KeyVal, DetailMin = min(KeyD) FROM dbo.KeyDetails GROUP BY KeyVal
SELECT * from dbo.KeyDetails

SELECT k.KeyVal, k.KeyCount, d.KeyD, iif( d.KeyD = c.DetailMin, k.KeyCount, 0), c.DetailMin
  FROM dbo.Keys K
  Join (SELECT KeyVal, DetailMin = min(KeyD) FROM dbo.KeyDetails GROUP BY KeyVal) C on k.KeyVal  = c.KeyVal
  join dbo.KeyDetails D on k.KeyVal  = d.KeyVal 

SELECT KeyVal, DetailCnt = count(1), min(KeyD) FROM dbo.KeyDetails GROUP BY KeyVal 


SELECT k.KeyVal, k.KeyCount, d.KeyD,c.DetailCnt, iif( d.KeyD = c.DetailMin,  k.KeyCount/c.DetailCnt + k.KeyCount % c.DetailCnt, k.KeyCount/c.DetailCnt)
     , fullInt = k.KeyCount/c.DetailCnt,  Remider = k.KeyCount % c.DetailCnt
  FROM dbo.Keys K
  Join (SELECT KeyVal, DetailCnt = count(1), DetailMin = min(KeyD) FROM dbo.KeyDetails GROUP BY KeyVal ) C on k.KeyVal  = c.KeyVal
  join dbo.KeyDetails D on k.KeyVal  = d.KeyVal 



SELECT *
  FROM dbo.KeyDetails

--aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
SELECT KeyDetails.KeyVal, KeyDetails.KeyD, Keys.KeyCount 
  FROM dbo.Keys
 INNER JOIN dbo.KeyDetails ON Keys.KeyVal = KeyDetails.KeyVal

--aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

SELECT KeyDetails.KeyVal, COUNT(KeyDetails.KeyVal)
  FROM KeyDetails
 GROUP BY KeyDetails.KeyVal