/*=====================================
	 Managing Databases 
    
    DDL commands - CREATE, DROP
=======================================*/

/***1.1 Creating & Selecting a MySQL Database***/

-- List the databases that are available on your server
SHOW DATABASES; -- end your code with semi-colon

-- Ctrl+Enter to execute online of code; Ctrl+Shift+Enter to execute mutiple selected lines of code.
-- Use Lower case for tables and databases
-- use Upper case for KEYWORDS

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

# CREATE DATABASE testdb; -- Error

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

- Numeric data types == # INT,FLOAT,DECIMAL(Precison,scale)
- Date and time data types == # DATETIME,TIMESTAMP,YEAR,MONTH,DAY
- String data types == # VARCHAR
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
			
> Referential integrity - It is the relationship between two tables.Becuase in each table in a database must have a primary key,
                          this primary key can appear in other tables because of its relationship to data within those tables.
                          when a primary key from one table appears in another table it is called foreign key.
                          
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
         
============================ DDL (Data Definition Language) ===================================
DDL or Data Definition Language actually consists of the SQL commands that can be used to define the database schema. It simply deals with descriptions of the database schema and is used to create and modify the structure of database objects in the database. DDL is a set of SQL commands used to create, modify, and delete database structures but not data. These commands are normally not used by a general user, who should be accessing the database via an application.

=========   List of DDL commands: 
CREATE: This command is used to create the database or its objects (like table, index, function, views, store procedure, and triggers).
DROP: This command is used to delete objects from the database.
ALTER: This is used to alter the structure of the database.
TRUNCATE: This is used to remove all records from a table, including all spaces allocated for the records are removed.
COMMENT: This is used to add comments to the data dictionary.
RENAME: This is used to rename an object existing in the database.


============================ DQL (Data Query Language) ==============================

DQL statements are used for performing queries on the data within schema objects. 
The purpose of the DQL Command is to get some schema relation based on the query passed to it. 
We can define DQL as follows it is a component of SQL statement that allows getting data from the database and imposing order upon it. 
It includes the SELECT statement. This command allows getting the data out of the database to perform operations with it. 
When a SELECT is fired against a table or tables the result is compiled into a further temporary table, 
which is displayed or perhaps received by the program i.e. a front-end.

==========  List of DQL: 
SELECT: It is used to retrieve data from the database.


============================ DML(Data Manipulation Language) =====================================
The SQL commands that deal with the manipulation of data present in the database belong to DML or Data Manipulation Language and
 this includes most of the SQL statements.
 It is the component of the SQL statement that controls access to data and to the database. Basically, DCL statements are grouped with DML statements.

========== List of DML commands: 
INSERT: It is used to insert data into a table.
UPDATE: It is used to update existing data within a table.
DELETE: It is used to delete records from a database table.
LOCK: Table control concurrency.


============================ DCL (Data Control Language) ===========================
DCL includes commands such as GRANT and REVOKE which mainly deal with the rights, permissions, and other controls of the database system. 

============ List of  DCL commands: 

GRANT: This command gives users access privileges to the database.
REVOKE: This command withdraws the user’s access privileges given by using the GRANT command.

============================ TCL (Transaction Control Language) =======================
Transactions group a set of tasks into a single execution unit. Each transaction begins with a specific task and ends when all the tasks in the group successfully complete. If any of the tasks fail, the transaction fails. Therefore, a transaction has only two results: success or failure. You can explore more about transactions here. Hence, the following TCL commands are used to control the execution of a transaction: 

BEGIN: Opens a Transaction.
COMMIT: Commits a Transaction.
ROLLBACK: Rollbacks a transaction in case of any error occurs.
SAVEPOINT: Sets a save point within a transaction.    
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


/* 
=================== ACID Properties =================
refer website
Java-T-point 
*/

CREATE DATABASE practice;

DROP DATABASE practice;

USE practice;

