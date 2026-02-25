-- Join / Group BY / aggregate functions /


USE MyDatabase

  DROP TABLE IF EXISTS dbo.Keys;
GO
CREATE TABLE dbo.Keys ( KeyVal CHAR (1) PRIMARY KEY NOT NULL,  KeyCount INT);

INSERT INTO dbo.Keys (KeyVal, KeyCount)
VALUES ('A', 30), ('B', 17), ('C', 13), ('D', 5);
------------------------------------

  DROP TABLE IF EXISTS dbo.KeyDetails;         -- SELECT * FROM dbo.KeyDetails  ORDER BY KeyVal
GO
CREATE TABLE dbo.KeyDetails (
    KeyVal CHAR (1) NOT NULL,
    KeyD VARCHAR (99) NULL
);                                             -- Truncate table dbo.KeyDetails
INSERT INTO dbo.KeyDetails(KeyVal, KeyD)
VALUES
('z', 'aaaa'),
 ('A', 'qq'), ('A', 'aa'), ('A', Null), ('A', 'zz'),/*('A', 'aa'),*/ --('A', 'ss'), -- ('A', 'zz'),
('B', 'aa'), ('B', 'dd'), ('B', 'ff'), ('B', Null),
('C', 'gg'), ('C', 'hh'), ('C', 'jj'),
('D', 'kk'), ('D', 'll'), ('D', 'mm'),  ('D', 'rr'), ('D', 'pp') , ('D', 'rr');

-------------------------------------------
/*  Explanation of Cartesian and Join difference: Join is a Cartesian Product where after 'ON' condition is True (Logical meaning)
  Table 1: 1 field A, B, C
  Table 2: 1 field 1, 2, 3
  Cartesian product: A1,A2,A3, B1,B2,B3, C1,C2,C3

  Table 1: 2 fields A: a, B: b, C: c
  Table 2: 1 field 1, 2, 3
  A, a, 1
  A, a, 2
  A, a, 3
  B, b, 1
  B, b, 2
  B, b, 3
  C, c, 1
  C, c, 2
  C, c, 3  -- Cartesian product will create 9 records, it does not matter how many fields in each table!!!


  Table 1: 2 fields A: Alex, B: Bob, C: Charlie
  Table 2: 2 fields A: 20,   B: 15,  C: 28
  Task: Print Name and Age for each person
  1. Build Cartesian Product:
  Table 1,  Table 2
  A, Alex,  A, 20      X
  A, Alex,  B, 15
  A, Alex,  C, 28

  B, Bob,   A, 20
  B, Bob,   B, 15      X
  B, Bob,   C, 28

  C, Charlie, A, 20
  C, Charlie, B, 15
  C, Charlie, C, 28    X

  2. Find records where first field from 1st Table = 1st field from 2nd table
    A, Alex,    A, 20      X
    B, Bob,     B, 15      X
    C, Charlie, C, 28      X


*/
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

SELECT * FROM #Calc

    -- 11. Building final report (query) easy to read and understand
    --     1st part: we build query for wholeInt > 0
    --     2nd part: adding logic to query for wholeInt = 0
SELECT d.KeyVal, c.KeyCount
     , Distr = case when wholeInt != 0 then iif(d.DetailID = 1, c.wholeInt + c.Remider, c.wholeInt)
                     else 9999 end
    -- , '|||'='|||', d.*, '|||'='|||', c.* -- for debugging and understanding purposes
  FROM #Details D
  JOIN #Calc C ON d.KeyVal = c.KeyVal