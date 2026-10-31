--CREATE DATABASE DataAnalyst;
--USE DataAnalyst;
--CREATE TABLE orders (
--	order_id INT PRIMARY KEY,
--	category VARCHAR(30),
--	quantity INT,
--	unit_price DECIMAL(10, 2),
--	customer_id INT,
--	amount DECIMAL(10, 2),
--	status VARCHAR(20),
--	city VARCHAR(50),
--);
--CREATE TABLE orders (
--    order_id INT PRIMARY KEY,
--    category VARCHAR(30),
--    quantity INT,
--    unit_price DECIMAL(10, 2),
--    status VARCHAR(20),
--    city VARCHAR(50)
--);

--INSERT INTO orders
--    (order_id, category, quantity, unit_price, status, city)
--VALUES
--    (1001, 'Electronics', 2, 1500, 'Delivered', 'Delhi'),
--    (1002, 'Clothing', 5, 400, 'Pending', 'Hisar'),
--    (1003, 'Electronics', 4, 2500, 'Delivered', 'Delhi'),
--    (1004, 'Furniture', 1, 5000, 'Cancelled', 'Fatehabad'),
--    (1005, 'Clothing', 3, 800, 'Delivered', 'Hisar'),
--    (1006, 'Electronics', 1, 1200, 'Pending', 'Fatehabad'),
--    (1007, 'Furniture', 2, 3500, 'Delivered', 'Delhi'),
--    (1008, 'Clothing', 6, 300, 'Delivered', 'Fatehabad'),
--    (1009, 'Electronics', 5, 1800, 'Pending', 'Hisar'),
--    (1010, 'Furniture', 3, 2200, 'Delivered', 'Delhi');
--INSERT INTO orders (order_id, customer_id, amount, status)
--VALUES
--(1001, 201, 500, 'Delivered'),
--(1002, 202, 1500, 'Delivered'),
--(1003, 203, 750, 'Pending'),
--(1004, 201, 2200, 'Delivered'),
--(1005, 204, 1200, 'Cancelled'),
--(1006, 205, 3000, 'Delivered'),
--(1007, 202, 850, 'Pending'),
--(1008, 206, 4500, 'Delivered'),
--(1009, 207, 950, 'Cancelled'),
--(1010, 203, 1800, 'Pending'),
--(1011, 208, 650, 'Delivered'),
--(1012, 204, 2500, 'Delivered'),
--(1013, 209, 1100, 'Pending'),
--(1014, 205, 400, 'Cancelled'),
--(1015, 210, 3500, 'Delivered');

--SELECT * FROM orders;

--SELECT *
--FROM orders
--WHERE amount > 1000;
--SELECT *
--FROM orders
--ORDER BY amount DESC;

--SELECT TOP 5 *
--FROM orders;
--SELECT COUNT(*)
--FROM orders;

--SELECT SUM(amount)
--FROM orders;

--SELECT AVG(amount)
--FROM orders;

--SELECT status, COUNT(*)
--FROM orders
--GROUP BY status;

--SELECT status, COUNT(*) 
--FROM orders 
--GROUP BY status
--HAVING COUNT(*) > 4 ;

--SELECT * 
--FROM orders;

--SELECT * FROM orders;

--SELECT order_id, category, status FROM orderS;
