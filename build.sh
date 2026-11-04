#!/bin/bash
# ======================================================
# CareCampus - Build Script (Linux/Mac)
# ======================================================
# This script reads .env file and passes all values as
# --dart-define parameters to flutter build/run commands.
# ======================================================
# Usage:
#   ./build.sh run              # flutter run with .env
#   ./build.sh build apk        # flutter build apk with .env
#   ./build.sh build web        # flutter build web with .env
#   ./build.sh run -d chrome    # flutter run on chrome with .env
# ======================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: .env file not found!"
    echo "Copy .env.example to .env and fill in your actual values:"
    echo "  cp .env.example .env"
    exit 1
fi

# Read .env file and build --dart-define flags
DART_DEFINES=""
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    line=$(echo "$line" | xargs)
    if [ -n "$line" ] && [[ ! "$line" =~ ^# ]]; then
        DART_DEFINES="$DART_DEFINES --dart-define=$line"
    fi
done < "$ENV_FILE"

COMMAND="${1:-run}"
shift 2>/dev/null

echo "Running: flutter $COMMAND $DART_DEFINES $@"
echo ""

flutter $COMMAND $DART_DEFINES "$@"
