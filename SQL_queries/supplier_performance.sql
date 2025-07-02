WITH lagged AS (
  SELECT
    Store_ID,
    Product_ID,
    Date,
    Inventory_Level,
    Units_Ordered,
    Units_Sold,
    LAG(Inventory_Level) OVER (
      PARTITION BY Store_ID, Product_ID ORDER BY Date
    ) AS Prev_Inventory,
    LAG(Units_Sold) OVER (
      PARTITION BY Store_ID, Product_ID ORDER BY Date
    ) AS Prev_Sales
  FROM Inventory_Facts
),
inconsistencies AS (
  SELECT
    Store_ID,
    Product_ID,
    Date,
    Prev_Inventory,
    Inventory_Level,
    Units_Ordered,
    Prev_Sales,
    CASE
      WHEN Prev_Inventory - Prev_Sales <= 10 AND Units_Ordered = 0 THEN '⚠️ Missed Reorder'
      WHEN Units_Ordered > 0 AND Inventory_Level - Prev_Inventory < 0 THEN '⚠️ Order But No Refill'
      ELSE '✅ OK'
    END AS Supply_Alert
  FROM lagged
)
SELECT
  Store_ID,
  Product_ID,
  Date,
  Supply_Alert,
  COUNT(*) OVER (PARTITION BY Product_ID, Supply_Alert) AS Occurrences
FROM inconsistencies
WHERE Supply_Alert != '✅ OK'
ORDER BY Product_ID, Date;
