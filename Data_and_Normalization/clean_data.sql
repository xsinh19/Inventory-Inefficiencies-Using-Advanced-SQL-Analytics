CREATE TABLE Dates (
    Date TEXT PRIMARY KEY,
    Month INTEGER,
    Week INTEGER,
    Quarter INTEGER,
    Is_Holiday TEXT,
    Season TEXT
);
INSERT INTO Dates (Date, Month, Week, Quarter, Is_Holiday, Season)
SELECT
    Date,
    CAST(strftime('%m', Date) AS INTEGER) AS Month,
    CAST(strftime('%W', Date) AS INTEGER) AS Week,
    ((CAST(strftime('%m', Date) AS INTEGER) - 1) / 3 + 1) AS Quarter,
    MIN(Holiday_Promotion),
    MIN(Seasonality)
FROM inventory_clean
GROUP BY Date;


CREATE TABLE Stores (
    Store_ID TEXT PRIMARY KEY,
    Region TEXT
);


INSERT INTO Stores (Store_ID, Region)
SELECT Store_ID, Region
FROM (
    SELECT Store_ID, Region,
           COUNT(*) AS cnt,
           ROW_NUMBER() OVER (PARTITION BY Store_ID ORDER BY COUNT(*) DESC) AS rn
    FROM inventory_clean
    GROUP BY Store_ID, Region
)
WHERE rn = 1;



CREATE TABLE Products (
    Product_ID TEXT PRIMARY KEY,
    Category TEXT
);

INSERT INTO Products (Product_ID, Category)
SELECT Product_ID, MIN(Category)
FROM inventory_clean
GROUP BY Product_ID;

DROP TABLE IF EXISTS Inventory_Facts;

CREATE TABLE Inventory_Facts (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Date TEXT,
    Store_ID TEXT,
    Product_ID TEXT,
    Inventory_Level INTEGER,
    Units_Sold INTEGER,
    Units_Ordered INTEGER,
    Demand_Forecast REAL,
    Price REAL,
    Discount REAL,
    Weather_Condition TEXT,
    Holiday_Promotion TEXT,
    Competitor_Pricing REAL,
    FOREIGN KEY (Store_ID) REFERENCES Stores(Store_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID),
    FOREIGN KEY (Date) REFERENCES Dates(Date)
);

INSERT INTO Inventory_Facts (
    Date, Store_ID, Product_ID,
    Inventory_Level, Units_Sold, Units_Ordered,
    Demand_Forecast, Price, Discount,
    Weather_Condition, Holiday_Promotion, Competitor_Pricing
)
SELECT
    Date, Store_ID, Product_ID,
    Inventory_Level, Units_Sold, Units_Ordered,
    Demand_Forecast, Price, Discount,
    Weather_Condition, Holiday_Promotion, Competitor_Pricing
FROM inventory_clean;
