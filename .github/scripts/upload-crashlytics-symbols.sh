#!/usr/bin/env bash
# Uploads dSYMs to Firebase Crashlytics. Replaces the Xcode build phase, which
# silently stopped working when Firebase moved from CocoaPods to SPM.
# CI only: builds archived locally from Xcode ship without symbols.
set -euo pipefail

platform="${1:?usage: upload-crashlytics-symbols.sh <ios|macos> <dev|prod>}"
flavor="${2:?usage: upload-crashlytics-symbols.sh <ios|macos> <dev|prod>}"

case "$platform" in
  ios)
    upload_platform="ios"
    dsym_root="build/ios/archive"
    ;;
  macos)
    upload_platform="mac"
    dsym_root="build/macos/Build/Products/Release-$flavor"
    ;;
  *)
    echo "ERROR: unknown platform '$platform' (expected 'ios' or 'macos')" >&2
    exit 1
    ;;
esac

# upload-symbols comes from the SPM checkout, whose path is a Flutter tool detail.
upload_symbols=$(find "build/$platform" -type f -perm -u+x -name upload-symbols -print -quit)

if [ -z "$upload_symbols" ]; then
  echo "ERROR: upload-symbols not found under build/$platform" >&2
  echo "Firebase is resolved via SPM; check that the build populated SourcePackages." >&2
  exit 1
fi

# Name every bundle: handed a directory, upload-symbols treats "no dSYMs in here"
# as a warning and still exits 0 — the silent no-op this script exists to kill.
dsym_paths=()
while IFS= read -r dsym; do
  dsym_paths+=("$dsym")
done < <(find "$dsym_root" -type d -name '*.dSYM' -prune 2>/dev/null)

if [ ${#dsym_paths[@]} -eq 0 ]; then
  echo "ERROR: no dSYMs found under $dsym_root" >&2
  exit 1
fi

gsp="$platform/config/$flavor/GoogleService-Info.plist"

printf 'Uploading %s dSYMs using %s:\n' "${#dsym_paths[@]}" "$gsp"
printf '  %s\n' "${dsym_paths[@]}"
"$upload_symbols" -gsp "$gsp" -p "$upload_platform" -- "${dsym_paths[@]}"

# Share the resolved paths so the artifact step cannot drift from what was uploaded.
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  {
    echo 'paths<<DSYM_PATHS'
    printf '%s\n' "${dsym_paths[@]}"
    echo 'DSYM_PATHS'
  } >> "$GITHUB_OUTPUT"
fi
