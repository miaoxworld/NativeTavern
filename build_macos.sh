#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

require_file() {
  [[ -f "$1" ]] || fail "Required file not found: $1"
}

for cmd in git flutter ditto shasum; do
  require_command "$cmd"
done

require_file pubspec.yaml
VERSION="$(awk '/^version:/ { print $2; exit }' pubspec.yaml)"
[[ "$VERSION" == *+* ]] || fail "pubspec version must include a build number (e.g. 1.0.0+1)"
BUILD_NAME="${VERSION%%+*}"
BUILD_NUMBER="${VERSION##*+}"

printf '=== Building NativeTavern macOS %s ===\n' "$VERSION"

# Ensure macOS platform files exist
if [[ ! -d "macos" ]]; then
  printf 'Creating macOS platform support...\n'
  flutter create --platforms=macos --org com.miaomiaoxworld .
fi

# Clean and fetch dependencies
flutter clean
flutter pub get

printf '=== Generating Launcher Icons ===\n'
dart run flutter_launcher_icons

# Build macOS release application
flutter build macos --release \
  --build-name="$BUILD_NAME" \
  --build-number="$BUILD_NUMBER"

# Locate built .app bundle
BUILD_APP_PATH="$(find build/macos/Build/Products/Release -maxdepth 1 -type d -name '*.app' -print -quit)"
[[ -n "$BUILD_APP_PATH" ]] || fail "macOS release build did not produce an .app bundle"

mkdir -p release
FINAL_ZIP="$REPO_ROOT/release/NativeTavern_v${VERSION}_macOS.zip"
rm -f "$FINAL_ZIP"

printf 'Packaging application bundle into %s...\n' "$FINAL_ZIP"
ditto -c -k --sequesterRsrc --keepParent "$BUILD_APP_PATH" "$FINAL_ZIP"

[[ -f "$FINAL_ZIP" ]] || fail "Failed to produce release zip: $FINAL_ZIP"

SHA="$(shasum -a 256 "$FINAL_ZIP" | awk '{ print $1 }')"
printf '%s  %s\n' "$SHA" "$(basename "$FINAL_ZIP")" > "${FINAL_ZIP}.sha256"

printf '=== macOS release build complete ===\n'
printf 'Archive: %s\n' "$FINAL_ZIP"
printf 'SHA-256: %s\n' "$SHA"
