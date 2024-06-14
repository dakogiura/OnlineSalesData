-- 1.) View the entire dataset
SELECT
	*
FROM
	online_sales_data
;

-- 2.) Total Revenue, Total Units Sold, and Average Price by Region
SELECT
	Region,
    ROUND(SUM(TotalRevenue), 2) 		   			 AS SumRevenue,
    SUM(UnitsSold) 						   			 AS TotalUnitsSold,
    ROUND(AVG(UnitPrice), 2)	   		   			 AS AvgUnitPrice
    -- ROUND(((SUM(TotalRevenue))/(SUM(UnitsSold))), 2) AS WrongAvgUnitPrice
FROM
	online_sales_data
GROUP BY
	Region
;
	-- Use CTE to get SumRevenue / TotalUnitsSold = WrongAvUnitPrice
    -- Used JOIN to check the two against each other (checking for myself)
WITH
	temporary_table
AS (
	SELECT
		Region,
		ROUND(SUM(TotalRevenue), 2) AS SumRevenue,
		SUM(UnitsSold) 				AS TotalUnitsSold,
		ROUND(AVG(UnitPrice), 2)	AS AvgUnitPrice
	FROM
		online_sales_data
	GROUP BY
		Region
)
SELECT
	temp.Region,
	ROUND((temp.SumRevenue / temp.TotalUnitsSold), 2)	 	 AS WrongAvgUnitPrice,
    ROUND(((SUM(osd.TotalRevenue))/(SUM(osd.UnitsSold))), 2) AS WrongAvgUnitPrice2
FROM
	temporary_table   temp
JOIN
	online_sales_data osd
ON
	temp.Region = osd.Region
GROUP BY
	osd.Region
;

-- 3.) Find the Transactions with Highest Revenue
-- 	   Then, find the top ten most expensive products
-- 	   Then, find the products with the most units sold (if any)

	-- Highest Revenue
SELECT
	ProductCategory,
    ProductName,
    UnitPrice,
    UnitsSold,
    TotalRevenue
FROM
	online_sales_data
ORDER BY
	TotalRevenue DESC
LIMIT
	10
;
	-- Most Expensive
SELECT
	*
FROM
	online_sales_data
ORDER BY
	UnitPrice DESC
LIMIT
	10
;
	-- Products with most units sold
SELECT
	ProductName,
    SUM(UnitsSold) 			 AS UnitsSoldTotal,
    ROUND(AVG(UnitPrice), 2) AS AveragePrice,
    ProductCategory
FROM
	online_sales_data
GROUP BY
	1, 4
ORDER BY
	2 DESC
;

-- 4.) What is the most popular type of item by UnitsSold?
-- 	   What is the most expensive item?
SELECT
	ProductCategory,
    SUM(UnitsSold)	   			AS TotalUnitsSold,
    ROUND(AVG(UnitPrice), 2)	AS AvgUnitPrice
FROM
	online_sales_data
GROUP BY
	1
ORDER BY
	2 DESC -- Change this to '3 DESC' for most expensive item on average
;

-- 5.) Timeseries: Split by Region, and continue to add TotalRevenue
SELECT
	a.Date,
    a.Region,
    b.TotalRevenue,
    ROUND(SUM(b.TotalRevenue) OVER
		(PARTITION BY 
			a.Region
         ORDER BY
			a.Region,
			a.Date), 2)
				AS RollingTotalRevenue,
	a.UnitsSold,
	SUM(b.UnitsSold) 		  OVER
		(PARTITION BY
			a.Region
		ORDER BY
			a.Region,
            a.Date)
				AS RollingUnitsSold
FROM
	online_sales_data a
JOIN
	online_sales_data b
	ON
		a.Date = b.Date
        AND
        a.Region = b.Region
ORDER BY
	2, 1
;

-- 6.) 