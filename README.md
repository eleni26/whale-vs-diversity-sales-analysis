# Whale vs Diversity Sales Analysis

SQL star schema + Power BI dashboard analyzing Whale orders vs diversified healthy pipe revenue by territory — built on AdventureWorks2025.

## Dashboard
![Dashboard](Whale%20Sales%20Dashboard.png)

## Star Schema
![Star Schema](Whale%20Sale%20Star%20schema.png)

## 📐 Architecture

A star schema data mart is built via a single SQL Server stored procedure (`Procedure Scripts.sql`):

| Object | Type | Description |
|---|---|---|
| `DimDate` | Table | Calendar attributes (year, quarter, month) |
| `DimProduct` | Table | Product hierarchy (category → subcategory) |
| `DimSalesTerritory` | Table | Territory, region group, and country |
| `DimSalesPerson` | Table | Salesperson names |
| `FactSales` | Table | Order-line grain — qty, unit price, line total |
| `v_FactSales_WhaleAnalysis` | View | Fact + whale classification + KPIs (Power BI source) |
| `v_DimProduct_Diversity` | View | Product revenue split by order category (Power BI source) |
| `v_DimTerritory_GapAnalysis` | View | Territory lookup for slicer filtering (Power BI source) |

## 📈 KPI Summary

| Metric | Value |
|---|---|
| Total Revenue | 80.5 M |
| Whale Concentration | 45.5 % |
| Revenue Diversity | 54.5 % |
| Average Order Value (AOV) | 21.1 K |
| Order Count | 215 K |

## 🚀 Setup

### Prerequisites
- SQL Server with **AdventureWorks2025** restored
- Power BI Desktop

### 1 — Build the data mart

```sql
USE [AdventureWorks2025];
GO
EXEC dbo.sp_CreateFactSAndDimTables;
GO
```

The procedure drops and recreates all objects — safe to re-run at any time.

### 2 — Connect Power BI
- **Get Data → SQL Server** → point to your AdventureWorks2025 database
- Import the three reporting views:
  - `v_FactSales_WhaleAnalysis`
  - `v_DimProduct_Diversity`
  - `v_DimTerritory_GapAnalysis`
- In the **Model view**, confirm relationships on `TerritoryID` and `ProductID`
- Add DAX measures for AOV, Whale Concentration, Revenue Diversity %, etc.

## 🛠️ Tech Stack
- **SQL Server** — stored procedure, star schema, views
- **T-SQL** — data transformation and mart build
- **Power BI Desktop** — data model, DAX measures, report visuals
