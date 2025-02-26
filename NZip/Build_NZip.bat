@echo off
setlocal enabledelayedexpansion

:: Define installation paths
set NZIP_DIR=C:\Program Files\NZip
set DIST_DIR=%~dp0dist
set BUILD_LOG=%~dp0build_log.txt

:: Create necessary directories
if not exist "%DIST_DIR%" mkdir "%DIST_DIR%"
if not exist "%NZIP_DIR%" mkdir "%NZIP_DIR%"

:: Install dependencies (assumes Chocolatey is installed)
echo Installing dependencies... > %BUILD_LOG%
choco install -y mingw rust >> %BUILD_LOG% 2>&1

:: Ensure compilers are in PATH
set PATH=C:\Program Files\mingw-w64\x86_64-8.1.0-posix-seh-rt_v6-rev0\mingw64\bin;%PATH%
set PATH=%USERPROFILE%\.cargo\bin;%PATH%

:: Compile NZip (C)
echo Compiling NZip... >> %BUILD_LOG%
gcc src\nzip.c -o "%DIST_DIR%\nzip.exe" >> %BUILD_LOG% 2>&1
if %errorlevel% neq 0 echo ERROR: Failed to compile nzip.exe >> %BUILD_LOG% && exit /b 1

:: Compile NZip Zip Module (Rust)
echo Compiling nzip_zip (Rust)... >> %BUILD_LOG%
cd src\nzip_zip
cargo build --release >> %BUILD_LOG% 2>&1
if %errorlevel% neq 0 echo ERROR: Failed to compile nzip_zip.exe >> %BUILD_LOG% && exit /b 1
copy target\release\nzip_zip.exe "%DIST_DIR%\nzip_zip.exe"
cd ..\..

:: Compile Updater (C)
echo Compiling Updater... >> %BUILD_LOG%
gcc src\updater.c -o "%DIST_DIR%\updater.exe" >> %BUILD_LOG% 2>&1
if %errorlevel% neq 0 echo ERROR: Failed to compile updater.exe >> %BUILD_LOG% && exit /b 1

:: Move all executables to NZip directory
xcopy "%DIST_DIR%\*" "%NZIP_DIR%" /Y /E

:: Final packaging
echo Creating ZIP package... >> %BUILD_LOG%
powershell Compress-Archive -Path "%DIST_DIR%\*" -DestinationPath "%~dp0NZip_Package.zip" -Force

:: Done
echo Build completed successfully!
pause
exit /b 0
