# Refillio - Agent Guidelines

## 1. Project Context
Refillio is a "Mini-ERP for the Home" designed to automate the procurement of essential household utilities.
**Goal:** Track consumption rates and monitor real-time market prices to ensure users never run out of essentials while securing the lowest "price per unit".
**Reference:** See `product_spec.md` for detailed feature specifications and roadmap.

## 2. Technology Stack
- **Backend:** Java 21, Spring Boot 4.0.1, Gradle (Kotlin DSL).
- **Mobile:** Flutter, Dart, Riverpod (State Management).
- **Database:** PostgreSQL (with Flyway for migrations).
- **API Strategy:** REST with strict OpenAPI (Swagger) definitions.

## 3. Operational Commands

### Backend (Java/Spring Boot)
*Run commands from the `backend/` root directory.*
- **Build & Test:** `./gradlew clean build`
- **Run Application:** `./gradlew bootRun`
- **Run Tests Only:** `./gradlew test`
- **Format Code:** `./gradlew spotlessApply` (Requires Spotless plugin)
- **DB Migration:** `./gradlew flywayMigrate`

### Mobile (Flutter)
*Run commands from the `mobile/` root directory.*
- **Install Dependencies:** `flutter pub get`
- **Run (Dev):** `flutter run`
- **Run Tests:** `flutter test`
- **Generate Code:** `dart run build_runner build --delete-conflicting-outputs`
- **Analyze:** `flutter analyze`

### 🛠️ Pre-commit Checklist
Before every commit, you **MUST** run:
1.  `flutter analyze` (Mobile)
2.  `flutter test` (Mobile)
3.  `./gradlew spotlessCheck` (Backend - if available)
4.  `./gradlew test` (Backend)

## 4. Architecture

### Backend: Modular Monolith (Spring Modulith)
**Pattern:** Hexagonal (Ports & Adapters).
**Core Principle:** Strict separation between the Domain (Business Logic) and Infrastructure (Web/DB).

**Module Boundaries:**
1.  **Identity:** Users, Auth, Profiles.
2.  **Catalog:** Canonical Products, Categories, Measurement Units.
3.  **Market:** Scrapers, Listings, Price Normalization, Providers.
4.  **Inventory:** User Stock, Consumption Logs, Procurement Orders.

### Directory Structure
```text
refillio/
├── backend/src/main/java/com/refillio/
│   ├── modules/
│   │   ├── identity/
│   │   │   ├── domain/        # Core Logic & Entities (Pure Java)
│   │   │   ├── adapter/
│   │   │   │   ├── in/        # REST Controllers (Web Layer)
│   │   │   │   └── out/       # JPA Repositories (Persistence Layer)
│   │   │   └── IdentityModule.java
│   │   ├── catalog/ ...
│   │   └── ...
│   └── RefillioApplication.java
├── mobile/lib/src/
│   ├── features/              # Mirrors backend modules (identity, catalog...)
│   │   ├── presentation/      # Widgets & Riverpod Controllers
│   │   ├── domain/            # Dart Models
│   │   └── data/              # API Repositories
│   ├── shared/                # Common UI components & Utils
│   └── app.dart
```

## 5. API & Integration
- **Protocol:** REST.
- **Strategy:** **Code-First OpenAPI**.
    - **Source:** Java Controllers & DTOs are the source of truth.
    - **Output:** `springdoc-openapi` generates the Swagger/OpenAPI spec.
    - **Client:** `openapi-generator` consumes the spec to build the Flutter client.
- **Design:** API First (Conceptually). Define DTOs explicitly. Do not expose Domain Entities directly via the API.
- **Future Proofing:** Keep Controllers "thin". All business logic must reside in Domain Services. This enables easy addition of other adapters (gRPC, CLI) in the future without changing core logic.

## 6. Code Style & Conventions

### Java (Backend)
- **Format:** Google Java Format.
- **Naming:**
    - Classes: `PascalCase` (e.g., `PriceService`).
    - Methods/Variables: `camelCase`.
    - Constants: `UPPER_SNAKE_CASE`.
