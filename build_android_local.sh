#!/bin/bash

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
BUILD_TARGET="${BUILD_TARGET:-apk}" # apk, aab, all
CHECK_ONLY="${CHECK_ONLY:-false}"
INSTALL_TO_DEVICE="${INSTALL_TO_DEVICE:-false}"
DEVICE_ID="${DEVICE_ID:-}"
SKIP_CLEAN="${SKIP_CLEAN:-${SKIP_FLUTTER_CLEAN:-false}}"
SKIP_LAUNCHER_ICONS="${SKIP_LAUNCHER_ICONS:-false}"

# Google Play / Android configuration
PACKAGE_NAME="${PACKAGE_NAME:-${GOOGLE_PLAY_PACKAGE_NAME:-com.miaomiaoxworld.nativetavern}}"
TRACK_NAME="${GOOGLE_PLAY_TRACK:-${TRACK:-}}"

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
        --apk)
            BUILD_TARGET="apk"
            shift
            ;;
        --aab)
            BUILD_TARGET="aab"
            shift
            ;;
        --all)
            BUILD_TARGET="all"
            shift
            ;;
        --package)
            PACKAGE_NAME="$2"
            shift 2
            ;;
        --track)
            TRACK_NAME="$2"
            shift 2
            ;;
        --skip-clean)
            SKIP_CLEAN="true"
            shift
            ;;
        -i|--install)
            INSTALL_TO_DEVICE="true"
            shift
            ;;
        -d|--device)
            DEVICE_ID="$2"
            INSTALL_TO_DEVICE="true"
            shift 2
            ;;
        -h|--help)
            echo "Usage: ./build_android_local.sh [options]"
            echo "Options:"
            echo "  --check-only    Validate configuration without building"
            echo "  --debug         Build in debug mode"
            echo "  --release       Build in release mode (default)"
            echo "  --apk           Build APK only (default)"
            echo "  --aab           Build AAB only"
            echo "  --all           Build both APK and AAB"
            echo "  --package <id>  Override application package ID (default: from GOOGLE_PLAY_PACKAGE_NAME)"
            echo "  --track <name>  Override track name (default: from GOOGLE_PLAY_TRACK)"
            echo "  --skip-clean    Skip flutter clean for faster rebuilds"
            echo "  -i, --install   Automatically sideload APK to connected device via adb"
            echo "  -d, --device ID Sideload APK to specific adb device ID"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "=== NativeTavern Local Android Build ==="
echo "Build Mode: $BUILD_MODE"
echo "Build Target: $BUILD_TARGET"
echo "Package Name: $PACKAGE_NAME"
if [ -n "$TRACK_NAME" ]; then
    echo "Google Play Track: $TRACK_NAME"
fi
if [ -n "${GOOGLE_PLAY_SERVICE_ACCOUNT_JSON:-}" ]; then
    echo "Google Play Service Account: configured"
fi
echo "Check Only: $CHECK_ONLY"

# Auto-detect JAVA_HOME if not set or invalid
if [ -z "${JAVA_HOME:-}" ] || [ ! -d "$JAVA_HOME" ]; then
    if [ -d "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home" ]; then
        export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
    elif [ -d "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home" ]; then
        export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
    elif command -v /usr/libexec/java_home >/dev/null 2>&1; then
        export JAVA_HOME="$(/usr/libexec/java_home -v 17 2>/dev/null || /usr/libexec/java_home 2>/dev/null || true)"
    fi
fi

if [ -n "${JAVA_HOME:-}" ] && [ -d "$JAVA_HOME" ]; then
    export PATH="$JAVA_HOME/bin:$PATH"
    echo "Using JAVA_HOME: $JAVA_HOME"
fi

# Auto-detect ANDROID_HOME / ANDROID_SDK_ROOT if not set
if [ -z "${ANDROID_HOME:-}" ] || [ ! -d "$ANDROID_HOME" ]; then
    if [ -d "$HOME/Library/Android/sdk" ]; then
        export ANDROID_HOME="$HOME/Library/Android/sdk"
    elif [ -d "/opt/homebrew/share/android-commandlinetools" ]; then
        export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
    fi
fi

if [ -n "${ANDROID_HOME:-}" ] && [ -d "$ANDROID_HOME" ]; then
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
    export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
    echo "Using ANDROID_HOME: $ANDROID_HOME"
fi

# Preserve state files
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

