# Contributing to NativeTavern

<p align="center">
  <a href="CONTRIBUTING.md">简体中文</a> | <a href="CONTRIBUTING.en.md">English</a>
</p>

Thank you for your interest in contributing to NativeTavern! This document provides guidelines and setup instructions to help you get started quickly and effectively.

---

## 1. Quick Start & Onboarding

On a fresh clone, run the automated setup script from the repository root:

```sh
./setup.sh
```

`setup.sh` handles:
1. Verifying toolchain prerequisites (`git`, `flutter >=3.44.9`, `dart`).
2. Creating `.env` from `.env.example` if not already present.
3. Setting execute permissions across all project scripts (`build_*.sh`, `tool/*.sh`).
4. Running `flutter doctor -v`.
5. Resolving dependencies via `flutter pub get`.
6. Running preflight sanity checks (Dart static analysis, localization generation, and local build script checks).

---

## 2. Local Development & Testing

### Running the App
To start the app during day-to-day development:

```sh
flutter run
```

### Local Build Scripts
Platform-specific local build scripts are provided for fast iteration, custom bundle IDs, and device sideloading:

- **iOS Local**:
  ```sh
  ./build_ios_local.sh [options]
  # Options: --check-only, --skip-clean, --export-method <development|ad-hoc>, --bundle-id <id>, --device <id>
  ```
- **Android Local**:
  ```sh
  ./build_android_local.sh [options]
  # Options: --check-only, --debug, --release, --skip-clean, --package <id>, --track <name>, --install (-i)
  ```
  *(Release builds automatically fallback to debug signing if no custom keystore is present, producing sideloadable APKs in `build/local_release/`)*.
- **macOS Local**:
  ```sh
  ./build_macos_local.sh [options]
  # Options: --check-only, --debug, --release, --skip-clean, --bundle-id <id>
  ```

---

## 3. Architecture & Code Guidelines

NativeTavern enforces a Clean Architecture with Riverpod 2.x and Drift SQLite:

```
lib/
├── data/           # Drift SQLite database, DAOs, DTOs, Repositories
├── domain/         # Business logic, LLM providers, Services, Parsers
└── presentation/   # Riverpod providers, Screens, Widgets, GoRouter, Theme
```

### Key Principles:
- **Riverpod 2.x**: Use code-generated `@riverpod` or `StateNotifierProvider` / `NotifierProvider`. Manage lifecycle cleanly with `autoDispose`.
- **Immutability**: Data models must be immutable (using `@freezed` or `Equatable`). Never mutate state directly.
- **Drift SQLite**: Database migrations must increment `schemaVersion` and specify explicit migration paths in `app_database.dart`. After schema changes, run:
  ```sh
  dart run build_runner build --delete-conflicting-outputs
  ```
- **GoRouter**: All routes must be declared in `lib/presentation/router/app_router.dart`.

For detailed architecture patterns, see [.agents/rules/architecture.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/rules/architecture.md).

---

## 4. UI & Localization Rules (MANDATORY)

1. **Zero Hardcoded Strings**: Never hardcode user-visible strings in widgets, dialogs, bottom sheets, or error messages.
2. **Access via Localizations**: Always use `AppLocalizations.of(context)!` (or `l10n`).
3. **Adding New Strings**:
   - Add new translation keys with descriptive metadata (`@key`) to `lib/l10n/app_en.arb`.
   - Propagate translations across target `.arb` files in `lib/l10n/` (`app_zh.arb`, `app_ja.arb`, `app_de.arb`, `app_fr.arb`, `app_es.arb`, etc.).
   - Regenerate classes:
     ```sh
     flutter gen-l10n
     ```
4. **Consent & Settings**: Keep AI data sharing consent lists (`aiDataSharingRecipients`) synchronized when adding or altering AI providers.

---

## 5. Native Runtimes & FFI (Live2D, Spine, Rust)

- **Live2D Cubism SDK**:
  - Pinned to Cubism Core 6.0.1.
  - The proprietary header `Live2DCubismCore.h` is not tracked by Git. If working on macOS Live2D native bindings, copy `Live2DCubismCore.h` into `packages/native_tavern_live2d_macos/macos/CubismCore/include/`.
- **Spine 4.1 Compatibility**:
  - Located in `packages/spine_flutter_4_1_compat/`. Pins Spine 4.1.14 binary runtime.
- **Rust Native Core**:
  - Located in `rust/` (`native_tavern_core`). Uses `flutter_rust_bridge 2.0`.
  - To regenerate FFI bindings after Rust changes:
    ```sh
    flutter_rust_bridge_codegen generate
    ```

---

## 6. Pre-flight Verification & Testing

Before submitting a Pull Request:

1. **Format & Analyze**:
   ```sh
   dart format --output=none --set-exit-if-changed .
   dart analyze lib test
   ```
2. **Run Unit & Widget Tests**:
   ```sh
   flutter test
   ```
3. **Run Setup Sanity Check**:
   ```sh
   ./setup.sh
   ```

---

## 7. Security & Release Confidentiality

- **Never Commit Secrets**: Do not commit `.env`, keystore files (`.jks`), certificates (`.p12`), or private keys (`.p8`).
- **Official Releases**: Packaging for distribution must always use the official repository scripts:
  - iOS: `./build_ios.sh`
  - Android: `./build_android.sh`
  - macOS: `./build_macos.sh`
- Refer to `docs/release-runbook.md` and [.agents/rules/release_and_security.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/rules/release_and_security.md) for full release procedures.

---

## 8. Reference Documentation

For deep technical specifications, refer to `.agents/docs/`:
- [Project Architecture & Dependency Overview](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/project_overview.md)
- [SillyTavern Card Spec (V2 & V3 / CharX)](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/sillytavern_card_spec.md)
- [Backup & Cloud Sync Specification (.ntb, .ntx, .ntm, .jsonl)](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/backup_and_sync_spec.md)
- [Live2D & Spine Native Rendering](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/live2d_and_spine.md)
- [Tool Calling & MCP Specification](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/tool_calling_and_mcp.md)
- [Rust Native Core Architecture](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/rust_native_core.md)
