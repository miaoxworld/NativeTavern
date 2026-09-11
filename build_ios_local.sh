#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"
if [[ -f .env ]]; then
  set -a
  source .env
  set +a
  FLUTTER_ENV_FLAGS="--dart-define-from-file=.env"
else
  FLUTTER_ENV_FLAGS=""
fi

EXPECTED_BUNDLE_ID="com.miaomiaoxworld.nativetavern"
BUNDLE_ID="${BUNDLE_ID:-${APPLE_BUNDLE_ID:-${IOS_BUNDLE_ID:-$EXPECTED_BUNDLE_ID}}}"
APP_GROUP_ID="${APP_GROUP_ID:-group.${BUNDLE_ID}}"
EXPECTED_WIDGET_BUNDLE_ID="${EXPECTED_BUNDLE_ID}.HomeWidgets"
WIDGET_BUNDLE_ID="${BUNDLE_ID}.HomeWidgets"
EXPECTED_IOS_TARGET="15.0"
EXPORT_METHOD="${EXPORT_METHOD:-${IOS_EXPORT_METHOD:-development}}"
BUILD_FOR_DEVICE="${BUILD_FOR_DEVICE:-false}"
BUILD_FOR_SIMULATOR="${BUILD_FOR_SIMULATOR:-false}"
DEVICE_ID="${DEVICE_ID:-}"
SIMULATOR_QUERY="${SIMULATOR_QUERY:-}"
XCODE_APP="${XCODE_APP:-}"
XCODE_MAJOR="${XCODE_MAJOR:-0}"
XCODE_VERSION_STRING="${XCODE_VERSION_STRING:-}"
SIMULATOR_UI="${SIMULATOR_UI:-}"
POD_REPO_UPDATE="${POD_REPO_UPDATE:-false}"
CHECK_ONLY="${CHECK_ONLY:-false}"
SKIP_CLEAN="${SKIP_CLEAN:-false}"

ICLOUD_CONTAINER_ID="${ICLOUD_CONTAINER_ID:-${APPLE_ICLOUD_CONTAINER_ID:-${ICLOUD_CONTAINER:-}}}"
if [[ -n "$ICLOUD_CONTAINER_ID" ]]; then
  ENABLE_ICLOUD="${ENABLE_ICLOUD:-true}"
else
  ENABLE_ICLOUD="${ENABLE_ICLOUD:-false}"
fi

