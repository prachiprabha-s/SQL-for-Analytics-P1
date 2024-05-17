CREATE TABLE IF NOT EXISTS Products_ (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    OriginalPrice DECIMAL(10, 2),
    DiscountRate DECIMAL(5, 2)  -- Discount rate as a percentage, e.g., 10% discount is represented as 10.
);

INSERT INTO Products_ (ProductID, ProductName, OriginalPrice, DiscountRate) VALUES
(1, 'Laptop', 1200.00, 15),
(2, 'Smartphone', 700.00, 10),
(3, 'Headphones', 150.00, 5),
(4, 'E-Reader', 200.00, 20);

CREATE TABLE IF NOT EXISTS Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    QuantitySold INT,
    SaleDate DATE
);

-- Sample sales during the 10-day sale period
INSERT INTO Sales (SaleID, ProductID, QuantitySold, SaleDate) VALUES
(1, 1, 2, '2023-03-11'),
(2, 2, 3, '2023-03-12'),
(3, 3, 5, '2023-03-13'),
(4, 1, 1, '2023-03-14'),
(5, 4, 4, '2023-03-15'),
(6, 2, 2, '2023-03-16'),
(7, 3, 3, '2023-03-17'),
(8, 4, 2, '2023-03-18');

-- Additional pre-sale transactions
INSERT INTO Sales (SaleID, ProductID, QuantitySold, SaleDate) VALUES
(9, 1, 1, '2023-03-01'),
(10, 2, 2, '2023-03-02'),
(11, 3, 1, '2023-03-03'),
(12, 4, 1, '2023-03-04'),
(13, 1, 2, '2023-03-05'),
(14, 2, 1, '2023-03-06'),
(15, 3, 3, '2023-03-07'),
(16, 4, 2, '2023-03-08'),
(17, 2, 1, '2023-03-09');

SELECT * FROM Sales
SELECT * FROM Products_


--1.	How much revenue was generated each day of the sale?
SELECT
    s.SaleDate,
    SUM(s.QuantitySold * (p.OriginalPrice * (100 - p.DiscountRate) / 100)) AS RevenueGenerated -- revenue generated for each product category
FROM
    Sales s
JOIN
    Products_ p ON s.ProductID = p.ProductID
WHERE 
    s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18' -- specifying the tenure of the sale period
GROUP BY
    s.SaleDate
ORDER BY
    s.SaleDate;-- organising based on saledate in asc order
	
--Summary: 
--Hence, as per the condition 11th to 18th is the sale day and we can see the total revenue is highest on the 11th date and the lowest on 18th.


--2.	Which product had the highest sales volume during the sale?

SELECT p.productname, 
	   SUM(s.quantitysold) AS salesvolume 
FROM sales s
JOIN
    products_ p ON s.ProductID = p.ProductID
WHERE 
    saledate BETWEEN '2023-03-11' AND '2023-03-18' --during the sales tenure
GROUP BY 
    p.productname
ORDER BY 
    salesvolume DESC --ordering by the highest volume
LIMIT 1;

--Summary: 
--Hence, the product Headphones is having the highest sales volume during the sale period.

--3.	What was the total discount given during the sale period?

SELECT 
    SUM(p.OriginalPrice * p.DiscountRate / 100 * s.QuantitySold) AS TotalDiscountGivenDuringSale
FROM 
    Sales s
JOIN 
    Products_ p ON s.ProductID = p.ProductID
WHERE 
    s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18'; 


--Summary: 
--Hence, the results show us that the total discount given on during sale on the products is 1190.

--4.	How does the sale performance compare in terms of units sold before and during the sale?
	 	
