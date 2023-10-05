/*=====================================
	 Managing Databases 
    
    DDL commands - CREATE, DROP
=======================================*/

/***1.1 Creating & Selecting a MySQL Database***/

-- List the databases that are available on your server
SHOW DATABASES; -- end your code with semi-colon

-- Ctrl+Enter to execute online of code; Ctrl+Shift+Enter to execute mutiple selected lines of code.

/*
Multi-line comments
in SQL
*/
-- Single line comment

-- Create a new database - demo
CREATE DATABASE demo;

-- To select a database to work with, you need to use the USE statement
USE demo;

-- To verify it, you can use the select database() statement
SELECT DATABASE();

-- using IF EXISTS and IF NOT EXISTS
CREATE DATABASE testdb;

#CREATE DATABASE testdb; -- Error

CREATE DATABASE IF NOT EXISTS testdb; -- Warning

/***1.2 DROP Database***/
DROP DATABASE IF EXISTS testdb;

/*=====================================
	  MySQL Data Types
=======================================*/
/*
A database table contains multiple columns with specific data types such as numeric or string or date. 
MySQL provides more data types other than just numeric and string. Each data type in MySQL 
can be determined by the following characteristics:

> The kind of values it represents.
> The space that takes up and whether the values are a fixed-length or variable length.

They are grouped into five main categories:

- Numeric data types
- Date and time data types
- String data types
- Spatial data types
- JSON data types
*/

/*=====================================
	 MySQL constraints
=======================================*/
/*

> NOT NULL–  a NOT NULL column  will make sure no NULL values are inserted in the column.

> PRIMARY KEY - 
	A primary key is a column or a set of columns that uniquely identifies each row in the table.  The primary key follows these rules:
		- A primary key must contain unique values. If the primary key consists of multiple columns, 
			the combination of values in these columns must be unique.
		- A primary key column cannot have NULL values. Any attempt to insert or update NULL to primary key columns will result in an error. 
			Note that MySQL implicitly adds a NOT NULL constraint to primary key columns.
		- A table can have one an only one primary key.

> FOREIGN KEY - A foreign key is a column or group of columns in a table that links to a column or group of columns in another table. 
				The foreign key places constraints on data in the related tables, which allows MySQL to maintain "referential integrity".

> Disable Foreign Key Checks
	Sometimes, it is very useful to disable foreign key checks. For example, you can load data to the parent and child tables in any order 
    with the foreign key constraint check disabled. If you don’t disable foreign key checks, you have to load data into the parent 
    tables first and then the child tables in sequence, which can be tedious.

	Another scenario that you want to disable the foreign key check is when you want to drop a table. 
    Unless you disable the foreign key checks, you cannot drop a table referenced by a foreign key constraint.
    
    SET foreign_key_checks = 0;
    
    SET foreign_key_checks = 1;
    
> UNIQUE Constraint - A UNIQUE constraint is an integrity constraint that ensures values in a column or group of columns to be unique.
					  A UNIQUE constraint can be either a column constraint or a table constraint.
                      
> CHECK Constraint - CHECK constraint to ensure that values stored in a column or group of columns satisfy a Boolean expression.

> DEFAULT constraint - allows you to specify a default value for a column.

*/

/*======================================================
	     Working with tables
    
    DDL commands - CREATE, ALTER, DROP, RENAME, TRUNCATE
    DML commands - SELECT, INSERT, UPDATE, DELETE
========================================================*/

/***4.1 CREATE TABLE***/

/*
-- syntax

CREATE TABLE [IF NOT EXISTS] table_name(
   column_1_definition,
   column_2_definition,
   ...,
   table_constraints
) [ENGINE=storage_engine];

InnoDB became the default storage engine since MySQL version 5.5. The InnoDB storage engine brings many benefits of a 
relational database management system such as ACID transaction, referential integrity, and crash recovery. 
In the previous versions, MySQL used MyISAM as the default storage engine.


-- column_1_definition
column_name data_type(length) [NOT NULL] [DEFAULT value] [AUTO_INCREMENT] [column_constraint]

*/ 

CREATE TABLE trasnsactions(
transaction_id INT,
transaction_date DATETIME,
Customer_id INT,
Product_id INT,
quantity INT,
tax DECIMAL(5,2),
price DECIMAL(5,2),
isCustomerMembership BIT,
comments varchar(500)
);

-- Display table info
DESC trasnsactions;
DESCRIBE trasnsactions;
-- Generate the CREATE table script
SHOW CREATE TABLE trasnsactions;

-- DDL command: DROP a Table
DROP TABLE IF EXISTS trasnsactions;

DROP TABLE IF EXISTS transactions;
-- DDLcommand: CREATE a Table
CREATE TABLE IF NOT EXISTS transactions(
transaction_id INT,
transaction_date DATETIME,
Customer_id INT,
Product_id INT,
quantity INT,
tax DECIMAL(5,2),
price DECIMAL(5,2),
isCustomerMembership BIT,
comments varchar(500)
);

-- DML command: SELECT
SELECT * FROM transactions; -- Empty table

-- DML command: INSERT
INSERT INTO transactions 
(transaction_id,transaction_date,Customer_id,Product_id,quantity,tax,price,isCustomerMembership,comments)
VALUES
(1,'2022-01-27 11:53:45',101,20254,25,0.05,120,1,'Republic day Sale');

-- Check the INSERTED data
SELECT * FROM transactions;

-- Insert the same data again
INSERT INTO transactions 
(transaction_id,transaction_date,Customer_id,Product_id,quantity,tax,price,isCustomerMembership,comments)
VALUES
(1,'2022-01-27 11:53:45',101,20254,25,0.05,120,1,'Republic day Sale');

