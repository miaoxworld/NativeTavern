#!/bin/bash

# Exit on error
set -e

# Configuration
TEAM_ID="${TEAM_ID:-}"  # Set your Apple Team ID here or via environment variable
ENABLE_MAC_CATALYST="${ENABLE_MAC_CATALYST:-true}"
DEVICE_ID="${DEVICE_ID:-}"  # Set device UDID for direct installation
BUILD_FOR_DEVICE="${BUILD_FOR_DEVICE:-false}"  # Set to true to build and install to device

echo "=== Cleaning everything for fresh build ==="
flutter clean

echo "=== Removing iOS folder to regenerate fresh ==="
rm -rf ios

echo "=== Clearing pub cache for file_picker ==="
flutter pub cache repair

echo "=== Getting Flutter packages ==="
flutter pub get

echo "=== Generating iOS platform files ==="
flutter create --platforms=ios --org com.miaomiaoxworld .

echo "=== Fixing bundle identifier to use lowercase ==="
# Replace nativeTavern with nativetavern in project.pbxproj
if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
    sed -i '' 's/com\.miaomiaoxworld\.nativeTavern/com.miaomiaoxworld.nativetavern/g' ios/Runner.xcodeproj/project.pbxproj
    echo "Bundle ID fixed to: com.miaomiaoxworld.nativetavern"
fi

echo "=== Re-running pub get to ensure symlinks are correct ==="
flutter pub get

echo "Configuring iOS Podfile..."
# Fix Podfile for proper module support with static linkage
if [ -f "ios/Podfile" ]; then
    cat > ios/Podfile << 'PODFILE_CONTENT'
# iOS platform version
platform :ios, '13.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks! :linkage => :static
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      
      # Fix for module not found issues in Release builds
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['DEFINES_MODULE'] = 'YES'
      config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
      
      # Ensure module maps are generated
      config.build_settings['CLANG_ENABLE_MODULES'] = 'YES'
      config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
      
      # Fix header search paths for Release
      if config.name == 'Release' || config.name == 'Profile'
        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)']
        config.build_settings['OTHER_SWIFT_FLAGS'] << '-no-verify-emitted-module-interface'
      end
    end
  end
  
  # Fix the Pods project settings
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['CLANG_ENABLE_MODULES'] = 'YES'
  end
end
PODFILE_CONTENT
    echo "Podfile configured successfully with static linkage"
fi

echo "Configuring Xcode project for automatic signing and Mac Catalyst..."
PBXPROJ_PATH="ios/Runner.xcodeproj/project.pbxproj"
if [ -f "$PBXPROJ_PATH" ]; then
    # Enable automatic code signing
    sed -i '' 's/CODE_SIGN_STYLE = Manual;/CODE_SIGN_STYLE = Automatic;/g' "$PBXPROJ_PATH"
    
    # Set development team if provided
    if [ -n "$TEAM_ID" ]; then
        sed -i '' "s/DEVELOPMENT_TEAM = \"\";/DEVELOPMENT_TEAM = \"$TEAM_ID\";/g" "$PBXPROJ_PATH"
        sed -i '' "s/DEVELOPMENT_TEAM = ;/DEVELOPMENT_TEAM = \"$TEAM_ID\";/g" "$PBXPROJ_PATH"
        echo "Set development team to: $TEAM_ID"
    fi
    
    # Enable Mac Catalyst (Designed for iPad on Mac)
    if [ "$ENABLE_MAC_CATALYST" = "true" ]; then
        # Add SUPPORTS_MACCATALYST = YES if not present
        if ! grep -q "SUPPORTS_MACCATALYST" "$PBXPROJ_PATH"; then
            sed -i '' 's/TARGETED_DEVICE_FAMILY = "1,2";/TARGETED_DEVICE_FAMILY = "1,2";\n\t\t\t\tSUPPORTS_MACCATALYST = YES;\n\t\t\t\tDERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER = YES;/g' "$PBXPROJ_PATH"
        fi
        echo "Mac Catalyst support enabled"
    fi
    
    echo "Xcode project configured successfully"
