WITH monthly_sales AS (
  SELECT 
    f.Store_ID,
    strftime('%Y', f.Date) AS Year,
    strftime('%m', f.Date) AS Month,
    p.Category,
    SUM(f.Units_Sold) AS Monthly_Sales
  FROM Inventory_Facts f
  JOIN Products p ON f.Product_ID = p.Product_ID
  GROUP BY f.Store_ID, Year, Month, p.Category
),

-- 1️⃣ Forecast: multi-year average
forecast AS (
  SELECT
    Store_ID,
    Category,
    Month,
    ROUND(AVG(Monthly_Sales), 0) AS Forecast_Sales
  FROM monthly_sales
  GROUP BY Store_ID, Category, Month
),

-- 2️⃣ Actual: sales from most recent year
latest_year AS (
  SELECT MAX(Year) AS last_year FROM monthly_sales
),
actual AS (
  SELECT
    m.Store_ID,
    m.Category,
    m.Month,
    m.Monthly_Sales AS Actual_Sales
  FROM monthly_sales m
  JOIN latest_year y ON m.Year = y.last_year
)

-- 3️⃣ Combine both for comparison
SELECT
  f.Store_ID,
  f.Category,
  f.Month,
  f.Forecast_Sales,
  a.Actual_Sales,
  (a.Actual_Sales - f.Forecast_Sales) AS Error,
  ROUND(100.0 * (a.Actual_Sales - f.Forecast_Sales) / f.Forecast_Sales, 2) AS Percent_Error
FROM forecast f
JOIN actual a
  ON f.Store_ID = a.Store_ID AND f.Category = a.Category AND f.Month = a.Month
ORDER BY ABS(Percent_Error) DESC;
