Create Or Alter Procedure sp_CreateFactSAndDimTables as
BEGIN
   

    Drop view if exists v_FactSales_WhaleAnalysis;
    Drop view if exists v_DimProduct_Diversity;
    Drop view if exists v_DimTerritory_GapAnalysis;
    Drop table if exists FactSales;
    Drop table if exists DimProduct;
    Drop table if exists DimSalesPerson;
    Drop table if exists DimSalesTerritory;
    Drop table if exists DimDate;

    SELECT
        SalesOrderDetail.SalesOrderID,
        SalesOrderDetail.OrderQty,
        SalesOrderDetail.ProductID,
        SalesOrderDetail.UnitPrice,
        SalesOrderDetail.LineTotal,
        SalesOrderHeader.OrderDate,
        SalesOrderHeader.TerritoryID,
        SalesPerson.BusinessEntityID
    INTO FactSales
    FROM [AdventureWorks2025].[Sales].SalesOrderDetail
    INNER JOIN [AdventureWorks2025].[Sales].SalesOrderHeader
        ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
    INNER JOIN [AdventureWorks2025].[Sales].SalesPerson
        ON SalesOrderHeader.SalesPersonID = SalesPerson.BusinessEntityID;

    SELECT DISTINCT
        [Production].[Product].ProductID,
        [Production].[Product].Name AS ProductName,
        [Production].[ProductCategory].Name AS ProductCategory
    INTO DimProduct
    FROM [Production].[Product]
    INNER JOIN [Production].[ProductSubcategory]
        ON [Production].[Product].ProductSubcategoryID = [Production].[ProductSubcategory].ProductSubcategoryID
    INNER JOIN [Production].[ProductCategory]
        ON [Production].[ProductSubcategory].ProductCategoryID = [Production].[ProductCategory].ProductCategoryID;

    SELECT DISTINCT
        Sales.SalesPerson.BusinessEntityID,
        Person.Person.FirstName,
        Person.Person.LastName
    INTO DimSalesPerson
    FROM [AdventureWorks2025].[Person].[Person]
    INNER JOIN [AdventureWorks2025].[Sales].[SalesPerson]
        ON Person.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID;

    SELECT DISTINCT
        SalesTerritory.TerritoryID,
        SalesTerritory.[Name] AS SalesTerritory,
        SalesTerritory.[Group] AS SalesTerritoryGroup,
        Person.CountryRegion.[Name] AS CountryRegionName
    INTO DimSalesTerritory
    FROM [AdventureWorks2025].[Sales].[SalesTerritory] AS SalesTerritory
    INNER JOIN [AdventureWorks2025].Person.CountryRegion
        ON SalesTerritory.CountryRegionCode = Person.CountryRegion.CountryRegionCode;

    SELECT DISTINCT
        CAST(OrderDate AS DATE) AS FullDate,
        YEAR(OrderDate) AS [Year],
        MONTH(OrderDate) AS [MonthNumber],
        DATENAME(MONTH, OrderDate) AS [MonthName],
        DATEPART(QUARTER, OrderDate) AS [Quarter],
        DATENAME(WEEKDAY, OrderDate) AS [DayName]
    INTO DimDate
    FROM Sales.SalesOrderHeader;

    EXEC('CREATE VIEW v_FactSales_WhaleAnalysis AS
    SELECT
        FactSales.SalesOrderID,
        FactSales.ProductID,
        FactSales.OrderQty,
        FactSales.UnitPrice,
        FactSales.LineTotal,
        FactSales.OrderDate,
        FactSales.TerritoryID,
        FactSales.BusinessEntityID,
        CASE
            WHEN SUM(FactSales.LineTotal) OVER(PARTITION BY FactSales.SalesOrderID) > 50000
            THEN ''Whale''
            ELSE ''Healthy Pipe''
        END AS OrderCategory
    FROM FactSales');

    EXEC('CREATE VIEW v_DimProduct_Diversity AS
    SELECT
        DimProduct.ProductID,
        DimProduct.ProductName,
        DimProduct.ProductCategory
    FROM DimProduct');

    EXEC('CREATE VIEW v_DimTerritory_GapAnalysis AS
    SELECT
        DimSalesTerritory.TerritoryID,
        DimSalesTerritory.SalesTerritory,
        DimSalesTerritory.SalesTerritoryGroup,
        DimSalesTerritory.CountryRegionName
    FROM DimSalesTerritory');

    PRINT 'Build Success: Star Schema tables and views are ready.';
END