fi

echo "=== Adding Region Detection Code to AppDelegate ==="
# Modify AppDelegate.swift to include region detection code directly
APPDELEGATE_PATH="ios/Runner/AppDelegate.swift"
if [ -f "$APPDELEGATE_PATH" ]; then
    cat > "$APPDELEGATE_PATH" << 'APPDELEGATE_CONTENT'
import Flutter
import UIKit
import StoreKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Register region detection channel
    let controller = window?.rootViewController as! FlutterViewController
    let regionChannel = FlutterMethodChannel(name: "com.nativetavern/region",
                                              binaryMessenger: controller.binaryMessenger)
    
    regionChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getStorefrontCountry" {
        self?.getStorefrontCountry(result: result)
      } else if call.method == "isChinaRegion" {
        self?.isChinaRegion(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func getStorefrontCountry(result: @escaping FlutterResult) {
    if #available(iOS 13.0, *) {
      // Use SKStorefront for iOS 13+
      if let storefront = SKPaymentQueue.default().storefront {
        result(storefront.countryCode)
        return
      }
    }
    
    // Fallback: Use device locale
    let countryCode = Locale.current.regionCode ?? Locale.current.identifier
    result(countryCode)
  }
  
  /// Comprehensive China region detection
  /// Checks multiple sources: SKStorefront, system locale, preferred languages, timezone
  private func isChinaRegion(result: @escaping FlutterResult) {
    var reasons: [String] = []
    
    // 1. Check SKStorefront (App Store region)
    if #available(iOS 13.0, *) {
      if let storefront = SKPaymentQueue.default().storefront {
        let code = storefront.countryCode.uppercased()
        if code == "CHN" || code == "CN" {
          reasons.append("storefront:\(code)")
        }
      }
    }
    
    // 2. Check system locale region
    if let regionCode = Locale.current.regionCode?.uppercased() {
      if regionCode == "CN" || regionCode == "CHN" {
        reasons.append("locale_region:\(regionCode)")
      }
    }
    
    // 3. Check preferred languages (if user has Chinese as preferred)
    let preferredLanguages = Locale.preferredLanguages
    for lang in preferredLanguages {
      // Check for zh-Hans-CN, zh-CN, zh_CN patterns
      let langLower = lang.lowercased()
      if langLower.hasPrefix("zh") && (langLower.contains("-cn") || langLower.contains("_cn") || langLower.contains("-hans-cn")) {
        reasons.append("preferred_lang:\(lang)")
        break
      }
    }
    
    // 4. Check timezone (Asia/Shanghai, Asia/Chongqing, etc.)
    let timezone = TimeZone.current.identifier
    if timezone.hasPrefix("Asia/Shanghai") ||
       timezone.hasPrefix("Asia/Chongqing") ||
       timezone.hasPrefix("Asia/Harbin") ||
       timezone.hasPrefix("Asia/Urumqi") ||
       timezone == "PRC" {
      reasons.append("timezone:\(timezone)")
    }
    
    // 5. Check locale identifier
    let localeId = Locale.current.identifier.lowercased()
    if localeId.contains("zh_cn") || localeId.contains("zh-cn") || localeId.contains("zh_hans_cn") {
      reasons.append("locale_id:\(localeId)")
    }
    
    // Log for debugging
    print("RegionService iOS: reasons=\(reasons)")
    
    // Return true if any China indicator is found
    let isChina = !reasons.isEmpty
    result(["isChina": isChina, "reasons": reasons])
  }
}
APPDELEGATE_CONTENT
    echo "Updated AppDelegate.swift with comprehensive region detection code"
fi

echo "Configuring Info.plist with required permissions..."
INFO_PLIST_PATH="ios/Runner/Info.plist"
if [ -f "$INFO_PLIST_PATH" ]; then
    # Check if permissions already exist
    if ! grep -q "NSPhotoLibraryUsageDescription" "$INFO_PLIST_PATH"; then
        # Use sed to insert permissions before </dict>
        sed -i '' '/<\/dict>/i\
	<key>NSPhotoLibraryUsageDescription</key>\
	<string>This app needs access to your photo library to import character images, avatars, and chat backgrounds.</string>\
	<key>NSCameraUsageDescription</key>\
	<string>This app needs access to your camera to take photos for character avatars and chat images.</string>\
	<key>NSLocalNetworkUsageDescription</key>\
	<string>This app needs to connect to local AI services and APIs on your network.</string>