# Parse CLI arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --check-only)
      CHECK_ONLY="true"
      shift
      ;;
    --skip-clean)
      SKIP_CLEAN="true"
      shift
      ;;
    --export-method)
      EXPORT_METHOD="$2"
      shift 2
      ;;
    --bundle-id)
      BUNDLE_ID="$2"
      shift 2
      ;;
    --device)
      BUILD_FOR_DEVICE="true"
      DEVICE_ID="$2"
      shift 2
      ;;
    --simulator)
      BUILD_FOR_SIMULATOR="true"
      if [[ $# -gt 1 && "$2" != -* ]]; then
        SIMULATOR_QUERY="$2"
        shift 2
      else
        SIMULATOR_QUERY="iPhone 14 Pro Max"
        shift
      fi
      ;;
    -h|--help)
      echo "Usage: ./build_ios_local.sh [options]"
      echo "Options:"
      echo "  --check-only          Validate configuration without building"
      echo "  --skip-clean          Skip flutter clean for faster rebuilds"
      echo "  --export-method <m>   development or ad-hoc (default: development)"
      echo "  --bundle-id <id>      Override iOS bundle identifier"
      echo "  --device <id>         Target a connected physical iOS device"
      echo "  --simulator [id|name] Build, install, and keep a Debug session on an"
      echo "                        iOS Simulator using BUNDLE_ID and"
      echo "                        ICLOUD_CONTAINER_ID from .env"
      echo "                        (default: iPhone 14 Pro Max)."
      echo "                        Stays attached so the app can run; logs go to"
      echo "                        build/local_release/simulator/."
      echo "                        Xcode 26 and earlier open Simulator.app;"
      echo "                        Xcode 27+ opens Device Hub."
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done


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

# Apple seed/developer-beta builds end in a lowercase letter (e.g. 26A5425a).
# Release builds end in digits (e.g. 24G84). ProductVersionExtra is an RSR
# suffix like "(a)", not a beta marker — do not use it here.
macos_is_developer_beta() {
  local build
  build="$(sw_vers -buildVersion 2>/dev/null || true)"
  [[ "$build" =~ [a-z]$ ]]
}

# Prefer /Applications/Xcode.app. Use Xcode-beta.app only when macOS itself is
# a developer beta and the release Xcode.app is missing. An explicit XCODE_APP
# in the environment wins, so local sideload machines with only Xcode-beta can
# still archive an IPA.
select_xcode_app() {
  local app="${XCODE_APP:-}"
  if [[ -n "$app" ]]; then
    [[ -d "$app" ]] || fail "XCODE_APP is set but not a directory: $app"
  elif [[ -d /Applications/Xcode.app ]]; then
    app="/Applications/Xcode.app"
  elif [[ -d /Applications/Xcode-beta.app ]]; then
    app="/Applications/Xcode-beta.app"
  else
    fail "Xcode was not found in /Applications."
  fi
  XCODE_APP="$app"
  export DEVELOPER_DIR="$XCODE_APP/Contents/Developer"
}

read_xcode_major() {
  local ver out
  out="$(xcodebuild -version 2>/dev/null || true)"
  ver="$(printf '%s\n' "$out" | awk '/^Xcode / { print $2; exit }')"
  XCODE_VERSION_STRING="${ver:-unknown}"
  XCODE_MAJOR="${ver%%.*}"
  [[ "$XCODE_MAJOR" =~ ^[0-9]+$ ]] || XCODE_MAJOR=0
}

# Device Hub replaced Simulator.app in Xcode 27 (WWDC 2026 / Apple docs).
# Xcode 26.x and earlier still ship Simulator.app.
simulator_ui_kind() {
  local sim_app="${XCODE_APP}/Contents/Developer/Applications/Simulator.app"
  local hub_app="${XCODE_APP}/Contents/Applications/DeviceHub.app"
  if [[ "${XCODE_MAJOR:-0}" -ge 27 && -d "$hub_app" ]]; then
    printf 'devicehub\n'
    return
  fi
  if [[ -d "$sim_app" ]]; then
    printf 'simulator\n'
    return
  fi
  if [[ -d "$hub_app" ]]; then
    printf 'devicehub\n'
    return
  fi
  printf 'none\n'
}

open_simulator_runtime_ui() {
  local kind hub sim
  kind="$(simulator_ui_kind)"
  SIMULATOR_UI="$kind"
  case "$kind" in
    devicehub)
      hub="${XCODE_APP}/Contents/Applications/DeviceHub.app"
      printf 'Opening Device Hub (Xcode %s; Simulator.app is not used on Xcode 27+)\n' "$XCODE_MAJOR"
      open "$hub"
      ;;
    simulator)
      sim="${XCODE_APP}/Contents/Developer/Applications/Simulator.app"
      printf 'Opening Simulator.app (Xcode %s)\n' "$XCODE_MAJOR"
      open "$sim"
      ;;
    *)
      printf 'WARNING: Neither Simulator.app nor Device Hub was found in %s\n' "$XCODE_APP" >&2
      ;;
  esac
}

