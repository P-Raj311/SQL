USE dmart;
/*==================================================
             Handling & Manipulating Data
    
    Querying, Sorting , Filtering and Grouping  Data
======================================================*/

/***********    Querying data ***********/


SELECT * FROM employees; -- SELECT *: all columns and all rows

SELECT jobTitle FROM employees;
SELECT employeeNumber, jobTitle FROM employees;
SELECT 
	employeeNumber as EmpNo, 
	CONCAT(firstName, ' ', lastname) as FullName, -- CONCAT() function & column Alias
	jobTitle as Designation
FROM employees;

/*********** ORDER BY ***********/

SELECT contactFirstName, contactLastName 
FROM Customers
ORDER BY contactFirstName; -- in ascending order by default

SELECT contactFirstName, contactLastName 
FROM Customers
ORDER BY contactFirstName DESC;

SELECT * FROM Customers
ORDER BY creditlimit DESC;

SELECT * FROM Customers ORDER BY country ASC, city DESC;
SELECT * FROM Customers ORDER BY country, city;

/***********  Filtering data ***********/
SELECT lastname, firstname, jobtitle
FROM employees
WHERE jobtitle = 'Sales Rep';

-- DISTINCT operator in the SELECT
SELECT DISTINCT jobtitle FROM employees; -- Unique ones in the column

-- Using multiple conditions using AND operator
SELECT lastname,firstname,jobtitle,officeCode
FROM employees
WHERE jobtitle = 'Sales Rep' AND officeCode = 1; -- Both Requirments should match

-- Using multiple conditions using OR operator
SELECT lastName, firstName, jobTitle, officeCode
FROM  employees
WHERE jobtitle = 'Sales Rep' OR  officeCode = 1 -- Any one of the match is fine
ORDER BY officeCode , jobTitle;

-- Using WHERE clause with the BETWEEN operator
SELECT firstName,lastName,officeCode
FROM  employees
WHERE officeCode BETWEEN 1 AND 3 -- BETWEEN low AND high
ORDER BY officeCode;

SELECT * FROM Customers WHERE Creditlimit BETWEEN 100000 AND 125000;
SELECT * FROM Customers WHERE city = 'San Francisco';-- it is text value so we have to enclosed in single quotes


-- Using WHERE clause with the LIKE & NOT LIKE operators  -- Wild card operators
-- Helps to work with strings and patterns
SELECT firstName,lastName
FROM employees
WHERE lastName LIKE '%son'; -- ending with "son" names will be result

SELECT firstName,lastName
FROM employees
WHERE firstName LIKE 'L%'; -- staring with L 

SELECT firstName,lastName
FROM employees
WHERE firstName LIKE 'L%' OR firstName LIKE '%i';  -- staring with L OR ending with i

-- Regex expressions

SELECT DISTINCT firstName,lastname
from employees
WHERE firstName REGEXP '^[aeiou]';

SELECT DISTINCT FIRSTNAME FROM EMPLOYEES 
WHERE LOWER(SUBSTR(firstname,1,1)) NOT IN ('a','e','i','o','u') and 
LOWER(SUBSTR(firstname, LENGTH(firstname),1)) NOT IN ('a','e','i','o','u');   

-- Get the number of rows in a table
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM employees WHERE firstName LIKE 'L%';
SELECT COUNT(*) FROM Customers WHERE Creditlimit BETWEEN 100000 AND 125000;

SELECT firstName,lastName
FROM employees
WHERE firstName LIKE '%on%' OR lastName LIKE '%at%'; -- these string patterns can occur in any position in the firstname and lastname

SELECT *
FROM employees
WHERE jobTitle LIKE '%VP%';

SELECT *
FROM employees
WHERE jobTitle NOT LIKE '%Rep%'; -- NOT LIKE OPERATOR where not having Rep in that values

/*
Query the two names in table with the shortest and longest names, as well as their respective lengths 
(i.e.: number of characters in the name). 
If there is more than one smallest or largest name, choose the one that comes first when ordered alphabetically.
*/

select jobtitle, length(jobtitle) from employees order by length(jobtitle), jobtitle limit 1;
select jobtitle, length(jobtitle) from employees order by length(jobtitle) desc, jobtitle limit 1;

