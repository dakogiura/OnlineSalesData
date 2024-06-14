DROP TABLE IF EXISTS
	online_sales_data;

USE
	kaggledatasets;
CREATE TABLE
	online_sales_data
(
TransactionID   INT,
Date 		    DATE,
ProductCategory VARCHAR(255),
ProductName		VARCHAR(255),
UnitsSold		INT,
UnitPrice		FLOAT,
TotalRevenue	FLOAT,
Region			VARCHAR(255),
PaymentMethod	VARCHAR(255)
)
;

LOAD DATA INFILE
	'onlinesalesdata.csv'
INTO TABLE
	online_sales_data
FIELDS TERMINATED BY
	','
IGNORE
	1 LINES
;