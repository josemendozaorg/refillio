# 0005. Methodology: DDD and TDD

Date: 2026-01-06
Status: Accepted

## Context
Refillio handles complex logic regarding unit conversions ("1.5L bottle" vs "pack of 6") and price normalization.
Traditional "CRUD" development often leads to anemia in the domain model, where logic leaks into services or controllers.
Additionally, as a solo developer project, regression bugs are costly. We need high confidence in our changes without manual QA.

## Decision
We will enforce two core methodologies for the Backend:

1.  **Domain Driven Design (DDD):**
    *   We will model the software to match the business domain (Identity, Catalog, Market, Inventory).
    *   We will use Tactical DDD patterns: **Entities**, **Value Objects** (especially for Money/Units), **Aggregates**, and **Domain Events**.
    *   The "Domain" layer must be pure Java and agnostic of the database or API.

2.  **Test Driven Development (TDD):**
    *   Tests must be written **before** the implementation code.
    *   Cycle: **Red** (Write failing test) -> **Green** (Make it pass) -> **Refactor** (Clean up).
    *   This ensures testability is designed into the system from day one.

## Consequences
*   **Positive:** **High Confidence.** We can refactor complex price logic fearlessly.
*   **Positive:** **Rich Model.** Logic stays in the Domain objects (e.g., `Price.add(Price other)`), not in "Utils" classes.
*   **Negative:** **Slower Initial Velocity.** Writing tests first feels slower initially but pays off in debugging time saved.
*   **Negative:** **Learning Curve.** DDD patterns (Aggregates, bounded contexts) require discipline to avoid "God Objects".
