@echo off
setlocal enabledelayedexpansion

rem Save current directory
set "startDir=%CD%"

rem Change to script directory
cd /d "%~dp0\..\build"

REM Check if GPG is available
where gpg >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: GPG is not found in PATH
    echo Please install GPG and ensure it's in your PATH
    exit /b 1
)

REM Count total exe files
set /a count=0
for /r %%f in (*.exe) do (
    set /a count+=1
)

echo Found %count% .exe file(s) to sign

if %count% equ 0 (
    echo No .exe files found in current directory and subdirectories
    exit /b 0
)

REM Sign each exe file
set /a signed=0
set /a failed=0

for /r %%f in (*.exe) do (
    echo Signing: %%f
    
    REM Create detached signature
    gpg --yes --detach-sign "%%f"
    
    if !errorlevel! equ 0 (
        set /a signed+=1
    ) else (
        set /a failed+=1
        echo [FAILED] Could not sign: %%f
    )
)

rem Return to original directory
cd /d "%startDir%"
endlocal