SELECT S.SaleVolumeDuringSale, P.SaleVolumePreSale
FROM 
---- Subquery to calculate the total sale volume during the specified sale period    
    (SELECT SUM(s.QuantitySold) AS SaleVolumeDuringSale
     FROM Sales s
     WHERE s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18') AS S
CROSS JOIN --Since there's no specific relationship or condition between the results, a cross join is sufficient for combining them
-- Subquery to calculate the total sale volume before the specified sale period
    (SELECT SUM(s.QuantitySold) AS SaleVolumePreSale
     FROM Sales s
     WHERE s.SaleDate BETWEEN '2023-03-01' AND '2023-03-09') AS P ;
	 
--Summary:
--As we can see in the results, the total unit sales during sale are higher than the total unit sales during presale. 
--Which also means products have higher demands on discounts and sales than the normal days. 
--The difference between two is 8(22 - 14) units. To find the percentage of this increase is 57.14%  ((sale during sale – sale presale)/sale presale) * 100.


--5.	What was the average discount rate applied to products sold during the sale?


SELECT AVG(p.DiscountRate) AS AverageDiscountRate
FROM 
       Sales s
JOIN 
       Products_ p ON s.ProductID = p.ProductID
WHERE 
       s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18';

--Summary:
--The average discount rate applied to the products sold during the sale was 12.5%.

--6.	Which day had the highest revenue, and what was the top-selling product on that day?

SELECT s.saledate, 
       p.ProductName AS top_selling_product, 
       (SUM(s.QuantitySold * (p.OriginalPrice - (p.OriginalPrice * p.DiscountRate / 100)))) AS highestrevenue
FROM Sales s
JOIN 
     Products_ p ON s.ProductID = p.ProductID
GROUP BY 
     s.saledate, p.ProductName
ORDER BY 
     highestrevenue DESC
LIMIT 1;

--Summary:
--Following the results,2023-03-05 is the highest revenue making day, 
--Laptop is the top-selling product on that day with the highest revenue 2040.

--7.	How many units were sold per product category during the sale? (Assuming product categories can be derived from product names or an additional field)

SELECT 
CASE 
    WHEN p.productname LIKE 'H%' THEN 'Category 1' --Assigning 'Categories' to products starting with 'Certain letters'
    WHEN p.productname LIKE 'E%' THEN 'Category 2'
    WHEN p.productname LIKE 'S%' THEN 'Category 3'
    ELSE 'Category 4'
	END AS Product_category, 
    SUM(s.quantitysold) AS total_unit_sold 
FROM  
    products_ p
JOIN
    sales s ON s.ProductID = p.ProductID
WHERE 
    s.saledate BETWEEN '2023-03-11' AND '2023-03-18' --during sales period
GROUP BY 
    p.productname
ORDER BY
    total_unit_sold DESC;

--Summary:
--Assuming an additional field for each of the product name, we can find that Category 1(Headphones) has the highest total units sold and Category 4(Laptop) has the Lowest.

--8.	What was the total number of transactions each day?

SELECT 
     s.saledate, 
     COUNT(*) AS totaltransaction
FROM 
     sales s
GROUP BY 
     s.saledate
ORDER BY
     s.saledate;

--Summary:
--This output indicates that each day has one transaction according to the provided sample data.


--9.	Which product had the largest discount impact on revenue?

--The discount impact refers to the effect or influence that discounts have on sales transactions or business revenue
SELECT p.productname, 
       SUM(s.QuantitySold * p.DiscountRate * p.OriginalPrice / 100) AS DiscountImpact 
FROM
    sales s
JOIN
    products_ p ON s.ProductID = p.ProductID
GROUP BY
    p.productname,p.discountrate
    LIMIT 1;

--Summary:
--Hence, the product Laptop had the highest discount impact on the revenue.

--*Quantity Sold (s.QuantitySold):
--note:- It's crucial to consider the quantity sold because discounts may apply differently based on the quantity
---purchased. For example, bulk discounts or volume discounts might be applicable.

--*Discount Rate (p.DiscountRate):
--It indicates the extent to which the price is discounted. 
--For instance, a discount rate of 10% means the product price is reduced by 10%.

--*Original Price (p.OriginalPrice):
--This is the price of the product before any discounts are applied. 
--It serves as the baseline against which the discount is calculated.


--10.	Calculate the percentage increase in sales volume during the sale compared to a similar period before the sale.

WITH PreSaleVolume AS (
	                    SELECT SUM(QuantitySold) AS PreSaleVolume
                        FROM Sales
                        WHERE SaleDate < '2023-03-11' ),
     SaleVolume AS (
		                SELECT SUM(QuantitySold) AS SaleVolume
                        FROM Sales
                        WHERE SaleDate BETWEEN '2023-03-11' AND '2023-03-18')
SELECT 
     (SaleVolume - PreSaleVolume) / PreSaleVolume * 100 AS  PercentageIncrease
FROM SaleVolume, 
     PreSaleVolume;
	 
--Summary:
--The difference in the two period is 8(22 - 14), hence the percentage increase in sales volume during the sale 
--compared to a similar period before the is 57.14% (after converting it into percentage).



--*******************************************PRACTICE SECTION******************************************************

--**
SELECT COUNT(Transactionid) AS Number_of_transaction, Customerid
FROM 
     Transactions
GROUP BY 
     Customerid
ORDER BY 
     Number_of_transaction DESC
            LIMIT 1;
SELECT * FROM TRANSACTIONS

--SELECT p.*, t.transactionid
FROM Products p
LEFT JOIN Transactions t ON p.ProductID = t.ProductID
WHERE t.quantity IS NULL;

--**
SELECT p.productname,max(t.quantity) as highest_quantity_sold
FROM 
    Products p
JOIN 
    Transactions t ON t.ProductID = p.ProductID
GROUP BY 
    p.productname
ORDER BY 
    highest_quantity_sold DESC
LIMIT 1;

--**
SELECT p.*, t.transactionid
FROM Products p
LEFT JOIN Transactions t ON p.ProductID = t.ProductID
WHERE t.ProductID IS NULL;


--**
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
     AverageTransactionValue DESC;

--**
SELECT ((S.Salevolumeduringsale - P.Salevolumepresale) * 100) /100 AS Percentageincrease
FROM (SELECT SUM(s.Quantitysold) AS Salevolumeduringsale
      FROM sales s
      WHERE 
           s.saledate BETWEEN '2023-03-011' AND '2023-03-18'
      ) S ,
     (SELECT SUM(s.Quantitysold) AS Salevolumepresale 
      FROM sales s
      WHERE 
           s.saledate BETWEEN '2023-03-01' AND '2023-03-10'
      ) P   

--**
SELECT ((S.Salevolumeduringsale - P.Salevolumepresale) * 100) /100 AS Salesvolume
FROM (SELECT SUM(s.Quantitysold) AS Salevolumeduringsale
      FROM sales s
      WHERE 
           s.saledate BETWEEN '2023-03-011' AND '2023-03-18'
      ) S ,
     (SELECT SUM(s.Quantitysold) AS Salevolumepresale 
      FROM sales s
      WHERE 
           s.saledate BETWEEN '2023-03-01' AND '2023-03-10'
      ) P   

--**
SELECT AVG(p.OriginalPrice * p.DiscountRate / 100 * s.QuantitySold) AS TotalDiscountGivenDuringSale
FROM Sales s
JOIN Products_ p ON s.ProductID = p.ProductID
WHERE s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18';

--**
SELECT AVG(p.DiscountRate) AS AverageDiscountRate
FROM Sales s
JOIN Products_ p ON s.ProductID = p.ProductID
WHERE s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18';

--**
SELECT S.Salevolumeduringsale, P.Salevolumepresale 
FROM (SELECT SUM(s.Quantitysold) AS Salevolumeduringsale
      FROM sales s
      WHERE 
           s.saledate BETWEEN '2023-03-11' AND '2023-03-18'
      ) S ,
     (SELECT SUM(s.Quantitysold) AS Salevolumepresale 
      FROM sales s
      WHERE 
           s.saledate BETWEEN '2023-03-01' AND '2023-03-09'
      ) P   
	  
-- same as above ----
SELECT 
    p.ProductName, 
    SUM(s.QuantitySold) AS TotalUnitsSold,
    SUM (CASE WHEN s.SaleDate BETWEEN '2023-03-11' AND '2023-03-18' THEN s.QuantitySold ELSE 0 END) AS UnitsSoldDuringSale,
    SUM (CASE WHEN s.SaleDate BETWEEN '2023-03-01' AND '2023-03-11' THEN s.QuantitySold ELSE 0 END) AS UnitsSoldBeforeSale
FROM 
    Sales s
JOIN 
    Products_ p ON s.ProductID = p.ProductID
GROUP BY 
    p.ProductName
ORDER BY 
    TotalUnitsSold DESC;

--**
SELECT s.saledate, SUM(s.QuantitySold * p.OriginalPrice) AS Revenuegenerated
FROM Products_ p
JOIN 
     Sales s ON s.Productid = p.productid
GROUP BY s.saledate

    
