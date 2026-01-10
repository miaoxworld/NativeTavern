#!/bin/bash

# Exit on error
set -e

# Configuration
TEAM_ID="${TEAM_ID:-}"  # Set your Apple Team ID here or via environment variable
ENABLE_MAC_CATALYST="${ENABLE_MAC_CATALYST:-true}"

echo "=== Cleaning everything for fresh build ==="
flutter clean

echo "=== Removing iOS folder to regenerate fresh ==="
rm -rf ios

echo "=== Clearing pub cache for file_picker ==="
flutter pub cache repair

echo "=== Getting Flutter packages ==="
flutter pub get

echo "=== Generating iOS platform files ==="
flutter create --platforms=ios --org com.miaoxworld .

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

echo "Building iOS App..."
# Build with automatic signing (requires Xcode to have a valid signing identity)
flutter build ios --release

# Extract version from pubspec.yaml
VERSION=$(grep 'version:' pubspec.yaml | head -n 1 | awk '{print $2}')

# Create release directory
mkdir -p release

# Compress iOS App
echo "Compressing iOS App..."
cd build/ios/iphoneos
zip -r "../../../release/NativeTavern_v${VERSION}_iOS.zip" Runner.app
cd -

echo "Build artifact saved to release/NativeTavern_v${VERSION}_iOS.zip"
echo ""
echo "iOS build complete!"
echo ""
if [ -n "$TEAM_ID" ]; then
    echo "✓ Automatic signing enabled with Team ID: $TEAM_ID"
else
    echo "Note: For automatic signing, set your Team ID:"
    echo "  export TEAM_ID=\"YOUR_TEAM_ID\" && ./build_ios.sh"
    echo "  Or open ios/Runner.xcworkspace in Xcode to configure signing manually."
fi
if [ "$ENABLE_MAC_CATALYST" = "true" ]; then
    echo "✓ Mac Catalyst enabled - App can run on macOS via 'Designed for iPad'"
fi