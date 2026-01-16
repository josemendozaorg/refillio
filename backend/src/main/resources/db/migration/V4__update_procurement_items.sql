ALTER TABLE procurement_order_items ADD COLUMN canonical_product_id UUID REFERENCES canonical_products(id);
ALTER TABLE procurement_order_items ALTER COLUMN listing_id DROP NOT NULL;