resolve_simulator_udid() {
  local query="$1"
  local udid=""
  if [[ "$query" =~ ^[0-9A-Fa-f-]{36}$ ]]; then
    printf '%s\n' "$query"
    return 0
  fi
  udid="$(
    set +o pipefail
    xcrun simctl list devices available \
      | awk -v name="$query" '
          index($0, name) && $0 ~ /\([0-9A-F-]{36}\)/ {
            if (match($0, /\([0-9A-F-]{36}\)/)) {
              print substr($0, RSTART + 1, RLENGTH - 2)
              exit
            }
          }
        '
  )"
  [[ -n "$udid" ]] || fail "No available simulator matching: $query"
  printf '%s\n' "$udid"
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

  [[ "$bundle_id" == "$BUNDLE_ID" ]] \
    || fail "Built bundle identifier is $bundle_id, expected $BUNDLE_ID"
  [[ "$version" == "$BUILD_NAME" ]] \
    || fail "Built version is $version, expected $BUILD_NAME"
  [[ "$build" == "$BUILD_NUMBER" ]] \
    || fail "Built number is $build, expected $BUILD_NUMBER"
  [[ "$minimum_os" == "$EXPECTED_IOS_TARGET" ]] \
    || fail "Built MinimumOSVersion is $minimum_os, expected $EXPECTED_IOS_TARGET"
  require_file "$app_path/$executable"

  widget_appex="$app_path/PlugIns/HomeWidgets.appex"
  [[ -d "$widget_appex" ]] \
    || fail "HomeWidgets.appex is missing from $app_path/PlugIns"
  widget_group="$(codesign -d --entitlements :- "$widget_appex" 2>/dev/null | tr -d '\0' || true)"
  printf '%s' "$widget_group" | grep -Fq "$APP_GROUP_ID" \
    || fail "HomeWidgets.appex is missing App Group $APP_GROUP_ID from .env"
  runner_group="$(codesign -d --entitlements :- "$app_path/$executable" 2>/dev/null | tr -d '\0' || true)"
  printf '%s' "$runner_group" | grep -Fq "$APP_GROUP_ID" \
    || fail "Runner is missing App Group $APP_GROUP_ID from .env"
  widget_plist_group="$(read_plist_value "$widget_appex/Info.plist" NTAppGroupId || true)"
  [[ "$widget_plist_group" == "$APP_GROUP_ID" ]] \
    || fail "HomeWidgets Info.plist NTAppGroupId is ${widget_plist_group:-empty}, expected $APP_GROUP_ID"
  printf 'Verified App Group %s on Runner and HomeWidgets\n' "$APP_GROUP_ID"

  app_contains_string() {
    local needle="$1"
    strings "$app_path/$executable" | grep -F "$needle" >/dev/null && return 0
    if [[ -f "$app_path/${executable}.debug.dylib" ]]; then
      strings "$app_path/${executable}.debug.dylib" | grep -F "$needle" >/dev/null && return 0
    fi
    return 1
  }

  app_contains_symbol() {
    local needle="$1"
    nm -gjU "$app_path/$executable" | grep -Fx "$needle" >/dev/null && return 0
    if [[ -f "$app_path/${executable}.debug.dylib" ]]; then
      nm -gjU "$app_path/${executable}.debug.dylib" | grep -Fx "$needle" >/dev/null && return 0
    fi
    return 1
  }

  app_contains_string 'com.nativetavern/live2d_render_scale' \
    || fail "Built native binary is missing the Live2D render-scale channel"
  app_contains_string 'Live2DGLView' \
    || fail "Built native binary is missing the Live2D renderer"
  app_contains_symbol '_spine_major_version' \
    || fail "Built native binary is missing the statically linked Spine FFI symbols"
  require_file "$app_path/Frameworks/App.framework/App"
  # Debug simulator JIT may not embed this dart string in App.framework.
  if [[ "$app_path" != *iphonesimulator* ]]; then
    strings "$app_path/Frameworks/App.framework/App" \
      | grep -F 'com.nativetavern/live2d_render_scale' >/dev/null \
      || fail "Built Dart binary is missing the Live2D render-scale channel"
  fi

  if [[ "$app_path" != *iphonesimulator* ]]; then
    codesign --verify --deep --strict "$app_path"
  fi
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

select_xcode_app
for command_name in git flutter pod xcodebuild plutil unzip strings nm codesign shasum; do
  require_command "$command_name"
done
read_xcode_major
SIMULATOR_UI="$(simulator_ui_kind)"

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

PROJECT_TEAM_ID="$(read_project_team_id)"
TEAM_ID="${TEAM_ID:-${APPLE_DEVELOP_ID:-$PROJECT_TEAM_ID}}"
[[ -n "$TEAM_ID" ]] || fail "Set TEAM_ID, APPLE_DEVELOP_ID in .env, or configure DEVELOPMENT_TEAM in Xcode"

TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/nativetavern-ios-release.XXXXXX")"
ENTITLEMENTS_FILE="ios/Runner/Runner.entitlements"
ENTITLEMENTS_BACKUP="$TEMP_DIR/Runner.entitlements.bak"
WIDGET_ENTITLEMENTS_FILE="ios/HomeWidgets/HomeWidgets.entitlements"
WIDGET_ENTITLEMENTS_BACKUP="$TEMP_DIR/HomeWidgets.entitlements.bak"
WIDGET_INFO_PLIST="ios/HomeWidgets/Info.plist"
WIDGET_INFO_PLIST_BACKUP="$TEMP_DIR/HomeWidgets.Info.plist.bak"
INFO_PLIST_BACKUP="$TEMP_DIR/Info.plist.bak"
PBXPROJ_BACKUP="$TEMP_DIR/project.pbxproj.bak"
DEBUG_XCCONFIG="ios/Flutter/Debug.xcconfig"
DEBUG_XCCONFIG_BACKUP="$TEMP_DIR/Debug.xcconfig.bak"
SIMULATOR_LOGSTREAM_PID=""
FLUTTER_RUN_PID=""
SIMULATOR_TAIL_PID=""

