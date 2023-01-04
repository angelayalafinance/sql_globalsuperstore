.open --new "c:/ucf_classes/eco_4444_fall_2021/sql/databases/Global_Superstore.db"

/* Creation of the People table */
CREATE TABLE People
(
Person      Text , 
Region      Text ,
PRIMARY KEY (Region)
)
;

.separator ,
.import --csv --skip 1 c:/ucf_classes/eco_4444_fall_2021/sql/data/people_global.csv People


.mode column
.headers on 

/* Creation of the Returned table */

CREATE TABLE Returned
(
Returned    Text ,
`Order ID`  Text ,
Market      Text ,
PRIMARY KEY (`Order ID`)
)
;

.import --skip 1 c:/ucf_classes/eco_4444_fall_2021/sql/data/returns_global.csv Returned



/* Creation of the Orders table */
CREATE TABLE Orders
(
`Row ID`            Integer ,
`Order ID`          Text ,
`Order Date`        Text ,
`Ship Date`         Text ,
`Ship Mode`         Text ,
`Customer ID`       Text ,
`Customer Name`     Text ,
Segment             Text , 
City                Text ,
State               Text , 
Country             Text ,
`Postal Code`       Text ,
Market              Text ,
Region              Text ,
`Product ID`        Text ,
Category            Text ,
`Sub-Category`      Text ,
`Product Name`      Text ,
Sales               Real ,
Quantity            Integer ,
Discount            Real ,
Profit              Real ,
`Shipping Cost`     Real ,
`Order Priority`    Text ,
PRIMARY KEY (`Row ID`) ,
FOREIGN KEY (Region) REFERENCES People (Region) ,
FOREIGN KEY (`Order ID`) REFERENCES Returned (`Order ID`) 
)
;

.import --skip 1 c:/ucf_classes/eco_4444_fall_2021/sql/data/orders_global.csv Orders



/*C. Query the database to determine the countries contained in it and the number of salesoriginating from each country over all years. 
   Assign the alias ‘Number of Sales’ to each ofthe country counts, and place these in descending order by the number of sales. */

SELECT Country , 
COUNT(Country) AS `Number of Sales`
FROM Orders
GROUP BY Country
ORDER BY -`Number of Sales` 
;

/* D. Modify the query in ‘C’ to identify countries with at least one ‘Z’ (or ‘z’) in their names. */

SELECT Country , 
COUNT(Country) AS `Number of Sales`
FROM Orders
GROUP BY Country 
HAVING Country LIKE '%Z%'
ORDER BY -`Number of Sales` 
;

/* E. For each of the countries identified in ‘D’, determine the total profit and profit per sale overthe period. 
Round both to 2 decimal places, assign the aliases ‘Total Profit’ and ‘Profit perSale’, respectively, and place 
the results in descending order by ‘Profit per Sale’. */

SELECT Country , 
round(SUM(Profit), 2) AS `Total Profit` ,
round((Profit / Sales), 2) AS `Profit per Sale`
FROM Orders
GROUP BY Country 
HAVING Country LIKE '%Z%'
ORDER BY -`Profit per Sale`
;

/* F. Modify the query in ‘E’ to identify countries whose total profit or profit per unit is negative. */

SELECT Country , 
round(SUM(Profit), 2) AS `Total Profit` ,
round((Profit / Quantity), 2) AS `Profit per unit`
FROM Orders
GROUP BY Country 
HAVING Country LIKE '%Z%'
AND (`Total Profit` < 0 OR `Profit per unit` < 0) 
ORDER BY -`Profit per unit`
;

/* G. From the full set of countries identified in ‘B’, choose 2 that are of interest to you. 
Query thedatabase in order to determine the quantity of sales, total sales revenue, sales revenue perunit, total profit, and profit per unit for each country over all periods. 
Round the results to2 decimal places and assign aliases of your choosing. */

SELECT Country , 
COUNT(Country) AS `Number of Sales` ,
round(SUM(Sales), 2) AS `Total Sales` ,
round((Sales / Quantity), 2) AS `Sales per Unit` ,
round(SUM(Profit), 2) AS `Total Profit` ,
round((Profit / Quantity), 2) AS `Profit per unit`
FROM Orders
GROUP BY Country
HAVING Country LIKE '%Singapore%'
OR Country LIKE  '%Switzerland%'
;

/* H. Modify the query in ‘G’ to report the quantity of sales, total sales revenue, sales revenue perunit, total profit, 
and profit per unit on an annual basis through substringing of either ‘OrderID’ or ‘Order Date’. Report the results in ascending order by year (e.g., 2011, 2012, etc.). */

