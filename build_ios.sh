#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

EXPECTED_BUNDLE_ID="com.miaomiaoxworld.nativetavern"
EXPECTED_IOS_TARGET="15.0"
EXPORT_METHOD="${EXPORT_METHOD:-app-store-connect}"
BUILD_FOR_DEVICE="${BUILD_FOR_DEVICE:-false}"
DEVICE_ID="${DEVICE_ID:-}"
POD_REPO_UPDATE="${POD_REPO_UPDATE:-false}"
CHECK_ONLY="${CHECK_ONLY:-false}"

APP_DELEGATE="ios/Runner/AppDelegate.swift"
INFO_PLIST="ios/Runner/Info.plist"
PODFILE="ios/Podfile"
PODFILE_LOCK="ios/Podfile.lock"
PBXPROJ="ios/Runner.xcodeproj/project.pbxproj"

CRITICAL_IOS_FILES=(
  "$APP_DELEGATE"
  "$INFO_PLIST"
  "$PODFILE"
  "$PODFILE_LOCK"
  "$PBXPROJ"
)

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

read_plist_value() {
  /usr/libexec/PlistBuddy -c "Print :$2" "$1" 2>/dev/null || true
}

read_project_team_id() {
  sed -n 's/.*DEVELOPMENT_TEAM = \([^;]*\);.*/\1/p' "$PBXPROJ" \
    | tr -d '"' \
    | awk 'NF { print; exit }'
}

validate_source_project() {
  printf '%s\n' '=== Validating committed iOS project ==='

  for path in "${CRITICAL_IOS_FILES[@]}"; do
    require_file "$path"
    git ls-files --error-unmatch "$path" >/dev/null 2>&1 \
      || fail "Critical iOS release file is not tracked by Git: $path"
  done

  grep -Fq 'com.nativetavern/live2d_render_scale' "$APP_DELEGATE" \
    || fail "AppDelegate is missing the native Live2D render-scale channel"
  grep -Fq 'synchronizeContentScale' "$APP_DELEGATE" \
    || fail "AppDelegate is missing the Live2D render-scale handler"
  grep -Fq "platform :ios, '$EXPECTED_IOS_TARGET'" "$PODFILE" \
    || fail "Podfile must target iOS $EXPECTED_IOS_TARGET"
  grep -Fq "IPHONEOS_DEPLOYMENT_TARGET = $EXPECTED_IOS_TARGET;" "$PBXPROJ" \
    || fail "Xcode project must target iOS $EXPECTED_IOS_TARGET"
  grep -Fq "PRODUCT_BUNDLE_IDENTIFIER = $EXPECTED_BUNDLE_ID;" "$PBXPROJ" \
    || fail "Xcode project bundle identifier is not $EXPECTED_BUNDLE_ID"

  [[ "$(read_plist_value "$INFO_PLIST" ITSAppUsesNonExemptEncryption)" == 'false' ]] \
    || fail "ITSAppUsesNonExemptEncryption must be false"
  [[ -n "$(read_plist_value "$INFO_PLIST" NSPhotoLibraryUsageDescription)" ]] \
    || fail "Info.plist is missing photo-library usage text"
  [[ -n "$(read_plist_value "$INFO_PLIST" NSLocationWhenInUseUsageDescription)" ]] \
    || fail "Info.plist is missing location usage text required by DKCamera"
  [[ -n "$(read_plist_value "$INFO_PLIST" NSMicrophoneUsageDescription)" ]] \
    || fail "Info.plist is missing microphone usage text"

  printf '%s\n' 'Committed iOS project validation passed.'
}

snapshot_critical_ios_files() {
  shasum -a 256 "${CRITICAL_IOS_FILES[@]}"
}

assert_critical_ios_files_unchanged() {
  local after_snapshot
  after_snapshot="$(snapshot_critical_ios_files)"
  [[ "$after_snapshot" == "$IOS_SOURCE_SNAPSHOT" ]] \
    || fail "The build changed committed iOS source files; refusing to package"
}

