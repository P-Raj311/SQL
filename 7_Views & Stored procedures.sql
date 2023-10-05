USE dmart;
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
 
 
 
 
 
/******************* CASE STUDY **************************/

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
