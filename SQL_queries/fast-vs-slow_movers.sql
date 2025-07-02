WITH recent_sales AS (
  SELECT
    Product_ID,
    SUM(Units_Sold) * 1.0 / COUNT(DISTINCT Date) AS Daily_Velocity
  FROM Inventory_Facts
  WHERE Date >= DATE((SELECT MAX(Date) FROM Inventory_Facts), '-30 day')
  GROUP BY Product_ID
),
ranked AS (
  SELECT
    r.*,
    ROW_NUMBER() OVER (ORDER BY Daily_Velocity DESC) AS rnk,
    COUNT(*) OVER () AS total
  FROM recent_sales r
),
labeled AS (
  SELECT
    Product_ID,
    Daily_Velocity,
    CASE
      WHEN rnk <= total * 0.25 THEN '🚀 Fast'
      WHEN rnk >= total * 0.75 THEN '🐢 Slow'
      ELSE '⚖️ Average'
    END AS Speed_Bucket
  FROM ranked
)
SELECT
  l.Product_ID,
  p.Category,
  l.Daily_Velocity,
  l.Speed_Bucket
FROM labeled l
JOIN Products p USING (Product_ID)
ORDER BY l.Daily_Velocity DESC;
