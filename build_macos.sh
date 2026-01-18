#!/bin/bash

# Exit on error
set -e

# Configuration
TEAM_ID="${TEAM_ID:-Q2AMTVPJ86}"  # Set your Apple Team ID here or via environment variable
BUNDLE_ID="com.miaomiaoxworld.nativetavern"
ICLOUD_CONTAINER_ID="iCloud.com.miaomiaoxworld.nativetavern"

echo "=== Cleaning everything for fresh build ==="
flutter clean

echo "=== Removing macos folder to regenerate fresh ==="
rm -rf macos

echo "=== Getting Flutter packages ==="
flutter pub get

echo "=== Generating macOS platform files ==="
flutter create --platforms=macos --org com.miaomiaoxworld .

echo "=== Fixing bundle identifier to match iOS ==="
# Update AppInfo.xcconfig
APPINFO_CONFIG="macos/Runner/Configs/AppInfo.xcconfig"
if [ -f "$APPINFO_CONFIG" ]; then
    sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = .*/PRODUCT_BUNDLE_IDENTIFIER = ${BUNDLE_ID}/" "$APPINFO_CONFIG"
    sed -i '' "s/PRODUCT_COPYRIGHT = .*/PRODUCT_COPYRIGHT = Copyright © 2026 miaomiaoxworld. All rights reserved./" "$APPINFO_CONFIG"
    echo "Bundle ID fixed to: $BUNDLE_ID"
fi

# Also fix in project.pbxproj for RunnerTests
PBXPROJ_PATH="macos/Runner.xcodeproj/project.pbxproj"
if [ -f "$PBXPROJ_PATH" ]; then
    sed -i '' "s/com\.example\.nativeTavern/${BUNDLE_ID}/g" "$PBXPROJ_PATH"
    echo "Fixed bundle ID in project.pbxproj"
fi

echo "Generating App Icons..."
flutter pub run flutter_launcher_icons

echo "=== Configuring macOS entitlements with iCloud ==="
MACOS_ENTITLEMENTS_RELEASE="macos/Runner/Release.entitlements"
MACOS_ENTITLEMENTS_DEBUG="macos/Runner/DebugProfile.entitlements"

# Create Debug/Profile entitlements with iCloud support
configure_debug_entitlements() {
    local FILE=$1
    cat > "$FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<true/>
	<key>com.apple.security.cs.allow-jit</key>
	<true/>
	<key>com.apple.security.network.server</key>
	<true/>
	<key>com.apple.security.network.client</key>
	<true/>
	<key>com.apple.security.files.user-selected.read-write</key>
	<true/>
	<key>com.apple.security.files.downloads.read-write</key>
	<true/>
	<key>com.apple.developer.icloud-container-identifiers</key>
	<array>
		<string>${ICLOUD_CONTAINER_ID}</string>
	</array>
	<key>com.apple.developer.icloud-services</key>
	<array>
		<string>CloudDocuments</string>
	</array>
	<key>com.apple.developer.ubiquity-container-identifiers</key>
	<array>
		<string>${ICLOUD_CONTAINER_ID}</string>
	</array>
</dict>
</plist>
EOF
    echo "Configured iCloud entitlements: $FILE"
}

# Create Release entitlements with iCloud support
configure_release_entitlements() {
    local FILE=$1
    cat > "$FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<true/>
	<key>com.apple.security.network.client</key>
	<true/>
	<key>com.apple.security.files.user-selected.read-write</key>
	<true/>
	<key>com.apple.security.files.downloads.read-write</key>
	<true/>
	<key>com.apple.developer.icloud-container-identifiers</key>
	<array>
		<string>${ICLOUD_CONTAINER_ID}</string>
	</array>
	<key>com.apple.developer.icloud-services</key>
	<array>
		<string>CloudDocuments</string>
	</array>
	<key>com.apple.developer.ubiquity-container-identifiers</key>
	<array>
		<string>${ICLOUD_CONTAINER_ID}</string>
	</array>
</dict>
</plist>
EOF
    echo "Configured iCloud entitlements: $FILE"
}

configure_debug_entitlements "$MACOS_ENTITLEMENTS_DEBUG"
configure_release_entitlements "$MACOS_ENTITLEMENTS_RELEASE"

