                                            --W3SCHOOL EXERCISE(15 QUESTIONS)

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


--4.	Customer details of the 5 customers with the highest number of orders.
SELECT TOP(5) WITH TIES o.CustomerID, COUNT(o.OrderID) AS TotalNumberofOrders, c.CustomerName,
c.ContactName, c.Address, c.City, c.PostalCode, c.Country
FROM Orders AS o
LEFT JOIN Customers AS c
ON c.CustomerID = o.CustomerID
GROUP BY o.CustomerID, c.CustomerName, c.ContactName , c.Address, c.City, c.PostalCode,
c.Country
ORDER BY TotalNumberofOrders DESC



--5.	Customer details of the top 5 customers by total amount spent.
SELECT TOP(5)
      o.CustomerID
	 ,c.CustomerName
	 ,c.ContactName
	 ,c.Address
	 ,c.City
	 ,c.PostalCode
	 ,c.Country
	 ,SUM(od.Quantity * p.Price) AS Amount
  FROM orders AS o
  LEFT JOIN customers AS c
  ON c.CustomerID = o.CustomerID
  LEFT JOIN order_details AS od
ON od.OrderID = o.OrderID
LEFT JOIN products AS p
ON p.ProductID = od.ProductID
GROUP BY 
o.CustomerID,
c.CustomerName
,c.ContactName
,c.Address
,c.City
,c.PostalCode
,c.Country
ORDER BY Amount DESC



--6.	What Category of products is the most popular with customers?
SELECT ca.CategoryName, SUM(od.Quantity) AS TotalOrderQuantity
FROM categories AS ca
RIGHT JOIN products AS p
ON p.CategoryID = ca.CategoryID
LEFT JOIN order_details AS od
ON od.ProductID = p.ProductID
GROUP BY CategoryName



--7.	What is the most purchased item on the product list and how many times was it purchased?
select TOP(2) p.ProductName, SUM(od.Quantity) AS TotalQuantityOrdered from products AS p
RIGHT JOIN  order_details AS od
ON od.ProductID = p.ProductID
GROUP BY ProductName
ORDER BY TotalQuantityOrdered DESC



--8.	Management wants to see the value and volume of products ordered per month in descending order.
WITH ProductOrderDetails
 AS
 (select DATENAME(MONTH, o.OrderDate) AS MonthDate, od.Quantity AS Volume , p.Price*od.Quantity AS Value_Amount
  from order_details AS od
  LEFT JOIN orders AS o
  ON o.OrderID = od.OrderID
  LEFT JOIN products AS p
  ON p.ProductID = od.ProductID)
  
  SELECT MonthDate, SUM(Volume) AS Volume, SUM(Value_Amount) AS Value_Amount
  FROM ProductOrderDetails
  GROUP BY MonthDate
  ORDER BY Volume DESC



--9.	Management wants to know the total average sales per month.
WITH ProductOrderDetails
 AS
 (select DATENAME(MONTH, o.OrderDate) AS MonthDate, od.Quantity AS Volume,  p.Price*od.Quantity AS Value_Amount
  from order_details AS od
  LEFT JOIN orders AS o
  ON o.OrderID = od.OrderID
  LEFT JOIN products AS p
  ON p.ProductID = od.ProductID)

  SELECT MonthDate, ROUND(AVG(Value_Amount),2) AS TotalAverageSales
  FROM ProductOrderDetails
  GROUP BY MonthDate



--10.	Details of the company’s biggest supplier?
WITH SupplierQuantity
AS
(SELECT  
 p.SupplierID
,s.SupplierName, s.ContactName, s.City, s.PostalCode, s.Country, s.Phone, s.Address
,od.Quantity
FROM order_details AS od
LEFT JOIN products AS p
ON p.ProductID = od.ProductID
LEFT JOIN suppliers AS s
ON s.SupplierID = p.SupplierID)

SELECT TOP(3) SupplierID, SupplierName, ContactName, City, PostalCode, Country, Phone, Address, SUM(Quantity) AS Quantity
FROM SupplierQuantity
GROUP BY SupplierID, SupplierName, ContactName, City, PostalCode, Country, Phone, Address
ORDER BY Quantity DESC