-- INSERT NULLS
INSERT INTO transactions 
(transaction_id,transaction_date,Customer_id,Product_id,quantity,tax,price,isCustomerMembership,comments)
VALUES
(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

INSERT INTO transactions 
(transaction_id,transaction_date,Customer_id,Product_id,quantity,tax,price,isCustomerMembership,comments)
VALUES
(NULL,'2022-01-27 11:53:45',NULL,20254,25,0.05,120,1,'Republic day Sale');

-- Check the INSERTED data
SELECT * FROM transactions;

-- Now DROP the table and recreate with Constraints and Keys

DROP TABLE IF EXISTS transactions;

-- DDLcommand: CREATE a Table
CREATE TABLE IF NOT EXISTS transactions(
transaction_id INT AUTO_INCREMENT PRIMARY KEY,
transaction_date DATETIME DEFAULT NOW(),
Customer_id INT NOT NULL,
Product_id INT NOT NULL,
quantity INT,
tax DECIMAL(5,2),
price DECIMAL(5,2),
isCustomerMembership BIT DEFAULT 0,
comments varchar(500) DEFAULT 'NA'
);

DESCRIBE transactions;

-- DML command: INSERT
INSERT INTO transactions 
(transaction_date,Customer_id,Product_id,quantity,tax,price,isCustomerMembership,comments)
VALUES
('2022-01-28 11:53:45',101,20254,25,0.05,120,1,'Republic day Sale'); -- transaction_id is inserted automatically

SELECT * FROM transactions;

-- DML command: INSERT
INSERT INTO transactions 
(Customer_id,Product_id,quantity,tax,price)
VALUES
(101,202487,30,0.05,145); -- transaction_id is inserted automatically

SELECT * FROM transactions;

-- Use ALTER to MODIFY the columns
-- make quantity NOT NULL
-- add a check on the tax i.e., tax >= 0 and also make it NOT NULL
-- change the datatype of the price, increse the precision & scale 
ALTER TABLE transactions
MODIFY quantity INT NOT NULL;

DESCRIBE transactions;

-- Check this
ALTER TABLE transactions
MODIFY tax decimal(3,2);

ALTER TABLE transactions
ADD CHECK (tax>=0);

DESCRIBE transactions;

ALTER TABLE transactions
MODIFY price decimal(10,4);

DESCRIBE transactions;

SELECT * FROM transactions;

-- Now check the constraints
INSERT INTO transactions 
(Customer_id,Product_id,quantity,tax,price)
VALUES
(NULL,202487,30,0.05,145);  -- try inserting NULL into customer_id

INSERT INTO transactions 
(Customer_id,Product_id,quantity,tax,price)
VALUES
(107,12587,NULL,0.05,145);  -- try inserting NULL into quantity

-- Check this
INSERT INTO transactions 
(Customer_id,Product_id,quantity,tax,price)
VALUES
(107,12587,12,0,145);  -- try inserting 0 into tax column

-- Use UPDATE to modify the records
UPDATE transactions SET tax = 0.05; -- UPDATE without a WHERE clause
SELECT * FROM transactions;

-- Always use WHERE clause in the UPDATE and use SELECT to check the rows that are going to get updated
SELECT * FROM transactions WHERE quantity > 25; -- WHERE is used to filter the rows
UPDATE transactions SET tax = 0.15 WHERE quantity > 25;

SELECT * FROM transactions;

-- filter the columns or SELECT on required colulmns
SELECT transaction_id, quantity, tax FROM transactions;
SELECT transaction_id, quantity, tax FROM transactions WHERE quantity > 25;

-- Few more examples on ALTER

SELECT * FROM transactions;
-- Add a new column using ALTER
ALTER TABLE transactions ADD discount DECIMAL(5,2) DEFAULT 0; -- by default new column will be added at the end
SELECT * FROM transactions;

-- DROP a Column from the table
ALTER TABLE transactions DROP discount;
SELECT * FROM transactions;

-- Add the new column after price
ALTER TABLE transactions ADD discount DECIMAL(5,2) DEFAULT 0 AFTER price;
SELECT * FROM transactions;

-- MODIFY a COLUMN using ALTER
ALTER TABLE transactions MODIFY discount DECIMAL(5,2) DEFAULT 0.02; -- this will not change the existing data
SELECT * FROM transactions;

INSERT INTO transactions 
(Customer_id,Product_id,quantity,tax,price)
VALUES
(107,12587,12,0.02,145); 
SELECT * FROM transactions;

-- DELETE a record from the table
-- Always use WHERE clause with DELETE
DELETE FROM transactions; -- without WHERE, DELETE will remove all the records
SELECT * FROM transactions;

-- Let's INSERT some data again
-- INSERT multiple rows into the TABLE
INSERT INTO transactions 
(Customer_id,Product_id,quantity,tax,price)
VALUES
(101,202487,30,0.05,145),
(105,2054,42,0.05,99),
(203,2365,3,0.03,65),
(205,12587,1,0.02,120),
(301,98521,10,0.04,35),
(112,1236,22,0.01,44);

SELECT * FROM transactions; -- transaction_id is not starting from 1.

-- DELETE vs TRUNCATE (DDL command)
DELETE FROM transactions; -- this will DELETE all records but it will NOT reset the AUTO_INCREMENT column to 1
INSERT INTO transactions 
(Customer_id,Product_id,quantity,tax,price)
VALUES
(101,202487,30,0.05,145),
(105,2054,42,0.05,99),
(203,2365,3,0.03,65),
(205,12587,1,0.02,120),
(301,98521,10,0.04,35),
(112,1236,22,0.01,44);
SELECT * FROM transactions;

-- DDL command: TRUNCATE
TRUNCATE TABLE transactions; -- this will DELETE all records but it will reset the AUTO_INCREMENT column to 1
SELECT * FROM transactions;
INSERT INTO transactions 
(Customer_id,Product_id,quantity,tax,price)
VALUES
(101,202487,30,0.05,145),
(105,2054,42,0.05,99),
(203,2365,3,0.03,65),
(205,12587,1,0.02,120),
(301,98521,10,0.04,35),
(112,1236,22,0.01,44);
SELECT * FROM transactions;

-- DELETE with WHERE clause
-- Check with SELECT before DELETE
SELECT * FROM transactions WHERE quantity < 5;
DELETE FROM transactions WHERE quantity < 5;

-- RENAME the TABLE
RENAME TABLE transactions TO transactions_old;

-- Create a COPY of a table
CREATE TABLE transactions_new LIKE transactions_old;
SELECT * FROM transactions_new;

INSERT INTO transactions_new 
SELECT * FROM transactions_old;

SELECT * FROM transactions_new;

-- DROP a table from the Database
DROP TABLE transactions_old;


/*======================================================
	  Create a new Database and Datamodel    
========================================================*/
DROP DATABASE IF EXISTS retail;

CREATE DATABASE IF NOT EXISTS retail;

USE retail;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customerNumber int NOT NULL,
  customerName varchar(50) NOT NULL,
  contactLastName varchar(50) NOT NULL,
  contactFirstName varchar(50) NOT NULL,
  phone varchar(50) NOT NULL,
  addressLine1 varchar(50) NOT NULL,
  addressLine2 varchar(50) DEFAULT NULL,
  city varchar(50) NOT NULL,
  state varchar(50) DEFAULT NULL,
  postalCode varchar(15) DEFAULT NULL,
  country varchar(50) NOT NULL,
  salesRepEmployeeNumber int DEFAULT NULL,
  creditLimit decimal(10,2) DEFAULT NULL
  );

