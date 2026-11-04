--USE MyDatabase;
/*
SELECT 
	first_name,
	country
FROM customers 
WHERE country = 'Germany';*/ 

--SELECT * FROM customers;
--SELECT * FROM customers ORDER BY country ASC, score DESC;
-- THE RESULT OF GROUP BY DETERMINED BY THE UNIQUE VALUES OF THE GROUPED COLUMSN.
--SELECT country, SUM(score) AS total_score, COUNT(id) AS total_customer FROM customers GROUP BY country;
--SELECT 
--	country, 
--	SUM(score) AS total_score, 
--	COUNT(id) AS total_customer 
--FROM customers 
--GROUP BY country
--HAVING SUM(SCORE) > 800;
--SELECT 
--	country, AVG(score) AS avg_score
--FROM customers 
--WHERE score != 0 
--GROUP BY country 
--HAVING AVG(score) > 450; 


--DISTINCT
--SELECT DISTINCT COUNTRY FROM customers;

--USE DataAnalyst;
--DROP TABLE IF EXISTS SalesOrders;
--GO
--CREATE TABLE SalesOrders (
--	order_id INT PRIMARY KEY,
--	order_date DATE,
--	category VARCHAR(30),
--	product_name VARCHAR(50),
--	quantity INT,
--	unit_price DECIMAL(10, 2),
--	status VARCHAR(20),
--	city VARCHAR(20)
--);

--INSERT INTO dbo.SalesOrders 
--(order_id, order_date, category, product_name, quantity, unit_price, status, city
--) VALUES
--(1001, '2026-10-01', 'Electronics', 'Keyboard',       2, 1500, 'Delivered', 'Delhi'),
--(1002, '2026-10-02', 'Clothing',    'T-Shirt',        5,  400, 'Pending',   'Hisar'),
--(1003, '2026-10-03', 'Electronics', 'Monitor',        4, 2500, 'Delivered', 'Delhi'),
--(1004, '2026-10-04', 'Furniture',   'Office Chair',   1, 5000, 'Cancelled', 'Fatehabad'),
--(1005, '2026-10-05', 'Clothing',    'Jeans',          3,  800, 'Delivered', 'Hisar'),
--(1006, '2026-10-06', 'Electronics', 'Mouse',          1, 1200, 'Pending',   'Fatehabad'),
--(1007, '2026-10-07', 'Furniture',   'Desk',            2, 3500, 'Delivered', 'Delhi'),
--(1008, '2026-10-08', 'Clothing',    'Jacket',         6,  300, 'Delivered', 'Fatehabad'),
--(1009, '2026-10-09', 'Electronics', 'Headphones',     5, 1800, 'Pending',   'Hisar'),
--(1010, '2026-10-10', 'Furniture',   'Bookshelf',      3, 2200, 'Delivered', 'Delhi'),
--(1011, '2026-10-11', 'Clothing',    'Shoes',          2, 1500, 'Delivered', 'Delhi'),
--(1012, '2026-10-12', 'Electronics', 'Laptop',         2, 4500, 'Delivered', 'Hisar'),
--(1013, '2026-10-13', 'Furniture',   'Table',          4, 2800, 'Pending',   'Fatehabad'),
--(1014, '2026-10-14', 'Clothing',    'Shirt',          8,  500, 'Cancelled', 'Delhi'),
--(1015, '2026-10-15', 'Electronics', 'Speaker',        3, 2200, 'Delivered', 'Fatehabad'),
--(1016, '2026-10-16', 'Furniture',   'Sofa',            1, 12000, 'Delivered', 'Hisar'),
--(1017, '2026-10-17', 'Clothing',    'Sweater',        4,  900, 'Pending',   'Hisar'),
--(1018, '2026-10-18', 'Electronics', 'Tablet',         3, 3200, 'Cancelled', 'Delhi'),
--(1019, '2026-10-19', 'Furniture',   'Cabinet',        2, 4200, 'Delivered', 'Fatehabad'),
--(1020, '2026-10-20', 'Clothing',    'Cap',             10, 200, 'Delivered', 'Delhi');


--SELECT 
--category, COUNT(*) AS total_orders 
--FROM dbo.SalesOrders
--GROUP BY category
--ORDER BY total_orders DESC;

--SELECT 
--	category, 
--	SUM(quantity * unit_price) AS total_revenue 
--FROM dbo.SalesOrders
--GROUP BY category
--ORDER BY total_revenue DESC;

--IF DB_ID('DataAnalyst') IS NULL
--	CREATE DATABASE DataAnalyst;
--GO

--USE DataAnalyst;
--GO

--DROP TABLE IF EXISTS dbo.Orders;
--DROP TABLE IF EXISTS dbo.Customers;
--GO 


--CREATE TABLE dbo.Customers (
--    customer_id INT PRIMARY KEY,
--    customer_name VARCHAR(50),
--    city VARCHAR(50)
--);

---- Create Orders table
--CREATE TABLE dbo.Orders (
--    order_id INT PRIMARY KEY,
--    customer_id INT,
--    order_date DATE,
--    category VARCHAR(30),
--    quantity INT,
--    unit_price DECIMAL(10, 2),
--    FOREIGN KEY (customer_id)
--        REFERENCES dbo.Customers(customer_id)
--);
-- Insert customers
--INSERT INTO dbo.Customers
--    (customer_id, customer_name, city)
--VALUES
--    (1, 'Amit', 'Delhi'),
--    (2, 'Priya', 'Mumbai'),
--    (3, 'Rahul', 'Delhi'),
--    (4, 'Neha', 'Pune'),
--    (5, 'Vikas', 'Mumbai'),
--    (6, 'Sara', 'Jaipur');

