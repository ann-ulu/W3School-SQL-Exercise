# W3School-SQL-Exercise
This exercise is designed to enhance SQL querying skills using the W3Schools sample database. 


## Introduction
This exercise is a personal endeavor to enhance SQL skills by tackling 15 questions using the W3Schools sample database tables. With tables covering essential aspects such as Customers, Categories, Employees, and more, this exercise aims to provide hands-on experience in database querying.

Project Description:
The database includes tables such as Customers (91 records), Categories (8 records), Employees (10 records), and more. To get started, I created a database named "wschool" and imported the tables into SQL Server Management Studio (SSMS). With the database set up, I proceeded to answer 15 questions, exploring various aspects of data manipulation and retrieval.
[link to w3school DB](https://www.w3schools.com/sql/trysql.asp?filename=trysql_editor)

```
--1.	How many customers do we have in each country?
SELECT Country, COUNT(CustomerID) AS TotalCustomer
FROM Customers
GROUP BY Country


--2.	What is the number of orders per customer?
SELECT o.CustomerID 
,c.ContactName
, COUNT(o.OrderID) AS TotalOrder
FROM Orders AS o
INNER JOIN customers AS c
ON c.CustomerID = o.CustomerID
GROUP BY o.CustomerID, c.ContactName


--3.	List of Customers who placed orders in the year 1996.
SELECT CustomerID, CustomerName, Yearr FROM (SELECT CustomerID, CustomerName, DATENAME(YEAR, OrderDate) AS Yearr FROM
(SELECT
      o.CustomerID
     ,c.CustomerName
      ,o.OrderDate
  FROM orders AS o
  LEFT JOIN customers AS c
  ON c.CustomerID = o.CustomerID
  WHERE OrderDate BETWEEN '1996-01-01' AND '1996-12-31') AS Subquery
  GROUP BY CustomerID, CustomerName, OrderDate) AS Subquerytwo
  GROUP BY CustomerID, CustomerName, Yearr

```

See the attached file for answers to the each exercises
