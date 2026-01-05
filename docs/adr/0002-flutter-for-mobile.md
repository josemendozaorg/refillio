# 0002. Frontend Framework: Flutter

Date: 2026-01-06
Status: Accepted

## Context
Refillio requires a "Mobile First" user experience (scanning barcodes, push notifications, quick pantry updates).
The primary developer has a strong background in Java and Spring Boot.
We evaluated three options:
1.  **Flutter:** Dart language, native performance.
2.  **React Native:** JavaScript/TypeScript ecosystem.
3.  **PWA/Hilla:** Web-only approach.

## Decision
We will use **Flutter** for the mobile application.

## Justification
*   **Skill Transfer:** The Dart language is very similar to Java (strongly typed, object-oriented), significantly reducing the context switching cost for the developer compared to the async quirks of JavaScript.
*   **Performance:** Flutter compiles to native ARM code, offering a superior 60fps experience for list scrolling and animations compared to WebViews or React Native bridges.
*   **Cross-Platform:** Provides a single codebase for both Android and iOS, with a "workable" web target for future administrative dashboards.

## Consequences
*   **Positive:** Rapid UI development with hot reload.
*   **Positive:** Type safety across the stack (Java Backend -> Dart Frontend).
*   **Negative:** The web build of Flutter is large (heavy initial download) and has poor SEO (though irrelevant for an authenticated app).
*   **Negative:** Requires maintaining a separate "Mobile" codebase, rather than a Unified "Fullstack Java" approach like Hilla (accepted trade-off for native mobile quality).