' "$INFO_PLIST_PATH"
        echo "Added required privacy descriptions to Info.plist"
    else
        echo "Privacy descriptions already exist in Info.plist"
    fi
    
    # Configure Google Sign-In
    echo "Configuring Google Sign-In..."
    BACKCLOUD_CONFIG="assets/backcloud.config"
    if [ -f "$BACKCLOUD_CONFIG" ]; then
        # Read iOS client ID from config
        IOS_CLIENT_ID=$(grep 'ios_client_id=' "$BACKCLOUD_CONFIG" | cut -d'=' -f2)
        if [ -n "$IOS_CLIENT_ID" ]; then
            # Extract reversed client ID for URL scheme
            # Format: 1077961567755-xxx.apps.googleusercontent.com -> com.googleusercontent.apps.1077961567755-xxx
            REVERSED_CLIENT_ID=$(echo "$IOS_CLIENT_ID" | sed 's/\.apps\.googleusercontent\.com$//' | xargs -I {} echo "com.googleusercontent.apps.{}")
            
            # Add GIDClientID if not present
            if ! grep -q "GIDClientID" "$INFO_PLIST_PATH"; then
                sed -i '' '/<\/dict>/i\
	<key>GIDClientID</key>\
	<string>'"$IOS_CLIENT_ID"'</string>
' "$INFO_PLIST_PATH"
                echo "Added GIDClientID: $IOS_CLIENT_ID"
            fi
            
            # Add CFBundleURLTypes for Google Sign-In if not present
            if ! grep -q "CFBundleURLTypes" "$INFO_PLIST_PATH"; then
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
' "$INFO_PLIST_PATH"
                echo "Added Google Sign-In URL scheme: $REVERSED_CLIENT_ID"
            fi
        else
            echo "Warning: ios_client_id not found in $BACKCLOUD_CONFIG"
        fi
    else
        echo "Warning: $BACKCLOUD_CONFIG not found, skipping Google Sign-In configuration"
    fi
fi

echo "Generating App Icons..."
flutter pub run flutter_launcher_icons

echo "Cleaning and reinstalling CocoaPods dependencies..."
cd ios
rm -rf Pods
rm -rf .symlinks
rm -f Podfile.lock
pod cache clean --all
pod install --repo-update
cd ..

# Extract version from pubspec.yaml
VERSION=$(grep 'version:' pubspec.yaml | head -n 1 | awk '{print $2}')

# Create release directory
mkdir -p release

# Check if we should build for device installation
if [ "$BUILD_FOR_DEVICE" = "true" ]; then
    echo "=== Building for Device Installation ==="
    
    # Determine device destination
    if [ -n "$DEVICE_ID" ]; then
        DESTINATION="id=$DEVICE_ID"
        echo "Target device: $DEVICE_ID"
    else
        DESTINATION="generic/platform=iOS"
        echo "No device specified, building for generic iOS device"
    fi
    
    # Build the app for device
    cd ios
    xcodebuild -workspace Runner.xcworkspace \
      -scheme Runner \
      -configuration Release \
      -destination "$DESTINATION" \
      SUPPORTS_MACCATALYST=NO \
      build
    
    cd ..
    
    # Find the built app
    APP_PATH=$(find build/ios -name "Runner.app" -type d | head -n 1)
    
    if [ -n "$APP_PATH" ]; then
        echo ""
        echo "✓ App built successfully!"
        echo "App location: $APP_PATH"
        echo ""
        
        # Check if ios-deploy is available
        if command -v ios-deploy &> /dev/null; then
            if [ -n "$DEVICE_ID" ]; then
                echo "Installing to device $DEVICE_ID..."
                ios-deploy --id "$DEVICE_ID" --bundle "$APP_PATH"
            else
                echo "Installing to connected device..."
                ios-deploy --bundle "$APP_PATH"
            fi
        else
            echo "To install to device, you can:"
            echo "  1. Install ios-deploy: brew install ios-deploy"
            echo "  2. Run: ios-deploy --bundle \"$APP_PATH\""
            echo ""
            echo "Or use Xcode:"
            echo "  1. Open ios/Runner.xcworkspace in Xcode"
            echo "  2. Select your device and click Run"
        fi
    else
        echo "❌ Could not find built app"
        exit 1
    fi
