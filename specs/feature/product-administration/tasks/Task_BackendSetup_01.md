# Task 1: Backend Database & Entities

## Objective
Set up the database schema and TypeORM/Prisma entities for the Product Catalog.

## Steps
1.  **Create Migration**:
    *   Table `categories`: `id` (Serial), `name` (VarChar), `parent_id` (FK, nullable), `slug` (VarChar).
    *   Table `measurement_units`: `id` (Serial), `symbol` (VarChar), `type` (VarChar: 'volume'|'weight'|'count').
    *   Table `canonical_products`: `id` (UUID), `name` (VarChar), `description` (Text), `category_id` (FK), `base_unit_id` (FK).
2.  **Define Entities**: Add corresponding classes/schema definitions in `backend/src/domain/entities` (or equivalent path based on project structure).
3.  **Seed Data**: Create a seed script to populate basic Categories (Home, Kitchen, Hygiene) and Units (roll, ml, kg, pcs).

## Verification
*   Run migration command successfully.
*   Verify tables exist in the database.
*   Run seed script and query tables to check data.
