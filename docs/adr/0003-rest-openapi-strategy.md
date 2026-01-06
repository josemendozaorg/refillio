# 0003. API Strategy: REST with OpenAPI

Date: 2026-01-06
Status: Accepted

## Context
The backend logic must be accessible to the Flutter mobile app now, but potentially a Web Dashboard, Smart Watch app, or CLI tools in the future.
We considered gRPC and REST.

## Decision
We will expose the backend via **REST APIs**, adhering to a **Code-First OpenAPI Strategy** and a **Reverse Proxy Architecture**.
1.  **Source of Truth:** Java `@RestController` code and DTO classes.
2.  **Spec Generation:** `springdoc-openapi` generates the `openapi.json` at build/runtime.
3.  **Client Generation:** `openapi-generator` builds the Flutter (Dart) client from the generated spec.
4.  **Gateway:** The Mobile Web container (Nginx) acts as a reverse proxy, forwarding `/api` requests to the Backend service.

## Justification
*   **Unified Origin:** By using Nginx to proxy `/api`, the frontend and backend appear to the browser as a single origin. This eliminates **CORS** (Cross-Origin Resource Sharing) issues entirely.
*   **Security:** The backend container remains private within the Docker network. Only the Nginx Gateway is exposed to the public internet (or Coolify URL).
*   **Environment Agnostic:** Flutter Web code uses relative paths (`/api/...`), making the build artifact identical across Local, Staging, and Production environments without needing to recompile with different URLs.
*   **AI Agent Compatibility:** AI Agents write high-quality Java code faster and more accurately than they edit massive YAML specification files. This leverages the agent's strength in the primary language (Java).

## Consequences
*   **Positive:** **Zero Drift.** The spec matches the code because it is generated *from* the code.
*   **Positive:** Auto-generated Swagger UI for documentation/testing.
*   **Positive:** Type-safe clients generated for frontend.
*   **Negative:** slightly higher payload size (JSON) compared to Protobuf (negligible for this use case).
*   **Negative:** Requires discipline to keep DTOs decoupled from Domain Entities to ensure the generated spec is clean.
