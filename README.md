# Whale vs Diversity Sales Analysis

SQL star schema + Power BI dashboard analyzing Whale orders vs diversified healthy pipe revenue by territory — built on AdventureWorks2025.

## Dashboard
![Dashboard](assets/Whale Sales Dashboard.png)

## Star Schema
![Star Schema](assets/Whale Sale Star schema.png)

## Overview
This project builds a star schema on top of AdventureWorks2025 to answer one key business question: **are we over-indexed on Whale orders (>$50K single orders) or do we have a healthy, diversified sales pipeline?**

## Star Schema
| Table | Type | Description |
|---|---|---|
| `FactSales` | Fact | Order line items with revenue, qty, territory, salesperson |
| `DimProduct` | Dimension | Product name and category |
| `DimSalesTerritory` | Dimension | Territory, group, and country |
| `DimSalesPerson` | Dimension | Salesperson names |
| `DimDate` | Dimension | Date breakdown by month, quarter, year |

## Views
- **`v_FactSales_WhaleAnalysis`** — classifies orders as Whale vs Healthy Pipe, computes AOV, Order Count, Total Revenue, Whale Concentration
- **`v_DimProduct_Diversity`** — breaks revenue per product into Whale vs Healthy Pipe with Revenue Diversity %
- **`v_DimTerritory_GapAnalysis`** — territory lookup for slicer filtering

## Tech Stack
- SQL Server / T-SQL
- AdventureWorks2025
- Power BI