if [[ -f "$ENTITLEMENTS_FILE" ]]; then
  cp "$ENTITLEMENTS_FILE" "$ENTITLEMENTS_BACKUP"
fi
if [[ -f "$WIDGET_ENTITLEMENTS_FILE" ]]; then
  cp "$WIDGET_ENTITLEMENTS_FILE" "$WIDGET_ENTITLEMENTS_BACKUP"
fi
if [[ -f "$WIDGET_INFO_PLIST" ]]; then
  cp "$WIDGET_INFO_PLIST" "$WIDGET_INFO_PLIST_BACKUP"
fi
if [[ -f "$INFO_PLIST" ]]; then
  cp "$INFO_PLIST" "$INFO_PLIST_BACKUP"
fi
if [[ -f "$PBXPROJ" ]]; then
  cp "$PBXPROJ" "$PBXPROJ_BACKUP"
fi
if [[ -f "$DEBUG_XCCONFIG" ]]; then
  cp "$DEBUG_XCCONFIG" "$DEBUG_XCCONFIG_BACKUP"
fi

cleanup() {
  if [[ -n "${SIMULATOR_TAIL_PID:-}" ]]; then
    kill "${SIMULATOR_TAIL_PID}" 2>/dev/null || true
  fi
  if [[ -n "${SIMULATOR_LOGSTREAM_PID:-}" ]]; then
    kill "${SIMULATOR_LOGSTREAM_PID}" 2>/dev/null || true
  fi
  if [[ -n "${FLUTTER_RUN_PID:-}" ]]; then
    kill "${FLUTTER_RUN_PID}" 2>/dev/null || true
    wait "${FLUTTER_RUN_PID}" 2>/dev/null || true
  fi
  if [[ -f "$ENTITLEMENTS_BACKUP" ]]; then
    cp -f "$ENTITLEMENTS_BACKUP" "$ENTITLEMENTS_FILE"
  fi
  if [[ -f "$WIDGET_ENTITLEMENTS_BACKUP" ]]; then
    cp -f "$WIDGET_ENTITLEMENTS_BACKUP" "$WIDGET_ENTITLEMENTS_FILE"
  fi
  if [[ -f "$WIDGET_INFO_PLIST_BACKUP" ]]; then
    cp -f "$WIDGET_INFO_PLIST_BACKUP" "$WIDGET_INFO_PLIST"
  fi
  if [[ -f "$DEBUG_XCCONFIG_BACKUP" ]]; then
    cp -f "$DEBUG_XCCONFIG_BACKUP" "$DEBUG_XCCONFIG"
  fi
  if [[ -f "$PBXPROJ_BACKUP" ]]; then
    cp -f "$PBXPROJ_BACKUP" "$PBXPROJ"
  fi
  if [[ -f "$INFO_PLIST_BACKUP" ]]; then
    cp -f "$INFO_PLIST_BACKUP" "$INFO_PLIST"
  fi
  rm -rf -- "$TEMP_DIR"
}
trap cleanup EXIT INT TERM

BUILD_ROOT="$REPO_ROOT/build/ios-release/$VERSION"
ARCHIVE_PATH="$BUILD_ROOT/Runner.xcarchive"
EXPORT_PATH="$BUILD_ROOT/export"
FINAL_IPA="$REPO_ROOT/release/NativeTavern_v${VERSION}.ipa"
EXPORT_OPTIONS="$TEMP_DIR/ExportOptions.plist"

TARGET_CONTAINER_ID="${ICLOUD_CONTAINER_ID:-iCloud.com.miaomiaoxworld.nativetavern}"

printf '=== Building NativeTavern %s ===\n' "$VERSION"
printf 'macOS: %s (%s)%s\n' \
  "$(sw_vers -productVersion)" \
  "$(sw_vers -buildVersion)" \
  "$(macos_is_developer_beta && printf ' [developer beta]' || true)"
printf 'Xcode: %s (major %s) at %s\n' \
  "${XCODE_VERSION_STRING:-unknown}" \
  "$XCODE_MAJOR" \
  "$XCODE_APP"
