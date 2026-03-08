@echo off
rem ============================================================
rem compile.bat
rem Usage: compile.bat [import|export] [target]
rem Compiles a Nim file from ../src/<action>/<target>.nim
rem and moves the executable to ../build/<action>/
rem ============================================================

setlocal

rem Save current directory
set "startDir=%CD%"

rem Change to script directory
cd /d "%~dp0"

rem Parse arguments
set "action=%1"
set "target=%2"

if "%~1"=="" (
    echo "[!] Missing action (import or export)"
    goto :eof
)
if "%~2"=="" (
    echo [!] Missing target filename
    goto :eof
)

rem Build relative paths
set "fileNimRel=%~dp0..\src\%action%\%target%\%action%_%target%.nim"
set "fileExeRel=%~dp0..\src\%action%\%target%\%action%_%target%.exe"
set "buildFile=%~dp0..\src\%action%\%target%\build.nim"
set "buildExe=%~dp0..\src\%action%\%target%\build.exe"
set "buildOutput=%~dp0..\build\%action%\%target%"

rem Resolve relative paths to absolute paths
for %%I in ("%fileNimRel%") do set "fileNim=%%~fI"
for %%I in ("%fileExeRel%") do set "fileExe=%%~fI"
for %%I in ("%buildOutput%") do set "buildOutput=%%~fI"
for %%I in ("%buildFile%") do set "buildFile=%%~fI"
for %%I in ("%buildExe%") do set "buildExe=%%~fI"

rem Check if Nim file exists
if not exist "%fileNim%" (
    echo [!] Nim file not found!
    goto :eof
)

rem Check if Build file exists
if not exist "%buildFile%" (
    echo [!] Build file not found!
    goto :eof
)

rem Create build folder if it doesn't exist
if not exist "%buildOutput%" mkdir "%buildOutput%"

rem Compile and Run Build File
nim c -r "%buildFile%"
del "%buildExe%"

rem Compile Nim file
nim c -d:release "%fileNim%"

rem Move the executable to the build folder
if exist "%fileExe%" (
    move /Y "%fileExe%" "%buildOutput%\"
    echo Moved executable to "%buildOutput%"
) else (
    echo [!] Executable not found after compilation!
)

rem Return to original directory
cd /d "%startDir%"
endlocal