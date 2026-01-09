@echo off
setlocal

echo Generating Android platform files...
call flutter create --platforms=android .

echo Generating App Icons...
call flutter pub run flutter_launcher_icons

echo Configuring Android permissions...
powershell -Command "$path = 'android/app/src/main/AndroidManifest.xml'; if (Test-Path $path) { $c = Get-Content $path -Raw; $perms = @('android.permission.INTERNET', 'android.permission.ACCESS_NETWORK_STATE', 'android.permission.READ_EXTERNAL_STORAGE', 'android.permission.WRITE_EXTERNAL_STORAGE', 'android.permission.MANAGE_EXTERNAL_STORAGE'); foreach ($perm in $perms) { if (-not ($c -match $perm)) { $c = $c -replace '(<manifest[^>]*>)', ('$1`n    <uses-permission android:name=\"' + $perm + '\"/>'); Write-Host ('Added ' + $perm) } }; if (-not ($c -match 'android:usesCleartextTraffic')) { $c = $c -replace '<application', '<application android:usesCleartextTraffic=\"true\"'; Write-Host 'Added usesCleartextTraffic' }; Set-Content $path $c -NoNewline } else { Write-Host 'AndroidManifest.xml not found' }"

echo Android configuration complete!

echo Building Android APK...
call flutter build apk --release

echo Extracting version...
for /f "tokens=2" %%v in ('findstr /B "version: " pubspec.yaml') do set VERSION=%%v
echo Detected version: %VERSION%

if not exist release mkdir release

echo Copying APK to release directory...
copy build\app\outputs\flutter-apk\app-release.apk "release\NativeTavern_v%VERSION%_Android.apk"

echo Build artifact saved to release\NativeTavern_v%VERSION%_Android.apk
pause