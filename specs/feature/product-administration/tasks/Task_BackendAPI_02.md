# Task 2: Backend API Implementation

## Objective
Expose CRUD endpoints for managing Canonical Products.

## Steps
1.  **Create Repository**:
    *   `CanonicalProductRepository`: `findAll`, `findById`, `create`, `update`, `delete`.
2.  **Create Service**:
    *   `CanonicalProductService`: Business logic, validation (e.g., ensure name is unique).
3.  **Create Controller**:
    *   `GET /api/v1/products`: List products (pagination, filtering).
    *   `GET /api/v1/products/:id`: Get details.
    *   `POST /api/v1/products`: Create new product.
    *   `PUT /api/v1/products/:id`: Update.
    *   `DELETE /api/v1/products/:id`: Delete (soft delete preferred if referenced).
4.  **Register Routes**: Add to main router.

## Verification
*   Use `curl` or Postman to test all endpoints.
*   Write integration tests for the controller.
