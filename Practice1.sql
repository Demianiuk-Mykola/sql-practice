
DROP TABLE IF EXISTS dbo.Employees;
CREATE TABLE dbo.Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireYear INT
);
INSERT INTO Employees (EmployeeID, FirstName, Department, Salary, HireYear)
VALUES
(1, 'Alice', 'IT', 85000, 2021),
(2, 'Bob', 'HR', 60000, 2019),
(3, 'Charlie', 'IT', 95000, 2020),
(4, 'Diana', 'Finance', 105000, 2018),
(5, 'Evan', 'HR', 58000, 2022),
(6, 'Fiona', 'IT', 72000, 2023),
(7, 'George', 'Finance', 98000, 2020);


SELECT * FROM dbo.Employees

SELECT *
FROM dbo.Employees
WHERE Department = 'IT'
ORDER BY Salary DESC

SELECT DISTINCT Department
FROM dbo.Employees

SELECT AVG(Salary) as 'average salary'
FROM dbo.Employees

SELECT SUM(Salary) as 'total salary'
FROM dbo.Employees

SELECT 
    Department,
    AVG(Salary) AS 'average salary'
FROM dbo.Employees
GROUP BY Department

SELECT 
    Department,
    AVG(Salary) AS 'average salary'
FROM dbo.Employees
GROUP BY Department
HAVING AVG(Salary) > 80000

SELECT FirstName, Salary
FROM dbo.Employees
ORDER BY Salary ASC


DROP TABLE IF EXISTS dbo.HighEarners;
GO

CREATE TABLE dbo.HighEarners (
    EmployeeID INT,
    FirstName VARCHAR(50),
    Salary DECIMAL(10,2)
);

SELECT * FROM dbo.HighEarners

INSERT INTO dbo.HighEarners (EmployeeID, FirstName, Salary)
    SELECT 
        EmployeeID, 
        FirstName, 
        Salary 
    FROM dbo.Employees
    WHERE Salary > 90000