-- Add a PRIMARY KEY to the table
ALTER TABLE customers ADD PRIMARY KEY (customerNumber);

DESCRIBE customers;

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
  employeeNumber INT PRIMARY KEY, -- PRIMARY KEY
  lastName varchar(50) NOT NULL,
  firstName varchar(50) NOT NULL,
  extension varchar(10) NOT NULL,
  email varchar(100) NOT NULL,
  officeCode INT NOT NULL,
  reportsTo int DEFAULT NULL,
  jobTitle varchar(50) NOT NULL
);

DESCRIBE employees;

-- Add FOREIGN KEY using ALTER
ALTER TABLE employees
	ADD CONSTRAINT fk_employees_reportsTo
	FOREIGN KEY (reportsTo) 
    REFERENCES employees (employeeNumber);
    
ALTER TABLE customers
	ADD CONSTRAINT fk_customers_salesRepEmployeeNumber 
	FOREIGN KEY (salesRepEmployeeNumber) 
    REFERENCES employees (employeeNumber);

DESCRIBE employees;
DESCRIBE customers;

DROP TABLE IF EXISTS offices;
CREATE TABLE offices (
  officeCode INT AUTO_INCREMENT PRIMARY KEY,
  city varchar(50) NOT NULL UNIQUE,
  phone varchar(50) NOT NULL,
  addressLine1 varchar(50) NOT NULL,
  addressLine2 varchar(50) DEFAULT NULL,
  state varchar(50) DEFAULT NULL,
  country varchar(50) NOT NULL,
  postalCode varchar(15) NOT NULL,
  territory varchar(10) NOT NULL
  );

DESCRIBE offices;

-- Add FOREIGN KEY using ALTER on employees 
ALTER TABLE employees
	ADD CONSTRAINT fk_employees_officeCode 
	FOREIGN KEY (officeCode) 
    REFERENCES offices (officeCode);

DESC employees;
SHOW COLUMNS FROM employees;

/* Key abbreviations:
PRI - Primary Key
UNI - Unique Key
MUL - "Multiple" because multiple occurrences of the same value are allowed.
*/

-- Referential Integrity

DROP TABLE IF EXISTS offices; -- This will result in ERROR
-- Error Code: 3730. Cannot drop table 'offices' referenced by a foreign key constraint 'fk_employees_officeCode' on table 'employees'.

SET foreign_key_checks = 0; -- Disbale the foreign key checks
DROP TABLE IF EXISTS offices; -- Now the table can be dropped
SET foreign_key_checks = 1; -- Enable the foreign key check




-- Let's look at the data we have Inserted

-- SELECT required columns in required order
SELECT * FROM orderdetails;
SELECT orderNumber, orderLineNumber, productcode, quantityordered, priceeach FROM orderdetails;
SELECT orderNumber, orderLineNumber, quantityordered FROM orderdetails;

-- SELECT using WHERE clause
SELECT * FROM products WHERE productline = 'Motorcycles';

-- let's use INSERT INTO option to create a table  (this option require the table to be created)
-- Create a new product table for 'Motorcycles'

DROP TABLE IF EXISTS products_Motorcycles;

