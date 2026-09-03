# NativeTavern Agent Instructions

Welcome to NativeTavern. This document and the `.agents/` customization directory provide durable, agent-agnostic instructions for AI pair programmers and human contributors. Human contributors should also consult [CONTRIBUTING.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/CONTRIBUTING.md) (简体中文) or [CONTRIBUTING.en.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/CONTRIBUTING.en.md) (English).

---

## 1. Quick Developer Onboarding

Before making code modifications on a fresh checkout:

```sh
./setup.sh
```

`setup.sh` handles:
1. Verifying toolchains (`git`, `flutter >=3.44.9`, `dart`).
2. Initializing `.env` from `.env.example` if not already present.
3. Setting execute permissions on project scripts (`chmod +x build_*.sh setup.sh`).
4. Running `flutter doctor -v`.
5. Resolving dependencies via `flutter pub get`.
6. Running preflight sanity checks (Dart static analysis, localization check, build script preflights).

---

## 2. Release Work & Publishing

Before any packaging, store upload, release announcement, or version bump:

1. Read `docs/release-runbook.md` completely.
2. Inspect the existing `.sh` scripts and list relevant `.env` key names without printing secret values.
3. Check `git status`, the current `pubspec.yaml` version, recent tags, and the latest Discord release announcement.

Release packages must be produced by the repository scripts:

- **iOS**: `./build_ios.sh`
- **Android APK and AAB**: `./build_android.sh`
- **macOS**: `./build_macos.sh`

Do not replace these scripts with direct `flutter build`, Gradle, or `xcodebuild` packaging commands. A direct command is allowed only while fixing the corresponding build script, and the final artifact must still be rebuilt with that script.

Use `tool/discord_release.sh` for Discord release history and announcements. Do not use a browser when the configured Discord bot API is available.

Treat `.env` values as secrets. Never print tokens, service-account JSON, access keys, private keys, or complete authorization headers.

Unless the user explicitly overrides these defaults:

- Apple uploads go to internal TestFlight only; do not submit App Store review.
- Google Play receives the AAB; direct APK distribution goes to Cloudflare R2.
- macOS releases produce a packaged zip and SHA-256 checksum in `release/`.
- License review is outside engineering release scope and must not block an otherwise valid build.
- Work directly on `main` for the current regression/release phase.

Do not report a release complete until the external platform states, artifact checksums, Git commit, remote branch, and release tag have all been verified.

---

## 3. Local Development & Sideloading Builds

For fast day-to-day local testing and non-store device sideloading:

- **iOS Local**: `./build_ios_local.sh [options]`
  - Supports `--check-only`, `--skip-clean`, `--export-method <development|ad-hoc>`, and custom `BUNDLE_ID` in `.env`.
- **Android Local**: `./build_android_local.sh [options]`
  - Supports `--check-only`, `--debug`, `--release`, `--skip-clean`, `--package <id>`, `--install` (`-i`), and automatic debug-signed fallback for device sideloading via `adb`.
- **macOS Local**: `./build_macos_local.sh [options]`
  - Supports `--check-only`, `--debug`, `--release`, `--skip-clean`, and packages to `build/local_release/`.

---

## 4. User-Facing UI & Localization

When creating or modifying any user-facing UI:

1. Never hardcode user-visible strings in widgets or screens; always access localized strings through `AppLocalizations.of(context)!` (or `l10n`).
2. Add new translation keys and descriptions to `lib/l10n/app_en.arb` (including proper metadata `@key` blocks with descriptions and placeholder definitions).
3. Propagate corresponding translation entries across all target language `.arb` files in `lib/l10n/` (e.g., `app_zh.arb`, `app_zh_TW.arb`, `app_ja.arb`, `app_de.arb`, `app_fr.arb`, `app_es.arb`, etc.).
4. Run `flutter gen-l10n` to regenerate the localization classes in `lib/l10n/generated/`.
5. Keep related provider sources, consent lists (such as `aiDataSharingRecipients`), and UI settings tiles properly synchronized with any added/changed features.

---

## 5. Agent Customizations & Reference Documentation (`.agents/`)

Detailed architectural rules, skills, and technical specifications are maintained locally under `.agents/`:

### Rules (`.agents/rules/`)
- [architecture.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/rules/architecture.md): Clean Architecture (Data, Domain, Presentation), Riverpod 2.x, Drift SQLite, and GoRouter conventions.
- [coding_standards.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/rules/coding_standards.md): Dart 3 patterns, zero hardcoded user strings, ARB localization, theming.
- [release_and_security.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/rules/release_and_security.md): Release script execution rules, secrets discipline, checksum verification.

### Skills (`.agents/skills/`)
- [nativetavern-architecture](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/skills/nativetavern-architecture/SKILL.md): Subsystems, repositories, services, and provider layout.
- [sillytavern-formats](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/skills/sillytavern-formats/SKILL.md): Character Card Spec V2/V3, `.ntb`, `.ntx`, `.ntm`, `.jsonl`, and lorebooks.
- [native-runtimes](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/skills/native-runtimes/SKILL.md): Live2D Cubism Core 6.0.1, Spine 4.1 FFI, and Rust native core.
- [ios-build-and-test](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/skills/ios-build-and-test/SKILL.md): iOS local/release build, custom bundle IDs, sideloading, and tests.
- [android-build-and-test](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/skills/android-build-and-test/SKILL.md): Android local/release build, debug-signed sideloading, Play Store, and tests.
- [macos-build-and-test](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/skills/macos-build-and-test/SKILL.md): macOS build, packaging, entitlements, and integration tests.

### Reference Documentation (`.agents/docs/`)
- [project_overview.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/project_overview.md): Technical architecture and dependency stack.
- [sillytavern_card_spec.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/sillytavern_card_spec.md): Character Card V2 & V3 specification details.
- [backup_and_sync_spec.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/backup_and_sync_spec.md): Backup formats, iCloud, and Google Drive sync protocols.
- [rust_native_core.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/rust_native_core.md): Rust native core and `flutter_rust_bridge 2.0`.
- [live2d_and_spine.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/live2d_and_spine.md): Live2D Cubism OpenGL textures and Spine 4.1 pipelines.
- [tool_calling_and_mcp.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/tool_calling_and_mcp.md): Tool calling loop and Model Context Protocol (`mcp_dart`) client.
