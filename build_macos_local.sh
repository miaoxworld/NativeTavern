#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

# Load environment variables from .env if present
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

BUILD_MODE="${BUILD_MODE:-release}"
CHECK_ONLY="${CHECK_ONLY:-false}"
SKIP_CLEAN="${SKIP_CLEAN:-${SKIP_FLUTTER_CLEAN:-false}}"
BUNDLE_ID="${BUNDLE_ID:-${APPLE_BUNDLE_ID:-${MACOS_BUNDLE_ID:-com.miaomiaoxworld.nativetavern}}}"
APP_GROUP_ID="${APP_GROUP_ID:-group.${BUNDLE_ID}}"
EXPECTED_BUNDLE_ID="com.miaomiaoxworld.nativetavern"
EXPECTED_WIDGET_BUNDLE_ID="${EXPECTED_BUNDLE_ID}.HomeWidgets"
WIDGET_BUNDLE_ID="${BUNDLE_ID}.HomeWidgets"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --check-only)
            CHECK_ONLY="true"
            shift
            ;;
        --debug)
            BUILD_MODE="debug"
            shift
            ;;
        --release)
            BUILD_MODE="release"
            shift
            ;;
        --skip-clean)
            SKIP_CLEAN="true"
            shift
            ;;
        --bundle-id)
            BUNDLE_ID="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: ./build_macos_local.sh [options]"
            echo "Options:"
            echo "  --check-only         Validate configuration without building"
            echo "  --debug              Build in debug mode"
            echo "  --release            Build in release mode (default)"
            echo "  --skip-clean         Skip flutter clean for faster rebuilds"
            echo "  --bundle-id <id>     Override macOS bundle identifier"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "=== NativeTavern Local macOS Build ==="
echo "Build Mode: $BUILD_MODE"
echo "Bundle ID: $BUNDLE_ID"
echo "App Group: $APP_GROUP_ID"
echo "Skip Clean: $SKIP_CLEAN"
echo "Check Only: $CHECK_ONLY"

# Check required commands
for cmd in git flutter ditto shasum; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: Required command not found: $cmd" >&2
        exit 1
    fi
done

[ -f "pubspec.yaml" ] || { echo "ERROR: pubspec.yaml not found"; exit 1; }
VERSION="$(awk '/^version:/ { print $2; exit }' pubspec.yaml)"
[[ "$VERSION" == *+* ]] || { echo "ERROR: pubspec version must include a build number (e.g. 0.1.17+41)"; exit 1; }
BUILD_NAME="${VERSION%%+*}"
BUILD_NUMBER="${VERSION##*+}"

echo "App Version: $VERSION (Name: $BUILD_NAME, Number: $BUILD_NUMBER)"

# Ensure macOS platform files exist
if [ ! -d "macos" ]; then
    echo "Creating macOS platform support..."
    flutter create --platforms=macos --org com.miaomiaoxworld .
fi

if [ "$CHECK_ONLY" == "true" ]; then
    echo "Check passed successfully. macOS configuration is valid."
    exit 0
fi

if [ "$SKIP_CLEAN" == "true" ]; then
    echo "Skipping flutter clean (SKIP_CLEAN=true)."
else
    echo "Cleaning previous Flutter build..."
    flutter clean
fi

echo "Resolving dependencies..."
flutter pub get

if [[ -n "$FLUTTER_ENV_FLAGS" ]]; then
  flutter build ios --config-only $FLUTTER_ENV_FLAGS
fi

echo "Generating launcher icons..."
dart run flutter_launcher_icons

MACOS_TEMP="$(mktemp -d "${TMPDIR:-/tmp}/nt-macos-local.XXXXXX")"
restore_macos_identity() {
  for pair in \
    "macos/Runner/DebugProfile.entitlements" \
    "macos/Runner/Release.entitlements" \
    "macos/HomeWidgets/HomeWidgets.entitlements" \
    "macos/Runner/Info.plist" \
    "macos/HomeWidgets/Info.plist" \
    "macos/Runner.xcodeproj/project.pbxproj"
  do
    local bak="$MACOS_TEMP/$(echo "$pair" | tr '/' '_')"
    if [[ -f "$bak" ]]; then
      cp -f "$bak" "$pair"
    fi
  done
  rm -rf -- "$MACOS_TEMP"
}
trap restore_macos_identity EXIT INT TERM

