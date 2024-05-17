CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Country VARCHAR(50)
);

INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES
(1, 'John Doe', 'USA'),
(2, 'Jane Smith', 'Canada'),
(3, 'Emily Jones', 'UK'),
(4, 'Chris Brown', 'USA');

CREATE TABLE IF NOT EXISTS Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    Category VARCHAR(50)
);

INSERT INTO Products (ProductID, ProductName, Price, Category) VALUES
(1, 'Laptop', 1200.00, 'Electronics'),
(2, 'Smartphone', 700.00, 'Electronics'),
(3, 'Book', 15.00, 'Books'),
(4, 'Table', 150.00, 'Furniture');

CREATE TABLE IF NOT EXISTS Transactions (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    TransactionDate DATE
);

INSERT INTO Transactions (TransactionID, CustomerID, ProductID, Quantity, TransactionDate) VALUES
(1, 1, 1, 1, '2023-03-15'),
(2, 2, 2, 1, '2023-03-15'),
(3, 3, 3, 2, '2023-03-16'),
(4, 4, 4, 3, '2023-03-17'),
(5, 1, 3, 1, '2023-03-18');

SELECT * FROM Customers;
SELECT * FROM Transactions;
SELECT * FROM Products;


--1.	What is the total revenue generated from each product category?

SELECT 
    p.Category,
    SUM (p.Price * t.Quantity) AS TotalRevenue 
FROM 
    Products p
JOIN 
    Transactions t ON p.ProductID = t.ProductID
GROUP BY 
    p.Category
ORDER BY 
    TotalRevenue DESC; -- organizing according to the highest revenue made

--Summary: 
--Hence, we can see in the above screenshot output for the given query above that Electronics has the 
--highest total revenue amount “1900” followed by Furniture and then Books is the lowest.


--2.	Which customer made the highest number of transactions?

SELECT 
     c.Customername,
     COUNT(t.Transactionid) AS Number_of_transaction 
FROM 
     Transactions t
JOIN 
     customers c ON c.customerid = t.customerid
GROUP BY 
     c.Customername
ORDER BY 
     Number_of_transaction DESC 
LIMIT 1;

--Summary: 
--Hence, Customer John Doe made the highest transaction as the screenshot output above.

--3.	List products that have never been sold.

SELECT p.productname 
FROM 
       Products p
JOIN 
       Transactions t ON p.ProductID = t.ProductID
WHERE t.ProductID IS NULL; 

--Summary:
--Hence, we can see above there is no such products that have not been involved in any transactions.

--4.	What is the average transaction value for each country?

SELECT 
    c.Country,
    AVG (p.Price * t.Quantity) AS AverageTransactionValue  
FROM 
    Transactions t
JOIN 
    Customers c ON t.CustomerID = c.CustomerID-- Joining the Customers table based on CustomerID
JOIN 
    Products p ON t.ProductID = p.ProductID-- Joining the Products table based on ProductID
GROUP BY 
    c.Country
ORDER BY
    AverageTransactionValue DESC; 
	
--Summary: 
--Hence, as we can find in the above picture Canada is having the highest average value followed by USA and then UK.

--5.	Which product category is most popular in terms of quantity sold?

SELECT p.productname, 
       max(t.quantity) as highest_quantity_sold
FROM 
    Products p
JOIN 
    Transactions t ON t.ProductID = p.ProductID
GROUP BY 
    p.productname
ORDER BY 
    highest_quantity_sold DESC
LIMIT 1;

--Summary: 
--Hence, Table is having the highest product quantity sold.

--6.	Identify customers who have spent more than $1000 in total.

SELECT c.Customername, 
       SUM (t.Quantity * p.price) AS TotalSpent 
FROM Customers c
JOIN 
     Transactions t ON t.CustomerID = c.CustomerID
JOIN 
     Products p ON t.ProductID = p.ProductID
GROUP BY 
     c.Customername
HAVING 
     SUM (t.Quantity * p.price) > 1000; --filtering using having clause to filter the grouped results

--Summary: 
--Hence, by calculating the total spent we can able to see John Doe have the maximum total spent i.e. 1215.

--7.	How many transactions involved purchasing more than one item?

SELECT COUNT (*) AS TransactionsWithMultipleItems
FROM 
     Transactions
WHERE 
     Quantity > 1;
	 
--Summary: 
--We can see only 2 transactions involved purchasing more than one item.


--8.	What is the difference in total sales between 'Electronics' and 'Furniture' categories?

SELECT
    SUM (CASE WHEN p.Category = 'Electronics' THEN t.Quantity * p.Price ELSE 0 END) -
    SUM (CASE WHEN p.Category = 'Furniture' THEN t.Quantity * p.Price ELSE 0 END) AS SalesDifference --difference of sales by calculating quantity and price 
FROM
    Products p
JOIN
    Transactions t ON t.ProductID = p.ProductID;
	
--Summary: 
--Hence, the total sales difference is 1450 between the two-product category.


--9.	Which country has the highest average spending per transaction?		

SELECT 
    c.Country,
    AVG (p.Price * t.Quantity) AS AverageTransactionValue
FROM 
    Transactions t
JOIN 
    Customers c ON t.CustomerID = c.CustomerID
JOIN 
    Products p ON t.ProductID = p.ProductID
GROUP BY 
    c.Country
ORDER BY 
    AverageTransactionValue DESC 
LIMIT 1;

--Summary: 
--Hence, Canada holds the highest average spending per transaction

--10.	For each product, calculate the total revenue and categorize its sales volume as 'High' (more than $500), 
--'Medium' ($100-$500), or 'Low' (less than $100).


SELECT p.Productname, 
       SUM(p.price * t.quantity) AS TotalRevenue,
CASE 
	WHEN SUM(p.price * t.quantity) > 500 THEN 'High'
            WHEN SUM(p.price * t.quantity) BETWEEN 100 AND 500 THEN 'Medium'
            ELSE 'Low'
	END AS Totalsalesvolumecategory	--to categorize them using the sales volume
FROM 
    Products p
JOIN 
    Transactions t ON t.ProductID = p.ProductID
GROUP BY 
    p.Productname --group by each product
ORDER BY 
    Totalrevenue DESC --ordering by highest totalrevenue
	
	
--Summary: 
--Hence, above is the output for each product, as we can see Laptop & Smartphone stands top as High and Book as Low.


	











