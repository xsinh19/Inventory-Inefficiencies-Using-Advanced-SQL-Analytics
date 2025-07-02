/* Inventory Turnover = Units Sold / Avg Inventory */
WITH sales AS (
  SELECT Product_ID,
         SUM(Units_Sold) AS total_sales
  FROM Inventory_Facts
  GROUP BY Product_ID
),
avg_stock AS (
  SELECT Product_ID,
         AVG(Inventory_Level) AS avg_inventory
  FROM Inventory_Facts
  GROUP BY Product_ID
)
SELECT
  p.Product_ID,
  p.Category,
  s.total_sales,
  a.avg_inventory,
  ROUND(1.0 * s.total_sales / a.avg_inventory, 2) AS Inventory_Turnover
FROM sales s
JOIN avg_stock a USING (Product_ID)
JOIN Products p  USING (Product_ID)
WHERE a.avg_inventory > 0
ORDER BY Inventory_Turnover DESC;
