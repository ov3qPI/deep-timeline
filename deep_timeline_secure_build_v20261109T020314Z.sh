#!/usr/bin/env bash
set -euo pipefail
SCRIPT_ID=deep_timeline_secure_build_v20261109T020314Z
cd "$(dirname "${BASH_SOURCE[0]}")"
printf 'Deep Timeline signing password (input hidden): ' >/dev/tty
IFS= read -r -s DEEP_TIMELINE_STORE_PASS </dev/tty
printf '\n' >/dev/tty
[ -n "$DEEP_TIMELINE_STORE_PASS" ] || { echo 'ERROR: Empty password';exit 1; }
export DEEP_TIMELINE_STORE_PASS
export DEEP_TIMELINE_KEY_PASS="$DEEP_TIMELINE_STORE_PASS"
trap 'unset DEEP_TIMELINE_STORE_PASS DEEP_TIMELINE_KEY_PASS' EXIT
bash build.sh
