WITH monthly_sales AS (
  SELECT 
    strftime('%Y', Date) AS Year,
    strftime('%m', Date) AS Month,
    p.Category,
    SUM(f.Units_Sold) AS Monthly_Sales
  FROM Inventory_Facts f
  JOIN Products p ON f.Product_ID = p.Product_ID
  GROUP BY Year, Month, p.Category
),
category_month_avg AS (
  SELECT
    Category,
    Month,
    ROUND(AVG(Monthly_Sales), 0) AS Avg_Monthly_Sales,
    MAX(Year) AS Last_Year
  FROM monthly_sales
  GROUP BY Category, Month
),
forecast AS (
  SELECT
    Category,
    Month,
    Avg_Monthly_Sales AS Forecast_Next_Year
  FROM category_month_avg
)
SELECT 
  Category,
  Month,
  Forecast_Next_Year
FROM forecast
ORDER BY Category, Month;
