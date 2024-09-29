USE Final_project;

--- Data Modelling:
--- We need to link our tables using primary and foreign keys,so we will use the following query.
ALTER TABLE Orders
ADD FOREIGN KEY (Customer_ID)
REFERENCES Customers (Customer_ID);

ALTER TABLE Orders
ADD FOREIGN KEY (New_Product_ID)
REFERENCES Products (New_Product_ID);

-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

--- Data cleaning:
---We have completed the initial cleaning process using Power Query.
--- We can't remove duplicates from our data as we need it in our analysis.

--- Finding null values:
SELECT 
	*
FROM 
	Orders
WHERE 
	Order_ID IS NULL
OR
	Order_Date IS NULL
OR
	Ship_Date IS NULL
OR
	Ship_Mode IS NULL
OR
	Customer_ID IS NULL
OR
	Country IS NULL
OR
	City IS NULL
OR
	State IS NULL
OR
	Postal_code IS NULL
OR
	Region IS NULL
OR
	New_Product_ID IS NULL
OR
	Sales IS NULL;

--- We have found that there are 11 rows that have null values in the postal_code column, but it's not a huge problem and we won't remove them.
--------------------------------------------------------------------------------------------------
SELECT 
	*
FROM 
	Customers
WHERE 
	Customer_ID IS NULL
OR
	Customer_Name IS NULL
OR
	Segment IS NULL;

--- We havn't found any null values here.
-------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	*
FROM 
	Products
WHERE 
	Product_ID IS NULL
OR
	Product_Name IS NULL
OR
	Category IS NULL
OR
	Sub_Category IS NULL
OR
	New_Product_ID IS NULL;

--- We havn't found any null values here.
-------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------

---Questions:
--- Period of our data:   ------------------------------------------------------------------------>KPI
SELECT
	MAX(Order_date) AS Last_time_order
FROM
	Orders;   --- we fininsh our analysis on 30/12/2018
------------------------------
SELECT
	Min(Order_date) AS First_time_order
FROM
	Orders;    --- we fininsh our analysis on 3/1/2015
------------------------------------------------------------------
------------------------------------------------------------------
--- 1-Total Number of Customers:   ---------------------------------------------------------------->KPI
SELECT 
	COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM 
	Customers;
------------------------------------------------------------------
--- 2- Total Number of Customers per Segment:
SELECT 
	Segment,
	COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM 
	Customers
GROUP BY 
	Segment;
------------------------------
SELECT 
	DISTINCT Segment
FROM 
	Customers;
------------------------------------------------------------------
--- 3-Total Number of Customer  per Each Year/month:
SELECT 
    Year(Order_Date) AS year ,
    COUNT(DISTINCT O.Customer_ID) AS Total_customer
FROM 
	Orders AS O
INNER JOIN 
	Customers AS C 
ON
	O.Customer_ID = C.Customer_ID
GROUP BY 
	Year(Order_Date) 
ORDER BY 
	Year;
------------------------------
SELECT 
    Year(Order_Date) AS year ,
	Month(Order_Date) AS month,
    COUNT(DISTINCT O.Customer_ID) AS Total_customer
FROM 
	Orders AS O
INNER JOIN 
	Customers AS C 
ON 
	O.Customer_ID = C.Customer_ID
GROUP BY 
	Year(Order_Date) , 
	Month(Order_Date)
ORDER BY 
	Year(Order_Date), 
	Month(Order_Date);
------------------------------------------------------------------
--- 4-total number of cities and states per each year-month:
SELECT 
	Year(Order_Date) AS year,
    COUNT(DISTINCT City) AS Total_cities,
	COUNT(DISTINCT State) AS Total_States
FROM 
	Orders
GROUP BY 
	Year(Order_Date);
------------------------------
SELECT 
	Year(Order_Date) AS year,
    Month(Order_Date)AS month,
    COUNT(DISTINCT City) AS Total_cities,
	COUNT(DISTINCT State) AS Total_States
FROM
	Orders
GROUP BY 
	Year(Order_Date), 
	Month(Order_Date);
