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


 