[ -f "pubspec.yaml" ] || { echo "ERROR: pubspec.yaml not found"; exit 1; }
VERSION=$(awk '/^version:/ {print $2; exit}' pubspec.yaml)
echo "App Version: $VERSION"

file_sha256() {
    if command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$1" | awk '{print $1}'
    else
        sha256sum "$1" | awk '{print $1}'
    fi
}

if [ "$SKIP_CLEAN" = "true" ]; then
    echo "Skipping flutter clean (SKIP_CLEAN=true)."
else
    echo "Cleaning previous Flutter build output..."
    flutter clean
fi

ORG_NAME="$(echo "$PACKAGE_NAME" | sed 's/\.[^.]*$//')"
[ -n "$ORG_NAME" ] || ORG_NAME="com.miaomiaoxworld"

echo "Generating Android platform files (org: $ORG_NAME)..."
flutter create --platforms=android --org "$ORG_NAME" .
restore_flutter_state

echo "Restoring Flutter dependencies..."
flutter pub get

if [ "${SKIP_LAUNCHER_ICONS:-false}" = "true" ]; then
    echo "Skipping launcher icon generation (SKIP_LAUNCHER_ICONS=true)."
else
    echo "Generating App Icons..."
    dart run flutter_launcher_icons
fi

echo "=== Configuring Signing ==="
CONFIG_KEYSTORE="config/upload-keystore.jks"
CONFIG_KEY_PROPERTIES="config/key.properties"
KEYSTORE_PATH="android/app/upload-keystore.jks"
KEY_PROPERTIES="android/key.properties"

USE_CUSTOM_SIGNING="false"
if [ -f "$CONFIG_KEYSTORE" ] && [ -f "$CONFIG_KEY_PROPERTIES" ]; then
    echo "Found local signing credentials in config/, copying..."
    mkdir -p android/app
    cp "$CONFIG_KEYSTORE" "$KEYSTORE_PATH"
    cp "$CONFIG_KEY_PROPERTIES" "$KEY_PROPERTIES"
    USE_CUSTOM_SIGNING="true"
elif [ -n "${ANDROID_KEYSTORE_PATH:-${KEYSTORE_PATH:-}}" ] && [ -f "${ANDROID_KEYSTORE_PATH:-${KEYSTORE_PATH:-}}" ]; then
    echo "Found signing keystore from environment, configuring..."
    mkdir -p android/app
    cp "${ANDROID_KEYSTORE_PATH:-$KEYSTORE_PATH}" "$KEYSTORE_PATH"
    cat > "$KEY_PROPERTIES" << EOF
storePassword=${ANDROID_STORE_PASSWORD:-${STORE_PASSWORD:-android}}
keyPassword=${ANDROID_KEY_PASSWORD:-${KEY_PASSWORD:-android}}
keyAlias=${ANDROID_KEY_ALIAS:-${KEY_ALIAS:-upload}}
storeFile=upload-keystore.jks
EOF
    USE_CUSTOM_SIGNING="true"
else
    echo "No custom release keystore found in config/ or .env. Using local debug/fallback signing configuration for sideloading."
fi

# Configure build.gradle.kts
BUILD_GRADLE_KTS="android/app/build.gradle.kts"
mkdir -p android/app

if [ "$USE_CUSTOM_SIGNING" == "true" ]; then
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

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "__APPLICATION_ID__"
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
else
    cat > "$BUILD_GRADLE_KTS" << 'GRADLE_KTS_CONTENT'
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.miaomiaoxworld.nativetavern"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "__APPLICATION_ID__"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Sign with debug keys for local sideloading
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
GRADLE_KTS_CONTENT
fi

perl -i -pe "s/__APPLICATION_ID__/$PACKAGE_NAME/g" "$BUILD_GRADLE_KTS"

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