---- Insert orders
--INSERT INTO dbo.Orders
--    (order_id, customer_id, order_date,
--     category, quantity, unit_price)


--VALUES
--    (101, 1, '2026-01-05', 'Electronics', 2, 500.00),
--    (102, 2, '2026-01-10', 'Furniture',   1, 1200.00),
--    (103, 1, '2026-02-15', 'Electronics', 1, 700.00),
--    (104, 3, '2026-02-20', 'Clothing',    5, 40.00),
--    (105, 4, '2026-03-01', 'Furniture',   2, 800.00),
--    (106, 2, '2026-03-05', 'Electronics', 3, 400.00),
--    (107, 5, '2026-03-10', 'Clothing',    2, 60.00),
--    (108, 3, '2026-03-15', 'Electronics', 1, 900.00),
--    (109, 1, '2026-03-20', 'Furniture',   1, 1500.00),
--    (110, 4, '2026-03-25', 'Clothing',    3, 50.00),
--    (111, 5, '2026-04-02', 'Electronics', 2, 600.00),
--    (112, 2, '2026-04-10', 'Furniture',   1, 1000.00);
--GO

--SELECT 
--	order_id, category, quantity, unit_price, CAST(quantity * unit_price AS DECIMAL(12, 2)) AS	revenue
--FROM dbo.orders
--ORDER BY revenue DESC;

--SELECT 
--	c.customer_id,
--	c.customer_name,
--	COALESCE(
--		SUM(o.quantity * o.unit_price), 
--		0
--	) AS total_spending
--FROM dbo.Customers AS c
--LEFT JOIN dbo.Orders AS o
--	on c.customer_id = o.customer_id
--GROUP BY
--	c.customer_id,
--	c.customer_name
--ORDER BY total_spending DESC;
--The company wants to identify its highest-spending customers, 
-- including customers who have never purchased anything.

--SELECT 
--	c.customer_id,
--	c.customer_name,
--	COALESCE(
--	SUM(o.quantity * o.unit_price),
--	0
--	) AS total_spending
--FROM dbo.Customers AS c
--LEFT JOIN dbo.Orders AS o
--	ON c.customer_id = o.customer_id
--GROUP BY 
--	c.customer_id,
--	c.customer_name
--ORDER BY total_spending DESC;

--Find categories generating more than 1000 in revenue

--SELECT 
--	category,
--	SUM(quantity * unit_price) AS total_revenue
--FROM dbo.Orders
--GROUP BY category
--HAVING SUM(quantity * unit_price) > 1000
--ORDER BY total_revenue DESC;

--Question 5. Find categories whose average order revenue exceeds ₹500

--SELECT 
-- c.customer_id, 
-- c.customer_name,
-- COUNT(o.order_id) AS total_orders
--FROM Customers AS c
--INNER JOIN Orders AS o
--	ON c.customer_id = o.customer_id
--GROUP BY
--	c.customer_id,
--	c.customer_name
--HAVING COUNT(o.order_id) >= 2
--ORDER BY total_orders DESC;

--Find categories whose average order revenve exceeds 500

--SELECT
--	category, 
--	COUNT(*) AS total_orders,
--	CAST(
--		AVG(quantity * unit_price) AS DECIMAL (12, 2)
--	) AS average_order_revenue
--FROM dbo.Orders
--GROUP BY category
--HAVING AVG(quantity * unit_price) > 500
--ORDER BY average_order_revenue DESC;


--Question 7. Find customers spending more than the average customer

--WITH CustomersTotals AS (
--	SELECT 
--		c.customer_id,
--		c.customer_name,
--		COALESCE(
--			SUM(o.quantity * o.unit_price), 
--			0
--		) AS total_spending
--	FROM Customers AS c
--	LEFT JOIN Orders AS	o
--		ON c.customer_id = o.customer_id
--	GROUP BY c.customer_id, c.customer_name
--)
--SELECT 
--	customer_name,
--	total_spending
--FROM CustomersTotals
--WHERE total_spending > (
--	SELECT AVG(total_spending) FROM CustomersTotals
--)
--ORDER BY total_spending DESC;



--8 Find the hightest-revenue order in each category
--WITH OrderRevenue AS (
--	SELECT 
--		order_id, 
--		category,
--		quantity * unit_price AS revenue
--	FROM dbo.Orders
--),

--RankedOrders AS (
--	SELECT 
--		order_id, 
--		category,
--		revenue, 
--		DENSE_RANK() OVER (
--			PARTITION BY category
--			ORDER BY revenue DESC
--			) AS revenue_rank
--	FROM OrderRevenue 
--)
--SELECT 
--	order_id,
--	category,
--	revenue
--FROM RankedOrders
--WHERE revenue_rank = 1
--ORDER BY category ASC;

--Find customers who have never placed an order.
--The marketing team wants to find registered customers who have not purchased anything  
--SELECT 
--	c.customer_id,
--	c.customer_name,
--	c.city
--FROM dbo.Customers AS c
--WHERE NOT EXISTS (
--	SELECT 1
--	FROM dbo.Orders AS o
--	WHERE c.customer_id = o.customer_id
--)


--SELECT 
--	c.customer_id,
--	c.customer_name,
--	c.city
--FROM dbo.Customers AS c
--LEFT JOIN dbo.Orders AS o
-- ON c.customer_id = o.customer_id 
--WHERE o.order_id IS NULL;


-- QUESTION 10 => CALCULATE MONTH-OVER-MONTH CHANGES








































	