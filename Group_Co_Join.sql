
  DROP TABLE IF EXISTS dbo.Keys;
GO
CREATE TABLE dbo.Keys ( KeyVal CHAR (1) PRIMARY KEY NOT NULL,  KeyCount INT);
INSERT INTO dbo.Keys (KeyVal, KeyCount)
VALUES ('A', 30), ('B', 17), ('C', 13), ('D', 5);
------------------------------------

  DROP TABLE IF EXISTS dbo.KeyDetails;
GO
CREATE TABLE dbo.KeyDetails (
    KeyVal CHAR (1) NOT NULL,
    KeyD VARCHAR (99) NULL
);
INSERT INTO dbo.KeyDetails(KeyVal, KeyD)
VALUES
('z', 'aaaa'),
('A', 'aa'), ('A', 'qq'), ('A', 'aa'), ('A', Null), --('A', 'ss'), -- ('A', 'zz'),
('B', 'aa'), ('B', 'dd'), ('B', 'ff'), ('B', Null),
('C', 'gg'), ('C', 'hh'), ('C', 'jj'),
('D', 'kk'), ('D', 'll'), ('D', 'mm'), ('D', 'rr'), ('D', 'rr'), ('D', 'pp');

-------------------------------------------
SELECT * FROM dbo.Keys K
SELECT KeyVal, KeyD, isnull(KeyD, '**Null**')  from dbo.KeyDetails order by KeyVal, KeyD
SELECT KeyVal, count (KeyD), count (1), DetailMin = min(KeyD) /*, DetailAvg = Avg(KeyD)*/, DetailMax = max(KeyD)FROM dbo.KeyDetails GROUP BY KeyVal
SELECT count (KeyD), count (distinct KeyD), count (distinct isnull(KeyD, '**Null**')), count (1), DetailMin = min(KeyD) /*, DetailAvg = Avg(KeyD)*/, DetailMax = max(KeyD) FROM dbo.KeyDetails 

    -- 1.
SELECT k.KeyVal, k.KeyCount, d.KeyD, iif( d.KeyD = c.Detail_1st, k.KeyCount, 0), '|||' = '|||', c.Detail_1st
  FROM dbo.Keys K
  Join (SELECT KeyVal, Detail_1st = min(KeyD) FROM dbo.KeyDetails GROUP BY KeyVal) C on k.KeyVal  = c.KeyVal
  join dbo.KeyDetails D on k.KeyVal  = d.KeyVal 

    -- 2.
SELECT k.KeyVal, k.KeyCount, d.KeyD, c.DetailCnt, AprDistribution = iif( d.KeyD = c.DetailMin,  k.KeyCount/c.DetailCnt + k.KeyCount % c.DetailCnt, k.KeyCount/c.DetailCnt)
     , '|||' = '|||', wholeInt = k.KeyCount/c.DetailCnt,  Remider = k.KeyCount % c.DetailCnt
  FROM dbo.Keys K
  Join (SELECT KeyVal, DetailCnt = count(1), DetailMin = min(KeyD) FROM dbo.KeyDetails GROUP BY KeyVal) C on k.KeyVal  = c.KeyVal
  join dbo.KeyDetails D on k.KeyVal  = d.KeyVal 


