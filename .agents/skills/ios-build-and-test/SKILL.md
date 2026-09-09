---
name: ios-build-and-test
description: >-
  Guides building, packaging, verifying, codesigning, and running integration tests
  for the NativeTavern iOS application.
---

# iOS Build & Test Workflow

## 1. Quick Local Builds & Sideloading

For local development and non-store device testing:

```sh
# Preflight check configuration
./build_ios_local.sh --check-only

# Build development IPA (default)
./build_ios_local.sh

# Fast rebuild skipping flutter clean
./build_ios_local.sh --skip-clean

# Build with custom bundle ID (for personal Apple Developer accounts)
./build_ios_local.sh --bundle-id com.yourname.nativetavern

# Build ad-hoc package
./build_ios_local.sh --export-method ad-hoc

# Target a connected physical iOS device
./build_ios_local.sh --device <device-id>

# Simulator (uses BUNDLE_ID and ICLOUD_CONTAINER_ID from .env)
./build_ios_local.sh --simulator
./build_ios_local.sh --simulator "iPhone 14 Pro Max"
```

Artifacts are placed in `build/local_release/`:
- `NativeTavern_v<VERSION>.ipa`
- `NativeTavern_v<VERSION>.ipa.sha256`

### Personal Team & Wildcard Provisioning:
- `build_ios_local.sh` automatically loads `.env` (`BUNDLE_ID`, `ICLOUD_CONTAINER_ID`, `ENABLE_ICLOUD`).
- When `ENABLE_ICLOUD=false` (or using standard wildcard provisioning profiles), `Runner.entitlements` is temporarily swapped with an empty plist during the build and safely restored via exit trap.
- When `ENABLE_ICLOUD=true` with a custom `ICLOUD_CONTAINER_ID`, the container identifier is dynamically injected into `Runner.entitlements` and `Info.plist`.
- `./build_ios_local.sh --simulator` (and `tool/run_ios_simulator.sh`) apply the same `.env` `BUNDLE_ID` and `ICLOUD_CONTAINER_ID` as the sideload IPA: they rewrite Runner `PRODUCT_BUNDLE_IDENTIFIER` in `project.pbxproj` (xcconfig is not enough; `flutter run` reads the target setting), inject entitlements/Info.plist, set `ENABLE_DEBUG_DYLIB=NO` (Xcode 16+ Debug otherwise builds a ~40KB blank executor that aborts at `abort_could_not_find_entry_point___debug_dylib` because `flutter run` on simulators uses `simctl launch` with no LLDB), then keep `flutter run --debug` attached. Logs go to `build/local_release/simulator/flutter_run.log` and `device.log`. After launch the script fails if the installed app is not that bundle ID / iCloud container, if the binary is still the Debug stub, or if Runner is not running. Leave the process running to keep the app alive. Flutter does not allow Release/Profile simulator builds. The pbxproj/Info.plist/entitlements/Debug.xcconfig files are restored on exit.
- Toolchain: use `/Applications/Xcode.app` when it exists. Use `/Applications/Xcode-beta.app` only when macOS is a developer beta (build version ends in a lowercase letter, e.g. `26A5425a`) **and** `Xcode.app` is missing.
- Live UI: **Xcode 26 and earlier** open `Simulator.app`. **Xcode 27+** (WWDC 2026) replaced Simulator.app with Device Hub (`Xcode > Open Developer Tool > Device Hub`). Do not `simctl boot` a Device Hub simulator first; that leaves `FramebufferProviderStates: none` / DeviceKit 4002.

---

## 2. Production Release Packaging

Use the canonical release script:

```sh
./build_ios.sh
```

- Produces `release/NativeTavern_v<VERSION>.ipa` and `.sha256`.
- Verified via:
  ```sh
  shasum -a 256 -c "release/NativeTavern_v${VERSION}.ipa.sha256"
  ```
- Upload to TestFlight using App Store Connect API:
  ```sh
  tool/app_store_connect_api.rb GET '/v1/apps/6757631215/appStoreVersions'
  ```

---

## 3. Running iOS Tests

### Unit and Widget Tests
```sh
flutter test
```

### Simulator & Device Integration Tests
List available simulators:
```sh
xcrun simctl list devices available
```

Run tests on iOS simulator:
```sh
flutter test integration_test/ -d iPhone
```

---

## 4. Entitlements & Capabilities

Configurations located in `ios/Runner/`:
- `Runner.entitlements`:
  - `com.apple.developer.ubiquity-container-identifiers`: iCloud container ID.
  - `com.apple.developer.icloud-services`: CloudDocuments.
  - `keychain-access-groups`: Secure token storage.
- `Info.plist`:
  - `NSUbiquitousContainers`: iCloud container declaration.
  - `NSPhotoLibraryUsageDescription`: Avatar and background image imports.
  - `NSMicrophoneUsageDescription`: Speech-to-text input.
  - `ITSAppUsesNonExemptEncryption`: Explicitly set to `false`.
