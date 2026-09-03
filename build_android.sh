#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

# `flutter create` rewrites repository metadata and may upgrade pubspec.lock.
# Preserve both so release builds use the dependency set committed by the app.
FLUTTER_STATE_DIR="$(mktemp -d)"
for state_file in .metadata pubspec.lock; do
    if [ -f "$state_file" ]; then
        cp "$state_file" "$FLUTTER_STATE_DIR/$state_file"
    fi
done

restore_flutter_state() {
    for state_file in .metadata pubspec.lock; do
        if [ -f "$FLUTTER_STATE_DIR/$state_file" ]; then
            cp "$FLUTTER_STATE_DIR/$state_file" "$state_file"
        else
            rm -f "$state_file"
        fi
    done
}

cleanup_flutter_state() {
    restore_flutter_state
    rm -rf "$FLUTTER_STATE_DIR"
}

trap cleanup_flutter_state EXIT

fail() {
    echo "ERROR: $*" >&2
    exit 1
}

require_file() {
    [ -f "$1" ] || fail "Required file not found: $1"
}

# Set environment variables for build
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"

echo "Environment configured:"
echo "JAVA_HOME: $JAVA_HOME"
echo "ANDROID_HOME: $ANDROID_HOME"

require_file "pubspec.yaml"
require_file "config/upload-keystore.jks"
require_file "config/key.properties"
require_file "config/backcloud.config"
require_file "tool/build_android_release.dart"

VERSION=$(awk '/^version:/ {print $2; exit}' pubspec.yaml)
[[ "$VERSION" == *+* ]] || fail "pubspec version must include a build number"
FINAL_APK="release/NativeTavern_v${VERSION}_Android.apk"
FINAL_AAB="release/NativeTavern_v${VERSION}_Android.aab"
[[ ! -e "$FINAL_APK" ]] || fail "Release artifact already exists: $FINAL_APK"
[[ ! -e "$FINAL_AAB" ]] || fail "Release artifact already exists: $FINAL_AAB"

echo "Cleaning previous Flutter build output..."
flutter clean

echo "Generating Android platform files..."
flutter create --platforms=android --org com.miaomiaoxworld .
restore_flutter_state

echo "Restoring committed Flutter dependencies..."
flutter pub get --offline

echo "=== Generating Launcher Icons ==="
dart run flutter_launcher_icons

echo "=== Configuring Release Signing ==="
CONFIG_KEYSTORE="config/upload-keystore.jks"
CONFIG_KEY_PROPERTIES="config/key.properties"
KEYSTORE_PATH="android/app/upload-keystore.jks"
KEY_PROPERTIES="android/key.properties"

# Copy keystore and key.properties to android directory
echo "Copying signing files to android directory..."
mkdir -p android/app
cp "$CONFIG_KEYSTORE" "$KEYSTORE_PATH"
cp "$CONFIG_KEY_PROPERTIES" "$KEY_PROPERTIES"
echo "Signing files copied to android directory"

# Configure build.gradle.kts for release signing (Kotlin DSL - new Flutter format)
BUILD_GRADLE_KTS="android/app/build.gradle.kts"
BUILD_GRADLE="android/app/build.gradle"

if [ -f "$BUILD_GRADLE_KTS" ]; then
    echo "Configuring signing for build.gradle.kts (Kotlin DSL)..."

    # Check if signing config already exists
    if ! grep -q "keystoreProperties" "$BUILD_GRADLE_KTS"; then
        echo "Adding signing configuration to build.gradle.kts..."

        # Create a new build.gradle.kts with proper signing config
        cat > "$BUILD_GRADLE_KTS" << 'GRADLE_KTS_CONTENT'
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.miaomiaoxworld.nativetavern"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.miaomiaoxworld.nativetavern"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
GRADLE_KTS_CONTENT
        echo "Signing configuration added to build.gradle.kts"
    else
        echo "Signing configuration already exists in build.gradle.kts"
    fi
fi

