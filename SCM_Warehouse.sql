-- Create & Use SCM_Warehouse Database
CREATE DATABASE IF NOT EXISTS SCM_Warehouse;
USE SCM_Warehouse;


-- Drop existing tables if they exist to avoid conflicts during creation 
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS PurchaseOrders;
DROP TABLE IF EXISTS Shipments;
DROP TABLE IF EXISTS Sales;


-- =======================
-- Create Tables Section
-- =======================

-- Suppliers Table
-- Stores supplier information
CREATE TABLE Suppliers(
SupplierID INT PRIMARY KEY,
SupplierName VARCHAR(50),
Country VARCHAR(30));

-- Products Table
-- Stores product information
CREATE TABLE Products(
ProductID INT PRIMARY KEY,
ProductName VARCHAR(50),
Category VARCHAR(30));

-- Inventory Table
-- Tracks product inventory levels
CREATE TABLE Inventory(
InventoryID INT PRIMARY KEY,
ProductID INT,
Quantity INT,
InventoryDate DATE,
FOREIGN KEY (ProductID) REFERENCES Products(ProductID));

-- PurchaseOrders Table
-- Records of orders placed to suppliers
CREATE TABLE PurchaseOrders(
POID INT PRIMARY KEY,
SupplierID INT,
ProductID INT,
OrderDate DATE,
Quantity INT,
Status VARCHAR(20),
FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID));

-- Shipments Table
-- Records details of shipments received
CREATE TABLE Shipments(
ShipmentID INT PRIMARY KEY,
POID INT,
ReceivedDate DATE,
Quantity INT,
FOREIGN KEY (POID) REFERENCES PurchaseOrders(POID));

-- Sales Table
-- Records sales transactions
CREATE TABLE Sales(
SaleID INT PRIMARY KEY,
ProductID INT,
SaleDate DATE,
Quantity INT,          -- Quantity sold
FOREIGN KEY (ProductID) REFERENCES Products(ProductID));


