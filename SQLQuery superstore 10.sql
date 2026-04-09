SELECT *
FROM  [PORTFOLIO PROJECT].[dbo].[Orders$]
ORDER BY 1,3

--TOTAL SALES

SELECT SUM(CAST(sales AS int)) AS total_sales
FROM [PORTFOLIO PROJECT].[dbo].[Orders$]

--SALES BY DATE

SELECT [Order Date], SUM(Sales) AS total_sales
FROM [PORTFOLIO PROJECT].[dbo].[Orders$]
GROUP BY [Order Date]
ORDER BY [Order Date]

--TOTAL NUMBER OF ORDERS (SALES COUNT

SELECT COUNT([Order ID]) AS total_orders
FROM [PORTFOLIO PROJECT].[dbo].[Orders$]

--highest sales (single transaction)

SELECT MAX(cast(sales as int)) AS highest_sale
FROM [PORTFOLIO PROJECT].[dbo].[Orders$]

SELECT GETDATE() AS today
FROM  [PORTFOLIO PROJECT].[dbo].[Orders$]
ORDER BY sales DESC

--MONTHLY SALE TREND 

SELECT 
    YEAR([Order Date]) AS year,
    MONTH([Order Date]) AS month,
    SUM(sales) AS total_sales
FROM [PORTFOLIO PROJECT].dbo.Orders$
GROUP BY YEAR([Order Date]), MONTH([Order Date])
ORDER BY year, month

--orders with late delivery

SELECT *
FROM [PORTFOLIO PROJECT].dbo.Orders$ 
WHERE DATEDIFF(day, [Order Date], [ship date]) > 5

--lets find the profit margin

SELECT 
    [Product Name],
    SUM([Sales]) AS total_sales,
    SUM([Profit]) AS total_profit,
    (SUM([Profit]) / SUM([Sales])) * 100 AS profit_margin_percent
FROM [PORTFOLIO PROJECT].dbo.Orders$
GROUP BY [Product Name]
ORDER BY profit_margin_percent DESC





--sales by ship method 

SELECT [Ship Mode], SUM(cast(sales as int)) AS total_sales
FROM [PORTFOLIO PROJECT].dbo.Orders$
GROUP BY [Ship Mode]
ORDER BY total_sales DESC

SELECT 
    [Order ID],
    [Customer Name],
    [Sales],
    [Order Date]
INTO #temp_sales
FROM [PORTFOLIO PROJECT].dbo.Orders$

SELECT *
FROM #temp_sales

--Aggregate from temp table 

SELECT [Order ID], [Sales]
FROM [PORTFOLIO PROJECT].dbo.Orders$


SELECT * FROM #temp_sales

SELECT 
    [Customer Name],
    SUM([Sales]) AS total_sales
FROM #temp_sales
GROUP BY [Customer Name]
ORDER BY total_sales DESC

--partition by running total per customers 

SELECT 
    [Customer Name],
    [Order Date],
    [Sales],
    SUM([Sales]) OVER (
        PARTITION BY [Customer Name]
        ORDER BY [Order Date]
    ) AS running_total
FROM [PORTFOLIO PROJECT].dbo.Orders$

--Dens and Rank

SELECT 
    [Customer Name],
    SUM([Sales]) AS total_sales,
    RANK() OVER (ORDER BY SUM([Sales]) DESC) AS rank_sales,
    DENSE_RANK() OVER (ORDER BY SUM([Sales]) DESC) AS dense_rank_sales
FROM [PORTFOLIO PROJECT].dbo.Orders$
GROUP BY [Customer Name]

--partition by average per category

SELECT 
    [Category],
    [Product Name],
    [Sales],
    AVG([Sales]) OVER (
        PARTITION BY [Category]
    ) AS avg_category_sales
FROM [PORTFOLIO PROJECT].dbo.Orders$

--Nile divide into groups 
SELECT 
    [Customer Name],
    [Sales],
    NTILE(4) OVER (ORDER BY [Sales] DESC) AS quartile
FROM [PORTFOLIO PROJECT].dbo.Orders$


SELECT TOP 10
    [Product Name],
    SUM([Sales]) AS total_sales
FROM [PORTFOLIO PROJECT].dbo.Orders$
GROUP BY [Product Name]
ORDER BY total_sales DESC

--product performance

SELECT 
    [Product Name],
    SUM([Quantity]) AS total_quantity,
    SUM([Sales]) AS total_sales
FROM [PORTFOLIO PROJECT].dbo.Orders$
GROUP BY [Product Name]
ORDER BY total_sales DESC

--loss making product 

SELECT 
    [Product Name],
    SUM([Profit]) AS total_profit
FROM [PORTFOLIO PROJECT].dbo.Orders$
GROUP BY [Product Name]
HAVING SUM([Profit]) < 0
ORDER BY total_profit ASC

--pinpointing the high revenue by product 

SELECT TOP 5
    [Product Name],
    SUM([Sales]) AS total_sales,
    SUM([Profit]) AS total_profit
FROM [PORTFOLIO PROJECT].dbo.Orders$
GROUP BY [Product Name]
ORDER BY total_sales DESC, total_profit DESC

--lets find the best overall ranking product

SELECT 
   [Product Name], 
    SUM([Sales]) AS total_sales,
    SUM([Profit]) AS total_profit,
    RANK() OVER (ORDER BY SUM([Sales]) DESC) AS sales_rank,
    RANK() OVER (ORDER BY SUM([Profit]) DESC) AS profit_rank
FROM [PORTFOLIO PROJECT].dbo.Orders$
GROUP BY [Product Name]

--TOTAL SALES, PROFIT AMD ORDERS BY COUNTRY

SELECT
Country,
SUM(Sales) as total_Sales,
SUM(Profit) as total_profit,
COUNT(*) AS Total_orders
FROM [PORTFOLIO PROJECT].dbo.Orders$
GROUP BY Country
ORDER BY total_Sales DESC

--FIND OUT THE TOP 3 COUNTRIES BY SALES

SELECT 
  Country,
  SUM(Sales) as total_sales
 FROM [PORTFOLIO PROJECT].dbo.Orders$
 GROUP BY Country
 order by total_sales

 