#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

printf '=== Building NativeTavern Ad-Hoc / Sideloading IPA ===\n'
printf 'Export Method: %s\n' "${EXPORT_METHOD:-ad-hoc}"

export EXPORT_METHOD="${EXPORT_METHOD:-ad-hoc}"
exec ./build_ios.sh "$@"