# Configure settings.gradle.kts with compatible AGP 8.9.1
SETTINGS_GRADLE_KTS="android/settings.gradle.kts"
if [ -f "$SETTINGS_GRADLE_KTS" ]; then
    perl -i -pe 's/id\("com\.android\.application"\) version "[^"]*"/id("com.android.application") version "8.9.1"/' "$SETTINGS_GRADLE_KTS"
    perl -i -pe 's/id\("org\.jetbrains\.kotlin\.android"\) version "[^"]*"/id("org.jetbrains.kotlin.android") version "2.1.0"/' "$SETTINGS_GRADLE_KTS"
fi

# Configure Gradle wrapper (AGP 8.9.1 uses Gradle 8.11.1)
GRADLE_WRAPPER_PROPERTIES="android/gradle/wrapper/gradle-wrapper.properties"
if [ -f "$GRADLE_WRAPPER_PROPERTIES" ]; then
    sed -i '' 's/gradle-[0-9.]*-[a-z]*.zip/gradle-8.11.1-all.zip/' "$GRADLE_WRAPPER_PROPERTIES" 2>/dev/null || \
    sed -i 's/gradle-[0-9.]*-[a-z]*.zip/gradle-8.11.1-all.zip/' "$GRADLE_WRAPPER_PROPERTIES" 2>/dev/null || true
fi
elif [ -f "$BUILD_GRADLE" ]; then
    echo "Configuring signing for build.gradle (Groovy DSL)..."
    # Legacy Groovy DSL support
    if ! grep -q "def keystoreProperties" "$BUILD_GRADLE"; then
        echo "Adding signing configuration to build.gradle..."

        # Add keystore properties loading at the top (after plugins block)
        perl -i -pe 's|(plugins \{[^}]*\})|$1\n\ndef keystoreProperties = new Properties()\ndef keystorePropertiesFile = rootProject.file('\''key.properties'\'')\nif (keystorePropertiesFile.exists()) {\n    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))\n}|' "$BUILD_GRADLE"

        # Add signingConfigs block before buildTypes
        perl -i -pe 's|(buildTypes \{)|signingConfigs {\n        release {\n            keyAlias keystoreProperties['\''keyAlias'\'']\n            keyPassword keystoreProperties['\''keyPassword'\'']\n            storeFile keystoreProperties['\''storeFile'\''] ? file(keystoreProperties['\''storeFile'\'']) : null\n            storePassword keystoreProperties['\''storePassword'\'']\n        }\n    }\n\n    $1|' "$BUILD_GRADLE"

        # Update release buildType to use signingConfig
        perl -i -pe 's|(release \{[^}]*signingConfig) signingConfigs\.debug|$1 signingConfigs.release|' "$BUILD_GRADLE"

        echo "Signing configuration added to build.gradle"
    else
        echo "Signing configuration already exists in build.gradle"
    fi
else
    echo "Warning: Neither build.gradle.kts nor build.gradle found"
fi

echo "Configuring Android permissions..."
ANDROID_MANIFEST="android/app/src/main/AndroidManifest.xml"