CREATE TABLE `products_Motorcycles` (
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

SELECT * FROM products_motorcycles;

INSERT INTO products_Motorcycles
SELECT * FROM products WHERE productline = 'Motorcycles';

TRUNCATE TABLE products_Motorcycles;

INSERT INTO products_Motorcycles
(productCode
,productName
,productLine
,productScale
,productVendor
,productDescription
,quantityInStock
,buyPrice
,MSRP) 
SELECT productCode
,productName
,productLine
,productScale
,productVendor
,productDescription
,quantityInStock
,buyPrice
,MSRP FROM products WHERE productline = 'Motorcycles';

/*
**********MySQL Generated Columns************
Two ways adding a generated column in MySQL
*/

-- Approach 1 (after table creation)
ALTER TABLE products_motorcycles
ADD COLUMN stockValue DOUBLE 
GENERATED ALWAYS AS (buyprice*quantityinstock) STORED;

SELECT * FROM products_motorcycles;

-- Approach 2 (at the time of table creation)

DROP TABLE products_Motorcycles;

CREATE TABLE `products_Motorcycles` (
  `productCode` varchar(15) NOT NULL,
  `productName` varchar(70) NOT NULL,
  `productLine` varchar(50) NOT NULL,
  `productScale` varchar(10) NOT NULL,
  `productVendor` varchar(50) NOT NULL,
  `productDescription` text NOT NULL,
  `quantityInStock` smallint NOT NULL,
  `buyPrice` decimal(10,2) NOT NULL,
  `MSRP` decimal(10,2) NOT NULL,
  `stockValue` DOUBLE GENERATED ALWAYS AS (buyprice*quantityinstock), 
  PRIMARY KEY (`productCode`)
); 

INSERT INTO products_Motorcycles
SELECT * FROM products WHERE productline = 'Motorcycles'; -- Error 

INSERT INTO products_Motorcycles
(productCode
,productName
,productLine
,productScale
,productVendor
,productDescription
,quantityInStock
,buyPrice
,MSRP) 
SELECT productCode
,productName
,productLine
,productScale
,productVendor
,productDescription
,quantityInStock
,buyPrice
,MSRP FROM products WHERE productline = 'Motorcycles';

SELECT * FROM products_motorcycles;

/*
**********UPDATE************
Syntax:
----------
UPDATE  table_name 
SET 
    column_name1 = expr1,
    column_name2 = expr2,
    ...
[WHERE
    condition];
*/

SELECT * FROM products_motorcycles;

UPDATE products_motorcycles SET productline = 'MOTORCYCLES';

SELECT * FROM products_motorcycles WHERE stockvalue < 1000; 
UPDATE products_motorcycles SET productline = 'MOTORCYCLES-1000' WHERE stockvalue < 1000; 

SELECT * FROM products_motorcycles;

/*
**********DELETE************
Syntax:
----------
DELETE FROM table_name
WHERE condition;
*/
-- DELETE FROM products_motorcycles; -- this will delete all the contents.
SELECT * FROM products_motorcycles WHERE stockvalue < 1000; 
DELETE FROM products_motorcycles WHERE stockvalue < 1000;

SELECT * FROM products_motorcycles;

/*
**********MySQL Transaction************
Transaction Control Language (TCL)
- COMMIT
- ROLLBACK

By default, MySQL automatically commits the changes permanently to the database. 
To force MySQL not to commit changes automatically, you use the following statement:
SET autocommit = 0; OR SET autocommit = OFF

to enable the autocommit mode explicitly:
SET autocommit = 1; OR SET autocommit = ON;
*/

-- We will use the  orders and orderDetails tables
-- COMMIT 

-- 1. start a new transaction
START TRANSACTION;

-- 2. insert a new order for customer 145
INSERT INTO orders(orderNumber,
                   orderDate,
                   requiredDate,
                   shippedDate,
                   status,
                   customerNumber)
VALUES(10426,
       '2005-05-31',
       '2005-06-10',
       '2005-06-11',
       'In Process',
        145);

-- 3. Insert order line items
INSERT INTO orderdetails(orderNumber,
                         productCode,
                         quantityOrdered,
                         priceEach,
                         orderLineNumber)
VALUES(10426,'S18_1749', 30, '136', 1),
      (10426,'S18_2248', 50, '55.09', 2);

-- 4. commit changes    
COMMIT;

SELECT * FROM orders WHERE orderNumber = 10426;
SELECT * FROM orderdetails WHERE orderNumber = 10426;


-- ROLLBACK
-- 1. start a new transaction
START TRANSACTION;

-- 2. insert a new order for customer 145
INSERT INTO orders(orderNumber,
                   orderDate,
                   requiredDate,
                   shippedDate,
                   status,
                   customerNumber)
VALUES(10427,
       '2005-05-31',
       '2005-06-10',
       '2005-06-11',
       'In Process',
        145);

-- 3. Insert order line items
INSERT INTO orderdetails(orderNumber,
                         productCode,
                         quantityOrdered,
                         priceEach,
                         orderLineNumber)
VALUES(10427,'S18_1749', 30, '136', 1),
      (10427,'S18_2248', 50, '55.09', 2);

SELECT * FROM orders WHERE orderNumber = 10427;
SELECT * FROM orderdetails WHERE orderNumber = 10427;

-- 4. Rollback changes    
ROLLBACK;

SELECT * FROM orders WHERE orderNumber = 10427;
SELECT * FROM orderdetails WHERE orderNumber = 10427;


START TRANSACTION;
SELECT COUNT(*) FROM products_motorcycles;
DELETE FROM products_motorcycles;
SELECT COUNT(*) FROM products_motorcycles;
ROLLBACK;
SELECT COUNT(*) FROM products_motorcycles;

SELECT * FROM orderdetails WHERE orderNumber = 10426;
START TRANSACTION;
UPDATE orderdetails SET priceEach = 100 WHERE orderNumber = 10426;
SELECT * FROM orderdetails WHERE orderNumber = 10426;
ROLLBACK;
SELECT * FROM orderdetails WHERE orderNumber = 10426;

SHOW CREATE TABLE  products_motorcycles;
/*
------------------- Database-Level ---------------------------------------------
DROP DATABASE databaseName                 -- Delete the database (irrecoverable!)
DROP DATABASE IF EXISTS databaseName       -- Delete if it exists
CREATE DATABASE databaseName               -- Create a new database
CREATE DATABASE IF NOT EXISTS databaseName -- Create only if it does not exists
SHOW DATABASES                             -- Show all the databases in this server
USE databaseName                           -- Set the default (current) database
SELECT DATABASE()                          -- Show the default database
SHOW CREATE DATABASE databaseName          -- Show the CREATE DATABASE statement

------------------- Table-Level ---------------------------------------------
DROP TABLE [IF EXISTS] tableName, ...
CREATE TABLE [IF NOT EXISTS] tableName (
   columnName columnType columnAttribute, ...
   PRIMARY KEY(columnName),
   FOREIGN KEY (columnNmae) REFERENCES tableName (columnNmae)
)
SHOW TABLES                -- Show all the tables in the default database
DESCRIBE|DESC tableName    -- Describe the details for a table
ALTER TABLE tableName ...  -- Modify a table, e.g., ADD COLUMN and DROP COLUMN
ALTER TABLE tableName ADD columnDefinition
ALTER TABLE tableName DROP columnName
ALTER TABLE tableName ADD FOREIGN KEY (columnNmae) REFERENCES tableName (columnNmae)
ALTER TABLE tableName DROP FOREIGN KEY constraintName
SHOW CREATE TABLE tableName        -- Show the CREATE TABLE statement for this tableName
 
------------------- Row-Level ---------------------------------------------
INSERT INTO tableName 
   VALUES (column1Value, column2Value,...)               -- Insert on all Columns
INSERT INTO tableName 
   VALUES (column1Value, column2Value,...), ...          -- Insert multiple rows
INSERT INTO tableName (column1Name, ..., columnNName)
   VALUES (column1Value, ..., columnNValue)              -- Insert on selected Columns
DELETE FROM tableName WHERE criteria
UPDATE tableName SET columnName = expr, ... WHERE criteria
SELECT * | column1Name AS alias1, ..., columnNName AS aliasN 
   FROM tableName
   WHERE criteria
   WHERE criteria
   
------------------- Transactions ---------------------------------------------
START TRANSACTION;
<INSERT/UPDATE/DELETE>
COMMIT/ROLLBACK;
*/




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
SELECT DISTINCT jobtitle FROM employees;

-- Using multiple conditions using AND operator
SELECT lastname,firstname,jobtitle,officeCode
FROM employees
WHERE jobtitle = 'Sales Rep' AND officeCode = 1;

-- Using multiple conditions using OR operator
SELECT lastName, firstName, jobTitle, officeCode
FROM  employees
WHERE jobtitle = 'Sales Rep' OR  officeCode = 1
ORDER BY officeCode , jobTitle;

-- Using WHERE clause with the BETWEEN operator
SELECT firstName,lastName,officeCode
FROM  employees
WHERE officeCode BETWEEN 1 AND 3 -- BETWEEN low AND high
ORDER BY officeCode;

SELECT * FROM Customers WHERE Creditlimit BETWEEN 100000 AND 125000;
SELECT * FROM Customers WHERE city = 'San Francisco';-- it is text value so we have to enclosed in single quotes


-- Using WHERE clause with the LIKE & NOT LIKE operators 
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
GROUP BY od.productCode WITH ROLLUP;

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

/*******************************
Order of execution in SQL
*******************************/


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




/*=====================================
	 JOINS in SQL    
=======================================*/

-- =========== MySQL alias for columns & tables=============

-- alias for columns
SELECT 
    CONCAT(lastName, ', ',firstname) AS `Full name`
FROM
    employees;
    
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
SELECT 
	c.customerNumber, c.customerName,
	o.orderNumber, o.orderDate,o.status, o.customerNumber as  orders_customerNumber
FROM customers c
INNER JOIN orders o 
ON c.customerNumber = o.customerNumber
ORDER BY c.customerNumber;

SELECT * FROM customers WHERE customerNumber = 103;
SELECT * FROM orders WHERE customerNumber = 103;

SELECT 
	COUNT(*)
FROM customers c
INNER JOIN orders o 
ON c.customerNumber = o.customerNumber; -- 327

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

-- No need of matching column condition
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
WHERE   customerNumber NOT IN (SELECT DISTINCT  customerNumber  FROM  orders);


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
 


/*=====================================
            Functions   
=======================================*/

/*******************************
1. Aggregate Functions
2. Comparison Functions
3. Date Functions
4. String Functions
5. Window Functions
6. Math Functions
*******************************/

-- ============= 1. Aggregate Functions ================
-- AVG() - Return the average of non-NULL values.

SELECT * FROM products;
SELECT AVG(buyPrice) as average_buy_price
FROM products;

SELECT productLine, AVG(buyPrice) as average_buy_price
FROM products
GROUP BY productLine;

 -- COUNT()- returns the number of the value in a set.
SELECT COUNT(*) AS total
FROM products;

SELECT productLine,COUNT(*) AS total
FROM products
GROUP BY productLine;

-- SUM() - returns the sum of values in a set.
SELECT SUM(amount) as TotalPayment 
FROM payments;

SELECT YEAR(paymentDate) as PaymentYear, SUM(amount) as TotalPayment 
FROM payments
GROUP BY PaymentYear;

-- MAX() - returns the maximum value in a set.
SELECT  MAX(buyPrice) as highest_price
FROM  products;

SELECT productLine, MAX(buyPrice) as highest_price
FROM products
GROUP BY productLine
ORDER BY highest_price DESC;


-- MIN() - returns the minimum value in a set.
SELECT  MIN(buyPrice) as min_price
FROM  products;

SELECT productLine, MIN(buyPrice) as min_price
FROM products
GROUP BY productLine
ORDER BY min_price DESC;

-- GROUP_CONCAT() - concatenates a set of strings and returns the concatenated string.
SELECT * FROM customers;
SELECT country, GROUP_CONCAT(DISTINCT customername ORDER BY customerName) as customer_list
FROM customers
GROUP BY country;

-- ============= 2. Comparison Functions ================
-- COALESCE() - allows you to substitute NULL values.
SELECT * FROM customers;
SELECT   customerName, city, COALESCE(state, 'N/A') as State, country
FROM  customers;

-- GREATEST and LEAST - functions to find the greatest and smallest values of two or more columns respectively.

SELECT MAX(buyPrice), MIN(buyPrice) FROM products;

SELECT ProductName, buyPrice, MSRP FROM products;

SELECT productName,buyPrice, MSRP, GREATEST(buyPrice, MSRP), LEAST(buyPrice, MSRP) FROM products;

-- ISNULL() -- takes one argument and tests whether that argument is NULL or not. 
-- The ISNULL function returns 1 if the argument is NULL, otherwise, it returns 0.

SELECT   customerName, city, state,ISNULL(state) as `IsStateNULL`,  country
FROM  customers;

-- ============= 3. Date Functions ================
-- CURDATE() - returns the current date as a value in the 'YYYY-MM-DD' format 

SELECT CURDATE();
SELECT CURRENT_DATE(),CURRENT_DATE, CURDATE();

-- NOW() - returns the current date and time in the configured time zone as a string or a number 
		-- in the 'YYYY-MM-DD HH:MM:DD' format.
        
SELECT NOW();
-- To get in numeric form
SELECT NOW() + 0;

-- SYSDATE()
SELECT SYSDATE();

-- NOW() vs SYSDATE()
SELECT NOW(), SLEEP(5), NOW(); --  constant date and time at which the statement started executing
SELECT SYSDATE(), SLEEP(5), SYSDATE(); -- changes. exact time at which the statement executes

-- DAY() - to get the day of the month of a specified date.
-- MONTH() - returns an integer that represents the month of a specified date value.
-- YEAR() - to get the year out of a date value.

SELECT 
	*,
    CURRENT_DATE(), 	
    DAY(paymentDate),
    MONTH(paymentDate),
    YEAR(paymentDate) 
FROM payments;

-- DATEDIFF - calculates the number of days between two  DATE,  DATETIME, or  TIMESTAMP values.
SELECT * FROM payments;

SELECT 
	*,CURRENT_DATE(), 
	DATEDIFF(CURRENT_DATE,paymentDate) as Days,
    DATEDIFF(CURRENT_DATE,paymentDate)/365 as Years
FROM payments;

-- DATE_ADD - to add a time value to a DATE or DATETIME value.
-- DATE_ADD(start_date, INTERVAL expr unit);

SELECT 
	*,
    CURRENT_DATE(), 	
    DAY(paymentDate),
    MONTH(paymentDate),
    YEAR(paymentDate),
    DATEDIFF(CURRENT_DATE,paymentDate) as Days,
    DATEDIFF(CURRENT_DATE,paymentDate)/365 as Years,
    DATE_ADD(paymentdate, INTERVAL 1 DAY)
FROM payments;



SELECT *, DATE_ADD(paymentdate, INTERVAL 1 DAY) FROM payments;
SELECT *, DATE_ADD(paymentdate, INTERVAL 1 HOUR) FROM payments; -- 2004-10-19 00:00:00 --> 2004-10-19 01:00:00 
SELECT *, DATE_ADD(paymentdate, INTERVAL 1 MINUTE) FROM payments; -- 2004-10-19 00:00:00 --> 2004-10-19 00:01:00 
SELECT *, DATE_ADD(paymentdate, INTERVAL 1 SECOND) FROM payments; -- 2004-10-19 00:00:00 --> 2004-10-19 00:00:01

SELECT *, DATE_ADD(paymentdate, INTERVAL '-1 5' DAY_HOUR) FROM payments; -- 2004-10-19 --> 2004-10-18 --> 2004-10-17 19:00:00
SELECT *, DATE_ADD(paymentdate, INTERVAL '-1 5' HOUR_MINUTE) FROM payments;
SELECT *, DATE_ADD(paymentdate, INTERVAL '-1 5' SECOND_MICROSECOND) FROM payments;

SELECT *, DATE_ADD(paymentdate, INTERVAL 1 WEEK) FROM payments;
SELECT *, DATE_ADD(paymentdate, INTERVAL -1 MONTH) FROM payments;

-- DATE_SUB() - subtracts a time value (or an interval) from a DATE or DATETIME value.

SELECT *, DATE_SUB(paymentdate, INTERVAL 1 DAY) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL 1 HOUR) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL 1 MINUTE) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL 1 SECOND) FROM payments;

