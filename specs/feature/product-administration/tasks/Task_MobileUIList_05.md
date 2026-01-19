# Task 5: Mobile UI - Product List

## Objective
Implement the Product List screen using the new design.

## Steps
1.  **Create Screen**: `ProductListScreen` in `features/catalog/presentation`.
2.  **List View**:
    *   Use `ListView.separated`.
    *   Connect to `productsProvider` using `ref.watch`.
    *   Handle `AsyncValue` states (loading, error, data).
3.  **List Item**:
    *   Create `ProductListTile` widget.
    *   Display icon, name, category, and unit badge.
    *   Implement "Swipe to Delete" or Long Press menu.
4.  **Navigation**:
    *   FAB to navigate to `AddProductScreen`.
    *   Tap item to navigate to `EditProductScreen`.

## Verification
*   Launch app in emulator.
*   Verify list renders correctly with mock/real data.
*   Check loading and error states.
