/* --- PARAMETERS --- */
-- Lead-time in days (how long suppliers take to deliver)
WITH params AS (
  SELECT 7  AS lead_time_days,
         0.3 AS safety_factor      -- 30 % extra buffer
),

/* --- 30-day rolling demand per Store + Product --- */
avg_30d AS (
  SELECT
    Store_ID,
    Product_ID,
    AVG(Units_Sold) AS avg_daily_demand
  FROM Inventory_Facts
  WHERE Date >= DATE((SELECT MAX(Date) FROM Inventory_Facts), '-30 day')
  GROUP BY Store_ID, Product_ID
),

/* --- Current on-hand stock (latest date) --- */
latest AS (
  SELECT f.*
  FROM Inventory_Facts f
  JOIN (SELECT Product_ID, Store_ID, MAX(Date) AS MaxDate
        FROM Inventory_Facts
        GROUP BY Product_ID, Store_ID) x
    ON x.Product_ID = f.Product_ID
   AND x.Store_ID   = f.Store_ID
   AND x.MaxDate    = f.Date
)

/* --- Final low-stock flag --- */
SELECT
  l.Store_ID,
  l.Product_ID,
  p.Category,
  l.Inventory_Level AS Current_Stock,
  ROUND(a.avg_daily_demand * (pr.lead_time_days + pr.lead_time_days*pr.safety_factor)) AS Reorder_Point,
  CASE
      WHEN l.Inventory_Level < ROUND(a.avg_daily_demand * (pr.lead_time_days + pr.lead_time_days*pr.safety_factor))
           THEN '⚠️  Reorder Now'
      ELSE 'OK'
  END AS Status
FROM latest l
JOIN avg_30d  a  USING (Store_ID, Product_ID)
JOIN params   pr ON 1=1
JOIN Products p  USING (Product_ID)
ORDER BY Status DESC, l.Store_ID, l.Product_ID;