SELECT *, DATE_SUB(paymentdate, INTERVAL '-1 5' DAY_HOUR) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL '-1 5' HOUR_MINUTE) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL '-1 5' SECOND_MICROSECOND) FROM payments;

SELECT *, DATE_SUB(paymentdate, INTERVAL 1 WEEK) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL -1 MONTH) FROM payments;


-- DATE_FORMAT - to format the date.
SELECT *, DATE_FORMAT(paymentdate, '%a') FROM payments;
SELECT *, DATE_FORMAT(paymentdate, '%e/%c/%Y') FROM payments;

-- DAYNAME - to get the name of a weekday for a given date.

SELECT *, DAYNAME(paymentdate) FROM payments;

SELECT 
    DAYNAME(orderdate) as weekday, 
    COUNT(*) as  total_orders
FROM  orders
WHERE YEAR(orderdate) = 2004
GROUP BY weekday
ORDER BY total_orders DESC;

-- DAYOFWEEK - returns the weekday index for a date i.e., 1 for Sunday, 2 for Monday, … 7 for Saturday.
SELECT *, 
		DAYNAME(paymentdate),
        DAYOFWEEK(paymentdate) 
FROM payments;

-- EXTRACT() - extracts part of a date.

SELECT *, EXTRACT(WEEK from paymentdate) FROM payments;
SELECT *, EXTRACT(MONTH from paymentdate) FROM payments;
SELECT *, EXTRACT(DAY from paymentdate) FROM payments;
SELECT *, EXTRACT(QUARTER from paymentdate) FROM payments;
SELECT *, EXTRACT(YEAR_MONTH from paymentdate) FROM payments;

