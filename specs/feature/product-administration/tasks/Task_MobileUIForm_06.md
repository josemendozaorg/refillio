# Task 6: Mobile UI - Add/Edit Form

## Objective
Implement the form for creating and editing products.

## Steps
1.  **Create Screen**: `AddEditProductScreen`.
2.  **Form State**:
    *   Use `GlobalKey<FormState>`.
    *   Controllers for Name, Description.
    *   State variables for Category and Unit selection.
3.  **Logic**:
    *   Prefil data if editing.
    *   Validation: Name required, Category required, Unit required.
    *   On Save: Call `productController.create` or `.update`.
    *   On Success: Show Snackbar and pop navigation.
    *   On Error: Show error dialog.

## Verification
*   Test form validation (try saving empty form).
*   Test creating a new product.
*   Test editing an existing product.
