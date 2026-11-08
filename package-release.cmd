@echo off
setlocal EnableExtensions

if "%~1"=="/?" goto :help
if /I "%~1"=="help" goto :help
if /I "%~1"=="--help" goto :help

set "BUILD_REPO=%~dp0"
for %%I in ("%BUILD_REPO%..") do set "WORKSPACE=%%~fI"
set "MVNW=%BUILD_REPO%mvnw.cmd"

if not exist "%MVNW%" goto :missing
if not exist "%BUILD_REPO%pom.xml" goto :missing
for %%M in (external-bom hive-domain hive-encryption db2oss hive-oss-frontend hive-release hive-oss) do (
    if not exist "%WORKSPACE%\%%M\pom.xml" goto :missing
)

echo [1/2] Building the Maven reactor...
call "%MVNW%" -f "%BUILD_REPO%pom.xml" clean install -Dmaven.test.skip=true || goto :fail

echo.
echo Application JAR: "%WORKSPACE%\hive-oss\target\hive-oss-1.0.jar"
echo [2/2] Assembling the release directory...
call "%BUILD_REPO%assemble-release.cmd" || goto :fail
echo Deployment ZIPs are generated only by the UI release workflow.
goto :end

:missing
echo ERROR: Missing Maven Wrapper or required sibling module. Expected workspace: "%WORKSPACE%"
exit /b 1

:fail
echo.
echo Packaging failed.
exit /b 1

:help
echo Usage: package-release.cmd
echo.
echo Builds the complete sibling Maven reactor and creates:
echo   ..\hive-oss\target\hive-oss-1.0.jar
echo Then assembles ..\.release\build from the JAR and hive-oss\src\distribution.
echo Tests are skipped. Start Hive and use the UI to package and publish this directory.
echo.
goto :end

:end
endlocal
