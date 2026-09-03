#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

for cmd in flutter xcrun open; do
  require_command "$cmd"
done

printf '=== NativeTavern iOS Simulator Runner ===\n'

# Find booted simulator
BOOTED_DEVICE_ID="$(xcrun simctl list devices | grep '(Booted)' | head -n 1 | sed -E 's/.*\(([A-F0-9-]+)\).*/\1/' || true)"

if [[ -z "$BOOTED_DEVICE_ID" ]]; then
  printf 'No running iOS simulator found. Discovering available simulators...\n'
  # Find an available iPhone simulator
  AVAILABLE_DEVICE_ID="$(xcrun simctl list devices available | grep -E 'iPhone' | head -n 1 | sed -E 's/.*\(([A-F0-9-]+)\).*/\1/' || true)"
  
  if [[ -z "$AVAILABLE_DEVICE_ID" ]]; then
    fail "No available iOS simulator runtime found. Please install an iOS simulator in Xcode."
  fi

  printf 'Booting iOS Simulator (%s)...\n' "$AVAILABLE_DEVICE_ID"
  xcrun simctl boot "$AVAILABLE_DEVICE_ID" || true
  BOOTED_DEVICE_ID="$AVAILABLE_DEVICE_ID"
fi

printf 'Opening Simulator app...\n'
open -a Simulator

printf 'Running NativeTavern on simulator %s...\n' "$BOOTED_DEVICE_ID"
flutter run -d "$BOOTED_DEVICE_ID" "$@"
