
--####################################### Join / Group BY / aggregate functions /

USE MyDatabase
------------------------------------
  DROP TABLE IF EXISTS dbo.Keys;
GO
CREATE TABLE dbo.Keys (KeyVal CHAR (1) PRIMARY KEY NOT NULL, KeyCount INT);

INSERT INTO dbo.Keys (KeyVal, KeyCount)
VALUES ('A', 30), ('B', 17), ('C', 13), ('D', 5);
------------------------------------
  DROP TABLE IF EXISTS dbo.KeyDetails;         -- SELECT * FROM dbo.KeyDetails  ORDER BY KeyVal
GO
CREATE TABLE dbo.KeyDetails (
    KeyVal CHAR (1) NOT NULL,
    KeyD VARCHAR (99) NULL
);
-- Truncate table dbo.KeyDetails
GO
INSERT INTO dbo.KeyDetails(KeyVal, KeyD)
VALUES
('z', 'aaaa'),
 ('A', 'qq'), ('A', 'aa'), ('A', Null), ('A', 'zz'),/*('A', 'aa'),*/ --('A', 'ss'), -- ('A', 'zz'),
('B', 'aa'), ('B', 'dd'), ('B', 'ff'), ('B', Null),
('C', 'gg'), ('C', 'hh'), ('C', 'jj'),
('D', 'kk'), ('D', 'll'), ('D', 'mm'),  ('D', 'rr'), ('D', 'pp') , ('D', 'rr');
GO
------------------------------------




SELECT * FROM dbo.Keys K       -- 1. Retrieving all records from Keys         (Logical meaning: any type of loops in languages like python, java, c++)
SELECT * FROM dbo.KeyDetails D -- 2. Retrieving all records from KeyDetails
-- 
SELECT KeyVal, KeyD, isnull(KeyD, '**Null**')  from dbo.KeyDetails order by KeyVal, KeyD  -- 3. Use isnull() to convert "Null" into real value for aggregate functions

-- 4. Shows how 'count' behaves when Null values are present (count(1) includes all values, count(KeyD) includes only NON-Null values)
SELECT KeyVal, count (KeyD), count (1), DetailMin = min(KeyD) /*, DetailAvg = Avg(KeyD)*/, DetailMax = max(KeyD)FROM dbo.KeyDetails GROUP BY KeyVal

-- 5. Here we retrieve count of distinct values in column KeyD, 
SELECT count (distinct 1), count (KeyD), count (distinct KeyD), count (distinct isnull(KeyD, '**Null**')), count (1), DetailMin = min(KeyD) /*, DetailAvg = Avg(KeyD)*/, DetailMax = max(KeyD) FROM dbo.KeyDetails 

-- 6. Task #1: Create query to assign value to the 1 record, rest make 0's
--    How: Create join between 2 tables and one result set "Group By". SELECT treats tables and result sets equally! If not sure - try it.
--    Assign KeyCount to only one record coming from "Group By" result set
SELECT k.KeyVal, k.KeyCount, d.KeyD, iif( d.KeyD = c.Detail_1st, k.KeyCount, 0), '|||' = '|||', c.Detail_1st
  FROM dbo.Keys K
  join dbo.KeyDetails D on k.KeyVal  = d.KeyVal 
  Join (SELECT KeyVal, Detail_1st = min(KeyD) FROM dbo.KeyDetails GROUP BY KeyVal) C on k.KeyVal  = c.KeyVal



