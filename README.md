````markdown
# SCM Warehouse Analytics

A SQL-based Supply Chain Management (SCM) warehouse project that includes schema design, data import structure, and analytical queries to extract real-time business insights.

---

## Project Overview

This project simulates a warehouse environment, where various SQL queries are used to analyze suppliers, inventory, sales, purchase orders, and shipments. Designed to support data-driven decision-making in supply chain operations.


## Project Structure

| File | Description |
|------|-------------|
| `SCM_Warehouse.sql` | SQL script to create database schema and tables |
| `SCM_Warehouse_Queries.sql` | Collection of analytical and reporting queries |
| `Suppliers.csv`<br>`Products.csv`<br>`Inventory.csv`<br>`PurchaseOrders.csv`<br>`Shipments.csv`<br>`Sales.csv` | CSV datasets used to populate each corresponding table (to be added) |



## Database Schema

### Tables

- `Suppliers(SupplierID, SupplierName, Country)`
- `Products(ProductID, ProductName, Category)`
- `Inventory(InventoryID, ProductID, Quantity, InventoryDate)`
- `PurchaseOrders(POID, SupplierID, ProductID, OrderDate, Quantity, Status)`
- `Shipments(ShipmentID, POID, ReceivedDate, Quantity)`
- `Sales(SaleID, ProductID, SaleDate, Quantity)`

### Entity Relationships

- **Products** are referenced in **Inventory**, **Sales**, and **PurchaseOrders**.
- **Suppliers** supply **PurchaseOrders** which lead to **Shipments**.
- **Shipments** are linked to **PurchaseOrders** by `POID`.


## SQL Queries and Analytics

| Query Title | Description |
|-------------|-------------|
| **Total Inventory** | Calculates total stock quantity per product |
| **Pending Orders** | Lists all purchase orders with a 'Pending' status |
| **Received Quantities by Supplier** | Aggregates received shipment quantities per supplier |
| **Stock Turnover Ratio** | Calculates Sales ÷ Avg Inventory for each product |
| **Low Inventory Alert** | Flags products with stock less than 1000 units |
| **Best-Selling Products** | Top 5 products with the highest quantity sold |
| **Supplier Delivery Performance** | Compares 'Delivered' vs. 'Cancelled' orders |
| **Monthly Sales Summary** | Monthly sales volume grouped by year-month |
| **Shipment Delay Analysis** | Computes days between order and shipment receipt |
| **Category Inventory Summary** | Sums inventory by product category |
| **Unshipped Orders** | Finds orders with no shipment record or still pending |
| **Status Breakdown by Supplier/Product** | Tracks Pending & Missing orders by each entity |


## Business Insights

- **Identify Restocking Needs:** Low inventory alerts guide procurement teams.
- **Efficiency Check:** High or low turnover ratios can show product demand trends.
- **Supplier Evaluation:** Track performance for better vendor negotiations.
- **Delay Monitoring:** Improve logistics by identifying common delay patterns.


## Getting Started

### 1. Create Database and Tables
```sql
SOURCE SCM_Warehouse.sql;
````

### 2. Import Data from CSV Files

> Replace file paths with your actual CSV locations.

```sql
LOAD DATA INFILE 'Suppliers.csv'
INTO TABLE Suppliers
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- Repeat for other CSVs
```
> You can also import by
```
Table Data Import Wizard
```
### 3. Run the Analytical Queries

```sql
SOURCE SCM_Warehouse_Queries.sql;
```

## Author

**Praful Patel**
This project is intended for learning, data reporting, and SCM analytics.
