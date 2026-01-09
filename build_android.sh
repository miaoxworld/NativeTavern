#!/bin/bash

# Exit on error
set -e

# Set environment variables for build
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"

echo "Environment configured:"
echo "JAVA_HOME: $JAVA_HOME"
echo "ANDROID_HOME: $ANDROID_HOME"

echo "Generating Android platform files..."
flutter create --platforms=android .

echo "Generating App Icons..."
flutter pub run flutter_launcher_icons

echo "Configuring Android permissions..."
ANDROID_MANIFEST="android/app/src/main/AndroidManifest.xml"

if [ -f "$ANDROID_MANIFEST" ]; then
    # Add common permissions
    PERMISSIONS=(
        "android.permission.INTERNET"
        "android.permission.ACCESS_NETWORK_STATE"
        "android.permission.READ_EXTERNAL_STORAGE"
        "android.permission.WRITE_EXTERNAL_STORAGE"
        "android.permission.MANAGE_EXTERNAL_STORAGE"
    )

    for PERM in "${PERMISSIONS[@]}"; do
        if ! grep -q "$PERM" "$ANDROID_MANIFEST"; then
            perl -i -pe "s|<manifest[^>]*>|$&\n    <uses-permission android:name=\"$PERM\"/>|" "$ANDROID_MANIFEST"
            echo "Added $PERM to AndroidManifest.xml"
        fi
    done

    # Add usesCleartextTraffic if not present
    if ! grep -q "android:usesCleartextTraffic" "$ANDROID_MANIFEST"; then
        perl -i -pe 's|<application|& android:usesCleartextTraffic="true"|' "$ANDROID_MANIFEST"
        echo "Added usesCleartextTraffic to AndroidManifest.xml"
    fi
else
    echo "Warning: AndroidManifest.xml not found at $ANDROID_MANIFEST"
fi

echo "Android configuration complete!"

echo "Building Android APK..."
flutter build apk --release

# Extract version from pubspec.yaml
VERSION=$(grep 'version:' pubspec.yaml | head -n 1 | awk '{print $2}')

# Create release directory
mkdir -p release

# Rename/Move APK
echo "Copying APK to release directory..."
cp build/app/outputs/flutter-apk/app-release.apk "release/NativeTavern_v${VERSION}_Android.apk"

echo "Build artifact saved to release/NativeTavern_v${VERSION}_Android.apk"