--11.	Which Employee had the highest sales in Oct 1996?
WITH employeesalesdetails
as
(SELECT o.EmployeeID,  e.FirstName, e.LastName, 
 o.OrderDate
,p.ProductName, p.Price * od.Quantity AS Sales
FROM employees AS e
RIGHT JOIN orders AS o
ON o.EmployeeID = e.EmployeeID
RIGHT JOIN order_details AS od
ON od.OrderID = o.OrderID
LEFT JOIN products AS p
ON p.ProductID = od.ProductID
WHERE o.OrderDate BETWEEN '1996-01-01' AND '1996-12-31')



SELECT EmployeeID, FirstName, LastName, SUM(Sales) AS Sales FROM employeesalesdetails
WHERE OrderDate BETWEEN '1996-10-01' AND '1996-10-31'
GROUP BY EmployeeID, FirstName, LastName
ORDER BY Sales DESC



--12.	If for $10 spent, a customer gets 2 points,  Tofu and Chocolade has a 2x point multiplier, Geitost and Guaraná Fantástica have a 3 times point multiplier. How many points would each customer have?
WITH customerspoint AS (
    SELECT 
        o.CustomerID,
        c.CustomerName,
        c.ContactName,
        p.ProductName,
        SUM(od.Quantity*p.Price) AS AmountSpent
    FROM 
        order_details AS od
    LEFT JOIN 
    products AS p ON p.ProductID = od.ProductID
    LEFT JOIN 
        orders AS o ON o.OrderID = od.OrderID
    LEFT JOIN 
        customers AS c ON c.CustomerID = o.CustomerID
    GROUP BY 
        o.CustomerID, c.CustomerName, c.ContactName, p.ProductName)


SELECT 
    CustomerID,
    CustomerName,
    SUM(AmountSpent) AS TotalAmountSpent,
    SUM(Points) AS TotalPoints
FROM (
    SELECT 
        CustomerID, 
        CustomerName, 
        ProductName, 
        SUM(AmountSpent) AS AmountSpent,
        CASE
      WHEN ProductName = 'Tofu' THEN CAST(ROUND(SUM(AmountSpent)/10,0) * 2 AS INT) * 2 
    WHEN ProductName = 'Chocolade' THEN CAST(ROUND(SUM(AmountSpent)/10,0) * 2 AS INT) * 2 
  WHEN ProductName = 'Geitost' THEN CAST(ROUND(SUM(AmountSpent)/10,0) * 2 AS INT) * 3
WHEN ProductName = 'Guaraná Fantástica' THEN CAST(ROUND(SUM(AmountSpent)/10,0) * 2 AS INT) * 3
            ELSE CAST(ROUND(SUM(AmountSpent)/10,0) * 2 AS INT) 
        END AS Points
    FROM 
        customerspoint
    GROUP BY 
        CustomerID, 
        CustomerName, 
        ProductName
) 
AS subquery
GROUP BY 
    CustomerID, 
   CustomerName;


--13.	What is the total revenue generated by each product month on month
WITH RevenueByMonth
AS
(SELECT DATENAME(MONTH, o.OrderDate) AS MonthDate
, p.ProductName, od.Quantity*p.Price AS TotalRevenue
FROM order_details AS od
LEFT JOIN orders AS o
ON o.OrderID = od.OrderID
LEFT JOIN products AS p
ON p.ProductID = od.ProductID)

select MonthDate, ProductName, SUM(TotalRevenue) AS TotalRevenue
from RevenueByMonth
GROUP BY ProductName, MonthDate
ORDER BY ProductName



--14.	On What Day of the Week do we have the highest number of orders?
SELECT DayInfo, COUNT(Orderss) AS Orderss FROM
(SELECT  
DATENAME(WEEKDAY, OrderDate) AS DayInfo
,OrderID AS Orderss
FROM orders)
AS Subquery
GROUP BY DayInfo
ORDER BY Orderss DESC



--15.	How many orders were shipped by each of the shippers year on year
WITH OrderShipped
AS
(select DATENAME(YEAR, o.OrderDate) AS DateYear
,s.ShipperName
, od.Quantity AS OrderQuantity
from orders AS o
LEFT JOIN shippers AS s
ON o.ShipperID = s.ShipperID
RIGHT JOIN order_details AS od
ON o.OrderID = od.OrderID)

SELECT DateYear, ShipperName, SUM(OrderQuantity) AS OrdersShipped FROM OrderShipped
GROUP BY DateYear, ShipperName