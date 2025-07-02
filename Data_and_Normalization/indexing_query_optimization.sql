
-- Index for joining and filtering by date
CREATE INDEX idx_inventory_date ON Inventory_Facts(Date);

-- Indexes for foreign keys
CREATE INDEX idx_inventory_store ON Inventory_Facts(Store_ID);
CREATE INDEX idx_inventory_product ON Inventory_Facts(Product_ID);

-- Index for product category-based filtering
CREATE INDEX idx_products_category ON Products(Category);

-- Index for region-based analysis
CREATE INDEX idx_stores_region ON Stores(Region);