/*
Query the list of names starting with vowels (i.e., a, e, i, o, or u) from employees. 
Your result cannot contain duplicates.
*/

select concat( firstName,' ',lastName) as full_name
from employees
Where firstName LIKE 'A%' 
or  firstName  LIKE 'E%' 
or firstName  LIKE 'I%'
or firstName  LIKE 'O%' 
or firstName  LIKE 'U%';

/*
Query the list of names not starting with vowels (i.e., a, e, i, o, or u) from employees. 
Your result cannot contain duplicates.
*/

select Distinct firstname from employees
Where firstname not LIKE 'A%' 
and  firstname  not LIKE 'E%' 
and firstname  not LIKE 'I%'
and firstname  not LIKE 'O%' 
and firstname  not LIKE 'U%';


-- WHERE clause with the IN & NOT IN operators
SELECT firstName,lastName,officeCode
FROM employees
WHERE officeCode IN (2, 3, 5)
ORDER BY officeCode;

SELECT firstName,lastName,officeCode
FROM employees
WHERE officeCode NOT IN (2, 3, 5)
ORDER BY officeCode;

SELECT *
FROM employees
WHERE jobTitle IN ('VP Sales', 'VP Marketing');

SELECT *
FROM employees
WHERE jobTitle NOT IN ('Sales Rep');

SELECT *
FROM employees
WHERE jobTitle IN ('VP Sales', 'VP Marketing');

SELECT *
FROM employees
WHERE jobTitle <> 'Sales Rep'; -- Not equal to sales rep values will result

-- Using WHERE clause with the IS NULL and IS NOT NULL operators
-- Similar to isna and NaN values in pandas
SELECT *
FROM employees
WHERE reportsTo IS NULL;

SELECT * FROM customers WHERE salesRepEmployeeNumber IS NULL;

SELECT * FROM customers WHERE addressLine2 IS NOT NULL AND state IS NOT NULL;
SELECT * FROM customers WHERE state IS NULL;
SELECT COUNT(*) FROM customers WHERE state IS NULL;

-- Using WHERE clause with comparison operators
/*
=			Equal to. You can use it with almost any data type.
<> or !=	Not equal to
<			Less than. You typically use it with numeric and date/time data types.
>			Greater than.
<=			Less than or equal to
>=			Greater than or equal to
*/
SELECT * FROM customers WHERE creditLimit > 200000;
SELECT * FROM customers WHERE city = 'Brisbane';
SELECT * FROM orders WHERE orderDate >= '2003-10-22' AND orderDate <= '2003-11-05';
SELECT COUNT(*) FROM orders WHERE orderDate >= '2003-10-22' AND orderDate <= '2003-11-05';
SELECT * FROM orders WHERE status <> 'Shipped';

-- *********MySQL LIMIT clause**************
SELECT * FROM orders LIMIT 5; -- first 5 rows

SELECT * FROM orders ORDER BY orderNumber DESC LIMIT 5; -- bottom 5 records

-- Top 5 Customers with high Credit limit
SELECT * FROM customers ORDER BY creditLimit DESC LIMIT 5; 

-- TOP 6-10 customers with  Creditlimit i.e. from the TOP 10 customers we need second half or bottom 5 customers
SELECT * FROM customers ORDER BY creditLimit DESC LIMIT 5,5; -- this will fetch 5+5 = 10 rows and get the bottom 5 rows.
SELECT * FROM customers ORDER BY creditLimit DESC LIMIT 5,2; -- this will fetch 5+2 = 7 rows and get the bottom 2 rows.
SELECT * FROM customers ORDER BY creditLimit DESC LIMIT 7; 

-- Using LIMIT to get the nth highest or lowest value

-- Customer with highest creditlimit
SELECT * FROM customers ORDER BY creditLimit DESC LIMIT 1;

-- Customer with second-highest creditlimit
SELECT * FROM customers ORDER BY creditLimit DESC LIMIT 1,1;

-- Customer with second and third highest creditlimit
SELECT * FROM customers ORDER BY creditLimit DESC LIMIT 1,2;

-- Customer with fourth highest creditlimit
SELECT * FROM customers ORDER BY creditLimit DESC LIMIT 3,1;

