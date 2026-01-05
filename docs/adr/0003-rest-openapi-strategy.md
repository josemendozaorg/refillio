# 0003. API Strategy: REST with OpenAPI

Date: 2026-01-06
Status: Accepted

## Context
The backend logic must be accessible to the Flutter mobile app now, but potentially a Web Dashboard, Smart Watch app, or CLI tools in the future.
We considered gRPC and REST.

## Decision
We will expose the backend via **REST APIs**, adhering to a **Code-First OpenAPI Strategy**.
1.  **Source of Truth:** Java `@RestController` code and DTO classes.
2.  **Spec Generation:** `springdoc-openapi` generates the `openapi.json` at build/runtime.
3.  **Client Generation:** `openapi-generator` builds the Flutter (Dart) client from the generated spec.

## Justification
*   **AI Agent Compatibility:** AI Agents write high-quality Java code faster and more accurately than they edit massive YAML specification files. This leverages the agent's strength in the primary language (Java).
*   **Decoupling:** The API specification acts as a contract. We can change the backend implementation without breaking clients as long as the contract holds.
*   **Code Generation:** We can use `openapi-generator` to automatically build the Dart (Flutter) client networking code, eliminating manual JSON parsing errors.
*   **Tooling:** REST is universally supported. Debugging via `curl`, Postman, or the Browser Network tab is significantly easier than debugging binary gRPC streams.
*   **Velocity:** Spring Boot + `springdoc-openapi` allows rapid iteration. You change a Java field, and the spec updates instantly.

## Consequences
*   **Positive:** **Zero Drift.** The spec matches the code because it is generated *from* the code.
*   **Positive:** Auto-generated Swagger UI for documentation/testing.
*   **Positive:** Type-safe clients generated for frontend.
*   **Negative:** slightly higher payload size (JSON) compared to Protobuf (negligible for this use case).
*   **Negative:** Requires discipline to keep DTOs decoupled from Domain Entities to ensure the generated spec is clean.