# GitHub-hosted runners have limited RAM. The Flutter template defaults to -Xmx8G,
# which can OOM a standard Linux runner. Keep local machines on the template values.
if [ "${CI:-}" = "true" ]; then
    GRADLE_PROPERTIES="android/gradle.properties"
    echo "Tuning Gradle memory and caching for CI..."
    mkdir -p android
    if [ -f "$GRADLE_PROPERTIES" ]; then
        if command -v perl >/dev/null 2>&1; then
            perl -i -pe 's/-Xmx\d+[GgMm]/-Xmx4G/; s/-XX:MaxMetaspaceSize=\d+[GgMm]/-XX:MaxMetaspaceSize=1G/' "$GRADLE_PROPERTIES"
        fi
    else
        printf 'org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=1G -XX:+HeapDumpOnOutOfMemoryError\n' > "$GRADLE_PROPERTIES"
    fi
    grep -q '^org.gradle.daemon=' "$GRADLE_PROPERTIES" 2>/dev/null || echo 'org.gradle.daemon=false' >> "$GRADLE_PROPERTIES"
    grep -q '^org.gradle.parallel=' "$GRADLE_PROPERTIES" 2>/dev/null || echo 'org.gradle.parallel=true' >> "$GRADLE_PROPERTIES"
    grep -q '^org.gradle.caching=' "$GRADLE_PROPERTIES" 2>/dev/null || echo 'org.gradle.caching=true' >> "$GRADLE_PROPERTIES"
fi

# Configure AndroidManifest.xml
ANDROID_MANIFEST="android/app/src/main/AndroidManifest.xml"
if [ -f "$ANDROID_MANIFEST" ]; then
    if ! grep -q "android.permission.INTERNET" "$ANDROID_MANIFEST"; then
        perl -i -pe 's|(<manifest[^>]*>)|$1\n    <uses-permission android:name="android.permission.INTERNET"/>\n    <uses-permission android:name="android.permission.READ_PHONE_STATE"/>\n    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>\n    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>\n    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>\n    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>\n    <uses-permission android:name="android.permission.READ_MEDIA_AUDIO"/>|' "$ANDROID_MANIFEST"
    fi

    if ! grep -q "android:screenOrientation=\"portrait\"" "$ANDROID_MANIFEST"; then
        perl -i -pe 's|(android:name="\.MainActivity"[^>]*)(\s*android:launchMode)|$1\n            android:screenOrientation="portrait"$2|' "$ANDROID_MANIFEST"
    fi

    if ! grep -q "android:pathPattern=\".*\\.ntb\"" "$ANDROID_MANIFEST"; then
        perl -i -pe 's|(</activity>)|            <intent-filter>\n                <action android:name="android.intent.action.VIEW" />\n                <category android:name="android.intent.category.DEFAULT" />\n                <category android:name="android.intent.category.BROWSABLE" />\n                <data android:scheme="file" />\n                <data android:scheme="content" />\n                <data android:mimeType="*/*" />\n                <data android:pathPattern=".*\\\\.jsonl" />\n                <data android:pathPattern=".*\\\\.ntb" />\n                <data android:pathPattern=".*\\\\.ntm" />\n                <data android:host="*" />\n            </intent-filter>\n            <intent-filter>\n                <action android:name="android.intent.action.SEND" />\n                <category android:name="android.intent.category.DEFAULT" />\n                <data android:mimeType="*/*" />\n            </intent-filter>\n$1|' "$ANDROID_MANIFEST"
    fi
fi

# Configure strings.xml for Google Sign-In
BACKCLOUD_CONFIG="config/backcloud.config"
STRINGS_XML="android/app/src/main/res/values/strings.xml"
mkdir -p "$(dirname "$STRINGS_XML")"
WEB_CLIENT_ID="local-testing-client-id"
if [ -f "$BACKCLOUD_CONFIG" ]; then
    FOUND_ID=$(grep '^desk_client_id=' "$BACKCLOUD_CONFIG" | cut -d'=' -f2 || true)
    if [ -n "$FOUND_ID" ]; then
        WEB_CLIENT_ID="$FOUND_ID"
    fi
fi

cat > "$STRINGS_XML" << EOF
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Native Tavern</string>
    <string name="default_web_client_id">$WEB_CLIENT_ID</string>
</resources>
EOF

# Create MainActivity.kt
MAIN_ACTIVITY_DIR="android/app/src/main/kotlin/com/miaomiaoxworld/nativetavern"
MAIN_ACTIVITY_PATH="$MAIN_ACTIVITY_DIR/MainActivity.kt"
mkdir -p "$MAIN_ACTIVITY_DIR"
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
        try {
            val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
            val simCountry = telephonyManager?.simCountryIso?.uppercase(Locale.ROOT)
            if (simCountry == "CN") {
                return true
            }

            val networkCountry = telephonyManager?.networkCountryIso?.uppercase(Locale.ROOT)
            if (networkCountry == "CN") {
                return true
            }
        } catch (e: Exception) {
            // Ignore errors
        }

        val locale = Locale.getDefault()
        if (locale.country == "CN" && locale.language == "zh") {
            return true
        }

        return false
    }
}
MAIN_ACTIVITY_CONTENT

