@echo off
setlocal EnableExtensions DisableDelayedExpansion

set "BUILD_REPO=%~dp0"
for %%I in ("%BUILD_REPO%..") do set "WORKSPACE=%%~fI"
set "RELEASE_DIR=%WORKSPACE%\.release"
set "BUILD_DIR=%RELEASE_DIR%\build"
set "RESOURCES_DIR=%WORKSPACE%\hive-oss\src\distribution"
set "JAR_FILE=%WORKSPACE%\hive-oss\target\hive-oss-1.0.jar"

if not exist "%JAR_FILE%" goto :missing
if not exist "%RESOURCES_DIR%\start.cmd" goto :missing
if not exist "%RESOURCES_DIR%\start.sh" goto :missing
if not exist "%RELEASE_DIR%" (
    mkdir "%RELEASE_DIR%" || goto :failed
)

if exist "%BUILD_DIR%" (
    rmdir /s /q "%BUILD_DIR%" || goto :failed
)
mkdir "%BUILD_DIR%" || goto :failed
copy /b /y "%JAR_FILE%" "%BUILD_DIR%\hive-oss.jar" >nul || goto :failed
copy /b /y "%RESOURCES_DIR%\start.cmd" "%BUILD_DIR%\start.cmd" >nul || goto :failed
copy /b /y "%RESOURCES_DIR%\start.sh" "%BUILD_DIR%\start.sh" >nul || goto :failed
echo Release build: "%BUILD_DIR%"
exit /b 0

:missing
echo ERROR: Missing JAR or distribution resource. Build the application first.
exit /b 1

:failed
echo ERROR: Release assembly failed. The build directory may be incomplete.
exit /b 1
