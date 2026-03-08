#!/bin/sh

# Save current directory
startDir="$(pwd)"

# Change to script directory
scriptDir="$(cd "$(dirname "$0")" && pwd)"
cd "$scriptDir" || exit 1

fileNIM="../src/relay.nim"
fileEXE="../src/relay"
outputDir="../build/linux"

# Check if Nim file exists
if [ ! -f "$fileNIM" ]; then
    echo "[!] Nim file not found!"
    exit 1
fi

nim c -d:release "$fileNIM"

mkdir -p "$outputDir"
mv "$fileEXE" "$outputDir/"

# Return to original directory
cd "$startDir" || exit 1