validate_app_bundle() {
  local app_path="$1"
  local executable bundle_id version build minimum_os

  require_file "$app_path/Info.plist"
  executable="$(read_plist_value "$app_path/Info.plist" CFBundleExecutable)"
  bundle_id="$(read_plist_value "$app_path/Info.plist" CFBundleIdentifier)"
  version="$(read_plist_value "$app_path/Info.plist" CFBundleShortVersionString)"
  build="$(read_plist_value "$app_path/Info.plist" CFBundleVersion)"
  minimum_os="$(read_plist_value "$app_path/Info.plist" MinimumOSVersion)"

  [[ "$bundle_id" == "$EXPECTED_BUNDLE_ID" ]] \
    || fail "Built bundle identifier is $bundle_id, expected $EXPECTED_BUNDLE_ID"
  [[ "$version" == "$BUILD_NAME" ]] \
    || fail "Built version is $version, expected $BUILD_NAME"
  [[ "$build" == "$BUILD_NUMBER" ]] \
    || fail "Built number is $build, expected $BUILD_NUMBER"
  [[ "$minimum_os" == "$EXPECTED_IOS_TARGET" ]] \
    || fail "Built MinimumOSVersion is $minimum_os, expected $EXPECTED_IOS_TARGET"
  require_file "$app_path/$executable"

  strings "$app_path/$executable" \
    | grep -F 'com.nativetavern/live2d_render_scale' >/dev/null \
    || fail "Built native binary is missing the Live2D render-scale channel"
  strings "$app_path/$executable" \
    | grep -F 'Live2DGLView' >/dev/null \
    || fail "Built native binary is missing the Live2D renderer"
  nm -gjU "$app_path/$executable" \
    | grep -Fx '_spine_major_version' >/dev/null \
    || fail "Built native binary is missing the statically linked Spine FFI symbols"
  require_file "$app_path/Frameworks/App.framework/App"
  strings "$app_path/Frameworks/App.framework/App" \
    | grep -F 'com.nativetavern/live2d_render_scale' >/dev/null \
    || fail "Built Dart binary is missing the Live2D render-scale channel"

  codesign --verify --deep --strict "$app_path"
  printf 'Validated app: %s %s (%s), iOS %s+\n' \
    "$bundle_id" "$version" "$build" "$minimum_os"
}

validate_ipa() {
  local ipa_path="$1"
  local inspect_dir app_path

  require_file "$ipa_path"
  inspect_dir="$TEMP_DIR/ipa-inspect"
  mkdir -p "$inspect_dir"
  unzip -q "$ipa_path" -d "$inspect_dir"
  app_path="$(find "$inspect_dir/Payload" -maxdepth 1 -type d -name '*.app' -print -quit)"
  [[ -n "$app_path" ]] || fail "IPA does not contain an application bundle"
  validate_app_bundle "$app_path"
}

for command_name in git flutter pod xcodebuild plutil unzip strings nm codesign shasum; do
  require_command "$command_name"
done

require_file pubspec.yaml
VERSION="$(awk '/^version:/ { print $2; exit }' pubspec.yaml)"
[[ "$VERSION" == *+* ]] || fail "pubspec version must include a build number"
BUILD_NAME="${VERSION%%+*}"
BUILD_NUMBER="${VERSION##*+}"
[[ "$BUILD_NUMBER" =~ ^[0-9]+$ ]] || fail "Invalid build number: $BUILD_NUMBER"

validate_source_project
IOS_SOURCE_SNAPSHOT="$(snapshot_critical_ios_files)"

if [[ "$CHECK_ONLY" == 'true' ]]; then
  printf 'Preflight passed for NativeTavern %s.\n' "$VERSION"
  exit 0
fi

if [[ -f .env ]]; then
  set -a
  source .env
  set +a
fi

PROJECT_TEAM_ID="$(read_project_team_id)"
TEAM_ID="${TEAM_ID:-${APPLE_DEVELOP_ID:-$PROJECT_TEAM_ID}}"
[[ -n "$TEAM_ID" ]] || fail "Set TEAM_ID, APPLE_DEVELOP_ID in .env, or configure DEVELOPMENT_TEAM in Xcode"

TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/nativetavern-ios-release.XXXXXX")"
cleanup() {
  rm -rf -- "$TEMP_DIR"
}
trap cleanup EXIT

BUILD_ROOT="$REPO_ROOT/build/ios-release/$VERSION"
ARCHIVE_PATH="$BUILD_ROOT/Runner.xcarchive"
EXPORT_PATH="$BUILD_ROOT/export"
FINAL_IPA="$REPO_ROOT/release/NativeTavern_v${VERSION}.ipa"
EXPORT_OPTIONS="$TEMP_DIR/ExportOptions.plist"