else
    echo "Creating Xcode Archive for App Store..."
    
    # Build archive with proper signing (iOS only, no Mac Catalyst)
    cd ios
    xcodebuild -workspace Runner.xcworkspace \
      -scheme Runner \
      -configuration Release \
      -destination 'generic/platform=iOS' \
      -archivePath "../build/ios/Runner.xcarchive" \
      SUPPORTS_MACCATALYST=NO \
      archive
    
    cd ..
    
    # Copy the archive to release directory with version number
    echo "Copying Archive to release directory..."
    ARCHIVE_NAME="NativeTavern_v${VERSION}.xcarchive"
    cp -R "build/ios/Runner.xcarchive" "release/${ARCHIVE_NAME}"
    
    # Export IPA for device installation
    echo ""
    echo "Exporting IPA for device installation..."
    
    # Create export options plist
    cat > /tmp/ExportOptions.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>compileBitcode</key>
    <false/>
    <key>destination</key>
    <string>export</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>teamID</key>
    <string>${TEAM_ID}</string>
    <key>thinning</key>
    <string>&lt;none&gt;</string>
</dict>
</plist>
EOF
    
    # Export IPA
    if [ -n "$TEAM_ID" ]; then
        xcodebuild -exportArchive \
          -archivePath "build/ios/Runner.xcarchive" \
          -exportPath "release" \
          -exportOptionsPlist /tmp/ExportOptions.plist || echo "⚠ IPA export failed (may need provisioning profile)"
        
        # Check if IPA was created
        if [ -f "release/Runner.ipa" ]; then
            IPA_NAME="NativeTavern_v${VERSION}.ipa"
            mv "release/Runner.ipa" "release/${IPA_NAME}"
            echo "✓ IPA exported: release/${IPA_NAME}"
        fi
    fi
    
    echo ""
    echo "✓ iOS Archive created successfully!"
    echo ""
    echo "Archive saved: release/${ARCHIVE_NAME}"
    echo ""
    echo "=== Installation Options ==="
    echo ""
    echo "Option 1: Install IPA to device using ios-deploy"
    if [ -f "release/${IPA_NAME:-Runner.ipa}" ]; then
        echo "  ios-deploy --bundle release/${IPA_NAME:-Runner.ipa}"
    else
        echo "  (IPA not exported - need TEAM_ID and provisioning profile)"
    fi
    echo ""
    echo "Option 2: Install directly from archive"
    echo "  1. Double-click release/${ARCHIVE_NAME} to open in Xcode Organizer"
    echo "  2. Click 'Distribute App' → 'Development' → Select device"
    echo ""
    echo "Option 3: Build and install directly to device"
    echo "  DEVICE_ID=\"00008120-0004243E3C40201E\" BUILD_FOR_DEVICE=true ./build_ios.sh"
    echo ""
    echo "Option 4: Upload to App Store"
    echo "  1. Double-click release/${ARCHIVE_NAME} to open in Xcode Organizer"
    echo "  2. Click 'Distribute App' → 'App Store Connect' → 'Upload'"
fi

echo ""
if [ -n "$TEAM_ID" ]; then
    echo "✓ Team ID: $TEAM_ID"
else
    echo "⚠ Set TEAM_ID environment variable for automatic signing:"
    echo "  export TEAM_ID=\"YOUR_TEAM_ID\" && ./build_ios.sh"
fi
if [ "$ENABLE_MAC_CATALYST" = "true" ]; then
    echo "✓ Mac Catalyst enabled"
fi