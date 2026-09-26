USE MyDatabase

--LEFT ANTI JOIN
SELECT * FROM dbo.customers
SELECT * FROM dbo.orders

SELECT * FROM dbo.customers C
LEFT JOIN dbo.orders O ON c.id = o.customer_id