-- Customer with least credit limit
SELECT * FROM customers WHERE creditLimit <> 0
ORDER BY creditLimit ASC LIMIT 1;

-- Second Least Credit limit
SELECT * FROM customers WHERE creditLimit <> 0
ORDER BY creditLimit ASC LIMIT 1,1;

/***********  Grouping data using GROUP BY ***********/

SELECT DISTINCT status FROM orders;
-- GROUP BY 
SELECT status FROM orders GROUP BY status; -- Simple GROUP BY similar to DISTINCT.

-- total records in orders table
SELECT COUNT(*) FROM orders; -- 327

-- GROUP BY with aggregate functions (count, sum, avg etc.,) in Pandas
-- Breakdown of row count by status
SELECT status, COUNT(*) FROM orders GROUP BY status;

SELECT * FROM orderdetails;

-- Total quantity ordered for each product
SELECT od.productCode, SUM(od.quantityOrdered) as TotalQty 
FROM orderdetails od -- Using Alias name for table
GROUP BY od.productCode
ORDER BY TotalQty DESC; 

-- GROUP BY Multiple columns
SELECT od.productCode,od.orderLineNumber, SUM(od.quantityOrdered) as TotalQty 
FROM orderdetails od -- Using Alias name for table
GROUP BY od.productCode,od.orderLineNumber
ORDER BY TotalQty DESC; 

-- HAVING: HAVING clause evaluates each group returned by the GROUP BY clause. 
-- Total quantity ordered for each product greater than 1000
SELECT od.productCode, SUM(od.quantityOrdered) as TotalQty 
FROM orderdetails od -- Using Alias name for table
GROUP BY od.productCode
HAVING TotalQty > 1000
ORDER BY TotalQty DESC; 

SELECT 
    ordernumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceeach*quantityOrdered) AS total
FROM   orderdetails
GROUP BY ordernumber
HAVING total > 50000 AND itemsCount > 600
ORDER BY total DESC;

-- ROLLUP
SELECT od.productCode, SUM(od.quantityOrdered) as TotalQty 
FROM orderdetails od
WHERE priceEach > 100 
GROUP BY od.productCode WITH ROLLUP; -- Grand total of the column
 
SELECT * FROM payments;
SELECT customerNumber, YEAR(paymentDate) as paymentyear, amount FROM payments;

-- GROUP BY multiple collumns WITH ROLLUP
SELECT 
	customerNumber, 
    YEAR(paymentDate) as paymentyear, 
    SUM(amount) as amountpaid
FROM payments
GROUP BY customerNumber,paymentyear WITH ROLLUP; -- Adds Subtotal and Grand total

SELECT 	
    YEAR(paymentDate) as paymentyear, 
    customerNumber, 
    SUM(amount) as amountpaid
FROM payments
GROUP BY paymentyear,customerNumber WITH ROLLUP;


/*=====================================
	  Set operators 
    UNION and UNION ALL
=======================================*/

-- Difference between UNION and UNION ALL
SELECT DISTINCT country from offices
UNION 
SELECT DISTINCT country from offices;

SELECT DISTINCT country from offices
UNION ALL
SELECT DISTINCT country from offices;

SELECT DISTINCT city,country from offices -- Error due differnet number of columns
UNION ALL
SELECT DISTINCT country from offices;

SELECT DISTINCT city,country from offices
UNION 
SELECT DISTINCT city,country from offices;



/*-- Order of execution in SQL
1. FROM
2. WHERE -- FILTERS
3. GROUP BY -- sum
4. HAVING
5. SELECT
6. DISTINCT
7. ORDR BY
8. LIMIT
*/
SELECT 
   DISTINCT (customerNumber), year(paymentdate) as PaymentYear,SUM(amount) as Total
FROM payments
WHERE year(paymentdate) = 2003
GROUP BY customerNumber,paymentyear
HAVING total > 15000
ORDER BY total DESC
LIMIT 5;
/* 
---- we have to write in this order
*/
SELECT count(*) FROM (
SELECT DISTINCT (customerNumber), year(paymentdate) as PaymentYear,SUM(amount) as Total
FROM payments -- 273
WHERE year(paymentdate) = 2003 -- 100
GROUP BY customerNumber,paymentyear -- 73
HAVING total >50000) a ; -- 20 





















































































