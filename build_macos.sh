#!/bin/bash

# Exit on error
set -e

echo "Generating macOS platform files..."
flutter create --platforms=macos .

echo "Generating App Icons..."
flutter pub run flutter_launcher_icons

echo "Configuring macOS entitlements..."
MACOS_ENTITLEMENTS_RELEASE="macos/Runner/Release.entitlements"
MACOS_ENTITLEMENTS_DEBUG="macos/Runner/DebugProfile.entitlements"

configure_entitlements() {
    local FILE=$1
    if [ -f "$FILE" ]; then
        if ! grep -q "com.apple.security.network.client" "$FILE"; then
            # Insert before the closing </dict>
            perl -i -0777 -pe 's|</dict>|	<key>com.apple.security.network.client</key>\n	<true/>\n</dict>|' "$FILE"
            echo "Added network client entitlement to $FILE"
        fi
    else
        echo "Warning: Entitlements file not found at $FILE"
    fi
}

configure_entitlements "$MACOS_ENTITLEMENTS_RELEASE"
configure_entitlements "$MACOS_ENTITLEMENTS_DEBUG"

echo "macOS configuration complete!"

echo "Building macOS App..."
flutter build macos --release

# Extract version from pubspec.yaml
VERSION=$(grep 'version:' pubspec.yaml | head -n 1 | awk '{print $2}')

# Create release directory
mkdir -p release

# Compress macOS App
echo "Compressing macOS App..."
cd build/macos/Build/Products/Release
zip -r "../../../../../release/NativeTavern_v${VERSION}_macOS.zip" NativeTavern.app
cd -

echo "Build artifact saved to release/NativeTavern_v${VERSION}_macOS.zip"