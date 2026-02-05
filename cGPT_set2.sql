DROP TABLE IF EXISTS dbo.Training;
GO

CREATE TABLE dbo.Training (
    TrainingID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    TrainingType VARCHAR(50),
    Hours INT,
    CompletionYear INT
);

INSERT INTO dbo.Training (TrainingID, EmployeeName, Department, TrainingType, Hours, CompletionYear)
VALUES
(1, 'Alice', 'IT', 'Cybersecurity', 20, 2022),
(2, 'Bob', 'HR', 'Conflict Management', 15, 2021),
(3, 'Charlie', 'IT', 'Cloud Computing', 25, 2023),
(4, 'Diana', 'Finance', 'Accounting Basics', 10, 2022),
(5, 'Evan', 'HR', 'Leadership', 18, 2023),
(6, 'Fiona', 'IT', 'Cybersecurity', 22, 2022),
(7, 'George', 'Finance', 'Tax Updates', 12, 2023);

--Q1:
SELECT * FROM dbo.Training --##########################################################################################################

--Q2:
SELECT *
  FROM dbo.Training
 WHERE Department = 'IT'
 ORDER BY [Hours] DESC

 --Q3:
 SELECT DISTINCT TrainingType
   FROM dbo.Training

--Q4:
SELECT EmployeeName, AVG([Hours])
  FROM dbo.Training
 GROUP BY EmployeeName

SELECT SUM([Hours])
  FROM dbo.Training

--Q5:
SELECT Department, SUM([Hours]) AS 'Hours'
FROM dbo.Training
GROUP BY Department

--Q6:
SELECT Department, SUM([Hours]) AS 'Hours'
FROM dbo.Training
GROUP BY Department
HAVING SUM([Hours]) > 50

--Q7:
SELECT EmployeeName, [Hours]
FROM dbo.Training
ORDER BY [Hours] ASC

--Q8:
CREATE TABLE IntensiveTraining (
    EmployeeName VARCHAR(50),
    TrainingType VARCHAR(50),
    [Hours] INT
);

SELECT * FROM dbo.IntensiveTraining

BEGIN
    INSERT INTO dbo.IntensiveTraining
        SELECT EmployeeName, TrainingType, [Hours]
        FROM dbo.Training
        WHERE [Hours] > 20;
END