#!/usr/bin/env bash
# Build a debug iOS IPA for GitHub Actions (and other CI).
#
# The committed iOS tree is incomplete on purpose: most of ios/ is gitignored,
# with only a handful of customized files tracked. This script regenerates the
# missing Flutter iOS scaffolding, restores the tracked files, then produces a
# debug IPA.
#
# Default output is an unsigned debug IPA (flutter build ios --debug --no-codesign
# packaged as Payload/Runner.app). That path works on GitHub-hosted macOS runners
# without Apple certificates. If signing secrets are present, the script instead
# builds a development-signed debug IPA via `flutter build ipa`.
#
# Environment:
#   SKIP_LAUNCHER_ICONS=true     Skip dart run flutter_launcher_icons
#   IOS_SIGNING_ENABLED=true     Build a signed development debug IPA
#   TEAM_ID / APPLE_DEVELOP_ID   Apple team ID used when signing
#   EXPORT_METHOD                Defaults to "debugging" for signed debug IPAs
#
# Output:
#   build/local_release/NativeTavern_v<version>_debug.ipa
#   build/local_release/NativeTavern_v<version>_debug.ipa.sha256

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

EXPECTED_BUNDLE_ID="com.miaomiaoxworld.nativetavern"
ORG="com.miaomiaoxworld"

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

require_file() {
  [[ -f "$1" ]] || fail "Required file not found: $1"
}

file_sha256() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    sha256sum "$1" | awk '{print $1}'
  fi
}

for command_name in git flutter zip; do
  require_command "$command_name"
done

require_file pubspec.yaml
VERSION="$(awk '/^version:/ { print $2; exit }' pubspec.yaml)"
[[ "$VERSION" == *+* ]] || fail "pubspec version must include a build number"
BUILD_NAME="${VERSION%%+*}"
BUILD_NUMBER="${VERSION##*+}"
[[ "$BUILD_NUMBER" =~ ^[0-9]+$ ]] || fail "Invalid build number: $BUILD_NUMBER"

TRACKED_IOS_FILES=(
  ios/Flutter/AppFrameworkInfo.plist
  ios/Podfile
  ios/Podfile.lock
  ios/Runner.xcodeproj/project.pbxproj
  ios/Runner/AppDelegate.swift
  ios/Runner/Info.plist
)

for path in "${TRACKED_IOS_FILES[@]}"; do
  require_file "$path"
done

STATE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/nativetavern-ios-debug-state.XXXXXX")"
cleanup() {
  rm -rf -- "$STATE_DIR"
}
trap cleanup EXIT

