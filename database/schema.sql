-- Refillio Database Schema
-- Dialect: PostgreSQL

-- ==========================================
-- MODULE A: IDENTITY & SETTINGS
-- ==========================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    -- We'll use Supabase/Auth0 so password handling might be delegated, 
    -- but keeping a placeholder for internal auth reference if needed.
    auth_provider_id VARCHAR(255), 
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR(100),
    language_pref VARCHAR(5) DEFAULT 'en', -- en, pl
    currency_pref VARCHAR(3) DEFAULT 'PLN'
);

CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    postal_code VARCHAR(20) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(2) DEFAULT 'PL',
    is_allegro_smart BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    plan_type VARCHAR(20) NOT NULL, -- 'fixed_annual', 'percent_savings'
    status VARCHAR(20) NOT NULL DEFAULT 'active', -- 'active', 'cancelled', 'past_due'
    valid_until TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- MODULE B: GLOBAL CATALOG (The "Truth")
-- ==========================================

CREATE TABLE measurement_units (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL UNIQUE, -- ml, l, g, kg, roll, pcs, tab
    type VARCHAR(20) NOT NULL -- volume, mass, count
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    slug VARCHAR(100) UNIQUE
);

CREATE TABLE canonical_products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id INTEGER REFERENCES categories(id),
    base_unit_id INTEGER REFERENCES measurement_units(id),
    name VARCHAR(200) NOT NULL, -- e.g., "Toilet Paper 3-ply", "Dish Soap"
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- MODULE C: MARKET INTELLIGENCE
-- ==========================================

CREATE TABLE providers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE, -- 'Allegro', 'Ceneo', 'Amazon PL'
    base_url VARCHAR(255),
    scraper_strategy_key VARCHAR(50) NOT NULL -- 'api_allegro', 'html_ceneo'
);

CREATE TABLE provider_listings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_id INTEGER REFERENCES providers(id),
    canonical_product_id UUID REFERENCES canonical_products(id),
    external_id VARCHAR(255), -- The ID on the remote platform
    listing_url TEXT NOT NULL,
    title VARCHAR(255),
    
    -- Normalization Logic
    -- Example: Listing is "Pack of 16 rolls". 
    -- Canonical Product base unit is "roll".
    -- normalization_factor = 16.0
    normalization_factor DECIMAL(10, 2) NOT NULL DEFAULT 1.0,
    
    last_checked_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE price_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    listing_id UUID REFERENCES provider_listings(id) ON DELETE CASCADE,
    price_total DECIMAL(10, 2) NOT NULL, -- The price displayed on the site
    currency VARCHAR(3) DEFAULT 'PLN',
    shipping_cost DECIMAL(10, 2) DEFAULT 0.00,
    
    -- Calculated: (price_total + shipping_cost) / normalization_factor
    calculated_price_per_unit DECIMAL(10, 4), 
    
    captured_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- MODULE D: USER WAREHOUSE (Inventory)
-- ==========================================

CREATE TABLE inventory_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    canonical_product_id UUID REFERENCES canonical_products(id),
    
    current_qty DECIMAL(10, 2) DEFAULT 0.00,
    
    -- Settings
    reorder_point DECIMAL(10, 2) DEFAULT 1.00, -- "Par Level"
    auto_reorder BOOLEAN DEFAULT FALSE,
    
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE consumption_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    inventory_item_id UUID REFERENCES inventory_items(id) ON DELETE CASCADE,
    qty_consumed DECIMAL(10, 2) NOT NULL,
    event_type VARCHAR(50) DEFAULT 'manual_log', -- 'manual_log', 'auto_estimated'
    occurred_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE procurement_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    status VARCHAR(20) DEFAULT 'draft', -- 'draft', 'suggested', 'ordered', 'completed'
    
    total_amount DECIMAL(10, 2),
    estimated_savings DECIMAL(10, 2),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE procurement_order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES procurement_orders(id) ON DELETE CASCADE,
    listing_id UUID REFERENCES provider_listings(id), -- The specific deal we found (Optional in Phase 1)
    canonical_product_id UUID REFERENCES canonical_products(id), -- Fallback for generic reorders
    quantity INTEGER NOT NULL DEFAULT 1,
    
    price_at_purchase DECIMAL(10, 2),
    reference_market_price DECIMAL(10, 2) -- To calculate savings later
);

-- Indexes for performance
CREATE INDEX idx_listings_product ON provider_listings(canonical_product_id);
CREATE INDEX idx_price_snapshots_listing ON price_snapshots(listing_id);
CREATE INDEX idx_inventory_user ON inventory_items(user_id);
