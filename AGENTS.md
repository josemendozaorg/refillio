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
- **Generate Code:** `dart run build_runner build` (for Riverpod/Freezed)
- **Analyze:** `flutter analyze`
- **Analyze (Fast Local):** `/home/dev/repos/flutter_sdk/bin/flutter analyze mobile/` (Requires local SDK at `/home/dev/repos/flutter_sdk`)

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

## 9. Local Deployment & Testing
### Commands
- **Start Stack:** `docker compose up --build -d`
- **Stop Stack:** `docker compose down`
- **View Logs:** `docker compose logs -f [service_name]`

### Deployment Strategy (Coolify Compatibility)
- **Port Mapping:** The `docker-compose.yml` does NOT use `ports` to avoid host collisions. It uses `expose`. 
- **Local Dev:** To access the app locally (e.g., `localhost:3000`), you must temporarily add the `ports` section back to `docker-compose.yml` or use an override file.

### Access Points (When ports are mapped)
- **Refillio App (Gateway):** `http://localhost:3000` (Serves UI + Proxies `/api` to Backend)
- **Backend API (Direct):** `http://localhost:8081` (Internal port 8080)
- **Database:** `localhost:5432` (User: `refillio`, Pass: `refillio_password`)
- **Swagger UI:** `http://localhost:3000/api/swagger-ui.html` (Accessed through Gateway)