snapshot_file() {
  local src="$1"
  local dest="$STATE_DIR/$src"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

restore_file() {
  local src="$1"
  local dest="$STATE_DIR/$src"
  if [[ -f "$dest" ]]; then
    mkdir -p "$(dirname "$src")"
    cp "$dest" "$src"
  fi
}

printf '=== NativeTavern CI iOS debug IPA ===\n'
printf 'Version: %s (%s / %s)\n' "$VERSION" "$BUILD_NAME" "$BUILD_NUMBER"

for state_file in .metadata pubspec.lock "${TRACKED_IOS_FILES[@]}"; do
  [[ -f "$state_file" ]] && snapshot_file "$state_file"
done

printf 'Generating missing iOS platform files with flutter create...\n'
flutter create --platforms=ios --org "$ORG" .
for state_file in .metadata pubspec.lock "${TRACKED_IOS_FILES[@]}"; do
  restore_file "$state_file"
done

printf 'Restoring Flutter dependencies...\n'
flutter pub get

if [[ "${SKIP_LAUNCHER_ICONS:-false}" == "true" ]]; then
  printf 'Skipping launcher icon generation (SKIP_LAUNCHER_ICONS=true).\n'
else
  printf 'Generating launcher icons...\n'
  dart run flutter_launcher_icons
fi

require_command pod
pushd ios >/dev/null
if [[ "${POD_REPO_UPDATE:-false}" == "true" ]]; then
  pod install --repo-update
else
  pod install
fi
popd >/dev/null

OUT_DIR="$REPO_ROOT/build/local_release"
mkdir -p "$OUT_DIR"
FINAL_IPA="$OUT_DIR/NativeTavern_v${VERSION}_debug.ipa"
rm -f "$FINAL_IPA" "${FINAL_IPA}.sha256"

SIGNING_ENABLED="${IOS_SIGNING_ENABLED:-false}"
TEAM_ID="${TEAM_ID:-${APPLE_DEVELOP_ID:-}}"

if [[ "$SIGNING_ENABLED" == "true" ]]; then
  require_command xcodebuild
  [[ -n "$TEAM_ID" ]] || fail "IOS_SIGNING_ENABLED=true requires TEAM_ID or APPLE_DEVELOP_ID"
  EXPORT_METHOD="${EXPORT_METHOD:-debugging}"
  printf 'Building signed debug IPA (export method: %s)...\n' "$EXPORT_METHOD"
  flutter build ipa \
    --debug \
    --no-pub \
    --export-method="$EXPORT_METHOD" \
    --build-name="$BUILD_NAME" \
    --build-number="$BUILD_NUMBER"

  EXPORTED_IPA="$(find build/ios/ipa -maxdepth 1 -type f -name '*.ipa' -print -quit 2>/dev/null || true)"
  [[ -n "$EXPORTED_IPA" && -f "$EXPORTED_IPA" ]] || fail "Signed debug IPA was not produced under build/ios/ipa"
  cp "$EXPORTED_IPA" "$FINAL_IPA"
else
  printf 'Building unsigned debug IPA (no Apple signing secrets configured)...\n'
  printf 'This artifact cannot be installed on a device until it is re-signed.\n'
  flutter build ios \
    --debug \
    --no-codesign \
    --no-pub \
    --build-name="$BUILD_NAME" \
    --build-number="$BUILD_NUMBER"

  APP_PATH=""
  for candidate in \
    "build/ios/iphoneos/Runner.app" \
    "build/ios/Debug-iphoneos/Runner.app"
  do
    if [[ -d "$candidate" ]]; then
      APP_PATH="$candidate"
      break
    fi
  done
  if [[ -z "$APP_PATH" ]]; then
    APP_PATH="$(find build/ios -type d -name 'Runner.app' -print -quit 2>/dev/null || true)"
  fi
  [[ -n "$APP_PATH" && -d "$APP_PATH" ]] || fail "Debug build did not produce Runner.app"

  BUNDLE_ID="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$APP_PATH/Info.plist" 2>/dev/null || true)"
  if [[ -n "$BUNDLE_ID" && "$BUNDLE_ID" != "\$(PRODUCT_BUNDLE_IDENTIFIER)" ]]; then
    [[ "$BUNDLE_ID" == "$EXPECTED_BUNDLE_ID" ]] \
      || fail "Built bundle identifier is $BUNDLE_ID, expected $EXPECTED_BUNDLE_ID"
  fi

  STAGE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/nativetavern-ios-debug-ipa.XXXXXX")"
  mkdir -p "$STAGE_DIR/Payload"
  cp -R "$APP_PATH" "$STAGE_DIR/Payload/"
  # ditto preserves symlinks inside the .app better than zip on macOS.
  if command -v ditto >/dev/null 2>&1; then
    (cd "$STAGE_DIR" && ditto -c -k --norsrc --keepParent Payload "$FINAL_IPA")
  else
    (cd "$STAGE_DIR" && zip -qry "$FINAL_IPA" Payload)
  fi
  rm -rf -- "$STAGE_DIR"
fi

[[ -f "$FINAL_IPA" ]] || fail "Failed to write $FINAL_IPA"
IPA_SHA="$(file_sha256 "$FINAL_IPA")"
printf '%s  %s\n' "$IPA_SHA" "$(basename "$FINAL_IPA")" > "${FINAL_IPA}.sha256"

printf '%s\n' '=== iOS debug IPA complete ==='
printf 'IPA: %s\n' "$FINAL_IPA"
printf 'SHA-256: %s\n' "$IPA_SHA"
printf 'Signed: %s\n' "$SIGNING_ENABLED"
