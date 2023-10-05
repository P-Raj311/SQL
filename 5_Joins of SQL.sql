 USE dmart;
 /*=====================================
	 JOINS in SQL    
=======================================*/

-- =========== MySQL alias for columns & tables =============

-- alias for columns
SELECT 
    CONCAT(lastName, ', ',firstname) AS `Full name` -- for spaces we have to use back ticks
FROM
    employees;
    
SELECT * FROM employees; 

SELECT
	orderNumber as Order_No,	
    SUM(priceEach * quantityOrdered) as `total`
FROM
	orderDetails
GROUP BY
	Order_No
HAVING total > 60000;  

-- alias for tables
SELECT 
    e.firstName, 
    e.lastName
FROM
    employees e
ORDER BY e.firstName;

-- ============ JOINS =======================
/* Get data from multiple tables
/*MySQL supports the following types of joins:
Inner join
Left join
Right join
Cross join
Self join*/

 -- =========== inner Join=================
 
SELECT * FROM customers;
SELECT COUNT(*) FROM customers; -- 122

SELECT * FROM orders;
SELECT COUNT(*) FROM orders; -- 327
SELECT COUNT(DISTINCT customerNumber) FROM orders; -- 98

SELECT customerNumber, COUNT(ordernumber) as Order_Count
FROM orders
GROUP BY customerNumber
ORDER BY Order_Count DESC;	


-- Inner join

SELECT * FROM customers;
SELECT * FROM orders;

SELECT * 
FROM customers c
INNER JOIN orders o
ON c.customerNumber = o.customerNumber;

SELECT 
	c.customerNumber, c.customerName,
	o.orderNumber, o.orderDate,o.status, o.customerNumber as  orders_customerNumber
FROM customers c
INNER JOIN orders o 
ON c.customerNumber = o.customerNumber
ORDER BY c.customerNumber;

SELECT * FROM customers WHERE customerNumber = 103;  -- 1
SELECT * FROM orders WHERE customerNumber = 103; -- 3 

SELECT 
	COUNT(*)
FROM customers c
INNER JOIN orders o 
ON c.customerNumber = o.customerNumber; -- 327 total count of orders table

SELECT DISTINCT (productName) FROM products NATURAL JOIN offices; 


-- =========== LEFT Join=================
SELECT 
	c.customerNumber, c.customerName,
	o.orderNumber, o.orderDate,o.status, o.customerNumber as  orders_customerNumber
FROM customers c
LEFT JOIN orders o 
ON c.customerNumber = o.customerNumber
ORDER BY c.customerNumber;

SELECT 
	COUNT(*)
FROM customers c
LEFT JOIN orders o 
ON c.customerNumber = o.customerNumber; -- 351

SELECT 
	COUNT(*)
FROM customers c
LEFT JOIN orders o 
ON c.customerNumber = o.customerNumber
WHERE o.customerNumber IS NULL; -- 24 extra rows in LEFT JOIN

SELECT 
	COUNT(*)
FROM customers c
LEFT JOIN orders o 
ON c.customerNumber = o.customerNumber
WHERE o.customerNumber IS NOT NULL; -- 327

/* these two joins are mostly used in the industry */	


-- ============ RIGHT Join=================

SELECT 
	c.customerNumber, c.customerName,
	o.orderNumber, o.orderDate,o.status, o.customerNumber as  orders_customerNumber
FROM orders o 
RIGHT JOIN customers c -- changed the order of the tables; now this output is same as the previous LEFT JOIN output
ON c.customerNumber = o.customerNumber
ORDER BY c.customerNumber; 

-- =========== Cross Join=================
SELECT DISTINCT city from offices;
SELECT COUNT(*) city from offices;

-- No need of matching column condition in cross
SELECT o1.city, o2.city FROM offices o1
CROSS JOIN offices o2;

SELECT COUNT(*) FROM offices o1
CROSS JOIN offices o2;

-- Cross Join with WHERE
-- behaves like INNER JOIN
SELECT o1.city, o2.city FROM offices o1
CROSS JOIN offices o2
WHERE o1.city = o2.city;

-- ===========  Self Join=================

SELECT * FROM employees;

-- Display the employee name and manager name
-- Self join using INNER JOIN clause


SELECT 
	concat(e1.firstname,' ',e1.lastname) as EmployeeName,
    concat(e2.firstname,' ',e2.lastname) as ManagerName
FROM employees e1 
INNER JOIN employees e2 ON e2.employeeNumber = e1.reportsTo;

-- Self join using LEFT JOIN clause
SELECT 
	concat(e1.firstname,' ',e1.lastname) as EmployeeName,
    concat(e2.firstname,' ',e2.lastname) as ManagerName