if [ "$CHECK_ONLY" == "true" ]; then
    echo "Check passed successfully. Android configuration is valid."
    exit 0
fi

# Run pre-build registrant generator
if [ -f "tool/build_android_release.dart" ]; then
    dart run tool/build_android_release.dart \
        .flutter-plugins-dependencies \
        android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java
fi

mkdir -p build/local_release

if [ "$BUILD_TARGET" == "apk" ] || [ "$BUILD_TARGET" == "all" ]; then
    echo "Building Android APK ($BUILD_MODE)..."
    flutter build apk "--$BUILD_MODE" --no-pub --android-skip-build-dependency-validation
    APK_OUTPUT="build/app/outputs/flutter-apk/app-$BUILD_MODE.apk"
    [ -f "$APK_OUTPUT" ] || { echo "ERROR: APK was not produced at $APK_OUTPUT"; exit 1; }
    LOCAL_APK="build/local_release/NativeTavern_v${VERSION}_${BUILD_MODE}.apk"
    cp "$APK_OUTPUT" "$LOCAL_APK"
    echo "Local APK ready for sideloading at: $LOCAL_APK"
    APK_SHA="$(file_sha256 "$LOCAL_APK")"
    echo "APK SHA-256: $APK_SHA"
    printf '%s  %s\n' "$APK_SHA" "$(basename "$LOCAL_APK")" > "${LOCAL_APK}.sha256"

    if [ -n "$TRACK_NAME" ]; then
        TRACK_APK="build/local_release/NativeTavern_v${VERSION}_${TRACK_NAME}_${BUILD_MODE}.apk"
        cp "$LOCAL_APK" "$TRACK_APK"
        printf '%s  %s\n' "$APK_SHA" "$(basename "$TRACK_APK")" > "${TRACK_APK}.sha256"
        echo "Track APK ($TRACK_NAME): $TRACK_APK"
    fi

    if [ "$INSTALL_TO_DEVICE" == "true" ]; then
        echo "=== Sideloading APK to Device ==="
        if command -v adb >/dev/null 2>&1; then
            ADB_ARGS=()
            if [ -n "$DEVICE_ID" ]; then
                ADB_ARGS+=(-s "$DEVICE_ID")
            fi
            echo "Installing $LOCAL_APK to device..."
            adb "${ADB_ARGS[@]}" install -r "$LOCAL_APK"
            echo "APK successfully sideloaded!"
        else
            echo "WARNING: adb command not found; install Android platform-tools or add adb to PATH to enable automatic device installation."
        fi
    fi
fi

if [ "$BUILD_TARGET" == "aab" ] || [ "$BUILD_TARGET" == "all" ]; then
    echo "Building Android App Bundle ($BUILD_MODE)..."
    flutter build appbundle "--$BUILD_MODE" --no-pub --android-skip-build-dependency-validation
    AAB_OUTPUT="build/app/outputs/bundle/$BUILD_MODE/app-$BUILD_MODE.aab"
    [ -f "$AAB_OUTPUT" ] || { echo "ERROR: AAB was not produced at $AAB_OUTPUT"; exit 1; }
    LOCAL_AAB="build/local_release/NativeTavern_v${VERSION}_${BUILD_MODE}.aab"
    cp "$AAB_OUTPUT" "$LOCAL_AAB"
    echo "Local AAB ready at: $LOCAL_AAB"
    AAB_SHA="$(file_sha256 "$LOCAL_AAB")"
    echo "AAB SHA-256: $AAB_SHA"
    printf '%s  %s\n' "$AAB_SHA" "$(basename "$LOCAL_AAB")" > "${LOCAL_AAB}.sha256"

    if [ -n "$TRACK_NAME" ]; then
        TRACK_AAB="build/local_release/NativeTavern_v${VERSION}_${TRACK_NAME}_${BUILD_MODE}.aab"
        cp "$LOCAL_AAB" "$TRACK_AAB"
        printf '%s  %s\n' "$AAB_SHA" "$(basename "$TRACK_AAB")" > "${TRACK_AAB}.sha256"
        echo "Track AAB ($TRACK_NAME): $TRACK_AAB"
    fi
fi

echo "=== Local Android Build Finished Successfully ==="
