---
name: android-build-and-test
description: >-
  Guides building, packaging, verifying, sideloading, and running integration tests
  for the NativeTavern Android application.
---

# Android Build & Test Workflow

## 1. Quick Local Builds & Sideloading

For day-to-day development and non-store device sideloading:

```sh
# Preflight check configuration
./build_android_local.sh --check-only

# Build debug APK
./build_android_local.sh --debug

# Build release APK (debug-signed fallback for sideloading)
./build_android_local.sh --release

# Fast rebuild skipping flutter clean
./build_android_local.sh --skip-clean

# Override package application ID
./build_android_local.sh --package com.yourname.nativetavern

# Automatically sideload built APK to connected device via adb
./build_android_local.sh -i

# Sideload to a specific adb device ID
./build_android_local.sh -i -d <device-id>
```

Artifacts are placed in `build/local_release/`:
- `NativeTavern_v<VERSION>_<MODE>.apk` (+ `.sha256`)
- `NativeTavern_v<VERSION>_<TRACK>_<MODE>.apk` (if track configured)
- `NativeTavern_v<VERSION>_<MODE>.aab` (+ `.sha256`, if `--aab` or `--all` requested)

### Sideloading Signing Fallback:
- If no custom production keystore is present in `config/` or `.env`, `build_android_local.sh` automatically configures `release { signingConfig = signingConfigs.getByName("debug") }`.
- This ensures release APKs are signed and installable on physical test devices without manual key configuration.

---

## 2. Production Release Packaging

Use the canonical release script:

```sh
./build_android.sh
```

- Requires `config/upload-keystore.jks` and `config/key.properties`.
- Produces:
  - `release/NativeTavern_v<VERSION>_Android.apk` (+ `.sha256`)
  - `release/NativeTavern_v<VERSION>_Android.aab` (+ `.sha256`)
- Distribute Google Play AAB:
  ```sh
  GOOGLE_PLAY_TRACK=production dart run tool/google_play_release.dart publish \
    release/NativeTavern_v<VERSION>_Android.aab \
    docs/releases/<VERSION>-app-store-whats-new.json <VERSION_CODE> completed
  ```
- Distribute APK via Cloudflare R2:
  Upload to `https://download.nativetavern.com/NativeTavern.apk`.

---

## 3. Running Android Tests

### Unit and Widget Tests
```sh
flutter test
```

### Connected Device / Emulator Integration Tests
List connected ADB devices:
```sh
adb devices
```

Run integration tests on target Android device:
```sh
flutter test integration_test/ -d android
```

---

## 4. Gradle & Application ID Architecture

- **Gradle Version**: Gradle Wrapper 8.13, AGP 8.9.1.
- **Java Home**: OpenJDK 17 (`/opt/homebrew/opt/openjdk@17`).
- **Namespace vs Application ID**:
  - `android.namespace = "com.miaomiaoxworld.nativetavern"`: Keeps Kotlin class references and package declarations intact.
  - `android.defaultConfig.applicationId = "$PACKAGE_NAME"`: Injected dynamically from `.env` or `--package` argument for independent device installation.
