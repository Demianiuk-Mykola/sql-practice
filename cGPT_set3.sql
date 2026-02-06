
/*
Q1 — Show everything

Display all information about every project in the table.

Q2 — Filter and sort

Show only projects from the IT department, and sort so that the highest budget projects appear first.

Q3 — Unique departments

List all the different departments involved in projects without repeating any.

Q4 — Aggregates per employee

Find the average budget of projects per employee.

Find the total budget of all projects combined.

Q5 — Summary per department

Show the total budget for projects grouped by department.

Q6 — Conditional summary

From the summary in Q5, show only departments where the total budget exceeds 60,000.

Q7 — Sorted employee budgets

Show each employee’s name and the budget of their projects, sorted so that the smallest budgets come first.

Q8 — Move high-budget projects to a new table

Create a new table HighBudgetProjects (columns: EmployeeName, ProjectName, Budget).
Then copy only the projects where the budget is greater than 30,000 into it.

Q9 — Extra challenge — combined conditions

Show IT projects completed in 2022 with a budget above 40,000, sorted so the largest budget is first.

Q10 — Extra aggregation

Show average and total budget per completion year.


*/


go
USE MyDatabase
go

CREATE TABLE dbo.Projects (
    ProjectID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    ProjectName VARCHAR(50),
    Budget DECIMAL(10,2),
    CompletionYear INT
);

INSERT INTO dbo.Projects (ProjectID, EmployeeName, Department, ProjectName, Budget, CompletionYear)
VALUES
(1, 'Alice', 'IT', 'Cloud Migration', 50000, 2022),
(2, 'Bob', 'HR', 'Recruitment Drive', 15000, 2021),
(3, 'Charlie', 'IT', 'Network Upgrade', 30000, 2023),
(4, 'Diana', 'Finance', 'Budget Forecast', 12000, 2022),
(5, 'Evan', 'HR', 'Training Program', 18000, 2023),
(6, 'Fiona', 'IT', 'Cybersecurity Audit', 45000, 2022),
(7, 'George', 'Finance', 'Tax Audit', 22000, 2023);

--Q1
SELECT *
FROM dbo.Projects

--Q2
SELECT *
FROM dbo.Projects
WHERE Department = 'IT'
ORDER BY Budget DESC

--Q3
SELECT DISTINCT Department
FROM dbo.Projects

--Q4
SELECT EmployeeName, AVG(Budget)
FROM dbo.Projects
GROUP BY EmployeeName;

SELECT SUM(Budget) AS [Total Budget]
FROM dbo.Projects


--Q5
SELECT Department, SUM(Budget)
FROM dbo.Projects
GROUP BY Department

--Q6
SELECT Department, SUM(Budget)
FROM dbo.Projects
GROUP BY Department
HAVING SUM(Budget) > 60000

--Q7
SELECT EmployeeName, Budget
FROM dbo.Projects
ORDER BY Budget ASC

--Q8

DROP TABLE IF EXISTS HighBudgetProjects
CREATE TABLE HighBudgetProjects (
    EmployeeName VARCHAR(50),
    ProjectName VARCHAR(50),
    Budget DECIMAL(10,2)
    );



INSERT INTO dbo.HighBudgetProjects (EmployeeName, ProjectName, Budget)
    SELECT EmployeeName, ProjectName, Budget
    FROM dbo.Projects
    WHERE Budget > 30000;

SELECT *
FROM dbo.HighBudgetProjects


--Q9
SELECT ProjectName, Budget
FROM dbo.Projects
WHERE CompletionYear = 2022 AND Budget > 40000 AND Department = 'IT'
ORDER BY Budget DESC

--Q10
SELECT CompletionYear, AVG(Budget) AS [Average budget], SUM(Budget) AS [Total budget]
FROM dbo.Projects
GROUP BY CompletionYear