printf 'Team: %s\n' "$TEAM_ID"
printf 'Bundle ID: %s\n' "$BUNDLE_ID"
printf 'App Group: %s\n' "$APP_GROUP_ID"
printf 'Widget Bundle ID: %s\n' "$WIDGET_BUNDLE_ID"
printf 'iCloud Enabled: %s\n' "$ENABLE_ICLOUD"
if [[ "$ENABLE_ICLOUD" == 'true' ]]; then
  printf 'iCloud Container: %s\n' "$TARGET_CONTAINER_ID"
fi
printf 'Export Method: %s\n' "$EXPORT_METHOD"
if [[ "$BUILD_FOR_SIMULATOR" == 'true' ]]; then
  printf 'Simulator: %s\n' "${SIMULATOR_QUERY:-iPhone 14 Pro Max}"
  printf 'Simulator UI: %s\n' "$SIMULATOR_UI"
fi

if [[ "$SKIP_CLEAN" != 'true' ]]; then
  flutter clean
  flutter pub get

if [[ -n "$FLUTTER_ENV_FLAGS" ]]; then
  flutter build ios --config-only $FLUTTER_ENV_FLAGS
fi
fi

echo "=== Generating Launcher Icons ==="
dart run flutter_launcher_icons

pushd ios >/dev/null
if [[ "$POD_REPO_UPDATE" == 'true' ]]; then
  pod install --repo-update
else
  pod install
fi
popd >/dev/null

#assert_critical_ios_files_unchanged
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

# Bundle IDs are written onto Runner and HomeWidgets in the pbxproj so the
# widget extension keeps "$BUNDLE_ID.HomeWidgets" instead of colliding.

write_app_group_entitlements() {
  local dest="$1"
  local extra_icloud="${2:-false}"
  if [[ "$extra_icloud" == 'true' ]]; then
    cat <<EOF > "$dest"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.developer.icloud-container-identifiers</key>
	<array>
		<string>$TARGET_CONTAINER_ID</string>
	</array>
	<key>com.apple.developer.icloud-services</key>
	<array>
		<string>CloudDocuments</string>
	</array>
	<key>com.apple.developer.ubiquity-container-identifiers</key>
	<array>
		<string>$TARGET_CONTAINER_ID</string>
	</array>
	<key>com.apple.security.application-groups</key>
	<array>
		<string>$APP_GROUP_ID</string>
	</array>
</dict>
</plist>
EOF
  else
    cat <<EOF > "$dest"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.application-groups</key>
	<array>
		<string>$APP_GROUP_ID</string>
	</array>
</dict>
</plist>
EOF
  fi
}

set_plist_app_group() {
  local plist="$1"
  [[ -f "$plist" ]] || return 0
  /usr/libexec/PlistBuddy -c "Delete :NTAppGroupId" "$plist" >/dev/null 2>&1 || true
  /usr/libexec/PlistBuddy -c "Add :NTAppGroupId string $APP_GROUP_ID" "$plist"
}

if [[ "$ENABLE_ICLOUD" == 'true' ]]; then
  write_app_group_entitlements "$ENTITLEMENTS_FILE" true
  if [[ "$TARGET_CONTAINER_ID" != "iCloud.com.miaomiaoxworld.nativetavern" ]]; then
    sed -i '' "s/iCloud\.com\.miaomiaoxworld\.nativetavern/$TARGET_CONTAINER_ID/g" "$INFO_PLIST"
  fi
else
  write_app_group_entitlements "$ENTITLEMENTS_FILE" false
fi
if [[ -f "$WIDGET_ENTITLEMENTS_FILE" ]]; then
  write_app_group_entitlements "$WIDGET_ENTITLEMENTS_FILE" false
fi
set_plist_app_group "$INFO_PLIST"
set_plist_app_group "$WIDGET_INFO_PLIST"