------------------------------------------------------------------
--- 5-Total Number of Products, Categories, and Subcategories per Each Year and Month:
SELECT 
    Year(Order_Date) AS year,
    COUNT(DISTINCT P.New_Product_ID) AS Total_Products,
    COUNT(DISTINCT P.Category) AS Total_Categories,
    COUNT(DISTINCT P.Sub_Category) AS Total_Subcategories
FROM 
	Orders as o
Inner JOIN
	Products as P 
ON 
	O.New_Product_ID = P.New_Product_ID
GROUP BY 
	Year(order_date);
------------------------------
SELECT 
    Year(Order_Date) AS year,
    Month(Order_Date) AS month,
    COUNT(DISTINCT P.New_Product_ID) AS Total_Products,
    COUNT(DISTINCT P.Category) AS Total_Categories,
    COUNT(DISTINCT P.Sub_Category) AS Total_Subcategories
FROM 
	Orders as o
Inner JOIN
	Products as P 
ON 
	O.New_Product_ID = P.New_Product_ID
GROUP BY 
	Year(order_date), 
	Month(order_date);
------------------------------------------------------------------
---6- Total number of customer per each region:
SELECT 
    Region,
    COUNT(DISTINCT C.Customer_ID) AS Total_Customers 
FROM
	Orders AS O
INNER JOIN 
	Customers as C
ON 
	O.Customer_ID = C.Customer_ID
GROUP BY 
	Region
ORDER BY 
	Total_Customers DESC;
------------------------------
SELECT 
    Region,
	State,
    COUNT(DISTINCT C.Customer_ID) AS Total_Customers 
FROM
	Orders AS O
INNER JOIN 
	Customers as C
ON 
	O.Customer_ID = C.Customer_ID
GROUP BY 
	Region,
	State
ORDER BY 
	Total_Customers DESC;
-------------------------------------------------------------------
--- 7-total & avg sales per each region:
SELECT
	Region,
	AVG(Sales) as avg_sales,
	SUM(Sales) AS Total_sales
from 
	Orders
GROUP BY 
	Region
ORDER BY 
	avg_sales DESC,
	Total_sales DESC;
------------------------------
SELECT
	Region ,
	State ,
	AVG(Sales) as avg_sales,
	SUM(Sales) AS Total_sales
from 
	Orders
GROUP BY 
	Region,
	State
ORDER BY 
	avg_sales DESC,
	Total_sales DESC;
-------------------------------------------------------------------
--- 8 --Total & avg sales per year & month:
SELECT
	Year(O.Order_Date) AS year ,
	AVG(O.Sales) AS avg_sales,
	SUM(Sales) AS Total_Sales 
FROM
	Orders as O
GROUP BY 
	Year(O.Order_Date)
ORDER BY
	avg_sales,
	Total_Sales DESC;
------------------------------
SELECT
	Month(O.order_date)AS month,
	AVG(O.Sales) AS avg_sales,
	SUM(Sales) AS Total_Sales     
FROM
	Orders as O
GROUP BY 
	Month(O.order_date)
ORDER BY
	avg_sales DESC,
	Total_Sales DESC;
------------------------------
SELECT
	Year(O.Order_Date) AS year ,
	Month(O.order_date)AS month,
	AVG(O.Sales) AS avg_sales,
	SUM(Sales) AS Total_Sales     
FROM
	Orders as O
GROUP BY 
	Year(O.Order_Date),
	Month(O.order_date)
ORDER BY
	year,
	month;
-------------------------------------------------------------------
--- 9-- Which customer segment has highest avg sales per order: 
SELECT
    C.Segment,
    AVG(O.Sales) AS Avg_Sales ,
	SUM(O.Sales) AS Total_Sales,
	COUNT(O.Order_ID) AS Total_Orders
FROM 
	Orders AS O
INNER JOIN 
	Customers C 
ON 
	O.Customer_ID = C.Customer_ID
GROUP BY
	C.Segment
ORDER BY 
	Avg_Sales DESC,
	Total_Sales DESC,
	Total_Orders DESC;
-------------------------------------------------------------------
--- 10--Average delivery time accross different region:
SELECT
	Region,
	AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS Avg_Delivery_time
