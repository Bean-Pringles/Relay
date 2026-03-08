#!/bin/sh
# ============================================================
# compile.sh
# Usage: compile.sh [import|export] [target]
# Compiles a Nim file from ../src/<action>/<target>.nim
# and moves the executable to ../build/<action>/
# ============================================================

# Save current directory
startDir="$(pwd)"

# Change to script directory
scriptDir="$(cd "$(dirname "$0")" && pwd)"
cd "$scriptDir" || exit 1

# Parse arguments
action="$1"
target="$2"

if [ -z "$1" ]; then
    echo "[!] Missing action (import or export)"
    exit 1
fi

if [ -z "$2" ]; then
    echo "[!] Missing target filename"
    exit 1
fi

# Build relative paths
fileNim="../src/$action/$target/${action}_${target}.nim"
fileExe="../src/$action/$target/${action}_${target}"
buildFile="../src/$action/$target/build.nim"
buildOutput="../build/linux/$action/$target"

# Check if Nim file exists
if [ ! -f "$fileNim" ]; then
    echo "[!] Nim file not found!"
    exit 1
fi

# Check if Build file exists
if [ ! -f "$buildFile" ]; then
    echo "[!] Build file not found!"
    exit 1
fi

# Create build folder if it doesn't exist
mkdir -p "$buildOutput"

# Compile and Run Build File
nim r "$buildFile"

# Compile Nim file
nim c -d:release "$fileNim"

# Move the executable to the build folder
if [ -f "$fileExe" ]; then
    mv -f "$fileExe" "$buildOutput/"
    echo "Moved executable to $buildOutput"
else
    echo "[!] Executable not found after compilation!"
fi

# Return to original directory
cd "$startDir" || exit 1