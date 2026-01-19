# Product Administration UX Design

## Goal
Enable administrators to manage the `CanonicalProduct` catalog (add, edit, update, delete products).

## User Flow

1. **Entry Point**: A "Manage Products" tile in the Settings or Admin Dashboard.
2. **Product List View**:
    - **Header**: Title "Global Catalog". Actions: Search.
    - **List**:
        - Displays list of `CanonicalProduct`s.
        - **Item Layout**:
            - Leading: Product Icon/Avatar (auto-generated from initials or placeholder image).
            - Title: Product Name.
            - Subtitle: Category Path (e.g., Home > Hygiene).
            - Trailing: Base Unit badge (e.g., "roll").
        - **Interactions**:
            - Tap: Opens "Edit Product" form.
            - Swipe Left: Delete (with confirmation).
    - **Floating Action Button**: "+" Icon to add a new product.

3. **Add/Edit Product View (Modal Bottom Sheet or Full Screen)**:
    - **Title**: "New Product" or "Edit Product".
    - **Form Fields**:
        - **Name**: Text Input. Validates non-empty.
            - *Hint*: "e.g., Toilet Paper 3-ply"
        - **Description**: Multiline Text Input.
            - *Hint*: "Detailed specs..."
        - **Category**: Dropdown / Selector.
            - *Selection*: Hierarchy of categories.
        - **Base Unit**: Dropdown.
            - *Options*: 'roll', 'ml', 'pcs', 'kg', etc.
    - **Actions**:
        - **Save**: Primary Button (Floating or Bottom actions).
        - **Delete**: Text Button (Red) at bottom (only in Edit mode).

## Styling (Material 3 + Custom Theme)
- **Colors**:
    - Primary: Emerald (`#10B981`) for Save/Add actions.
    - Surface: Deep Charcoal (`#1A1D23`).
    - Text: White/Grey on Dark.
- **Components**:
    - `Card`: Rounded corners (16dp), subtle elevation/border.
    - `InputDecorator`: Filled, outlined (12dp radius).
    - `FloatingActionButton`: Large, rounded rect.