-- 7. Task #2: Create query to evenly spread total value of KeyCount between all KeyDetails.
--    Idea: Example: KeyVal = 'A' has count of 30 and 4 KeyD (SELECT * FROM dbo.KeyDetails WHERE KeyVal = 'A')
--                   30/4 has a remainder, if we add this remainder to 1 record our count will be correct.               
SELECT k.KeyVal, k.KeyCount, d.KeyD, c.DetailCnt, AprDistribution = iif( d.KeyD = c.DetailMin,  k.KeyCount/c.DetailCnt + k.KeyCount % c.DetailCnt, k.KeyCount/c.DetailCnt)
     , '|||' = '|||', wholeInt = k.KeyCount/c.DetailCnt,  Remider = k.KeyCount % c.DetailCnt
  FROM dbo.Keys K
  Join (SELECT KeyVal, DetailCnt = count(1), DetailMin = min(KeyD) FROM dbo.KeyDetails GROUP BY KeyVal) C on k.KeyVal  = c.KeyVal
  join dbo.KeyDetails D on k.KeyVal  = d.KeyVal
 ORDER BY k.KeyVal, d.KeyD


    -- 8. Task #3: Create query to evenly spread total value of KeyCount between all KeyDetails regardless of duplicates
    -- Adding duplicates (we have to add 3 records bacuse 30 is divided without reminder by 5 and by 6)
INSERT INTO dbo.KeyDetails SELECT 'A', 'aa'
INSERT INTO dbo.KeyDetails SELECT 'A', 'aa'
INSERT INTO dbo.KeyDetails SELECT 'A', 'aa'

    -- 9. Create unique number for each record inside group (partition) KeyVal
  DROP TABLE IF EXISTS #Details;   -- Select * From #Details
SELECT d.KeyVal, d.KeyD, DetailID = ROW_NUMBER() OVER (PARTITION BY d.KeyVal ORDER BY d.KeyVal)
  INTO #Details
  FROM dbo.KeyDetails D
 ORDER BY d.KeyVal, d.KeyD
   
    -- 10. By joining Keys and KeyDetails and grouping by KeyVal we can easy "calculate" wholeInt and Reminder 
  DROP TABLE IF EXISTS #Calc;   -- Select * From #Calc
SELECT d.KeyVal, DetailCnt = count(1), k.KeyCount, wholeInt = k.KeyCount/count(1), Remider = k.KeyCount % count(1)
  INTO #Calc
  FROM dbo.KeyDetails D
  JOIN dbo.Keys K ON d.KeyVal = k.KeyVal
 GROUP BY d.KeyVal, k.KeyCount 

SELECT * FROM #Calc   -- SELECT * FROM KeyDetails ORDER BY KeyVal

    -- 11. Building final report (query) easy to read and understand
    --     1st part: we build query for wholeInt > 0
    --     2nd part: adding logic to query for wholeInt = 0
SELECT d.KeyVal, c.KeyCount
     , Distr = case when wholeInt != 0 then iif(d.DetailID = 1, c.wholeInt + c.Remider, c.wholeInt)
                     else iif(d.DetailID <= c.Remider,1,0 ) end
    -- , '|||'='|||', d.*, '|||'='|||', c.* -- for debugging and understanding purposes
  FROM #Details D
  JOIN #Calc C ON d.KeyVal = c.KeyVal
--######################################################### - If records have no representation in both tables
USE MyDatabase

SELECT * FROM dbo.Keys K       -- 1. Retrieving all records from Keys         (Logical meaning: any type of loops in languages like python, java, c++)
-- SELECT * FROM #TempKeys
SELECT * FROM dbo.KeyDetails D -- 2. Retrieving all records from KeyDetails


SELECT *
INTO #TempKeyD   
FROM dbo.KeyDetails

INSERT INTO #TempKeyD SELECT 'L','l1';
INSERT INTO #TempKeyD SELECT 'L','l2';
INSERT INTO #TempKeyD SELECT 'L','l3';
INSERT INTO #TempKeyD SELECT 'M','m1';
INSERT INTO #TempKeyD SELECT 'M','m2';
INSERT INTO #TempKeyD SELECT 'M','m3';

-- SELECT * FROM #TempKeys
-- SELECT * FROM #TempKeyD ORDER BY KeyVal

SELECT *
FROM #TempKeys T
FULL JOIN #TempKeyD D ON t.KeyVal = d.KeyVal;
--######################################################### -- Find list of keyV values that have no representation in Detail table,
                                                            -- Count them, calc avr, min, max