SELECT Country , 
SUBSTR(`Order Date`, -4, 4) as Year ,
COUNT(Country) AS `Number of Sales` ,
round(SUM(Sales), 2) AS `Total Sales` ,
round((Sales / Quantity), 2) AS `Sales per Unit` ,
round(SUM(Profit), 2) AS `Total Profit` ,
round((Profit / Quantity), 2) AS `Profit per unit`
FROM Orders
GROUP BY Year, Country
HAVING Country LIKE '%Singapore%'
OR Country LIKE  '%Switzerland%'
;

/* I. Modify the query in ‘H’ to report the quantity of sales, total sales revenue, sales revenue perunit,  
total  profit,  and  profit  per  unit  on  an  monthly  basis  within  each  year  throughsubstringing of either ‘Order ID’ or ‘Order Date’. 
Report the results in ascending order byyear and month within each. */

SELECT Country , 
SUBSTR(`Order Date`, -4, 4) as Year ,
CAST(RTRIM(SUBSTR(`Order Date`, 1, 2), '/') AS Integer) AS Month ,
COUNT(Country) AS `Quantity of Sales` ,
round(SUM(Sales), 2) AS `Total Sales Revenue` ,
round((Sales / Quantity), 2) AS `Sales per Unit` ,
round(SUM(Profit), 2) AS `Total Profit` ,
round((Profit / Quantity), 2) AS `Profit per unit`
FROM Orders
GROUP BY Country, Year, Month
HAVING Country LIKE '%Singapore%'
OR Country LIKE  '%Switzerland%'
;


/* J. Query the database to report the quantity of sales, total sales revenue, sales revenue per unit,total profit, and profit per unit by Region over all periods. */

SELECT Region ,
COUNT(Country) AS `Quantity of Sales` ,
round(SUM(Sales), 2) AS `Total Sales Revenue` ,
round((Sales / Quantity), 2) AS `Sales Revenue per Unit` ,
round(SUM(Profit), 2) AS `Total Profit` ,
round((Profit / Quantity), 2) AS `Profit per unit`
FROM Orders
GROUP BY Region
;


/* K. Modify the query in ‘J’ to report the quantity of sales, total sales revenue, sales revenue perunit, total profit, and 
profit per unit by Region on an annual basis, similar to ‘H’. */

SELECT Region ,
SUBSTR(`Order ID`, 4, 4) as Year ,
COUNT(Country) AS `Quantity of Sales` ,
round(SUM(Sales), 2) AS `Total Sales Revenue` ,
round((Sales / Quantity), 2) AS `Sales per Unit` ,
round(SUM(Profit), 2) AS `Total Profit` ,
round((Profit / Quantity), 2) AS `Profit per unit`
FROM Orders
GROUP BY Region, Year
;


/* L. Join the Orders table and the People table in order to report the quantity of sales, total salesrevenue,
 sales revenue per unit, total profit, and profit per unit by Region and by Person(regional manager) on an annual basis. */

SELECT P.Person , O.Region ,
SUBSTR(`Order ID`, 4, 4) as Year ,
COUNT(Country) AS `Quantity of Sales` ,
round(SUM(Sales), 2) AS `Total Sales Revenue` ,
round((SUM(Sales) / Quantity), 2) AS `Sales Revenue per Unit` ,
round(SUM(Profit), 2) AS `Total Profit` ,
round((Profit / Sales), 2) AS `Profit per Sale`

FROM Orders AS O
JOIN People AS P
ON P. Region = O. Region
GROUP BY Person, Year
 ;

 /* M. Lastly, join all 3 tables to determine the lost total profit from returned items and lost profitper  item  returned  
 for  each  Region  and  Person  (regional  manager)  over  all  years.Export/output the results of this query to a .csv filed named 
 ‘lost_profits_by_region.csv’.Open the file (e.g., in Excel) to confirm that it contains the desired information. */
.headers on
.mode csv
.output C:/ucf_classes/eco_4444_fall_2021/sql/intermediate/lost_profits_by_region.csv

SELECT P.Person, O.Region , 
COUNT(P.Person) AS `Total Returns` ,
round(SUM(Profit), 2) AS `Total Lost Profit` ,
round(SUM(Profit) / COUNT(P.Person), 2) AS `Lost Profit per Item`

FROM Orders as O
JOIN Returned AS R ON O.`Order ID` = R.`Order ID`
JOIN People as P ON P.Region = O.Region
GROUP BY P.Region
;
