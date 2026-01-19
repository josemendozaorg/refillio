# Task 3: Mobile Domain Layer

## Objective
Implement domain models and data transfer objects (DTOs) in the Flutter mobile app.

## Steps
1.  **Define Models**:
    *   `CanonicalProduct` (freezed): `id`, `name`, `description` (nullable), `category` (Category), `baseUnit` (MeasurementUnit).
    *   `Category` (freezed): `id`, `name`, `parentId` (nullable), `slug`.
    *   `MeasurementUnit` (freezed): `id`, `symbol`, `type`.
2.  **Define DTOs**: 
    *   `CreateProductDto`: `name`, `categoryId`, `baseUnitId`, `description`.
    *   `UpdateProductDto`: `id`, ...fields to update.
3.  **JSON Serialization**: Ensure `fromJson` and `toJson` methods are correctly generated.

## Verification
*   Run `dart run build_runner build` to generate freezed files.
*   Write unit tests for JSON serialization/deserialization to ensure compatibility with backend API.
