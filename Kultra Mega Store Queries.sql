CREATE DATABASE "Kultra Mega Store"

---Alter columns with to just 2 decimal points

ALTER TABLE dbo.KMS_Sales
ALTER COLUMN Sales DECIMAL(18,2);

ALTER TABLE KMS_Sales
ALTER COLUMN Discount DECIMAL(18,2);

ALTER TABLE KMS_Sales
ALTER COLUMN Profit DECIMAL(18,2);

ALTER TABLE KMS_Sales
ALTER COLUMN Unit_Price DECIMAL(18,2);

ALTER TABLE KMS_Sales
ALTER COLUMN Shipping_Cost DECIMAL(18,2);

ALTER TABLE KMS_Sales
ALTER COLUMN Product_Base_Margin DECIMAL(18,2);

--- Problem Questions 

--- 1. Which product category had the highest sales? 

SELECT TOP 1 
    (Product_Category), 
    SUM(Sales) AS TotalSales
FROM KMS_Sales
GROUP BY (Product_Category)
ORDER BY TotalSales DESC;

--- 2. What are the Top 3 and Bottom 3 regions in terms of sales? 
--- Top 3

SELECT TOP 3 
    Region, 
    SUM(Sales) AS TotalSales
FROM KMS_Sales
GROUP BY Region
ORDER BY TotalSales DESC;

--- Bottom 3 

SELECT TOP 3 
    Region, 
    SUM(Sales) AS TotalSales
FROM KMS_Sales
GROUP BY Region
ORDER BY TotalSales ASC;

 
 ---3. What were the total sales of appliances in Ontario? 

 SELECT 
    SUM(Sales) AS TotalSales
FROM KMS_Sales
WHERE (Product_Sub_Category) = 'Appliances'
  AND Province = 'Ontario';

  --- 4 Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers 

  SELECT TOP 10 
    (Customer_Name), 
    SUM(Sales) AS TotalSales
FROM KMS_Sales
GROUP BY (Customer_Name)
ORDER BY TotalSales ASC;

---  5. KMS incurred the most shipping cost using which shipping method? 

SELECT TOP 1 
    (Ship_Mode), 
    SUM((Shipping_Cost)) AS TotalShippingCost
FROM KMS_Sales
GROUP BY (Ship_Mode)
ORDER BY TotalShippingCost DESC;

---6. Who are the most valuable customers, and what products or services do they typically purchase? 

SELECT 
    (Customer_Name), 
    (Product_Category), 
    (Product_Sub_Category),
    SUM((Order_Quantity)) AS PurchaseCount,
    SUM(Profit) AS TotalProfit
FROM KMS_Sales
WHERE (Customer_Name) IN (
    SELECT TOP 5 (Customer_Name)
    FROM KMS_Sales
    GROUP BY (Customer_Name)
    ORDER BY SUM(Profit) DESC
)
GROUP BY (Customer_Name), (Product_Category), (Product_Sub_Category)
ORDER BY (Customer_Name), TotalProfit DESC;


--- 7. Which small business customer had the highest sales? 

SELECT TOP 1 
    (Customer_Name), 
    SUM(Sales) AS TotalSales
FROM KMS_Sales
WHERE (Customer_Segment) = 'Small Business'
GROUP BY (Customer_Name)
ORDER BY TotalSales DESC;

---8. Which Corporate Customer placed the most number of orders in 2009 – 2012? 

SELECT TOP 1 
    (Customer_Name), 
    COUNT(DISTINCT (Order_ID)) AS OrderCount
FROM KMS_Sales
WHERE (Customer_Segment) = 'Corporate'
  AND (Order_Date) BETWEEN '2009-01-01' AND '2012-12-31'
GROUP BY (Customer_Name)
ORDER BY OrderCount DESC;

---9.  Which consumer customer was the most profitable one?

SELECT TOP 1 
    (Customer_Name), 
    SUM(Profit) AS TotalProfit
FROM KMS_Sales
WHERE (Customer_Segment) = 'Consumer'
GROUP BY (Customer_Name)
ORDER BY TotalProfit DESC;

---10. Which customer returned items, and what segment do they belong to? 
--- Assuming returns is negative profit

SELECT DISTINCT 
    (Customer_Name), 
    (Customer_Segment)
FROM KMS_Sales
WHERE Profit < 0;

---11.If the delivery truck is the most economical but the slowest shipping method and Express Air is the fastest but
--the most expensive one, do you think the company appropriately spent shipping costs based on the Order Priority? Explain your answer 

SELECT 
    (Order_Priority),
    (Ship_Mode),
    COUNT(*) AS OrderCount,
    AVG([Shipping_Cost]) AS AvgShippingCost
FROM KMS_Sales
GROUP BY (Order_Priority), (Ship_Mode)
ORDER BY (Order_Priority), (Ship_Mode);

