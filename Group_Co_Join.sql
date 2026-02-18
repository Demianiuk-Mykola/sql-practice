USE MyDatabase

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
-- Retrieving all records in Keys table.
SELECT * FROM dbo.Keys K
SELECT * FROM dbo.KeyDetails D

-- Creating a column where Null values in KeyD column are replaced with "Null" word
SELECT KeyVal, KeyD, isnull(KeyD, '**Null**')  from dbo.KeyDetails order by KeyVal, KeyD

-- Shows how 'count' behaves when Null values are present (count(1) includes all values, count(KeyD) includes only NON-Null values)
SELECT KeyVal, count (KeyD), count (1), DetailMin = min(KeyD) /*, DetailAvg = Avg(KeyD)*/, DetailMax = max(KeyD)FROM dbo.KeyDetails GROUP BY KeyVal

-- Here we retrieve count of distinct values in column KeyD, 
SELECT count (KeyD), count (distinct KeyD), count (distinct isnull(KeyD, '**Null**')), count (1), DetailMin = min(KeyD) /*, DetailAvg = Avg(KeyD)*/, DetailMax = max(KeyD) FROM dbo.KeyDetails 

    -- 1. iif(this = this,put this value,othervise this)
    -- Retrieves combination of 2 tables and one calculated retrieval (SELECT). We find minimal value KeyD for each Group and use it to assign correct KeyCount (Actual value or 0)
SELECT k.KeyVal, k.KeyCount, d.KeyD, iif( d.KeyD = c.Detail_1st, k.KeyCount, 0), '|||' = '|||', c.Detail_1st
  FROM dbo.Keys K
  Join (SELECT KeyVal, Detail_1st = min(KeyD) FROM dbo.KeyDetails GROUP BY KeyVal) C on k.KeyVal  = c.KeyVal
  join dbo.KeyDetails D on k.KeyVal  = d.KeyVal 

    -- 2. We need to evenly spread total value of KeyCount between all KeyDetails. Example: 5 key details and 30 KeyCount -> 30 /5 = 6 KeyCount per KeyDetail
    -- Select statement retrieves combination of 2 tables and one calculated retrieval (SELECT). We find minimaal value KeyD for each group and assign to it
    -- result of division KeyCount by count of values in each group of KeyVals + the reminder of division (if any). Otherwise assign to it only the result of division.
SELECT k.KeyVal, k.KeyCount, d.KeyD, c.DetailCnt, AprDistribution = iif( d.KeyD = c.DetailMin,  k.KeyCount/c.DetailCnt + k.KeyCount % c.DetailCnt, k.KeyCount/c.DetailCnt)
     , '|||' = '|||', wholeInt = k.KeyCount/c.DetailCnt,  Remider = k.KeyCount % c.DetailCnt
  FROM dbo.Keys K
  Join (SELECT KeyVal, DetailCnt = count(1), DetailMin = min(KeyD) FROM dbo.KeyDetails GROUP BY KeyVal) C on k.KeyVal  = c.KeyVal
  join dbo.KeyDetails D on k.KeyVal  = d.KeyVal 



  -- 3. This interpreatiton adds column which sorts and enumerates records according to the group based on KeyVal field.
  -- THis allows to specify precisely which record should be chosen for manipulation (in our case adding reminder to AprDistribution).
  -- !!! It will work even with records that are duplicated, because it is not based on aggregate function min(), max(), avg()...
  SELECT k.KeyVal, k.KeyCount, d.KeyD, c.DetailCnt 
     ,   Gr_RowNumber = ROW_NUMBER() OVER (PARTITION BY k.KeyVal ORDER BY k.KeyVal)
     ,   AprDistribution =  iif( (ROW_NUMBER() OVER (PARTITION BY k.KeyVal ORDER BY k.KeyVal) = 1),  k.KeyCount/c.DetailCnt + k.KeyCount % c.DetailCnt, k.KeyCount/c.DetailCnt)
     , '|||' = '|||', wholeInt = k.KeyCount/c.DetailCnt,  Remider = k.KeyCount % c.DetailCnt
  FROM dbo.Keys K
  Join (SELECT KeyVal, DetailCnt = count(1), DetailMin = min(KeyD) FROM dbo.KeyDetails GROUP BY KeyVal) C on k.KeyVal  = c.KeyVal
  join dbo.KeyDetails D on k.KeyVal  = d.KeyVal 