for pair in \
  macos/Runner/DebugProfile.entitlements \
  macos/Runner/Release.entitlements \
  macos/HomeWidgets/HomeWidgets.entitlements \
  macos/Runner/Info.plist \
  macos/HomeWidgets/Info.plist \
  macos/Runner.xcodeproj/project.pbxproj
do
  [[ -f "$pair" ]] || continue
  cp -f "$pair" "$MACOS_TEMP/$(echo "$pair" | tr '/' '_')"
done

for entitlements in \
  macos/Runner/DebugProfile.entitlements \
  macos/Runner/Release.entitlements \
  macos/HomeWidgets/HomeWidgets.entitlements
do
  [[ -f "$entitlements" ]] || continue
  sed -i '' "s/group\.com\.miaomiaoxworld\.nativetavern/${APP_GROUP_ID}/g" "$entitlements"
done
for plist in macos/Runner/Info.plist macos/HomeWidgets/Info.plist; do
  [[ -f "$plist" ]] || continue
  /usr/libexec/PlistBuddy -c "Delete :NTAppGroupId" "$plist" >/dev/null 2>&1 || true
  /usr/libexec/PlistBuddy -c "Add :NTAppGroupId string $APP_GROUP_ID" "$plist"
done
if [[ "$BUNDLE_ID" != "$EXPECTED_BUNDLE_ID" ]]; then
  PBXPROJ="macos/Runner.xcodeproj/project.pbxproj"
  if grep -Fq "PRODUCT_BUNDLE_IDENTIFIER = ${EXPECTED_WIDGET_BUNDLE_ID};" "$PBXPROJ"; then
    sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = ${EXPECTED_WIDGET_BUNDLE_ID};/PRODUCT_BUNDLE_IDENTIFIER = ${WIDGET_BUNDLE_ID};/g" "$PBXPROJ"
  fi
  sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = ${EXPECTED_BUNDLE_ID};/PRODUCT_BUNDLE_IDENTIFIER = ${BUNDLE_ID};/g" "$PBXPROJ"
fi

echo "Building macOS application ($BUILD_MODE)..."
flutter build macos $FLUTTER_ENV_FLAGS "--$BUILD_MODE" \
    --build-name="$BUILD_NAME" \
    --build-number="$BUILD_NUMBER"

# Locate built .app bundle
BUILD_DIR_NAME="$(tr '[:lower:]' '[:upper:]' <<< "${BUILD_MODE:0:1}")${BUILD_MODE:1}"
BUILD_APP_PATH="$(find "build/macos/Build/Products/$BUILD_DIR_NAME" -maxdepth 1 -type d -name '*.app' -print -quit 2>/dev/null || true)"

if [ -z "$BUILD_APP_PATH" ] || [ ! -d "$BUILD_APP_PATH" ]; then
    BUILD_APP_PATH="$(find build/macos/Build/Products -maxdepth 2 -type d -name '*.app' -print -quit 2>/dev/null || true)"
fi

[ -n "$BUILD_APP_PATH" ] && [ -d "$BUILD_APP_PATH" ] || { echo "ERROR: macOS build did not produce an .app bundle"; exit 1; }

mkdir -p build/local_release
FINAL_ZIP="build/local_release/NativeTavern_v${VERSION}_macOS_${BUILD_MODE}.zip"
rm -f "$FINAL_ZIP"

echo "Packaging application bundle into $FINAL_ZIP..."
ditto -c -k --sequesterRsrc --keepParent "$BUILD_APP_PATH" "$FINAL_ZIP"

[ -f "$FINAL_ZIP" ] || { echo "ERROR: Failed to produce release archive: $FINAL_ZIP"; exit 1; }

echo "=== Local macOS Build Finished Successfully ==="
echo "Application bundle: $BUILD_APP_PATH"
echo "Archive: $FINAL_ZIP"
SHA="$(shasum -a 256 "$FINAL_ZIP" | awk '{ print $1 }')"
echo "SHA-256: $SHA"
printf '%s  %s\n' "$SHA" "$(basename "$FINAL_ZIP")" > "${FINAL_ZIP}.sha256"
