@echo off

setlocal

rem Save current directory
set "startDir=%CD%"

rem Change to script directory
cd /d "%~dp0"

set "fileNIM=%~dp0..\src\relay.nim"
set "fileEXE=%~dp0..\src\relay.exe"
set "outputDir=%~dp0..\build\windows"

rem Resolve relative paths to absolute paths
for %%I in ("%fileNIM%") do set "fileNIM=%%~fI"
for %%I in ("%fileEXE%") do set "fileEXE=%%~fI"
for %%I in ("%outputDir%") do set "outputDir=%%~fI"

rem Check if Nim file exists
if not exist "%fileNIM%" (
    echo [!] Nim file not found!
    goto :eof
)

nim c -d:release "%fileNIM%"

move %fileEXE% %outputDir%

rem Return to original directory
cd /d "%startDir%"
endlocal