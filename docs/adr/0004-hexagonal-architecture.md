# 0004. Internal Architecture: Hexagonal (Ports & Adapters)

Date: 2026-01-06
Status: Accepted

## Context
Refillio's core value lies in its logic: "Price Normalization" and "Consumption Forecasting."
Frameworks (Spring, Flutter) and drivers (PostgreSQL, REST) change over time. The business logic must be protected from these changes.

## Decision
We will apply **Hexagonal Architecture (Ports & Adapters)** within each module.

*   **The Domain (Hexagon):** Pure Java code (Entities, Value Objects, Services). **NO** dependencies on Spring, Hibernate, or Jackson annotations.
*   **Input Ports:** Interfaces defining *what* the domain can do (e.g., `PlaceOrderUseCase`).
*   **Output Ports:** Interfaces defining *what* the domain needs (e.g., `InventoryRepository`).
*   **Adapters:**
    *   **Primary (Driving):** REST Controllers that call Input Ports.
    *   **Secondary (Driven):** JPA Repositories that implement Output Ports.

## Consequences
*   **Positive:** **Testability.** We can test the complex Price Normalization logic with fast unit tests, without loading Spring Context or a Database.
*   **Positive:** **flexibility.** We can swap the API from REST to gRPC, or the database from Postgres to Mongo, without touching a single line of business logic.
*   **Negative:** **Boilerplate.** Requires mapping between DTOs (Web Layer), Domain Objects (Core), and Entity Objects (Persistence Layer).
*   **Mitigation:** We accept the extra mapping code as the "insurance premium" for long-term maintainability.
