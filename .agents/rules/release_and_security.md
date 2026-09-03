# NativeTavern Release & Security Rules

## 1. Release Packaging Workflows

- Official release artifacts MUST be generated using the checked-in repository scripts:
  - **iOS**: `./build_ios.sh`
  - **Android**: `./build_android.sh`
  - **macOS**: `./build_macos.sh`
- Never substitute ad-hoc `flutter build`, `gradle`, or `xcodebuild` commands when preparing release artifacts.
- Local developer testing builds must use the local build scripts:
  - `./build_ios_local.sh`
  - `./build_android_local.sh`
  - `./build_macos_local.sh`

---

## 2. Environment Variables & Secret Handling

- **Strict Confidentiality**: Values in `.env` are secrets. NEVER print, log, echo, commit, or display API keys, service account JSON, private keys (`.p8`, `.jks`), or authorization tokens.
- Reference variables by name only (e.g. `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON is configured`).
- Do not commit `.env`, keystore files, or credentials to git.

---

## 3. Artifact Verification

- Every release package must be accompanied by its SHA-256 checksum file (`.sha256`).
- Verify checksums before publishing:
  ```sh
  shasum -a 256 -c <artifact-file>.sha256
  ```
- Verify zip/tar archives before publishing using `unzip -t` or `tar -tf`.
