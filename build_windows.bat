@echo off
setlocal

echo Generating Windows platform files...
call flutter create --platforms=windows .

echo Generating App Icons...
call flutter pub run flutter_launcher_icons

echo Building Windows App...
call flutter build windows --release

echo Extracting version...
for /f "tokens=2" %%v in ('findstr /B "version: " pubspec.yaml') do set VERSION=%%v
echo Detected version: %VERSION%

if not exist release mkdir release

echo Compressing Windows App...
if exist "build\windows\x64\runner\Release" (
    powershell -Command "Compress-Archive -Path 'build\windows\x64\runner\Release\*' -DestinationPath 'release\NativeTavern_v%VERSION%_Windows.zip' -Force"
) else (
    powershell -Command "Compress-Archive -Path 'build\windows\runner\Release\*' -DestinationPath 'release\NativeTavern_v%VERSION%_Windows.zip' -Force"
)

echo Build artifact saved to release\NativeTavern_v%VERSION%_Windows.zip
pause