echo "=== Configuring Xcode project for automatic signing ==="
if [ -f "$PBXPROJ_PATH" ]; then
    # Enable automatic code signing
    sed -i '' 's/CODE_SIGN_STYLE = Manual;/CODE_SIGN_STYLE = Automatic;/g' "$PBXPROJ_PATH"
    
    # Set development team if provided
    if [ -n "$TEAM_ID" ]; then
        # Add DEVELOPMENT_TEAM if not present, or update existing
        if grep -q 'DEVELOPMENT_TEAM = ""' "$PBXPROJ_PATH" || grep -q 'DEVELOPMENT_TEAM = ;' "$PBXPROJ_PATH"; then
            sed -i '' "s/DEVELOPMENT_TEAM = \"\";/DEVELOPMENT_TEAM = \"$TEAM_ID\";/g" "$PBXPROJ_PATH"
            sed -i '' "s/DEVELOPMENT_TEAM = ;/DEVELOPMENT_TEAM = \"$TEAM_ID\";/g" "$PBXPROJ_PATH"
        fi
        echo "Set development team to: $TEAM_ID"
    fi
    
    echo "Xcode project configured successfully"
fi

echo "=== Configuring Google Sign-In for macOS ==="
MACOS_INFO_PLIST="macos/Runner/Info.plist"
BACKCLOUD_CONFIG="assets/backcloud.config"

if [ -f "$BACKCLOUD_CONFIG" ] && [ -f "$MACOS_INFO_PLIST" ]; then
    # Read desktop client ID from config
    DESKTOP_CLIENT_ID=$(grep 'ios_client_id=' "$BACKCLOUD_CONFIG" | cut -d'=' -f2)
    if [ -n "$DESKTOP_CLIENT_ID" ]; then
        # Extract reversed client ID for URL scheme
        # Format: 1077961567755-xxx.apps.googleusercontent.com -> com.googleusercontent.apps.1077961567755-xxx
        REVERSED_CLIENT_ID=$(echo "$DESKTOP_CLIENT_ID" | sed 's/\.apps\.googleusercontent\.com$//' | xargs -I {} echo "com.googleusercontent.apps.{}")
        
        # Add CFBundleURLTypes for Google Sign-In if not present
        if ! grep -q "CFBundleURLTypes" "$MACOS_INFO_PLIST"; then
            sed -i '' '/<\/dict>/i\
	<key>CFBundleURLTypes</key>\
	<array>\
		<dict>\
			<key>CFBundleTypeRole</key>\
			<string>Editor</string>\
			<key>CFBundleURLSchemes</key>\
			<array>\
				<string>'"$REVERSED_CLIENT_ID"'</string>\
			</array>\
		</dict>\
	</array>
' "$MACOS_INFO_PLIST"
            echo "Added Google Sign-In URL scheme: $REVERSED_CLIENT_ID"
        else
            echo "CFBundleURLTypes already configured in Info.plist"
        fi
    else
        echo "Warning: ios_client_id not found in $BACKCLOUD_CONFIG"
    fi
else
    echo "Warning: $BACKCLOUD_CONFIG or $MACOS_INFO_PLIST not found, skipping Google Sign-In configuration"
fi

echo "macOS configuration complete!"

echo "=== Building macOS App ==="
flutter build macos --release

# Extract version from pubspec.yaml
VERSION=$(grep 'version:' pubspec.yaml | head -n 1 | awk '{print $2}')

# Create release directory
mkdir -p release

# Compress macOS App
echo "Compressing macOS App..."
cd build/macos/Build/Products/Release
zip -r "../../../../../release/NativeTavern_v${VERSION}_macOS.zip" native_tavern.app
cd -

echo ""
echo "✓ Build completed successfully!"
echo ""
echo "=== Build Artifacts ==="
echo "  App: release/NativeTavern_v${VERSION}_macOS.zip"
echo ""
if [ -n "$TEAM_ID" ]; then
    echo "✓ Team ID: $TEAM_ID"
else
    echo "⚠ Set TEAM_ID environment variable for automatic signing:"
    echo "  export TEAM_ID=\"YOUR_TEAM_ID\" && ./build_macos.sh"
fi
echo ""
echo "=== iCloud Configuration ==="
echo "✓ Bundle ID: $BUNDLE_ID"
echo "✓ iCloud Container: $ICLOUD_CONTAINER_ID"
echo ""
echo "⚠ IMPORTANT: Before iCloud will work, you must configure in Xcode:"
echo "  1. Open macos/Runner.xcworkspace in Xcode"
echo "  2. Select Runner target → Signing & Capabilities"
echo "  3. Click + Capability → Add iCloud"
echo "  4. Check 'CloudKit' and add container: $ICLOUD_CONTAINER_ID"
echo ""
echo "  Or in Apple Developer Portal:"
echo "  1. Create iCloud Container: $ICLOUD_CONTAINER_ID"
echo "  2. Add iCloud capability to App ID: $BUNDLE_ID"