-- 📊 Stock Summary across Store, Region, and Category
SELECT 
    s.Region,
    f.Store_ID,
    p.Category,
    COUNT(DISTINCT f.Product_ID) AS Unique_Products,
    SUM(f.Inventory_Level) AS Total_Stock,
    SUM(f.Units_Sold) AS Total_Units_Sold,
    ROUND(AVG(f.Inventory_Level), 2) AS Avg_Stock_Per_Product,
    ROUND(1.0 * SUM(f.Units_Sold) / SUM(f.Inventory_Level), 2) AS Sell_Through_Rate,
    ROUND(1.0 * SUM(f.Inventory_Level) / SUM(f.Units_Sold), 2) AS Stock_to_Sales_Ratio
FROM Inventory_Facts f
JOIN Stores s ON f.Store_ID = s.Store_ID
JOIN Products p ON f.Product_ID = p.Product_ID
GROUP BY s.Region, f.Store_ID, p.Category
ORDER BY s.Region, f.Store_ID, p.Category;