SELECT EXTRACT(YEAR FROM CURDATE());

-- LAST_DAY() - takes a DATE or DATETIME value and returns the last day of the month for the input date.
SELECT *, LAST_DAY(paymentdate) FROM payments;

-- STR_TO_DATE() - converts the str string into a date value based on the fmt format string.

SELECT STR_TO_DATE('22,2,2022','%d,%m,%Y');

SELECT STR_TO_DATE('1,1,2022 is the New Year date','%d,%m,%Y');

SELECT STR_TO_DATE('20130101 1130','%Y%m%d %h%i') ; --  refer to DATE_FORMAT function for the list of format specifiers.

-- TIMEDIFF & TIMESTAMPDIFF - returns the difference between two TIME or DATETIME values. 

SELECT TIMEDIFF('12:00:00','10:00:00') as diff;
SELECT TIMEDIFF((NOW() - INTERVAL 1 HOUR), NOW());

SELECT TIMESTAMPDIFF(MONTH, '2012-03-01', NOW());
SELECT TIMESTAMPDIFF(WEEK, '2012-03-01', NOW());
SELECT TIMESTAMPDIFF(DAY, '2012-03-01', NOW());
SELECT TIMESTAMPDIFF(HOUR, '2012-03-01', NOW());
SELECT TIMESTAMPDIFF(MINUTE, '2012-03-01', NOW());
SELECT TIMESTAMPDIFF(SECOND, '2012-03-01', NOW());