FROM 
	Orders 
GROUP BY
	Region
ORDER BY 
	Avg_Delivery_time DESC;
-------------------------------------------------------------------
--- 11--Avg delivery time different ship mode, Segment,Product Category & sub categorge:
SELECT
	O.Ship_Mode,
    C.Segment,
    P.Category,
    P.Sub_Category,
	AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS Avg_Delivery_time
FROM 
	Orders AS O
INNER JOIN 
	Customers C 
ON 
	O.Customer_ID = C.Customer_ID
INNER JOIN 
	Products P 
ON 
	O.New_Product_ID = P.New_Product_ID
GROUP BY
	O.Ship_Mode,
    C.Segment,
    P.Category,
	P.Sub_Category
ORDER BY 
	Avg_Delivery_time DESC;
-------------------------------------------------------------------
---  12--Are there any city or state with a signifficantly higher concentration of customers?
 SELECT
    TOP 15 City,
    COUNT(Order_ID) AS Total_NO_Orders,
    SUM(Sales) AS Total_Sales,
	COUNT(DISTINCT Customer_ID) AS Total_customers
FROM 
	Orders
GROUP BY 
	City
ORDER BY 
	Total_NO_Orders DESC, 
	Total_Sales DESC,
	Total_customers DESC;
-------------------------------------------------------------------
---  13-Number of Orders:    ---------------------------------------------------------------->KPI
SELECT 
    COUNT( DISTINCT Order_ID) AS Total_Orders
FROM 
	Orders;
-------------------------------------------------------------------
--- 14- Total number of orders per each year:
SELECT 
	YEAR(Order_Date) AS Year,
	MONTH(Order_Date) AS Month,
    COUNT( DISTINCT Order_ID) AS Total_Orders
FROM 
	Orders
GROUP BY 
	YEAR(Order_Date),
	MONTH(Order_Date);
------------------------------
SELECT 
	YEAR(Order_Date) AS Year,
    COUNT( DISTINCT Order_ID) AS Total_Orders
FROM 
	Orders
GROUP BY 
	YEAR(Order_Date);
-------------------------------------------------------------------
--- 15-Most commonly used ship mode:
SELECT
    Ship_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM
    Orders
GROUP BY
    Ship_Mode
ORDER BY
	Total_Orders DESC;
-------------------------------------------------------------------
--- Check if any orderd distributed on more than 1 ship mode or not: 
SELECT
    Ship_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM
    Orders
WHERE 
    Order_ID IN (
        SELECT Order_ID
        FROM Orders
        GROUP BY Order_ID
        HAVING COUNT(DISTINCT Ship_Mode) > 1
    )
GROUP BY
    Ship_Mode
ORDER BY
    Total_Orders DESC;
	--- we found that , No orders distributed on more than 1 ship mode
-------------------------------------------------------------------
--- 16- Which ship mode is the most used mode , relation between ship mode and the segment:
SELECT
    Segment,
    Ship_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM
    Orders 
INNER JOIN 
    Customers 
ON 
	Orders.Customer_ID = Customers.Customer_ID
GROUP BY
    Segment,
    Ship_Mode
ORDER BY
    Total_Orders DESC;
------------------------------
SELECT
    Ship_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM
    Orders 
GROUP BY
    Ship_Mode
ORDER BY
    Total_Orders DESC;
------------------------------
SELECT
    Segment,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM
    Orders 
INNER JOIN 
    Customers 
ON 
	Orders.Customer_ID = Customers.Customer_ID
GROUP BY
    Segment
ORDER BY
    Total_Orders DESC;
-------------------------------------------------------------------
--- 17- Total number of products , category , sub category:    ---------------------------------------------------------------->KPI
SELECT 
	COUNT( DISTINCT Product_ID ) As Total_Products,
	COUNT( DISTINCT Category ) As Total_Categories,
	COUNT( DISTINCT Sub_Category ) As Total_Sub_Categories
FROM 
	Products;
-------------------------------------------------------------------
--- 18- Which product , Category and sub-category generate highest sales?
SELECT 
		Product_ID,
		Category,
		Sub_Category,
		SUM(Sales) AS Total_Sales,
		COUNT(Product_ID) AS number_of_sales
