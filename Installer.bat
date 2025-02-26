@echo off
setlocal enabledelayedexpansion

:: You may want to run the updater after installing
:: Define installation directory
set "INSTALL_DIR=C:\Program Files\NZip"
set "ZIP_URL=https://raw.githubusercontent.com/idk-kid1214/NZip/refs/heads/main/Releases/NZipV1.0.zip"
set "TEMP_ZIP=%TEMP%\NZipV1.0.zip"

:: Create installation directory
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: Download the latest NZip release
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%ZIP_URL%', '%TEMP_ZIP%')"

:: Check if download was successful
if not exist "%TEMP_ZIP%" (
    echo Failed to download NZip. Please check your internet connection.
    pause
    exit /b 1
)

:: Extract the ZIP file
powershell -Command "Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath '%INSTALL_DIR%' -Force"

:: Clean up the ZIP file
del "%TEMP_ZIP%"

:: Add NZip to system PATH
setx PATH "%INSTALL_DIR%;%PATH%" /M

:: Set Updater to run on startup
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v NZipUpdater /t REG_SZ /d "%INSTALL_DIR%\updater.exe" /f

:: Notify user
echo Installation complete! NZip is now installed in %INSTALL_DIR%
pause
exit
