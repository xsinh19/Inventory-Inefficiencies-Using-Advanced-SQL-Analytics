-- Step 1: Get start and end date (last 90-day window)
WITH max_dates AS (
  SELECT MAX(Date) AS end_date FROM Inventory_Facts
),
window AS (
  SELECT DATE(end_date, '-90 day') AS start_date, end_date
  FROM max_dates
),
base AS (
  SELECT f.*
  FROM Inventory_Facts f
  JOIN window w
    ON f.Date BETWEEN w.start_date AND w.end_date
)

/* --- Summary KPIs --- */
SELECT
  p.Category,
  COUNT(*) AS Records,
  
  -- Stock-out Days: when sold all available stock
  SUM(CASE WHEN Units_Sold >= Inventory_Level THEN 1 ELSE 0 END) AS Stockout_Days,
  
  -- Average Inventory across 90 days
  ROUND(AVG(Inventory_Level), 1) AS Avg_Stock_Level,
  
  -- Inventory Age proxy: stock-to-sales ratio
  ROUND(
    AVG(CASE 
          WHEN Units_Sold > 0 THEN 1.0 * Inventory_Level / Units_Sold 
          ELSE NULL 
        END), 1
  ) AS Avg_Inventory_Age,
  
  -- % of stockout days
  ROUND(
    100.0 * SUM(CASE WHEN Units_Sold >= Inventory_Level THEN 1 ELSE 0 END) / COUNT(*),
    2
  ) AS Stockout_Rate_Pct

FROM base b
JOIN Products p ON b.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Stockout_Rate_Pct DESC;
