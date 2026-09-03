#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

echo "=================================================="
echo "    NativeTavern Developer Setup & Sanity Check   "
echo "=================================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

pass() {
    printf "${GREEN}✓ %s${NC}\n" "$*"
}

warn() {
    printf "${YELLOW}⚠ %s${NC}\n" "$*"
}

fail() {
    printf "${RED}✗ ERROR: %s${NC}\n" "$*" >&2
    exit 1
}

# 1. Verify required prerequisites
echo ""
echo "--- 1. Checking Toolchain Prerequisites ---"

command -v git >/dev/null 2>&1 || fail "git is not installed. Please install Git."
pass "git found: $(git --version)"

command -v flutter >/dev/null 2>&1 || fail "flutter is not installed or not in PATH. Please install Flutter (>=3.44.9)."
pass "flutter found: $(flutter --version | head -n 1)"

command -v dart >/dev/null 2>&1 || fail "dart is not installed or not in PATH."
pass "dart found: $(dart --version 2>&1 | head -n 1)"

# 2. Environment configuration setup (.env)
echo ""
echo "--- 2. Setting up Local Environment (.env) ---"

if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        pass "Created .env from .env.example"
        warn "Please review and customize .env with your local developer credentials if needed."
    else
        warn ".env.example not found; skipping .env initialization."
    fi
else
    pass ".env file already exists (retained existing file)."
fi

# 3. Ensure executable permissions on project scripts
echo ""
echo "--- 3. Setting Script Permissions ---"

for script in setup.sh build_*.sh tool/*.sh; do
    if [ -f "$script" ]; then
        chmod +x "$script" 2>/dev/null || true
    fi
done
pass "Executable permissions set on build and utility scripts."

# 4. Flutter Doctor
echo ""
echo "--- 4. Running Flutter Doctor ---"
flutter doctor -v || warn "flutter doctor reported some warnings (review above)."

# 5. Restore Flutter dependencies
echo ""
echo "--- 5. Installing Flutter & Dart Dependencies ---"
flutter pub get
pass "Dependencies resolved successfully."

# 6. Sanity Checks
echo ""
echo "--- 6. Running Project Sanity Checks ---"

# Check pubspec.yaml version
[ -f "pubspec.yaml" ] || fail "pubspec.yaml missing from repository root."
VERSION=$(awk '/^version:/ {print $2; exit}' pubspec.yaml)
if [[ "$VERSION" == *+* ]]; then
    pass "pubspec.yaml version valid: $VERSION"
else
    fail "pubspec.yaml version must include a build number (e.g. 0.1.17+41). Found: $VERSION"
fi

# Check localization configuration
if [ -f "l10n.yaml" ] && [ -d "lib/l10n" ]; then
    flutter gen-l10n
    pass "Localization files validated and generated."
else
    warn "Localization directory or l10n.yaml missing."
fi

# Run static analysis
echo "Running Dart static analysis..."
if dart analyze lib test; then
    pass "Dart static analysis passed without errors."
else
    warn "Dart static analysis reported some warnings or suggestions."
fi

# Preflight check on local build scripts
echo ""
echo "--- 7. Preflight Checking Local Build Scripts ---"

if [ -x "./build_ios_local.sh" ]; then
    if ./build_ios_local.sh --check-only >/dev/null 2>&1 || CHECK_ONLY=true ./build_ios_local.sh >/dev/null 2>&1; then
        pass "iOS local build preflight passed."
    else
        warn "iOS local build preflight reported issues (Xcode/macOS specific)."
    fi
fi

if [ -x "./build_android_local.sh" ]; then
    if ./build_android_local.sh --check-only --skip-clean >/dev/null 2>&1; then
        pass "Android local build preflight passed."
    else
        warn "Android local build preflight reported issues (Java/Android SDK specific)."
    fi
fi

if [ -x "./build_macos_local.sh" ]; then
    if ./build_macos_local.sh --check-only >/dev/null 2>&1; then
        pass "macOS local build preflight passed."
    else
        warn "macOS local build preflight reported issues."
    fi
fi

echo ""
echo "=================================================="
echo -e "${GREEN}✓ NativeTavern setup and sanity checks complete!${NC}"
echo "=================================================="
echo "Next steps:"
echo "  • Edit .env to configure your developer credentials / API keys"
echo "  • Run on iOS:     ./build_ios_local.sh"
echo "  • Run on Android: ./build_android_local.sh"
echo "  • Run on macOS:   ./build_macos_local.sh"
echo "  • Run tests:      flutter test"
echo "=================================================="
