@echo off
echo ============================================
echo  EliteDrive Vehicle Rental - Build Script
echo ============================================
echo.

:: ─── Configuration ───────────────────────────────────────
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
set "JAVAC=%JAVA_HOME%\bin\javac.exe"
set "PROJECT_DIR=%~dp0"
set "SRC_DIR=%PROJECT_DIR%src"
set "LIB_DIR=%PROJECT_DIR%web\WEB-INF\lib"
set "OUT_DIR=%PROJECT_DIR%web\WEB-INF\classes"
set "SERVLET_API=%LIB_DIR%\jakarta.servlet-api.jar"

:: ─── Check javac ─────────────────────────────────────────
if not exist "%JAVAC%" (
    echo [ERROR] javac not found at: %JAVAC%
    echo         Please update JAVA_HOME at the top of this script.
    pause
    exit /b 1
)
echo [OK] Using javac: %JAVAC%

:: ─── Check servlet-api jar ───────────────────────────────
if not exist "%SERVLET_API%" (
    echo [ERROR] servlet-api not found: %SERVLET_API%
    echo.
    echo  You need to copy the servlet API jar into:
    echo    web\WEB-INF\lib\
    echo.
    echo  Options:
    echo    1. Copy javax.servlet-api-4.0.1.jar from your Tomcat install:
    echo       C:\apache-tomcat-x.x.x\lib\servlet-api.jar
    echo    2. Or download it from:
    echo       https://mvnrepository.com/artifact/javax.servlet/javax.servlet-api/4.0.1
    echo.
    pause
    exit /b 1
)
echo [OK] Found servlet-api: %SERVLET_API%

:: ─── Collect all Java source files ───────────────────────
echo.
echo Collecting Java source files...
dir /s /b "%SRC_DIR%\*.java" > "%TEMP%\sources.txt" 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] No Java source files found in: %SRC_DIR%
    pause
    exit /b 1
)

:: ─── Compile ─────────────────────────────────────────────
echo Compiling...
"%JAVAC%" -cp "%LIB_DIR%\mysql-connector-j-8.0.33.jar;%SERVLET_API%" ^
          -d "%OUT_DIR%" ^
          -source 11 -target 11 ^
          @"%TEMP%\sources.txt"

if %ERRORLEVEL% neq 0 (
    echo.
    echo [FAILED] Compilation failed. Check errors above.
    pause
    exit /b 1
)

echo.
echo ============================================
echo  BUILD SUCCESSFUL!
echo ============================================
echo.
echo Compiled classes are in:
echo   %OUT_DIR%
echo.
echo Next steps:
echo   1. Copy the entire 'web' folder to your Tomcat webapps directory:
echo        C:\apache-tomcat-x.x.x\webapps\vehicle_rental\
echo   2. Start Tomcat: catalina.bat start
echo   3. Open browser: http://localhost:8080/vehicle_rental/
echo.
pause
