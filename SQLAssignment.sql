--1.0 Setting up Oracle Chinook
--In this section you will begin the process of working with the Oracle Chinook database
--Task – Open the Chinook_Oracle.sql file and execute the scripts within.
--2.0 SQL Queries
--In this section you will be performing various queries against the Oracle Chinook database.
--2.1 SELECT
--Task – Select all records from the Employee table.
--Task – Select all records from the Employee table where last name is King.
--Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM employee;
SELECT * FROM EMPLOYEE
WHERE lastname = 'King';
SELECT * FROM EMPLOYEE WHERE firstname ='Andrew' AND reportsto = null;

--2.2 ORDER BY
--Task – Select all albums in Album table and sort result set in descending order by title.
--Task – Select first name from Customer and sort result set in ascending order by city
SELECT * FROM ALBUM ORDER BY TITLE Desc;

SELECT FIRSTNAME FROM CUSTOMER
ORDER BY CITY;
--2.3 INSERT INTO
--Task – Insert two new records into Genre table
--Task – Insert two new records into Employee table
--Task – Insert two new records into Customer table

/*Creating two new records for Genre Table*/
INSERT INTO GENRE(genreid, NAME)
VALUES (26, 'Neo Soul');
INSERT INTO GENRE(genreid, NAME)
VALUES(27, 'Trip Hop');