if [ -f "$ANDROID_MANIFEST" ]; then
    # Add common permissions (without MANAGE_EXTERNAL_STORAGE to comply with Google Play policy)
    # Storage permissions are limited to Android 9 (API 28) and below
    # Android 10+ uses Storage Access Framework (SAF) via file_picker which doesn't require these permissions

    # Network permissions (no SDK version limit)
    NETWORK_PERMISSIONS=(
        "android.permission.INTERNET"
        "android.permission.ACCESS_NETWORK_STATE"
    )

    for PERM in "${NETWORK_PERMISSIONS[@]}"; do
        if ! grep -q "$PERM" "$ANDROID_MANIFEST"; then
            perl -i -pe "s|<manifest[^>]*>|$&\n    <uses-permission android:name=\"$PERM\"/>|" "$ANDROID_MANIFEST"
            echo "Added $PERM to AndroidManifest.xml"
        fi
    done

    # Microphone permissions (voice input / STT)
    MIC_PERMISSIONS=(
        "android.permission.RECORD_AUDIO"
        "android.permission.BLUETOOTH_CONNECT"
    )

    for PERM in "${MIC_PERMISSIONS[@]}"; do
        if ! grep -q "$PERM" "$ANDROID_MANIFEST"; then
            perl -i -pe "s|<manifest[^>]*>|$&\n    <uses-permission android:name=\"$PERM\"/>|" "$ANDROID_MANIFEST"
            echo "Added $PERM to AndroidManifest.xml"
        fi
    done

    # TTS engine and speech recognition service discovery (Android 11+)
    if ! grep -q "android.speech.RecognitionService" "$ANDROID_MANIFEST"; then
        perl -i -pe 's|</manifest>|    <queries>\n        <intent>\n            <action android:name="android.intent.action.TTS_SERVICE"/>\n        </intent>\n        <intent>\n            <action android:name="android.speech.RecognitionService"/>\n        </intent>\n    </queries>\n</manifest>|' "$ANDROID_MANIFEST"
        echo "Added TTS/speech recognition queries to AndroidManifest.xml"
    fi

    # Storage permissions (only for Android 9 and below)
    STORAGE_PERMISSIONS=(
        "android.permission.READ_EXTERNAL_STORAGE"
        "android.permission.WRITE_EXTERNAL_STORAGE"
    )

    for PERM in "${STORAGE_PERMISSIONS[@]}"; do
        if ! grep -q "$PERM" "$ANDROID_MANIFEST"; then
            perl -i -pe "s|<manifest[^>]*>|$&\n    <uses-permission android:name=\"$PERM\" android:maxSdkVersion=\"28\"/>|" "$ANDROID_MANIFEST"
            echo "Added $PERM (maxSdkVersion=28) to AndroidManifest.xml"
        fi
    done

    # Add usesCleartextTraffic if not present
    if ! grep -q "android:usesCleartextTraffic" "$ANDROID_MANIFEST"; then
        perl -i -pe 's|<application|<application android:usesCleartextTraffic="true"|' "$ANDROID_MANIFEST"
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

    # Add intent-filter for .jsonl, .ntb, .ntm and chat files if not present
    if ! grep -q "android:pathPattern=\".*\\.jsonl\"" "$ANDROID_MANIFEST"; then
        perl -i -pe 's|(</activity>)|            <intent-filter>\n                <action android:name="android.intent.action.VIEW" />\n                <category android:name="android.intent.category.DEFAULT" />\n                <category android:name="android.intent.category.BROWSABLE" />\n                <data android:scheme="file" />\n                <data android:scheme="content" />\n                <data android:mimeType="*/*" />\n                <data android:pathPattern=".*\\\\.jsonl" />\n                <data android:pathPattern=".*\\\\.ntb" />\n                <data android:pathPattern=".*\\\\.ntm" />\n                <data android:host="*" />\n            </intent-filter>\n            <intent-filter>\n                <action android:name="android.intent.action.SEND" />\n                <category android:name="android.intent.category.DEFAULT" />\n                <data android:mimeType="*/*" />\n            </intent-filter>\n$1|' "$ANDROID_MANIFEST"
        echo "Added JSONL and NTB intent filters to AndroidManifest.xml"
    fi
else
    echo "Warning: AndroidManifest.xml not found at $ANDROID_MANIFEST"
fi

echo "Configuring Google Sign-In for Android..."
BACKCLOUD_CONFIG="config/backcloud.config"
STRINGS_XML="android/app/src/main/res/values/strings.xml"

if [ -f "$BACKCLOUD_CONFIG" ]; then
    # Android server auth requires the Web OAuth client, not the iOS client.
    WEB_CLIENT_ID=$(grep '^desk_client_id=' "$BACKCLOUD_CONFIG" | cut -d'=' -f2)
    if [ -n "$WEB_CLIENT_ID" ]; then
        # Create or update strings.xml with web client ID
        mkdir -p "$(dirname "$STRINGS_XML")"
        cat > "$STRINGS_XML" << EOF
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Native Tavern</string>
    <string name="default_web_client_id">$WEB_CLIENT_ID</string>
</resources>
EOF
        echo "Added Google Sign-In client ID to strings.xml"
    else
        echo "Warning: desk_client_id not found in $BACKCLOUD_CONFIG"
    fi
else
    echo "Warning: $BACKCLOUD_CONFIG not found, skipping Google Sign-In configuration"
fi