printf '=== Building NativeTavern %s ===\n' "$VERSION"
printf 'Team: %s\n' "$TEAM_ID"

flutter clean
flutter pub get

echo "=== Generating Launcher Icons ==="
dart run flutter_launcher_icons

pushd ios >/dev/null
if [[ "$POD_REPO_UPDATE" == 'true' ]]; then
  pod install --repo-update
else
  pod install
fi
popd >/dev/null

assert_critical_ios_files_unchanged
mkdir -p "$BUILD_ROOT" "$REPO_ROOT/release"

COMMON_XCODE_ARGS=(
  -workspace "$REPO_ROOT/ios/Runner.xcworkspace"
  -scheme Runner
  -configuration Release
  SUPPORTS_MACCATALYST=NO
  "DEVELOPMENT_TEAM=$TEAM_ID"
  "FLUTTER_BUILD_NAME=$BUILD_NAME"
  "FLUTTER_BUILD_NUMBER=$BUILD_NUMBER"
)

if [[ "$BUILD_FOR_DEVICE" == 'true' ]]; then
  [[ -n "$DEVICE_ID" ]] || fail "Set DEVICE_ID when BUILD_FOR_DEVICE=true"
  DERIVED_DATA_PATH="$BUILD_ROOT/DerivedData"

  xcodebuild "${COMMON_XCODE_ARGS[@]}" \
    -destination "id=$DEVICE_ID" \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    -allowProvisioningUpdates \
    -allowProvisioningDeviceRegistration \
    clean build

  DEVICE_APP="$DERIVED_DATA_PATH/Build/Products/Release-iphoneos/Runner.app"
  [[ -d "$DEVICE_APP" ]] || fail "Device application was not produced"
  validate_app_bundle "$DEVICE_APP"
  assert_critical_ios_files_unchanged

  if command -v ios-deploy >/dev/null 2>&1; then
    ios-deploy --id "$DEVICE_ID" --bundle "$DEVICE_APP"
  else
    xcrun devicectl device install app --device "$DEVICE_ID" "$DEVICE_APP"
  fi

  printf 'Installed NativeTavern %s on device %s.\n' "$VERSION" "$DEVICE_ID"
  exit 0
fi

xcodebuild "${COMMON_XCODE_ARGS[@]}" \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE_PATH" \
  -allowProvisioningUpdates \
  clean archive

ARCHIVED_APP="$ARCHIVE_PATH/Products/Applications/Runner.app"
[[ -d "$ARCHIVED_APP" ]] || fail "Xcode archive does not contain Runner.app"
validate_app_bundle "$ARCHIVED_APP"
assert_critical_ios_files_unchanged

plutil -create xml1 "$EXPORT_OPTIONS"
plutil -insert method -string "$EXPORT_METHOD" "$EXPORT_OPTIONS"
plutil -insert destination -string export "$EXPORT_OPTIONS"
plutil -insert signingStyle -string automatic "$EXPORT_OPTIONS"
plutil -insert teamID -string "$TEAM_ID" "$EXPORT_OPTIONS"
plutil -insert stripSwiftSymbols -bool true "$EXPORT_OPTIONS"
plutil -insert compileBitcode -bool false "$EXPORT_OPTIONS"
plutil -insert thinning -string '<none>' "$EXPORT_OPTIONS"

xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "$EXPORT_OPTIONS" \
  -allowProvisioningUpdates

EXPORTED_IPA="$(find "$EXPORT_PATH" -maxdepth 1 -type f -name '*.ipa' -print -quit)"
[[ -n "$EXPORTED_IPA" ]] || fail "App Store export did not produce an IPA"
validate_ipa "$EXPORTED_IPA"
assert_critical_ios_files_unchanged

[[ ! -e "$FINAL_IPA" ]] \
  || fail "Release artifact already exists: $FINAL_IPA"
cp "$EXPORTED_IPA" "$FINAL_IPA"

printf '%s\n' '=== iOS release build complete ==='
printf 'IPA: %s\n' "$FINAL_IPA"
printf 'SHA-256: '
shasum -a 256 "$FINAL_IPA" | awk '{ print $1 }'
