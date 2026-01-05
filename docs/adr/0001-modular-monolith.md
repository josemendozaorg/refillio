# 0001. Architecture Style: Modular Monolith

Date: 2026-01-06
Status: Accepted

## Context
Refillio is a complex domain (Identity, Catalog, Market Intelligence, Inventory) being built by a solo developer.
We need to balance:
1.  **Development Velocity:** Microservices introduce massive operational overhead (distributed tracing, networking, independent deployments) which kills productivity for small teams.
2.  **Maintainability:** A traditional "Layered Monolith" (Controller -> Service -> Repo) often degenerates into a "Big Ball of Mud" where business logic is tightly coupled across domains.

## Decision
We will adopt a **Modular Monolith** architecture, enforced by **Spring Modulith**.

*   **Structure:** The codebase will be organized by business domain (e.g., `modules/inventory`, `modules/catalog`), NOT by technical layer.
*   **Enforcement:** We will use `Spring Modulith` tests to fail the build if a module creates a cyclic dependency or accesses internal classes of another module.
*   **Deployment:** A single JAR artifact containing all modules.

## Consequences
*   **Positive:** Simplified deployment (one process).
*   **Positive:** Strong boundaries prevent "spaghetti code," making a future split to microservices easier if scale ever requires it.
*   **Positive:** Transaction management is simple (ACID compliant within the single database).
*   **Negative:** Strict discipline is required to define public APIs for each module.
*   **Negative:** Build time increases as the monolith grows (though Gradle build cache mitigates this).