-- WEEK - to get the week number for a date.
-- WEEKDAY -- 0 for Monday, 1 for Tuesday, … 6 for Sunday.
-- A year has 365 days for a normal year and 366 days for leap year. 
-- A year is then divided into weeks with each week has exact 7 days. 
-- So for a year we often has 365 / 7 = 52 weeks that range from 1 to 52.

SELECT *, WEEK(paymentdate), WEEKDAY(paymentdate) FROM payments;

-- ============= 4. String Functions ================

-- CONCAT & CONCAT_WS
SELECT CONCAT(contactFirstName,' ',contactLastName) Fullname
FROM customers;

SELECT CONCAT_WS('/',contactFirstName,contactLastName, City, Country) Fullname
FROM customers;

-- String Length
SELECT productName, LENGTH(productName) FROM products;

-- LEFT & RIGHT
SELECT productName, LEFT(productName, 4), RIGHT(productName, 4)  FROM products;

-- INSTR - to return the position of the first occurrence of a string.
SELECT productName, INSTR(productName,'son') FROM products;

-- LOWER & UPPER
SELECT productName, LOWER(productName), UPPER(productName)  FROM products;

-- LTRIM, RTRIM, TRIM
SELECT  
	contactFirstName,
    INSTR(contactFirstName,' '),
    LENGTH(contactFirstName),
    LENGTH(RTRIM(contactFirstName)), -- Trim RIGHT side spaces
    LENGTH(LTRIM(contactFirstName)), -- Trim LEFT side spaces
    LENGTH(TRIM(contactFirstName)) -- Trim spaces on BOTH sides
    FROM Customers WHERE contactFirstName IN ('Carine ','Mary ','Jean');

-- REPLACE
-- REPLACE(str,old_string,new_string);

SELECT productName, REPLACE(productName, 'son', ' S-O-N ') FROM products;

-- SUBSTRING 
SELECT productName, SUBSTRING(productName,5) FROM products;
SELECT productName, SUBSTRING(productName,10) FROM products;
SELECT productName, SUBSTRING(productName,10,15) FROM products;

SELECT productName, SUBSTRING(productName,-7) FROM products;

SELECT SUBSTRING('Harley Davidson', 5,9); -- starting from the 5th position fetch next 9 characters


-- ============= 5. Window Functions ================

DROP TABLE IF EXISTS sales;

CREATE TABLE sales(
    sales_employee VARCHAR(50) NOT NULL,
    fiscal_year INT NOT NULL,
    sale DECIMAL(14,2) NOT NULL,
    PRIMARY KEY(sales_employee,fiscal_year)
);

INSERT INTO sales(sales_employee,fiscal_year,sale)
VALUES('Bob',2016,100),
      ('Bob',2017,150),
      ('Bob',2018,200),
      ('Alice',2016,150),
      ('Alice',2017,100),
      ('Alice',2018,200),
       ('John',2016,200),
      ('John',2017,150),
      ('John',2018,250);

SELECT * FROM sales;

-- ROW_NUMBER
SELECT
    sales_employee,
    fiscal_year,
    sale,
    ROW_NUMBER() OVER() as sales_rowNum
FROM Sales;

SELECT
    sales_employee,
    fiscal_year,
    sale,
    ROW_NUMBER() OVER() as sales_rowNum,
    ROW_NUMBER() OVER(ORDER BY fiscal_year) as sales_rowNum_orderby,
    ROW_NUMBER() OVER(PARTITION BY fiscal_year ORDER BY sale DESC) as sales_rowNum_part_orderby
FROM Sales;