FROM
	Products
INNER JOIN
	Orders 
ON 
	Products.New_Product_ID= Orders.New_Product_ID
GROUP BY
		Product_ID,
		Category,
		Sub_Category
ORDER BY 
	Total_Sales DESC;
------------------------------
--- Total Sales Per Category:
SELECT 
		Category,
		SUM(Sales) AS Total_Sales,
		COUNT(Product_ID) AS number_of_sales
FROM
	Products
INNER JOIN
	Orders 
ON 
	Products.New_Product_ID= Orders.New_Product_ID
GROUP BY
		Category
ORDER BY 
	Total_Sales DESC;
------------------------------
--- Total Sales Per Sub_Category:
SELECT 
		Sub_Category,
		SUM(Sales) AS Total_Sales
FROM
	Products
INNER JOIN
	Orders 
ON 
	Products.New_Product_ID= Orders.New_Product_ID
GROUP BY
		Sub_Category
ORDER BY 
	Total_Sales DESC;
------------------------------
--- Total sales and product sales count:
SELECT 
	Product_ID,
	SUM(Sales) AS Total_Sales,
	COUNT (Product_ID) AS number_of_sales
FROM
	Products
INNER JOIN
	Orders
ON
	Products.[New_Product_ID]= Orders.[New_Product_ID]
GROUP BY 
	Product_ID
ORDER BY
	Total_Sales DESC,
	number_of_sales;
-------------------------------------------------------------------
--- 19- Product generate highest sales:
With Most_selling_product As 
(
	SELECT 
		TOP 1
			Product_ID,
			Category,
			Sub_Category,
			SUM(Sales) as Total_Sales,
			COUNT ( Product_ID) As number_of_sales
	FROM
		Products
	INNER JOIN 
		Orders 
	ON Products.[New_Product_ID]= Orders.[New_Product_ID]
	GROUP BY 
		Product_ID,
		Category,
		Sub_Category
	ORDER BY
		Total_Sales DESC
)

SELECT 
	*
FROM
	Most_selling_product;
-------------------------------------------------------------------
--- 20-Frequency of orders by per customer ? Top 10:
SELECT 
	Top 10
    Customers.Customer_ID,
	Orders.Ship_Mode,
	Customers.Segment,
    COUNT(DISTINCT Orders.Order_ID) AS Order_Frequency
FROM 
    Customers
Inner JOIN 
    Orders 
ON 
	Customers.Customer_ID = Orders.Customer_ID
GROUP BY 
    Customers.Customer_ID, 
    Orders.Ship_Mode,
	Customers.Segment
ORDER BY 
    Order_Frequency DESC;
------------------------------
SELECT 
	Top 10
    Customers.Customer_ID,
    COUNT(DISTINCT Orders.Order_ID) AS Order_Frequency
FROM 
    Customers
Inner JOIN 
    Orders 
ON 
	Customers.Customer_ID = Orders.Customer_ID
GROUP BY 
    Customers.Customer_ID
ORDER BY 
    Order_Frequency DESC;
------------------------------
SELECT 
	Top 10
    Customers.Customer_ID,
	Orders.Ship_Mode,
    COUNT(DISTINCT Orders.Order_ID) AS Order_Frequency
FROM 
    Customers
Inner JOIN 
    Orders 
ON 
	Customers.Customer_ID = Orders.Customer_ID
GROUP BY 
    Customers.Customer_ID, 
    Orders.Ship_Mode
ORDER BY 
    Order_Frequency DESC;
------------------------------
SELECT 
	Top 10
    Customers.Customer_ID,
	Customers.Segment,
    COUNT(DISTINCT Orders.Order_ID) AS Order_Frequency
FROM 
    Customers
Inner JOIN 
    Orders 
ON 
	Customers.Customer_ID = Orders.Customer_ID
GROUP BY 
    Customers.Customer_ID,
	Customers.Segment
ORDER BY 
    Order_Frequency DESC;
	--- answer : the most buyer is not the same as the highest sales customer.
