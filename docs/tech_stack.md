# Refillio - Technology Stack

This document defines the approved technology choices for the Refillio project. All contributions must adhere to these versions and libraries to ensure consistency and maintainability.

## 1. Backend (The Core)

| Category | Technology | Version | Justification |
| :--- | :--- | :--- | :--- |
| **Language** | Java | 25 | Latest available version in current environment. |
| **Framework** | Spring Boot | 4.0.1 | Modern Spring Boot with enhanced Jakarta EE support. |
| **Architecture** | Spring Modulith | 2.0.1 | Enforces logical module boundaries within the monolith (Boot 4.x compatible). |
| **Build Tool** | Gradle | 8.x | Kotlin DSL for better type safety in build scripts. |
| **Database** | PostgreSQL | 16 | Robust relational data, JSONB support for flexible attributes. |
| **Migrations** | Flyway | 10.x | Version control for database schema changes. |
| **Testing** | JUnit 5 | Latest | Standard testing framework. |
| **Mocking** | Mockito | Latest | Standard mocking framework. |
| **Integration** | Testcontainers | Latest | Runs real PostgreSQL instances in Docker for tests. |
| **Scraping** | Jsoup | Latest | Lightweight HTML parsing. |
| **Browser Auto** | Playwright (Java) | Latest | For complex scrapers needing JS execution (optional/future). |
| **Documentation** | SpringDoc OpenAPI | Latest | Generates Swagger UI and OpenAPI 3.0 specs. |

## 2. Mobile (The Frontend)

| Category | Technology | Version | Justification |
| :--- | :--- | :--- | :--- |
| **Framework** | Flutter | 3.x | Cross-platform, high performance, native compilation. |
| **Language** | Dart | 3.x | Strongly typed, null-safe, familiar to Java devs. |
| **State Mgmt** | Riverpod | 2.x | Compile-safe dependency injection and state management. |
| **Networking** | Dio | 5.x | Robust HTTP client with interceptors (better than default http). |
| **Data Classes** | Freezed | Latest | Code generation for immutable models and unions. |
| **JSON SerDe** | json_serializable | Latest | Auto-generation of to/fromJson methods. |
| **Routing** | GoRouter | Latest | Declarative routing (deep linking support). |

## 3. Infrastructure & DevOps

| Category | Technology | Description |
| :--- | :--- | :--- |
| **Containerization** | Docker | Dockerfile for Backend, Docker Compose for local dev (DB). |
| **CI/CD** | GitHub Actions | (Future) Automated build and test pipeline. |
| **Hosting** | VPS / PaaS | (Future) Deployment target (likely a simple VPS initially). |

## 4. Development Tools

*   **IDE (Backend):** IntelliJ IDEA (Recommended).
*   **IDE (Mobile):** VS Code or Android Studio.
*   **API Client:** Postman or Curl.
*   **Database GUI:** DBeaver or IntelliJ Database Tool.