-- RANK & DENSE_RANK
SELECT
    sales_employee,
    fiscal_year,
    sale,
    ROW_NUMBER() OVER(PARTITION BY fiscal_year ORDER BY sale DESC) as sales_rowNum_part_orderby,
    RANK() OVER (PARTITION BY fiscal_year ORDER BY sale DESC) as sales_rank,
    DENSE_RANK() OVER (PARTITION BY fiscal_year ORDER BY sale DESC) as sales_dense_rank    
FROM  sales;

-- NTILE -  divides rows in a sorted partition into a specific number of groups.
SELECT
    sales_employee,
    fiscal_year,
    sale,
	NTILE(3) OVER (ORDER BY sale DESC) as sales_Ntile
FROM  sales;

-- LEAD & LAG
SELECT
    sales_employee,
    fiscal_year,
    sale,
    LEAD(sales_employee, 1) OVER (ORDER BY sale DESC) as lead_sales,
	LEAD(sales_employee, 2) OVER (ORDER BY sale DESC) as lead_sales
FROM  sales;

SELECT
    sales_employee,
    fiscal_year,
    sale,
    LAG(sales_employee, 1) OVER (ORDER BY sale DESC) as lead_sales,
	LAG(sales_employee, 2) OVER (ORDER BY sale DESC) as lead_sales
FROM  sales;

-- ============= 6. Math Functions ================

SELECT 
	*,
	amount*-1,
    ABS(amount*-1),
    CEIL(amount),
    FLOOR(amount),
    ROUND(amount,1),
    MOD(amount,3) -- Returns the remainder of a number divided by another
FROM payments;


USE retail;

/*===============================================
        Stored Procedures & Views   
=================================================*/
-- Change of Delimiter

--  MySQL Workbench or mysql program uses the delimiter (;) to separate statements and executes each statement separately.
-- If you use a MySQL client program to define a stored procedure that contains semicolon characters, the MySQL client program will not treat the whole stored procedure as a single statement, but many statements.
-- Therefore, you must redefine the delimiter temporarily so that you can pass the whole stored procedure to the server as a single statement.

-- The delimiter_character may consist of a single character or multiple characters e.g., // or $$

/*
SYNTAX
--------

DELIMITER $$ 
CREATE PROCEDURE sp_name([param1, param2...])
BEGIN
	statement1;
    statement2;
    ......
END $$
DELIMITER ;
*/

DELIMITER $$ 
CREATE PROCEDURE GetAllCustomers() -- No parameters declared
BEGIN
	SELECT * FROM customers;
END $$
DELIMITER ;

CALL GetAllCustomers;

-- DROP PROCEDURE [IF EXISTS] GetAllCustomers;

-- Using parameters for Stored procedures with the keyword IN

DELIMITER $$ 
CREATE PROCEDURE GetOfficebyCountry (
	IN countryname VARCHAR(100)
)
BEGIN
	SELECT * FROM offices WHERE country = countryname;
END $$
DELIMITER ;

CALL GetOfficebyCountry('UK');
CALL GetOfficebyCountry('USA');


-- OUT parameter to store the value returned by the store procedure

DELIMITER $$
CREATE PROCEDURE GetOrderCountByStatus (
	IN  orderStatus VARCHAR(25),
	OUT total INT
)
BEGIN
	SELECT COUNT(orderNumber)
	INTO total
	FROM orders
	WHERE status = orderStatus;
END $$
DELIMITER ;

CALL GetOrderCountByStatus ('Shipped', @total);
SELECT @total;

-- User-defined variable
SET @i = 'Shipped';
SELECT @i;
CALL GetOrderCountByStatus(@i,@total);
SELECT @total;

SET @i = 'Cancelled';
SELECT @i;
CALL GetOrderCountByStatus(@i,@total);
SELECT @total;

-- Stored Procedure Variables
-- DECLARE variable_name datatype(size) [DEFAULT default_value];


-- ALter the Store Proc
-- Right click and Alter, change the code and Apply.

DELIMITER $$
CREATE PROCEDURE GetOrderCountByStatus (
	IN  orderStatus VARCHAR(25),
	OUT total INT
)
BEGIN
	DECLARE OrderYear INT DEFAULT 2003;
	SET OrderYear = 2004;
	
	SELECT COUNT(orderNumber)
	INTO total
	FROM orders
	WHERE status = orderStatus AND YEAR(orderDate) = OrderYear;
END$$
DELIMITER ;

SET @i = 'Shipped';
SELECT @i;
CALL GetOrderCountByStatus(@i,@total);
SELECT @total;


-- ===============VIEW======================
-- CREATE View 
CREATE VIEW customerPayments
AS 
SELECT 
    customerName, 
    checkNumber, 
    paymentDate, 
    amount
FROM
    customers
INNER JOIN
    payments USING (customerNumber);

SELECT * FROM customerPayments;


CREATE VIEW payments_datecalc
AS
SELECT 
	*,CURRENT_DATE() as TodayDate, 
	DATEDIFF(CURRENT_DATE,paymentDate) as Days,
    DATEDIFF(CURRENT_DATE,paymentDate)/365 as Years
FROM payments;

SELECT * FROM payments_datecalc;

 -- Rename View
RENAME TABLE payments_datecalc TO payments_datecalc_1;
RENAME TABLE payments_datecalc_1 TO payments_datecalc;

 -- DROP View
 -- DROP VIEW [IF EXISTS] customerPayments;
 
 
 
 
 
/*******************CASE STUDY**************************/

/* SYNTAX

SELECT [COULLM NAMES] ,
CASE
WHEN [COLUMN_NAME CONDITION] THEN ' WHAT TO BE PRINTED IF TRUE'
ELSE
' WHAT TO BE PRINTED IF FALSE'
END
FROM TABLE_NAME*/


 select customerName, case when creditLimit>10000  then 'LARGE' ELSE 'SMALL'  END from customers;
 
 
/*=================================end====================================================================================*/