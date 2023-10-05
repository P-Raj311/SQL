USE dmart;
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
SELECT * FROM products WHERE productline = 'Motorcycles'; -- Error doesn't match value count extra __ Stock value added 

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
SET SQL_SAFE_UPDATES=0; -- ERROR 1175 safe update mode
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
VALUES(10429,
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
VALUES(10429,'S18_1749', 30, '136', 1),
      (10429,'S18_2248', 50, '55.09', 2);

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
-- Banking transactions it will be very useful
SELECT * FROM orders WHERE orderNumber = 10427;
SELECT * FROM orderdetails WHERE orderNumber = 10427;


SELECT * FROM orderdetails WHERE orderNumber = 10426;
START TRANSACTION;
UPDATE orderdetails SET priceEach = 100 WHERE orderNumber = 10426;
SELECT * FROM orderdetails WHERE orderNumber = 10426;
ROLLBACK;
SELECT * FROM orderdetails WHERE orderNumber = 10426;

SHOW CREATE TABLE  products_motorcycles;
/*
------------------- Database-Level ---------------------------------------------
DROP DATABASE databaseName                 -- Deletes the database (irrecoverable!)
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