apply_local_bundle_ids() {
  # Target-level PRODUCT_BUNDLE_IDENTIFIER in project.pbxproj beats xcconfig.
  # flutter run / xcodebuild archive do not pass command-line overrides, so the
  # project file must match .env for simulator, device, and sideload IPA.
  # HomeWidgets keeps "$BUNDLE_ID.HomeWidgets".
  if [[ "$BUNDLE_ID" == "$EXPECTED_BUNDLE_ID" ]]; then
    return 0
  fi
  grep -Fq "PRODUCT_BUNDLE_IDENTIFIER = ${EXPECTED_BUNDLE_ID};" "$PBXPROJ" \
    || fail "Cannot apply BUNDLE_ID: expected $EXPECTED_BUNDLE_ID in $PBXPROJ"
  if grep -Fq "PRODUCT_BUNDLE_IDENTIFIER = ${EXPECTED_WIDGET_BUNDLE_ID};" "$PBXPROJ"; then
    sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = ${EXPECTED_WIDGET_BUNDLE_ID};/PRODUCT_BUNDLE_IDENTIFIER = ${WIDGET_BUNDLE_ID};/g" "$PBXPROJ"
  fi
  sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = ${EXPECTED_BUNDLE_ID};/PRODUCT_BUNDLE_IDENTIFIER = ${BUNDLE_ID};/g" "$PBXPROJ"
  grep -Fq "PRODUCT_BUNDLE_IDENTIFIER = ${BUNDLE_ID};" "$PBXPROJ" \
    || fail "Failed to write PRODUCT_BUNDLE_IDENTIFIER=$BUNDLE_ID into $PBXPROJ"
  if [[ -f "$DEBUG_XCCONFIG" ]]; then
    printf '\nPRODUCT_BUNDLE_IDENTIFIER=%s\n' "$BUNDLE_ID" >> "$DEBUG_XCCONFIG"
  fi
}

if [[ "$BUILD_FOR_DEVICE" == 'true' ]]; then
  [[ -n "$DEVICE_ID" ]] || fail "Set DEVICE_ID when BUILD_FOR_DEVICE=true"
  DERIVED_DATA_PATH="$BUILD_ROOT/DerivedData"
  apply_local_bundle_ids

  xcodebuild "${COMMON_XCODE_ARGS[@]}" \
    -destination "id=$DEVICE_ID" \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    -allowProvisioningUpdates \
    -allowProvisioningDeviceRegistration \
    clean build

  DEVICE_APP="$DERIVED_DATA_PATH/Build/Products/Release-iphoneos/Runner.app"
  [[ -d "$DEVICE_APP" ]] || fail "Device application was not produced"
  validate_app_bundle "$DEVICE_APP"
  # assert_critical_ios_files_unchanged

  if command -v ios-deploy >/dev/null 2>&1; then
    ios-deploy --id "$DEVICE_ID" --bundle "$DEVICE_APP"
  else
    xcrun devicectl device install app --device "$DEVICE_ID" "$DEVICE_APP"
  fi

  printf 'Installed NativeTavern %s on device %s.\n' "$VERSION" "$DEVICE_ID"
  exit 0
fi

apply_simulator_xcode_overrides() {
  apply_local_bundle_ids
  # Xcode 16+ Debug defaults to ENABLE_DEBUG_DYLIB=YES: a ~40KB blank executor
  # plus Runner.debug.dylib. flutter run on the simulator uses simctl launch
  # (no LLDB), so the stub aborts at abort_could_not_find_entry_point___debug_dylib.
  # Command-line FLUTTER_XCODE_* beats project defaults.
  if [[ -f "$DEBUG_XCCONFIG" ]]; then
    printf '\nENABLE_DEBUG_DYLIB=NO\n' >> "$DEBUG_XCCONFIG"
  fi
  export FLUTTER_XCODE_ENABLE_DEBUG_DYLIB=NO
}

