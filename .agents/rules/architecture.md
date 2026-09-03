# NativeTavern Architecture Rules

## 1. Clean Layered Architecture

NativeTavern enforces a three-tier architecture:

```
lib/
├── data/           # Data Layer: Models, DAOs, SQLite database, Repositories
├── domain/         # Domain Layer: Business logic, Services, LLM Providers, Parser logic
└── presentation/   # Presentation Layer: Widgets, Screens, Riverpod Providers, Theme
```

### Dependency Flow Rules:
- **Presentation** depends on **Domain** and **Data** (via Riverpod providers).
- **Domain** depends on **Data** interfaces/models, never directly on Presentation widgets.
- **Data** implements concrete persistence (Drift, SecureStorage, FileSystem) and external API communications.

---

## 2. State Management (Riverpod 2.x)

- Use **Riverpod 2.6+** (`flutter_riverpod`, `riverpod_annotation`).
- Prefer code-generated `@riverpod` notifiers or `StateNotifierProvider` / `NotifierProvider`.
- Always dispose resources cleanly: use `autoDispose` for screen-specific or transient providers.
- Handle loading, data, and error states explicitly using `AsyncValue.when` or `AsyncValue.maybeWhen`.
- Never mutate state directly; always create new immutable instances using `.copyWith()`.

---

## 3. Database & Persistence (Drift SQLite)

- Persistence is backed by **Drift** (`drift: 2.28+`, `sqlite3_flutter_libs`).
- Database schema definitions live in `lib/data/database/`.
- All schema migrations must increment the schema version in `schemaVersion` and implement explicit migration steps in `MigrationStrategy`.
- Run `dart run build_runner build --delete-conflicting-outputs` after modifying Drift tables or Freezed models.
- Sensitive credentials (e.g., API keys, OAuth tokens) MUST be stored in `FlutterSecureStorage`, NEVER in plain text SQLite tables.

---

## 4. Declarative Routing (GoRouter 13.x)

- All navigation routes are declared in `lib/presentation/router/app_router.dart`.
- Use named routes and type-safe route parameters.
- Handle deep links and external file openings (`.ntb`, `.ntx`, `.png`, `.json`) through `app_router.dart` and `opened_document.dart`.
