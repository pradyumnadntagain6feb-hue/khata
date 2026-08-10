@echo off
echo ========================================================
echo Building Khata App Production Release APK & AppBundle...
echo ========================================================

echo.
echo [1/2] Building Release APK...
call flutter build apk --release

echo.
echo [2/2] Building Google Play Store AppBundle (.aab)...
call flutter build appbundle --release

echo.
echo ========================================================
echo RELEASE BUILD COMPLETE!
echo.
echo Release APK Path:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
echo Play Store AppBundle Path:
echo build\app\outputs\bundle\release\app-release.aab
echo ========================================================
pause
