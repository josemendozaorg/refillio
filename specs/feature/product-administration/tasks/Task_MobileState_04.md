# Task 4: Mobile State Management

## Objective
Implement the repository pattern and state management for Products.

## Steps
1.  **ProductRepository**:
    *   `fetchProducts()`: Returns `Future<List<CanonicalProduct>>`.
    *   `deleteProduct(id)`: Returns `result`.
    *   `createProduct(dto)`: Returns `Future<CanonicalProduct>`.
    *   `updateProduct(dto)`: Returns `Future<CanonicalProduct>`.
2.  **Providers**:
    *   `productsProvider`: A Riverpod `FutureProvider` or `AsyncNotifier` to hold the list of products.
    *   `productControllerProvider`: A class/provider to handle the business logic of adding/editing/deleting (calling repo -> updating state).

## Verification
*   Write widget/unit tests mocking the API client to verify repository logic.
*   Verify state updates (optimistic UI or refresh) on mocked actions.
