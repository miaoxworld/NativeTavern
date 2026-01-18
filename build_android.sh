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
flutter create --platforms=android --org com.miaomiaoxworld .

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

    # Set app name to "Native Tavern"
    perl -i -pe 's|android:label="[^"]*"|android:label="Native Tavern"|' "$ANDROID_MANIFEST"
    echo "Set app name to Native Tavern"

    # Add portrait orientation restriction
    if ! grep -q "android:screenOrientation" "$ANDROID_MANIFEST"; then
        perl -i -pe 's|(android:name="\.MainActivity")|$1\n            android:screenOrientation="portrait"|' "$ANDROID_MANIFEST"
        echo "Added portrait orientation restriction"
    fi
else
    echo "Warning: AndroidManifest.xml not found at $ANDROID_MANIFEST"
fi

echo "Configuring Google Sign-In for Android..."
BACKCLOUD_CONFIG="assets/backcloud.config"
STRINGS_XML="android/app/src/main/res/values/strings.xml"

if [ -f "$BACKCLOUD_CONFIG" ]; then
    # Read desktop client ID from config (used for Android as well)
    DESKTOP_CLIENT_ID=$(grep 'ios_client_id=' "$BACKCLOUD_CONFIG" | cut -d'=' -f2)
    if [ -n "$DESKTOP_CLIENT_ID" ]; then
        # Create or update strings.xml with web client ID
        mkdir -p "$(dirname "$STRINGS_XML")"
        cat > "$STRINGS_XML" << EOF
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Native Tavern</string>
    <string name="default_web_client_id">$DESKTOP_CLIENT_ID</string>
</resources>
EOF
        echo "Added Google Sign-In client ID to strings.xml"
    else
        echo "Warning: ios_client_id not found in $BACKCLOUD_CONFIG"
    fi
else
    echo "Warning: $BACKCLOUD_CONFIG not found, skipping Google Sign-In configuration"
fi

echo "=== Adding Region Detection Code to MainActivity ==="
# Update MainActivity.kt with region detection code
MAIN_ACTIVITY_PATH="android/app/src/main/kotlin/com/miaomiaoxworld/nativetavern/MainActivity.kt"
if [ -f "$MAIN_ACTIVITY_PATH" ]; then
    cat > "$MAIN_ACTIVITY_PATH" << 'MAIN_ACTIVITY_CONTENT'
package com.miaomiaoxworld.nativetavern

import android.content.Context
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.nativetavern/region"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isChinaRegion" -> {
                    result.success(isChinaRegion())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun isChinaRegion(): Boolean {
        // Check SIM country code
        try {
            val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
            val simCountry = telephonyManager?.simCountryIso?.uppercase(Locale.ROOT)
            if (simCountry == "CN") {
                return true
            }
            
            // Check network country code
            val networkCountry = telephonyManager?.networkCountryIso?.uppercase(Locale.ROOT)
            if (networkCountry == "CN") {
                return true
            }
        } catch (e: Exception) {
            // Ignore errors
        }
        
        // Check system locale
        val locale = Locale.getDefault()
        if (locale.country == "CN" && locale.language == "zh") {
            return true
        }
        
        return false
    }
}
MAIN_ACTIVITY_CONTENT
    echo "Updated MainActivity.kt with region detection code"
else
    echo "Warning: MainActivity.kt not found at $MAIN_ACTIVITY_PATH"
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