USE MyDatabase

-- SELECT * FROM dbo.Keys K       -- 1. Retrieving all records from Keys         (Logical meaning: any type of loops in languages like python, java, c++)
-- SELECT * FROM #TempKeys
-- SELECT * FROM dbo.KeyDetails D -- 2. Retrieving all records from KeyDetails

DROP TABLE if EXISTS #TempKeys
SELECT *
INTO #TempKeys   
FROM dbo.Keys
GO

INSERT INTO #TempKeys SELECT 'E',21;
INSERT INTO #TempKeys SELECT 'F',24;
INSERT INTO #TempKeys SELECT 'G',3;
INSERT INTO #TempKeys SELECT 'H',8;
GO

DROP TABLE if EXISTS #TempKeyD
SELECT *
INTO #TempKeyD   
FROM dbo.KeyDetails

-- SELECT * FROM #TempKeys
-- SELECT * FROM #TempKeyD ORDER BY KeyVal

-- Show all tables and corresponding values Joined on 'KeyVal'
SELECT *
  FROM #TempKeys K
  LEFT JOIN #TempKeyD D ON k.KeyVal = d.KeyVal;

-- segregate records/calc counts(sum)/avr/min/max based on KeyVal that are present in KeysTable but has no representation in KeyDetails table.
  DROP table if exists #T;   -- select * from #T
SELECT SUM(k.KeyCount) AS sum_key_count, average_count = AVG(k.KeyCount), minimum = MIN(k.KeyCount), maximum = MAX(k.KeyCount)
  INTO #T
  FROM #TempKeys K
  LEFT JOIN #TempKeyD D ON k.KeyVal = d.KeyVal
 WHERE d.KeyVal Is NULL




-- SELECT * FROM #T;

-- Show list of KeyVal not represented in KeyDetails table
SELECT k.KeyVal,k.KeyCount, #T.sum_key_count, #T.average_count, #T.maximum, #T.minimum
FROM #TempKeys K
LEFT JOIN #TempKeyD D ON k.KeyVal = d.KeyVal
JOIN  #T ON 1=1
WHERE d.KeyVal Is NULL


  DROP table if exists #lst;   -- select * from #lst;             -- WITH JOIN !!!       Two ways (Left JOIN/not in) to get the same RS
SELECT k.KeyVal, k.KeyCount
  INTO #lst
  FROM #TempKeys K
  LEFT JOIN #TempKeyD D ON k.KeyVal = d.KeyVal                    -- WITH JOIN !!!
 WHERE d.KeyVal Is NULL                                           -- WITH JOIN !!!


select KeyVal, KeyCount, Total, avrKey, minKey, maxkey
  from #lst
  join (SELECT Total = SUM(KeyCount), avrKey = AVG(KeyCount), minKey = MIN(KeyCount), maxkey = MAX(KeyCount) from #lst ) T
    on 1 = 1


  DROP table if exists #lst;   -- select * from #lst;             -- NO JOIN (USED "IN") !!!
SELECT k.KeyVal, k.KeyCount
  INTO #lst
  FROM #TempKeys K
 WHERE K.KeyVal NOT IN (SELECT DISTINCT KeyVal FROM #TempKeyD)  --  NO JOIN (USED "IN") !!! 

-- Attempt to combine results from table KeyValues and KeyDetails WITHOUT JOIN, but by using variables
DECLARE @SUM INT;
    SET @SUM = (SELECT SUM(KeyCount) from #lst);
DECLARE @AVG INT; 
    SET @AVG = (SELECT AVG(KeyCount) from #lst); 
DECLARE @MIN INT;
    SET @MIN = (SELECT MIN(KeyCount) from #lst);
DECLARE @MAX INT;
    SET @MAX = (SELECT MAX(KeyCount) from #lst);

 select KeyVal, KeyCount, Total = @SUM, avrKey = @AVG, minKey = @MIN, maxkey = @MAX
   from #lst




-- one line is produced by inner select
-- this method used in many other languages

 

