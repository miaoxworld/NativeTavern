---
name: macos-build-and-test
description: >-
  Guides building, packaging, verifying, codesigning, and running integration tests
  for the NativeTavern macOS application.
---

# macOS Build & Test Workflow

## 1. Quick Local Builds

For development and local testing:

```sh
# Preflight check configuration
./build_macos_local.sh --check-only

# Build debug version
./build_macos_local.sh --debug

# Fast rebuild skipping flutter clean
./build_macos_local.sh --skip-clean

# Full local release package
./build_macos_local.sh --release
```

Artifacts are placed in `build/local_release/`:
- `NativeTavern_v<VERSION>_macOS_<MODE>.zip`
- `NativeTavern_v<VERSION>_macOS_<MODE>.zip.sha256`

---

## 2. Production Release Packaging

Use the canonical release script:

```sh
./build_macos.sh
```

- Produces `release/NativeTavern_v<VERSION>_macOS.zip` and `.sha256`.
- Verified via:
  ```sh
  unzip -t "release/NativeTavern_v${VERSION}_macOS.zip"
  shasum -a 256 -c "release/NativeTavern_v${VERSION}_macOS.zip.sha256"
  ```

---

## 3. Running macOS Integration Tests

Integration tests run directly on the host macOS desktop:

```sh
flutter test integration_test/live2d_default_group_macos_test.dart -d macos
```

Test parameters can be provided via `--dart-define`:
```sh
flutter test integration_test/live2d_default_group_macos_test.dart -d macos \
  --dart-define=LIVE2D_TEST_MODEL_DIR=/path/to/model \
  --dart-define=LIVE2D_TEST_MODEL_FILE=model.model3.json \
  --dart-define=LIVE2D_TEST_IDLE_INDEX=0
```

---

## 4. Entitlements & App Sandbox

Configurations located in `macos/Runner/`:
- `Release.entitlements`:
  - `com.apple.security.app-sandbox`: Enabled.
  - `com.apple.security.network.client`: Outgoing LLM API calls and model downloads.
  - `com.apple.security.network.server`: Local listening servers (MCP / local bridges).
  - `com.apple.security.files.user-selected.read-write`: File dialogs for imports/exports (`.ntb`, `.ntx`, `.png`).
  - `com.apple.security.files.bookmarks.app-scope`: Retaining access to persistent model directories.
  - `com.apple.security.device.audio-input`: Microphone voice input.
- `DebugProfile.entitlements`:
  - Adds `com.apple.security.cs.allow-jit` for Flutter JIT engine execution.
