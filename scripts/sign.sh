#!/bin/sh

# Save current directory
startDir="$(pwd)"

# Change to script directory
cd "$(dirname "$0")/../build" || exit 1

# Check if GPG is available
if ! command -v gpg >/dev/null 2>&1; then
    echo "ERROR: GPG is not found in PATH"
    echo "Please install GPG and ensure it's in your PATH"
    exit 1
fi

# Set GPG_TTY for WSL
export GPG_TTY=$(tty)

# Count total executable files (without extension)
count=$(find . -type f -executable ! -name "*.*" | wc -l)

echo "Found $count executable file(s) to sign"

if [ "$count" -eq 0 ]; then
    echo "No executable files found in current directory and subdirectories"
    exit 0
fi

# Sign each executable file
signed=0
failed=0

find . -type f -executable ! -name "*.*" | while IFS= read -r f; do
    echo "Signing: $f"
    
    # Create detached signature
    if gpg --yes --detach-sign "$f"; then
        signed=$((signed + 1))
    else
        failed=$((failed + 1))
        echo "[FAILED] Could not sign: $f"
    fi
done

# Return to original directory
cd "$startDir" || exit 1