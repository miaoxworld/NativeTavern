#!/usr/bin/env bash
set -euo pipefail

# Same identity as sideload IPA: BUNDLE_ID and ICLOUD_CONTAINER_ID from .env.
# Implemented by build_ios_local.sh --simulator so this cannot drift.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

SIMULATOR_QUERY="iPhone 14 Pro Max"
if [[ $# -gt 0 && "$1" != -* ]]; then
  SIMULATOR_QUERY="$1"
  shift
fi

exec "$REPO_ROOT/build_ios_local.sh" --simulator "$SIMULATOR_QUERY" --skip-clean
