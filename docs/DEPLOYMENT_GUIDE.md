# Refillio Deployment Guide

This document outlines the specialized deployment configuration for Refillio, specifically addressing SSL and CORS issues encountered when running behind nested proxies (Traefik -> Nginx).

## Infrastructure Overview

Refillio is deployed using **Coolify** on a Proxmox VM. The architecture consists of:
1.  **Cloudflare (External)**: Handles DNS and Proxying (Orange Cloud).
2.  **Traefik (Coolify Proxy)**: Handles incoming SSL and internal routing.
3.  **Nginx (Mobile Container)**: Serves Flutter Web and proxies `/api` requests to the backend.
4.  **Spring Boot (Backend Container)**: Internal API service.

---

## 1. SSL Configuration (DNS-01 Challenge)

### The Problem
Using the default Let's Encrypt **HTTP-01 Challenge** fails when the Cloudflare Proxy (Orange Cloud) is enabled. Cloudflare redirects HTTP traffic to HTTPS, but Traefik cannot accept HTTPS traffic until it has the certificate, creating a deadlock.

### The Fix
Switch to the **DNS-01 Challenge**. Traefik authenticates via the Cloudflare API instead of a public HTTP check.

**Coolify Setup:**
1.  Navigate to **Proxy Settings** for the server.
2.  Set `CF_DNS_API_TOKEN` in the **Environment Variables**.
3.  Update the Traefik `command` section:
    *   Remove `--certificatesresolvers.letsencrypt.acme.httpchallenge=true`.
    *   Add `--certificatesresolvers.letsencrypt.acme.dnschallenge=true`.
    *   Add `--certificatesresolvers.letsencrypt.acme.dnschallenge.provider=cloudflare`.

---

## 2. CORS Strategy (Nginx Level)

### The Problem
Spring Boot's internal CORS validation (`@CrossOrigin` or `WebMvcConfigurer`) is extremely strict regarding the `Origin` and `Scheme`. When a request comes from `https://subdomain.josemendoza.dev` but is handled as `http` internally, Spring often rejects it as an "Invalid CORS request" (403 Forbidden).

### The Fix: Same-Origin Spoofing
We move CORS handling entirely to **Nginx** and trick the backend into thinking the request is local.

**Nginx Configuration (`mobile/nginx.conf`):**
*   **Intercept OPTIONS**: Nginx handles preflight requests directly and returns `204`.
*   **Inject Headers**: Nginx adds `Access-Control-Allow-Origin` to **all** responses using the `always` flag.
*   **Spoof Backend**: Nginx overwrites the `Host` and `Origin` headers before passing to the backend:
    ```nginx
    proxy_set_header Host "backend:8080";
    proxy_set_header Origin "http://backend:8080";
    ```

---

## 3. Database Seeding

The application requires a specific test user for MVP functionality. This is handled via Flyway migration `V3__seed_test_user.sql`. 
*   **User ID**: `3fa85f64-5717-4562-b3fc-2c963f66afa6`
*   Ensure all new tables referencing `user_id` follow this pattern or have appropriate defaults.

---

## 4. Flutter Standards

To ensure successful CI/CD:
1.  **Relative Imports**: Always use relative imports (`../../`) instead of `package:mobile/...` to avoid resolution errors during headless builds.
2.  **Strict Analysis**: The Docker build will fail if `flutter analyze` reports any issues.