CREATE TABLE transactions(
transaction_ID INT,
transaction_date DATETIME,
customer_id INT,
Product_id INT,
Quantity INT,
Tax DECIMAL(5,2),
price DECIMAL (5,2),
IScustomermembership BIT,
Comments VARCHAR(500)
);

DESC transactions;
-- Both are same
DESCRIBE transactions;

SHOW CREATE TABLE transactions; -- Table Script
-- DDL Command # DROP
DROP table if exists transactions;

-- DDL command -- # CREATE
CREATE TABLE IF NOT EXISTS transactions(
transaction_ID INT,
transaction_date DATETIME,
customer_id INT,
Product_id INT,
Quantity INT,
Tax DECIMAL(5,2),
price DECIMAL (5,2),
IScustomermembership BIT,
Comments VARCHAR(500)
);

-- DML Command # SELECT
SELECT * FROM transactions;

-- DML Command # INSERT
INSERT INTO transactions(
transaction_ID,transaction_date,customer_id,Product_id,Quantity,Tax,price,IScustomermembership,Comments)
VALUES 
(1,'2023-05-17 12:10:55',101,206,5,0.5,120,1,'Summer Sale');

SELECT * FROM transactions;

INSERT INTO transactions 
(transaction_id,transaction_date,Customer_id,Product_id,quantity,tax,price,isCustomerMembership,comments)
VALUES
(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

-- Now Drop the table and Re_Create with Constraints

DROP TABLE IF EXISTS transactions;

CREATE TABLE IF NOT EXISTS transactions(
transaction_ID INT AUTO_INCREMENT PRIMARY KEY, -- it will automatically done the numbering
transaction_date DATETIME DEFAULT NOW(), -- Fill some default values instead of giving values 
customer_id INT NOT NULL,
Product_id INT NOT NULL,
Quantity INT,
Tax DECIMAL(5,2),
price DECIMAL (5,2),
IScustomermembership BIT DEFAULT 0,
Comments VARCHAR(500) DEFAULT 'N/A'
);

SELECT * FROM transactions;
 DESC transactions;
INSERT INTO transactions
(transaction_date,customer_id,Product_id,Quantity,Tax,price,IScustomermembership,Comments)
VALUES 
('2023-05-17 12:10:55',101,206,5,0.5,120,1,'Summer Sale');

INSERT INTO transactions
(customer_id,Product_id,Quantity,Tax,price)
VALUES 
(102,226,5,0.5,120);

SELECT * FROM transactions;

-- Use ALTER to MODIFY the columns
-- Make Quantity NOT NULL
-- add a check on the tax  i.e Tax>=0 & Make it NOT NULL
-- Change the datatype of price ,increase the precision and scale
-- Difference between Alter and UPDATE Geeks for geeks website

ALTER TABLE transactions 
MODIFY Quantity INT NOT NULL;

DESC transactions;
ALTER TABLE transactions
MODIFY tax DECIMAL (3,2) ; -- check this

DESC transactions;
ALTER TABLE transactions
MODIFY price decimal(10,4);

SELECT * FROM transactions;

-- Now check the constraints by inserting some data
INSERT INTO transactions
(customer_id,Product_id,Quantity,Tax,price)
VALUES 
(NULL,226,5,0.5,120); -- inserting NULL in customer_ID

INSERT INTO transactions
(customer_id,Product_id,Quantity,Tax,price)
VALUES 
(102,226,NULL,0.5,120);

INSERT INTO transactions
(customer_id,Product_id,Quantity,Tax,price)
VALUES 
(102,226,5,0,120); -- checking tax=0
SELECT * FROM transactions;

SET SQL_SAFE_UPDATES=0; -- ERROR 1175 safe update mode

-- Use UPDATE to modify the records
UPDATE transactions SET tax=0.2; -- UPDATE WITHOUT a WHERE Condition
SELECT * FROM transactions;
-- Always use WHERE clause in the update and use select to check the rows 
UPDATE transactions SET tax=0.5 WHERE quantity >25;

INSERT INTO transactions
(customer_id,Product_id,Quantity,Tax,price)
VALUES 
(102,226,44,0.2,120);

SELECT * FROM transactions WHERE quantity >25;

-- Filter the columns or SELECT	on required columns

SELECT transaction_id, quantity ,Tax FROM transactions;
SELECT transaction_id, quantity ,Tax FROM transactions WHERE quantity >25 ; 

-- ALTER examples
-- ADD a new column using ALTER
ALTER TABLE transactions ADD Discounts DECIMAL(5,2)  DEFAULT 0 ;
SELECT * FROM transactions;
 
-- ADD a column after price 
ALTER TABLE transactions ADD Discounts DECIMAL(5,2)  DEFAULT 0 AFTER price;

-- DROP a column
ALTER TABLE transactions DROP discount;
ALTER TABLE transactions DROP discounts;
SELECT * FROM transactions;

-- Modify a column using ALTER
ALTER TABLE transactions MODIFY discounts DECIMAL(5,2) DEFAULT 0.02;
SELECT * FROM transactions;

-- DELETE a record from a table
-- Always use WHERE clause with DELETE otherwise it will delete all records
DELETE FROM transactions;
SELECT * FROM transactions;
 
-- INSERT multiple rows into the TABLE
INSERT INTO transactions
(customer_id,Product_id,Quantity,Tax,price)
VALUES 
(104,236,34,0.9,110),
(112,126,24,0.12,400),
(108,226,54,0.8,170),
(102,226,44,0.2,180),
(102,2286,74,0.2,520),
(102,226,4,0.2,1250),
(62,256,11,0.2,120),
(102,226,14,0.2,150),
(192,226,44,0.2,120),
(102,286,564,0.08,100);

SELECT * FROM transactions; -- Transaction_id not starting from 1

-- DELETE vs TRUNCATE

DELETE FROM transactions; -- this will DELETE all records but it will NOT reset the AUTO_INCREMENT column to 1
INSERT INTO transactions
(customer_id,Product_id,Quantity,Tax,price)
VALUES 
(104,236,34,0.9,110),
(112,126,24,0.12,400),
(108,226,54,0.8,170),
(102,226,44,0.2,180),
(102,2286,74,0.2,520),
(102,226,4,0.2,1250),
(62,256,11,0.2,120),
(102,226,14,0.2,150),
(192,226,44,0.2,120),
(102,286,564,0.08,100);

SELECT * FROM transactions; 
-- DDL Command TRUNCATE
TRUNCATE TABLE transactions; -- this will DELETE all records but it will reset the AUTO_INCREMENT column to 1
INSERT INTO transactions
(customer_id,Product_id,Quantity,Tax,price)
VALUES 
(104,236,34,0.9,110),
(112,126,24,0.12,400),
(108,226,54,0.8,170),
(102,226,44,0.2,180),
(102,2286,74,0.2,520),
(102,226,4,0.2,1250),
(62,256,11,0.2,120),
(102,226,14,0.2,150),
(192,226,44,0.2,120),
(102,286,564,0.08,100);

SELECT * FROM transactions; 

-- DELETE with where Clause
SELECT * FROM transactions WHERE quantity < 20;
DELETE FROM transactions WHERE quantity < 20;

-- RENAME the TABLE
RENAME TABLE transactions to transactions_old;

-- How to create a copy of a table
CREATE TABLE transactions_new LIKE transactions_old;
SELECT * FROM transactions_new;
INSERT INTO transactions_new
SELECT * FROM transactions_old;

-- Drop a table from DB
DROP TABLE transactions_old;

/* Dropping of foreign keys
parent tables
child tables

Get all the foreign key names
-- Prepare Create Script
-- Prepare Drop Script

1. Drop all the FK
2. Do your changes
3. Create all Fk

-------------------------*/
