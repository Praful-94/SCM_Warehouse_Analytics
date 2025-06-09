-- --------------------------------------------------------
-- -- Reference for Table Columns
-- Suppliers (SupplierID, SupplierName, Country)
-- Products (ProductID, ProductName, Category)
-- Inventory (InventoryID, ProductID, Quantity, InventoryDate)
-- PurchaseOrders (POID, SupplierID, ProductID, OrderDate, Quantity, Status)
-- Shipments (ShipmentID, POID, ReceivedDate, Quantity)
-- Sales (SaleID, ProductID, SaleDate, Quantity)
-- --------------------------------------------------------


-- Set the active database
USE SCM_Warehouse;

-- View all records from each table to inspect raw data
SELECT * FROM Suppliers;
SELECT * FROM Products;
SELECT * FROM Inventory;
SELECT * FROM PurchaseOrders;
SELECT * FROM Shipments;
SELECT * FROM Sales;

-- Total inventory available per product
SELECT p.ProductName, SUM(i.Quantity) AS Total_Inventory
FROM Inventory i
JOIN Products p ON i.ProductID = p.ProductID
GROUP BY p.ProductName;

-- List of all pending purchase orders (not yet delivered)
SELECT po.POID, s.SupplierName, p.ProductName, po.Quantity, po.OrderDate
FROM PurchaseOrders po
JOIN Suppliers s ON po.SupplierID = s.SupplierID
JOIN Products p ON po.ProductID = p.ProductID
WHERE po.Status = 'Pending';

-- Total quantity of goods received, grouped by supplier
SELECT s.SupplierName, SUM(sh.Quantity) AS Total_Recieved
FROM Shipments sh
JOIN PurchaseOrders po ON sh.POID = po.POID
JOIN Suppliers s ON s.SupplierID = po.SupplierID
GROUP BY s.SupplierName;

-- Calculate the Stock Turnover Ratio = Sales / Average Inventory per product
SELECT p.ProductName, SUM(s.Quantity)/ AVG(i.Quantity) AS StockTurnoverRatio
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
JOIN Inventory i ON i.ProductID = p.ProductID
GROUP BY p.ProductName;

-- Products with total inventory below a threshold (1000 units)
SELECT p.ProductName, SUM(i.Quantity) AS TotalInventory
FROM Inventory i
JOIN Products p ON p.ProductID = i.ProductID
GROUP BY p.ProductName HAVING TotalInventory < 1000;

-- Quantity of each product sold (total sales per item)
SELECT p.ProductName, SUM(s.Quantity) AS Total_sold
FROM Products p
JOIN Sales s ON s.ProductID = p.ProductID
GROUP BY p.ProductName;

-- Top 5 best-selling products based on quantity sold
SELECT p.ProductName, SUM(s.Quantity) AS Total_Sold
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Total_Sold DESC LIMIT 5;


-- Supplier delivery performance: delivered vs. cancelled order counts
SELECT s.SupplierName,
       COUNT(CASE WHEN po.Status = 'Delivered' THEN 1 END) AS Delivered,
       COUNT(CASE WHEN po.Status = 'Cancelled' THEN 1 END) AS Cancelled
FROM PurchaseOrders po
JOIN Suppliers s ON s.SupplierID = po.SupplierID
GROUP BY s.SupplierName;


-- Monthly summary of total sales volume
SELECT DATE_FORMAT(SaleDate, '%Y-%m') AS Month, SUM(Quantity) AS Total_Units_Sold
FROM Sales
GROUP BY Month
ORDER BY Month ASC;

-- Shipment delay per order — calculates number of days between order and receipt
SELECT po.POID, p.ProductName, po.OrderDate, sh.ReceivedDate,
       DATEDIFF(sh.ReceivedDate, po.OrderDate) AS DelayDays
FROM Shipments sh
JOIN PurchaseOrders po ON sh.POID = po.POID
JOIN Products p ON p.ProductID = po.ProductID;

-- Average shipment delay per product
SELECT p.ProductName, Avg(DATEDIFF(sh.ReceivedDate, po.OrderDate)) AS Avg_Delay_Days
FROM Shipments sh
JOIN PurchaseOrders po ON sh.POID = po.POID
JOIN Products p ON p.ProductID = po.ProductID
GROUP BY p.ProductName;

-- Inventory summary grouped by product category
SELECT p.Category, SUM(i.Quantity) AS TotalInventory
FROM Inventory i
JOIN Products p ON p.ProductID = i.ProductID
GROUP BY p.Category;

-- Orders with no shipment yet: either pending or marked as missing
SELECT po.POID, s.SupplierName, p.ProductName, po.Status
FROM PurchaseOrders po
JOIN Suppliers s ON s.SupplierID = po.SupplierID
JOIN Products p ON p.ProductID = po.ProductID
LEFT JOIN Shipments sh ON sh.POID = po.POID
WHERE po.Status IN ('Pending','Missing');


-- Count of pending and missing orders grouped by supplier
SELECT s.SupplierName,
       COUNT(CASE WHEN po.Status = 'Pending' THEN 1 END) AS Pending,
       COUNT(CASE WHEN po.Status = 'Missing' THEN 1 END) AS Missing
FROM PurchaseOrders po
JOIN Suppliers s ON s.SupplierID = po.SupplierID
GROUP BY s.SupplierName;

-- Count of pending and missing orders grouped by product
SELECT p.ProductName,
	COUNT(CASE WHEN po.Status = 'Pending' THEN 1 END) AS Pending,
	COUNT(CASE WHEN po.Status = 'Missing' THEN 1 END) AS Missing
FROM PurchaseOrders po
JOIN Products p ON p.ProductID = po.ProductID
GROUP BY p.ProductName; 

-- Daily inventory value estimate (assumes fixed unit price of 10)
SELECT InventoryDate, SUM(Quantity) * 10 AS EstimatedInventoryValue
FROM Inventory
GROUP BY InventoryDate;






