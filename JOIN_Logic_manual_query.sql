			 /*  Explanation of Cartesian and Join difference: Join is a Cartesian Product where after 'ON' condition is True (Logical meaning)
  Table 1: 1 field: A, B, C
  Table 2: 1 field: 1, 2, 3
  Cartesian product: A1,A2,A3, B1,B2,B3, C1,C2,C3
 --------------------------------------------------
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

 --------------------------------------------------
 --BUILD LEFT JOIN MANUALY
  Table 1: 1 field: A, B, C, D
  Table 2: 1 field: 1, 2, 3
  Cartesian PRoduct; A1,A2,A3,B1,B2,B3,C1,C2,C3,D1,D2,D3;

  Table 1: 2 fields A: Alex, B: Bob, C: Charlie, D: David
  Table 2: 2 fields A: 20,   B: 15,  C: 28
  Cartesian Product: 
  Table 1,  Table 2
  A, Alex,  A, 20  x    
  A, Alex,  B, 15
  A, Alex,  C, 28

  B, Bob,   A, 20
  B, Bob,   B, 15   x   
  B, Bob,   C, 28

  C, Charlie, A, 20
  C, Charlie, B, 15
  C, Charlie, C, 28    x
  
  D, David,  Nothing   -- adding to result set by LEFT JOIN definition
  D, David,  A: 20
  D, David,  B: 15
  D, David,  C: 28
  Building LEFT JOIN manualy -> 'ON' Table1.Field1 = Table2.Field1
*/

DROP TABLE IF EXISTS #x1; CREATE TABLE #x1 (t_Id int,);
DROP TABLE IF EXISTS #y2; CREATE TABLE #y2 (t_Id INT);
INSERT INTO #x1 VALUES (Null),( 1), (2) 
INSERT INTO #y2 VALUES (20),(15), (28);
SELECT x.*,'|||', y.* FROM #x1 x LEFT JOIN #y2 y ON 1 = 1 ORDER BY x.t_Id, y.t_Id;

DROP TABLE IF EXISTS #t1; CREATE TABLE #t1 (t_Id VARCHAR(2), t_Name VARCHAR(20));
DROP TABLE IF EXISTS #t2; CREATE TABLE #t2 (t_Id VARCHAR(2), t_Age INT);
INSERT INTO #t1 VALUES ('A', 'Alex'),( 'B', 'Bob'), ('C', 'Charlie'), ('D', 'David');
INSERT INTO #t2 VALUES ('A', 20),( 'B', 15), ('C', 28);
GO


SELECT x.*,'|||', y.* FROM #t1 x LEFT JOIN #t2 y ON 1 = 1 ORDER BY x.t_Id, y.t_Id;
SELECT x.*,'|||', y.* FROM #t1 x LEFT JOIN #t2 y ON x.t_Id = y.t_Id where y.t_Id IS NULL ORDER BY x.t_Id, y.t_Id;