verify_simulator_app_identity() {
  local container plist installed
  container="$(xcrun simctl get_app_container "$SIMULATOR_ID" "$BUNDLE_ID" app 2>/dev/null || true)"
  if [[ -z "$container" || ! -d "$container" ]]; then
    if xcrun simctl get_app_container "$SIMULATOR_ID" "$EXPECTED_BUNDLE_ID" app >/dev/null 2>&1; then
      fail "Simulator installed $EXPECTED_BUNDLE_ID instead of $BUNDLE_ID from .env"
    fi
    fail "Simulator does not have $BUNDLE_ID installed"
  fi
  plist="$container/Info.plist"
  [[ -f "$plist" ]] || fail "Installed app is missing Info.plist at $plist"
  installed="$(read_plist_value "$plist" CFBundleIdentifier)"
  [[ "$installed" == "$BUNDLE_ID" ]] \
    || fail "Installed CFBundleIdentifier is $installed, expected $BUNDLE_ID"
  printf 'Verified simulator bundle ID: %s\n' "$installed"
  widget_appex="$container/PlugIns/HomeWidgets.appex"
  [[ -d "$widget_appex" ]] \
    || fail "HomeWidgets.appex is missing from $container/PlugIns"
  widget_group="$(codesign -d --entitlements :- "$widget_appex" 2>/dev/null | tr -d '\0' || true)"
  printf '%s' "$widget_group" | grep -Fq "$APP_GROUP_ID" \
    || fail "HomeWidgets.appex is missing App Group $APP_GROUP_ID"
  runner_group="$(codesign -d --entitlements :- "$container/Runner" 2>/dev/null | tr -d '\0' || true)"
  printf '%s' "$runner_group" | grep -Fq "$APP_GROUP_ID" \
    || fail "Runner is missing App Group $APP_GROUP_ID"
  printf 'Verified HomeWidgets extension and App Group %s\n' "$APP_GROUP_ID"
  if [[ "$ENABLE_ICLOUD" == 'true' ]]; then
    read_plist_value "$plist" "NSUbiquitousContainers:$TARGET_CONTAINER_ID:NSUbiquitousContainerName" \
      | grep -q . \
      || fail "Installed app is missing iCloud container $TARGET_CONTAINER_ID"
    printf 'Verified simulator iCloud container: %s\n' "$TARGET_CONTAINER_ID"
  fi
}

verify_simulator_debug_binary() {
  local container="$1"
  local runner size
  runner="$container/Runner"
  [[ -f "$runner" ]] || fail "Installed Runner binary missing at $runner"
  if nm "$runner" 2>/dev/null | grep -Fq 'abort_could_not_find_entry_point___debug_dylib'; then
    fail "Simulator binary is still Apple's Debug stub (ENABLE_DEBUG_DYLIB). It cannot run without LLDB."
  fi
  size="$(stat -f '%z' "$runner")"
  [[ "$size" -gt 1000000 ]] \
    || fail "Simulator Runner is only $size bytes; expected a full Debug executable"
  printf 'Verified simulator Debug binary is a real executable (%s bytes)\n' "$size"
}

wait_for_simulator_debug_session() {
  local log="$1"
  local timeout_s="${2:-360}"
  local start now elapsed
  start="$(date +%s)"
  while true; do
    if grep -Eq 'No entry point found\. Checked|Error launching application on|Could not build the application for the simulator|Error waiting for a debug connection' "$log" 2>/dev/null; then
      fail "Simulator launch failed. See $log"
    fi
    # Dart VM / key commands mean the process is up. Do not use `simctl spawn ps`:
    # iOS 27 simulator runtimes have no ps, which false-failed a live session.
    if grep -Eq 'Flutter run key commands|A Dart VM Service on|The Dart VM Service is listening' "$log" 2>/dev/null; then
      return 0
    fi
    if [[ -n "${FLUTTER_RUN_PID:-}" ]] && ! kill -0 "$FLUTTER_RUN_PID" 2>/dev/null; then
      fail "flutter run exited before the app was ready. See $log"
    fi
    now="$(date +%s)"
    elapsed=$((now - start))
    if [[ "$elapsed" -ge "$timeout_s" ]]; then
      fail "Timed out after ${timeout_s}s waiting for the simulator Debug session. See $log"
    fi
    sleep 2
  done
}