FROM employees e1 
LEFT JOIN employees e2 ON e2.employeeNumber = e1.reportsTo;



/*=====================================
	   Subqueries    
=======================================*/

SELECT * FROM employees;
SELECT * FROM offices;

-- One approach using JOINs
SELECT * 
FROM employees e
INNER JOIN offices o ON e.officeCode = o.officeCode
WHERE o.country = 'USA';


-- Using sub-query
SELECT * 
FROM employees 
WHERE officeCode IN (SELECT officeCode FROM offices WHERE country = 'USA');

SELECT officeCode FROM offices WHERE country = 'USA';
-- the above query is nothing but -
SELECT * 
FROM employees 
WHERE officeCode IN (1,2,3);

SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM  payments
WHERE amount > (SELECT AVG(amount)  FROM  payments);


SELECT   *
FROM	customers
WHERE   customerNumber NOT IN (SELECT DISTINCT  customerNumber  FROM  orders); -- it will give the customers who did not placed orders



-- =======Derived Tables=======

-- A derived table is a virtual table returned from a SELECT statement.

-- get the top five products by sales revenue in 2003 from the orders and orderdetails tables

SELECT 
    productCode, 
    productName,
    SUM(quantityOrdered * priceEach) as revenue
FROM orderdetails
INNER JOIN orders USING (orderNumber) -- USING keyword in JOINS. use this option when the two tables have the same colulmn name.
INNER JOIN products USING (productCode) -- multiple tables JOINED
WHERE  YEAR(shippedDate) = 2003
GROUP BY productCode
ORDER BY revenue DESC
LIMIT 5;

-- Using a derived table
SELECT top5.productCode, p.productName, top5.revenue FROM 
	(
	SELECT 
    productCode, 
    SUM(quantityOrdered * priceEach) as revenue
	FROM orderdetails
	INNER JOIN orders USING (orderNumber)
	WHERE  YEAR(shippedDate) = 2003
	GROUP BY productCode
	ORDER BY revenue DESC
	LIMIT 5
    ) as top5
INNER JOIN products p ON p.productCode = top5.productCode;


/*=====================================
       Temporary tables & CTEs   
=======================================*/

/*
**********MySQL temporary tables************
- A temporary table is created by using CREATE TEMPORARY TABLE statement. 
Notice that the keyword TEMPORARY is added between the CREATE and TABLE keywords.

- MySQL removes the temporary table automatically when the session ends or the connection is terminated. 
Of course, you can use the  DROP TABLE statement to remove a temporary table explicitly when you are no longer use it.
*/
CREATE TEMPORARY TABLE `products_planes` (
  `productCode` varchar(15) NOT NULL,
  `productName` varchar(70) NOT NULL,
  `productLine` varchar(50) NOT NULL,
  `productScale` varchar(10) NOT NULL,
  `productVendor` varchar(50) NOT NULL,
  `productDescription` text NOT NULL,
  `quantityInStock` smallint NOT NULL,
  `buyPrice` decimal(10,2) NOT NULL,
  `MSRP` decimal(10,2) NOT NULL,
  PRIMARY KEY (`productCode`)
); 

INSERT INTO products_planes
SELECT * FROM products WHERE productline = 'Planes';

SELECT * FROM products_planes;

-- DROP TEMPORARY TABLE products_planes;



-- **********Common Table Expression or CTE**********

-- A common table expression is a named temporary result set that exists only within the execution scope of a single SQL statement e.g.,SELECT, INSERT, UPDATE, or DELETE.

-- Similar to a derived table, a CTE is not stored as an object and last only during the execution of a query.

/*
SYNTAX
------
WITH cte_name (column_list) AS (
    query
) 
SELECT * FROM cte_name;

*/

;WITH cte1 AS 
(
	SELECT 
    productCode, 
    SUM(quantityOrdered * priceEach) as revenue
	FROM orderdetails
	INNER JOIN orders USING (orderNumber)
	WHERE  YEAR(shippedDate) = 2003
	GROUP BY productCode
	ORDER BY revenue DESC	
    LIMIT 5
)
SELECT cte1.productCode, p.productName, cte1.revenue FROM cte1
INNER JOIN products p ON p.productCode = cte1.productCode;

-- NESTED CTE

WITH salesrep AS (
    SELECT employeeNumber,
    CONCAT(firstName, ' ', lastName) AS salesrepName
    FROM employees
    WHERE jobTitle = 'Sales Rep'
),
customer_salesrep AS (
    SELECT customerName, salesrepName
    FROM customers c
	INNER JOIN salesrep sr ON sr.employeeNumber = c.salesrepEmployeeNumber
)
SELECT   *
FROM customer_salesrep
ORDER BY customerName;