/*Creating two new records for Employee Table*/
INSERT INTO EMPLOYEE(employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
VALUES(9, 'Roberts', 'Julia', 'Sales Manager', 1, '15-Dec-92', '18-Jul-10', '222 maple street', 'Edmonton', 'AB', 'Canada', 'T5K 2N1', '1 (780) 255-9555', '1 (780) 255- 9292', 'JuliaRoberts@gmail.com');
INSERT INTO EMPLOYEE(employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
VALUES(10, 'Cambridge', 'Calvin', 'Sales Manager', 1, '06-Jul-00', '02-Mar-18','780 canada dr', 'Edmonton', 'AB', 'Canada', 'T5B 789', '1 (780) 446-7878', '1 (780) 446-5400', 'CambridgeCalvin@gmail.com');

/*Creating two new records for Customer Table*/
/*Most info is of type VARCHAR*/
/*customerid and supportid is type int*/
INSERT INTO Customer (customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid)
VALUES(60, 'Kamilah', 'Carlisle', 'Revature', '12345 Business Lane', 'Reston', 'Va', 'USA', '20101', '+1 (222) 222-2222', '+1 (222) 222-2233', 'nunya@yahoo.com', 5);
INSERT INTO Customer (customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid)
VALUES(61, 'Kobe', 'Bryant', 'NBA', '999 Hollywood Lane', 'Los Angelos', 'CA', 'USA', '789789', '+1 (510) 777-7777', '+1 (510) 777-7788', 'lakersRegect@hotmail.com', 4);
--2.4 UPDATE
--Task – Update Aaron Mitchell in Customer table to Robert Walter
--Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE Customer
SET firstname = 'Robert', lastname = 'Walker'
WHERE firstname = 'Aaron' AND lastname = 'Mitchell';

UPDATE Artist
SET name = 'CCR'
WHERE name = 'Creedence Clearwater Revival';
--2.5 LIKE
--Task – Select all invoices with a billing address like “T%”
SELECT * FROM invoice WHERE billingaddress = 'T%';
--2.6 BETWEEN
--Task – Select all invoices that have a total between 15 and 50
--Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM invoice WHERE 15 < total AND total < 50;
/*error here*/
SELECT * FROM employee WHERE 01-June-03 < hiredate AND hiredate < 01-Mar-04;
--2.7 DELETE
--Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
/*Customer id = 32 which is a primary key for invoice customer id, Customer id is not nullable*/
/*error: 0 rows deleted*/

--3.0 SQL Functions
--In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
--3.1 System Defined Functions
--Task – Create a function that returns the current time.
--Task – create a function that returns the length of a mediatype from the mediatype table

ALTER TABLE Invoice DROP Constraint FK_InvoiceCustomerId;
ALTER TABLE Invoice ADD Constraint FK_InvoiceCustomerId
FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId)
ON DELETE CASCADE;
DELETE CASCADE Customer WHERE firstname = 'Robert' AND lastname = 'Walter';

CREATE OR REPLACE FUNCTION getCurrentTime 
    RETURN timestamp as

    begin 
    return getcurrenttime;
    end;
    


CREATE OR REPLACE FUNCTION getLength
    RETURN number is
    mediaLength number;
    begin
    SELECT length(name) INTO mediaLength FROM mediatype;
    return mediaLength;
    end;

--3.2 System Defined Aggregate Functions
--Task – Create a function that returns the average total of all invoices
--Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION getTotalAverage
    return number is totalAverage number;
    begin 
    SELECT AVG(total) INTO totalAverage FROM invoice;
    return totalAverage;
    end;
    
CREATE OR REPLACE FUNCTION mostExpensive
    return number is maxCost number;
    begin
    SELECT MAX(unitprice) INTO maxCost FROM track;
    return maxCost;
    end;
    
--3.3 User Defined Scalar Functions
--Task – Create a function that returns the average price of invoiceline items in the invoiceline table
    CREATE OR REPLACE FUNCTION getAveragePrice
    return number is averagePrice number;
    begin
    SELECT AVG(unitprice) INTO averagePrice FROM invoiceline;
    end;
--3.4 User Defined Table Valued Functions
--Task – Create a function that returns all employees who are born after 1968.
    
    CREATE OR REPLACE FUNCTION targetEmployees
    declare year datereturn varchar2 is employeeReturned varchar2
    begin
    select firstname, lastname from employee
    where extract(YEAR FROM birthdate) > 1968 into employeeReturned;
    end;
    
    
--4.0 Stored Procedures
-- In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
--4.1 Basic Stored Procedure
--Task – Create a stored procedure that selects the first and last names of all the employees.
    CREATE OR REPLACE PROCEDURE selectNames
    as
    begin
        SELECT firstname, lastname FROM Employee;
    end;
--4.2 Stored Procedure Input Parameters
--Task – Create a stored procedure that updates the personal information of an employee.
/*Assuming personal info is everything except employee id, title, hiredate, and who the employee reports to*/
CREATE OR REPLACE PROCEDURE employeeUpdate (updateLastName IN varchar2, updateFirstName IN varchar2,updateBirthDate IN date, 
                                            updateAddress IN varchar2, updateCity IN varchar2, updateState IN varchar2, 
                                            updateCounty IN varchar2, updateZip IN varchar2, updatePhone IN varchar2, 
                                            updatFax IN varchar2, updateEmail IN varchar2)
    as
    begin 
    insert into employee (lastname, firstname, birthdate, address, city, 
                        state, county, postalcode, phone, fax, email)
            
            VALUES(updateLastName, updateFirstName, updateBirthDate, updateAddress, updateCity, updateState, 
            updateCounty, updateZip, updatePhone, updatFax, updateEmail);
    
    end;
--Task – Create a stored procedure that returns the managers of an employee.
--4.3 Stored Procedure Output Parameters
    CREATE OR REPLACE PROCEDURE returnManager(employeeName in varchar2, manager OUT varchar2)
        is
        begin
        select reportsto from employee where name = employeeName;
        select name from employee where reportsto = employeeid;
        return name = manager;
        end;
--Task – Create a stored procedure that returns the name and company of a customer.
--6.0 Triggers
--In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
--6.1 AFTER/FOR
--Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
create or replace trigger afterEmployeeInsert
 after insert on employee for each row
 begin
    insert into employee(employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, 
                        state, county, postalcode, phone, fax, email)
                values (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, 
                        state, county, postalcode, phone, fax, email);
 end;
 
--Task – Create an after update trigger on the album table that fires after a row is inserted in the table
create or replace trigger afterAlbumInsert
 after update on album for each row
 begin
    insert into employee(employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, 
                        state, county, postalcode, phone, fax, email)
    values (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, 
                        state, county, postalcode, phone, fax, email);
 end;
--Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
    create or replace trigger afterCustomerDelete
    after delete on customer for each row
    begin
        delete from customer;
    end;
--Task – Create a trigger that restricts the deletion of any invoice that is priced over 50 dollars.
create or replace trigger invoiceOver50
 before delete on invoice for each row
 begin
    select * from invoice;
    if (data > 50) then
        RAISE_APPLICATION_ERROR (-20000, 'Cannot delete any invoice over $50');
    end if;
   
 end;
--7.0 JOINS
--In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
--7.1 INNER
--Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
    SELECT firstname, lastname, invoiceid FROM CUSTOMER c
    inner join invoice i ON (c.customerid = i.customerid);
    
--7.2 OUTER
--Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
    SELECT customerid, firstname, lastname, invoiceid, total FROM CUSTOMER c
    full outer join invoice i ON (c.customerid = i.customerid);
    
--7.3 RIGHT
--Task – Create a right join that joins album and artist specifying artist name and title.
    SELECT name, title FROM album a
    right join artist ar ON (ar.artistid = a.artistid);
--7.4 CROSS
--Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
    SELECT * FROM artist ar
    cross join album a WHERE a.artistid = ar.artistid
    ORDER BY ar.name;
--7.5 SELF
--Task – Perform a self-join on the employee table, joining on the reportsto column.
    SELECT e1.firstname as firstname1, e1.lastname  as lastname1, e2.firstname as firstname2, e2.lastname as lastname2
    FROM EMPLOYEE e1, EMPLOYEE e2
    WHERE e1.reportsto = e2.employeeid;
--
--14