if [[ "$BUILD_FOR_SIMULATOR" == 'true' ]]; then
  SIMULATOR_ID="$(resolve_simulator_udid "${SIMULATOR_QUERY:-iPhone 14 Pro Max}")"
  printf 'Resolved simulator UDID: %s\n' "$SIMULATOR_ID"

  SIM_LOG_DIR="$REPO_ROOT/build/local_release/simulator"
  mkdir -p "$SIM_LOG_DIR"
  FLUTTER_LOG="$SIM_LOG_DIR/flutter_run.log"
  DEVICE_LOG="$SIM_LOG_DIR/device.log"
  : >"$FLUTTER_LOG"
  : >"$DEVICE_LOG"

  # Flutter Debug on iOS 27 uses a blank executor unless ENABLE_DEBUG_DYLIB=NO.
  # flutter run on simulators does not attach LLDB; --no-resident then tears
  # the session down before you can test. Keep resident Debug + a real binary.
  apply_simulator_xcode_overrides
  printf 'Simulator Xcode identity: PRODUCT_BUNDLE_IDENTIFIER=%s\n' "$BUNDLE_ID"
  printf 'Simulator Debug dylib: ENABLE_DEBUG_DYLIB=NO\n'
  if [[ "$ENABLE_ICLOUD" == 'true' ]]; then
    printf 'Simulator iCloud identity: %s\n' "$TARGET_CONTAINER_ID"
  fi
  printf 'Simulator flutter log: %s\n' "$FLUTTER_LOG"
  printf 'Simulator device log: %s\n' "$DEVICE_LOG"

  open_simulator_runtime_ui
  sleep 2

  xcrun simctl terminate "$SIMULATOR_ID" "$BUNDLE_ID" >/dev/null 2>&1 || true
  xcrun simctl terminate "$SIMULATOR_ID" "$EXPECTED_BUNDLE_ID" >/dev/null 2>&1 || true
  xcrun simctl uninstall "$SIMULATOR_ID" "$EXPECTED_BUNDLE_ID" >/dev/null 2>&1 || true
  xcrun simctl uninstall "$SIMULATOR_ID" "$BUNDLE_ID" >/dev/null 2>&1 || true

  xcrun simctl spawn "$SIMULATOR_ID" log stream --level debug --style compact \
    --predicate 'processImagePath CONTAINS "Runner"' \
    >"$DEVICE_LOG" 2>&1 &
  SIMULATOR_LOGSTREAM_PID=$!

  printf 'Launching Debug session (stays attached; Ctrl-C to stop)...\n'
  flutter run \
    -d "$SIMULATOR_ID" \
    --debug \
    >"$FLUTTER_LOG" 2>&1 &
  FLUTTER_RUN_PID=$!
  tail -n +1 -f "$FLUTTER_LOG" &
  SIMULATOR_TAIL_PID=$!

  wait_for_simulator_debug_session "$FLUTTER_LOG"
  verify_simulator_app_identity
  INSTALLED_CONTAINER="$(xcrun simctl get_app_container "$SIMULATOR_ID" "$BUNDLE_ID" app)"
  verify_simulator_debug_binary "$INSTALLED_CONTAINER"

  printf 'NativeTavern %s is running on simulator %s (%s).\n' \
    "$VERSION" "${SIMULATOR_QUERY:-iPhone 14 Pro Max}" "$SIMULATOR_ID"
  printf 'Bundle ID: %s\n' "$BUNDLE_ID"
  if [[ "$ENABLE_ICLOUD" == 'true' ]]; then
    printf 'iCloud container: %s\n' "$TARGET_CONTAINER_ID"
  fi
  printf 'Leave this process running to keep the app alive. Ctrl-C stops it.\n'
  printf 'Logs: %s\n' "$FLUTTER_LOG"
  printf 'Device logs: %s\n' "$DEVICE_LOG"
  if [[ "$SIMULATOR_UI" == 'devicehub' ]]; then
    printf 'If Device Hub shows error 4002, select this simulator and click Start after CoreDevice has restarted.\n'
  fi

  wait "$FLUTTER_RUN_PID"
  flutter_status=$?
  if [[ "$flutter_status" -ne 0 ]]; then
    fail "flutter run exited $flutter_status. See $FLUTTER_LOG"
  fi
  exit 0
fi

apply_local_bundle_ids

xcodebuild "${COMMON_XCODE_ARGS[@]}" \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE_PATH" \
  -allowProvisioningUpdates \
  clean archive

ARCHIVED_APP="$ARCHIVE_PATH/Products/Applications/Runner.app"
[[ -d "$ARCHIVED_APP" ]] || fail "Xcode archive does not contain Runner.app"
validate_app_bundle "$ARCHIVED_APP"
#assert_critical_ios_files_unchanged

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
#assert_critical_ios_files_unchanged

mkdir -p "$REPO_ROOT/release" "$REPO_ROOT/build/local_release"
LOCAL_RELEASE_IPA="$REPO_ROOT/build/local_release/NativeTavern_v${VERSION}.ipa"
cp -f "$EXPORTED_IPA" "$FINAL_IPA"
cp -f "$EXPORTED_IPA" "$LOCAL_RELEASE_IPA"
shasum -a 256 "$LOCAL_RELEASE_IPA" > "${LOCAL_RELEASE_IPA}.sha256"

printf '%s\n' '=== iOS build complete ==='
printf 'IPA: %s\n' "$FINAL_IPA"
printf 'Local Release IPA: %s\n' "$LOCAL_RELEASE_IPA"
printf 'SHA-256: '
shasum -a 256 "$FINAL_IPA" | awk '{ print $1 }'
