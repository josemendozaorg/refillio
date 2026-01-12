-- Seed Initial Data for Demo

-- 1. Measurement Units
INSERT INTO measurement_units (symbol, type) VALUES 
('pcs', 'count'),
('pack', 'count'),
('l', 'volume'),
('ml', 'volume'),
('kg', 'mass'),
('g', 'mass')
ON CONFLICT (symbol) DO NOTHING;

-- 2. Categories
INSERT INTO categories (name, slug) VALUES 
('Dairy & Eggs', 'dairy-eggs'),
('Bakery', 'bakery'),
('Household', 'household'),
('Beverages', 'beverages'),
('Pantry Staples', 'pantry-staples')
ON CONFLICT (slug) DO NOTHING;

-- 3. Canonical Products
-- We need to look up IDs for FKs, so we use subqueries or DO blocks. 
-- For simplicity in standard SQL, we'll use subqueries.

INSERT INTO canonical_products (name, description, category_id, base_unit_id)
SELECT 'Milk 3.2%', 'Fresh cow milk, 3.2% fat', c.id, u.id
FROM categories c, measurement_units u
WHERE c.slug = 'dairy-eggs' AND u.symbol = 'l'
AND NOT EXISTS (SELECT 1 FROM canonical_products WHERE name = 'Milk 3.2%');

INSERT INTO canonical_products (name, description, category_id, base_unit_id)
SELECT 'Butter 82%', 'Creamery butter, 200g block', c.id, u.id
FROM categories c, measurement_units u
WHERE c.slug = 'dairy-eggs' AND u.symbol = 'pcs'
AND NOT EXISTS (SELECT 1 FROM canonical_products WHERE name = 'Butter 82%');

INSERT INTO canonical_products (name, description, category_id, base_unit_id)
SELECT 'Sourdough Bread', 'Whole wheat sourdough loaf', c.id, u.id
FROM categories c, measurement_units u
WHERE c.slug = 'bakery' AND u.symbol = 'pcs'
AND NOT EXISTS (SELECT 1 FROM canonical_products WHERE name = 'Sourdough Bread');

INSERT INTO canonical_products (name, description, category_id, base_unit_id)
SELECT 'Toilet Paper 3-ply', 'Soft 3-ply toilet tissue', c.id, u.id
FROM categories c, measurement_units u
WHERE c.slug = 'household' AND u.symbol = 'pack'
AND NOT EXISTS (SELECT 1 FROM canonical_products WHERE name = 'Toilet Paper 3-ply');

INSERT INTO canonical_products (name, description, category_id, base_unit_id)
SELECT 'Mineral Water 1.5L', 'Sparkling natural mineral water', c.id, u.id
FROM categories c, measurement_units u
WHERE c.slug = 'beverages' AND u.symbol = 'pcs'
AND NOT EXISTS (SELECT 1 FROM canonical_products WHERE name = 'Mineral Water 1.5L');

INSERT INTO canonical_products (name, description, category_id, base_unit_id)
SELECT 'Dish Soap', 'Lemon scent dishwashing liquid', c.id, u.id
FROM categories c, measurement_units u
WHERE c.slug = 'household' AND u.symbol = 'l'
AND NOT EXISTS (SELECT 1 FROM canonical_products WHERE name = 'Dish Soap');

INSERT INTO canonical_products (name, description, category_id, base_unit_id)
SELECT 'Pasta (Fusilli)', 'Durum wheat pasta, 500g', c.id, u.id
FROM categories c, measurement_units u
WHERE c.slug = 'pantry-staples' AND u.symbol = 'pack'
AND NOT EXISTS (SELECT 1 FROM canonical_products WHERE name = 'Pasta (Fusilli)');