echo "=== Adding Region Detection and File Open Code to MainActivity ==="
# Create the correct package directory and MainActivity.kt with region and file open code
MAIN_ACTIVITY_DIR="android/app/src/main/kotlin/com/miaomiaoxworld/nativetavern"
MAIN_ACTIVITY_PATH="$MAIN_ACTIVITY_DIR/MainActivity.kt"
mkdir -p "$MAIN_ACTIVITY_DIR"
if true; then
    cat > "$MAIN_ACTIVITY_PATH" << 'MAIN_ACTIVITY_CONTENT'
package com.miaomiaoxworld.nativetavern

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.Locale

class MainActivity : FlutterActivity() {
    private val REGION_CHANNEL = "com.nativetavern/region"
    private val FILE_OPEN_CHANNEL = "com.nativetavern/file_open"
    private var fileChannel: MethodChannel? = null
    private var initialFilePath: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, REGION_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isChinaRegion" -> {
                    result.success(isChinaRegion())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        fileChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FILE_OPEN_CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialFile" -> {
                        result.success(initialFilePath)
                        initialFilePath = null
                    }
                    else -> result.notImplemented()
                }
            }
        }

        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        if (intent == null) return
        val action = intent.action
        val uri: Uri? = if (Intent.ACTION_VIEW == action) {
            intent.data
        } else if (Intent.ACTION_SEND == action) {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(Intent.EXTRA_STREAM)
        } else {
            null
        }

        if (uri != null) {
            val path = copyUriToCache(uri)
            if (path != null) {
                if (fileChannel != null) {
                    fileChannel?.invokeMethod("onFileOpened", path)
                } else {
                    initialFilePath = path
                }
            }
        }
    }

    private fun copyUriToCache(uri: Uri): String? {
        return try {
            val contentResolver = applicationContext.contentResolver
            var extension = ".jsonl"
            val uriStr = uri.toString().lowercase(Locale.ROOT)
            if (uriStr.endsWith(".ntb")) {
                extension = ".ntb"
            } else if (uriStr.endsWith(".ntm")) {
                extension = ".ntm"
            } else {
                val cursor = contentResolver.query(uri, null, null, null, null)
                cursor?.use {
                    if (it.moveToFirst()) {
                        val nameIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                        if (nameIndex >= 0) {
                            val displayName = it.getString(nameIndex)?.lowercase(Locale.ROOT)
                            if (displayName?.endsWith(".ntb") == true) extension = ".ntb"
                            else if (displayName?.endsWith(".ntm") == true) extension = ".ntm"
                        }
                    }
                }
            }
            val fileName = "imported_${System.currentTimeMillis()}$extension"
            val tempFile = File(cacheDir, fileName)
            contentResolver.openInputStream(uri)?.use { input ->
                FileOutputStream(tempFile).use { output ->
                    input.copyTo(output)
                }
            }
            tempFile.absolutePath
        } catch (e: Exception) {
            null
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
    echo "Created MainActivity.kt with region detection and file open code"
fi

echo "Android configuration complete!"

# Create release directory
mkdir -p release

echo "Building Android APK (for direct distribution)..."
dart run tool/build_android_release.dart \
    .flutter-plugins-dependencies \
    android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java
flutter build apk --release --no-pub --android-skip-build-dependency-validation

# Rename/Move APK
echo "Copying APK to release directory..."
cp build/app/outputs/flutter-apk/app-release.apk "$FINAL_APK"
echo "APK saved to $FINAL_APK"

echo ""
echo "Building Android App Bundle (AAB) for Google Play..."
dart run tool/build_android_release.dart \
    .flutter-plugins-dependencies \
    android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java
flutter build appbundle --release --no-pub --android-skip-build-dependency-validation

# Rename/Move AAB
echo "Copying AAB to release directory..."
cp build/app/outputs/bundle/release/app-release.aab "$FINAL_AAB"
echo "AAB saved to $FINAL_AAB"

echo ""
echo "=============================================="
echo "Build Complete!"
echo "=============================================="
echo "APK (直接分发): $FINAL_APK"
echo "AAB (Google Play): $FINAL_AAB"
echo "APK SHA-256: $(shasum -a 256 "$FINAL_APK" | awk '{print $1}')"
echo "AAB SHA-256: $(shasum -a 256 "$FINAL_AAB" | awk '{print $1}')"
echo ""
echo "Note: 上传到 Google Play 请使用 .aab 文件"
echo "=============================================="