- **Dependencies:** Use constructor injection (lombok `@RequiredArgsConstructor` is permitted).
- **Null Safety:** Use `Optional<T>` for return types. Avoid returning `null`.
- **Error Handling:** Throw custom RuntimeExceptions. Use `@ControllerAdvice` to map them to standardized `ProblemDetails` JSON responses.
- **Scraping:** Use `Jsoup` for static HTML. encapsulate scraper logic within the `market` module's infrastructure layer.

### Dart (Mobile)
- **Style:** Effective Dart. Follow standard Flutter lints.
- **State Management:** Riverpod 2.x (Generator syntax preferred).
- **Naming:** `camelCase` for files/variables is NOT standard in Dart files. Use `snake_case` for filenames, `PascalCase` for Classes/Typedefs, `camelCase` for variables/functions.

## 7. Development Rules

### General
1.  **Spec Alignment:** Read `product_spec.md` before implementation.
2.  **Schema Consistency:** Backend JPA entities must match `database/schema.sql` exactly.
3.  **Comments:** JSDoc/Javadoc for complex "Unit Normalization" logic is mandatory.
4.  **Methodology:** Backend MUST be implemented using **Domain Driven Design (DDD)** and **Test Driven Development (TDD)**.
    - **TDD:** Write tests *before* implementation (Red -> Green -> Refactor).
    - **DDD:** Focus on the Domain Model first, strictly separating it from infrastructure. Use ubiquitous language.

### AI Agent Workflow
1.  **Identity:** Agents (Open Code, Claude Code, Antigravity, Gemini CLI) act as Senior Engineers.
2.  **Architectural Decisions:** Any modification to the Tech Stack or Architecture requires a new **Architecture Decision Record (ADR)** in `docs/adr/`.
    - **Trigger:** Changing libraries, patterns, or structural conventions.
    - **Format:** Follow the Nygard format (Context, Decision, Consequences).

### Testing Guidelines
- **Backend:**
    - **Unit:** JUnit 5 + Mockito for Domain Logic (especially Price Calculation).
    - **Integration:** `Testcontainers` (PostgreSQL) for Repository and End-to-End flow tests.
    - **Naming:** `ClassNameTest.java`.
- **Mobile:**
    - **Unit:** Test logical classes and Riverpod notifiers.
    - **Widget:** Test critical UI flows.

## 8. Git Workflow
- **Commit Messages:** Conventional Commits.
    - `feat(backend): add allegro scraper`
    - `fix(mobile): resolve layout overflow`
    - `chore(deps): update spring boot`
- **Secrets:** NEVER commit API keys or credentials. Use environment variables.

## 9. Deployment & Local Testing

### Local Development
The `docker-compose.yml` is optimized for production deployment (Coolify) and does **not** map ports to the host by default.

**To run locally with accessible ports:**
1.  Create an override file: `cp docker-compose.override.yml.example docker-compose.override.yml`
2.  Update `docker-compose.override.yml` if port conflicts occur (e.g., set backend to `8081:8080`).
3.  Start the stack: `docker compose up --build -d`
4.  Access:
    - **App:** `http://localhost:3000`
    - **Backend:** `http://localhost:8081` (or `8080` if default)
    - **DB:** `localhost:5432`

### Coolify Deployment Strategy
This project uses a "Coolify-First" configuration:
1.  **Network:** All services live in the `refillio_net` bridge network.
2.  **Expose:** We use `expose` (internal ports) instead of `ports` (host binding) to prevent conflicts on the VPS.
    - Backend: Exposes `8080`
    - Mobile: Exposes `80`
3.  **Container Names:** Explicit names (`refillio_backend`, `refillio_mobile`) ensure reliable internal DNS resolution.

**Critical: Coolify UI Configuration**
After deploying, you **MUST** manually configure the ports in the Coolify UI, as it does not auto-detect `expose` directives for routing.
1.  **Backend Service:**
    - Go to **Settings**.
    - Set **Ports Exposes** to `8080`.
    - (Optional) Set a Domain if external API access is needed.
2.  **Mobile Service:**
    - Go to **Settings**.
    - Set **Ports Exposes** to `80`.
    - Set **Domains** to your public URL (e.g., `https://app.refillio.com`).


