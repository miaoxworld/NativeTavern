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
```

Artifacts are placed in `build/local_release/`:
- `NativeTavern_v<VERSION>.ipa`
- `NativeTavern_v<VERSION>.ipa.sha256`

### Personal Team & Wildcard Provisioning:
- `build_ios_local.sh` automatically loads `.env` (`BUNDLE_ID`, `ICLOUD_CONTAINER_ID`, `ENABLE_ICLOUD`).
- When `ENABLE_ICLOUD=false` (or using standard wildcard provisioning profiles), `Runner.entitlements` is temporarily swapped with an empty plist during the build and safely restored via exit trap.
- When `ENABLE_ICLOUD=true` with a custom `ICLOUD_CONTAINER_ID`, the container identifier is dynamically injected into `Runner.entitlements` and `Info.plist`.

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