------------------------------
--- Most Common Shipping Mode
SELECT 
Top 1
    Ship_Mode,
    COUNT( distinct Order_ID) AS Usage_ship_mode
FROM 
    Orders
GROUP BY 
	Ship_Mode
ORDER BY 
    Usage_ship_mode DESC;
-------------------------------------------------------------------
--- 21-Orders, Customers and products:
--- Mostly requested product , Most selling products, Most product / most buyer - AVG shipping duration:
SELECT 
    New_Product_ID,
    COUNT(Order_ID) AS Total_number_orders,
    SUM(Sales) AS Total_sales,
    AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS Avg_Shipping_Duration
FROM
    Orders
GROUP BY 
    New_Product_ID
ORDER BY 
    Total_number_orders DESC;
----------------------------------------------
-- Mostly requested product and most frequent customer per each:
SELECT 
    TOP 10
    New_Product_ID,
    COUNT(Order_ID) AS Total_number_orders,
    SUM(Sales) AS Total_sales,
	AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS Avg_Shipping_Duration,
    (
        SELECT TOP 1 
            Customer_ID
        FROM 
            Orders AS CST_ORD
        WHERE 
            CST_ORD.New_Product_ID = Orders.New_Product_ID
        GROUP BY 
            Customer_ID
        ORDER BY 
            COUNT(Order_ID) DESC
    ) AS Most_Frequent_Customer
FROM
    Orders
GROUP BY 
    New_Product_ID
ORDER BY 
    Total_number_orders DESC;
------------------
--- Highest shipping duration for products:
SELECT 
    TOP 10
    New_Product_ID,
	AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS Avg_Shipping_Duration
FROM
	Orders
GROUP BY
	New_Product_ID
ORDER BY
	Avg_Shipping_Duration DESC;
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
---RMF analysis:
SELECT 
	*
From 
	( 
		SELECT
			Customer_ID,
			COUNT(distinct Order_ID) AS Frequency,
			ROUND(SUM(Sales),2) AS Total_Sales,
			Max(Order_Date) AS Max_order_date,
			(
			SELECT 
				MAX(Order_Date) 
			FROM 
				Orders) AS Last_Order_Date
		From
			Orders
		GROUP BY
			Customer_ID
	)  AS Freq_sales_maxdate
ORDER BY
	Total_sales DESC;
------------------------------------------------
--- RMF Segmentation orderd by Total Sales:
SELECT 
	Top 10
    Customer_ID,
	Total_Sales,
    CASE 
        WHEN Frequency BETWEEN 1 AND 5 THEN 'Least_Freq'
        WHEN Frequency BETWEEN 6 AND 10 THEN 'Medium_Freq'
        ELSE 'Highest_Freq' 
    END AS Freq_Segment,

    CASE 
        WHEN Recency BETWEEN 0 AND 500 THEN 'A'
        WHEN Recency BETWEEN 501 AND 1000 THEN 'B'
        ELSE 'C' 
    END AS Rec_Segment, 

    CASE 
        WHEN Total_Sales BETWEEN 1 AND 5000 THEN 'E_Value'
        WHEN Total_Sales BETWEEN 5001 AND 10000 THEN 'D_Value'
        WHEN Total_Sales BETWEEN 10001 AND 15000 THEN 'C_Value'
        WHEN Total_Sales BETWEEN 15001 AND 20000 THEN 'B_Value'
        ELSE 'A_Value'  
    END AS Monetary_Segment
FROM (
    SELECT
        Customer_ID,
        Total_Sales,
        Frequency,
        DATEDIFF(DAY, Max_Order_Date, Last_Order_Date) AS Recency
    FROM (
        SELECT
            Customer_ID,
            COUNT(DISTINCT Order_ID) AS Frequency,
            ROUND(SUM(Sales), 2) AS Total_Sales,
            MAX(Order_Date) AS Max_Order_Date,
            (SELECT 
				MAX(Order_Date) 
			FROM Orders) AS Last_Order_Date
        FROM
            Orders
        GROUP BY 
            Customer_ID
    ) AS Freq_Sales_MaxDate
) AS RMF 
ORDER BY 
	Total_Sales DESC;