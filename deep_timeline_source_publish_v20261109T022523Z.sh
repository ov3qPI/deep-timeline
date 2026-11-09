#!/usr/bin/env bash
set -euo pipefail
SCRIPT_ID=deep_timeline_source_publish_v20261109T022523Z
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OWNER=ov3qPI
REPO=deep-timeline
fail(){ printf 'ERROR: %s\n' "$*" >&2;exit 1;}
cd "$ROOT"
for cmd in git gh grep sed tr;do command -v "$cmd" >/dev/null 2>&1 || fail "Missing $cmd. Install with pkg install git gh";done
[ ! -e .git ] || fail 'This source folder already has Git history; use a fresh extraction'
[ -f .githooks/pre-commit ] && [ -f build.sh ] && [ -f AndroidManifest.xml ] || fail 'Incomplete source package'
if ! gh auth status --hostname github.com >/dev/null 2>&1;then gh auth login --hostname github.com --git-protocol https --web;fi
LOGIN="$(gh api user --jq .login)"
[ "${LOGIN,,}" = "${OWNER,,}" ] || fail "Authenticated as $LOGIN; expected $OWNER"
if gh repo view "$OWNER/$REPO" >/dev/null 2>&1;then fail "Repository $OWNER/$REPO already exists; refusing to modify it";fi
gh auth setup-git --hostname github.com
git init -b main
git config user.name "$LOGIN"
USER_ID="$(gh api user --jq .id)"
git config user.email "${USER_ID}+${LOGIN}@users.noreply.github.com"
git config core.hooksPath .githooks
git add -A
if git diff --cached --name-only | grep -Ei '(\.(apk|aab|keystore|jks|p12|pfx|p8|pem|key|age|json|db|sqlite|jar|dex|class|zip)$|(^|/)(assets|private|backups|data|logs)/)' >/dev/null;then fail 'Sensitive or generated file staged';fi
if git diff --cached --no-ext-diff --unified=0 | grep -E '^\+[^+]' | grep -E '(--(ks-pass|key-pass)[[:space:]]+pass:|-(storepass|keypass)[[:space:]]+[^$[:space:]]+|github_pat_[A-Za-z0-9_]+|gh[pous]_[A-Za-z0-9_]+|BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY)' >/dev/null;then fail 'Potential secret detected in staged source';fi
[ -n "$(git diff --cached --name-only)" ] || fail 'No source files to commit'
git commit -m 'Initial clean Deep Timeline source v20261108T180957Z'
gh repo create "$OWNER/$REPO" --private --description 'Offline-first Android timeline from tactical scheduling to deep history' --source=. --remote=origin --push
REMOTE_VISIBILITY="$(gh api "repos/$OWNER/$REPO" --jq .visibility)"
[ "$REMOTE_VISIBILITY" = private ] || fail "Unexpected GitHub visibility: $REMOTE_VISIBILITY"
printf 'SUCCESS: https://github.com/%s/%s\nLOCAL: %s\n' "$OWNER" "$REPO" "$ROOT"
printf 'Source only: no APK, signing keys, personal event JSON, tags, or GitHub releases were published.\n'
