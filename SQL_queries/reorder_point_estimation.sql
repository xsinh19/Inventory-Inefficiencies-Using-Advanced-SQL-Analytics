SELECT
  Store_ID,
  Product_ID,
  ROUND(AVG(Units_Sold) * 7 * 1.30) AS Suggested_Reorder_Point  -- avg weekly demand + 30 %
FROM Inventory_Facts
WHERE Date >= DATE((SELECT MAX(Date) FROM Inventory_Facts), '-90 day')
GROUP BY Store_ID, Product_ID
ORDER BY Suggested_Reorder_Point DESC;
