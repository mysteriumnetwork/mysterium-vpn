#!/usr/bin/env bash
# Uploads dSYMs to Firebase Crashlytics. Replaces the Xcode build phase, which
# silently stopped working when Firebase moved from CocoaPods to SPM.
set -euo pipefail

platform="${1:?usage: upload-crashlytics-symbols.sh <ios|macos> <dev|prod>}"
flavor="${2:?usage: upload-crashlytics-symbols.sh <ios|macos> <dev|prod>}"

case "$platform" in
  ios)
    upload_symbols="build/ios/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols"
    upload_platform="ios"
    dsym_paths=(build/ios/archive/*.xcarchive/dSYMs)
    ;;
  macos)
    upload_symbols="build/macos/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols"
    upload_platform="mac"
    dsym_paths=("build/macos/Build/Products/Release-$flavor")
    ;;
  *)
    echo "ERROR: unknown platform '$platform' (expected 'ios' or 'macos')" >&2
    exit 1
    ;;
esac

gsp="$platform/config/$flavor/GoogleService-Info.plist"

if [ ! -x "$upload_symbols" ]; then
  echo "ERROR: upload-symbols not found at $upload_symbols" >&2
  echo "Firebase is resolved via SPM; check that the build populated SourcePackages." >&2
  find build -name upload-symbols -type f 2>/dev/null || true
  exit 1
fi

if [ ! -f "$gsp" ]; then
  echo "ERROR: GoogleService-Info.plist not found at $gsp" >&2
  exit 1
fi

if [ ! -e "${dsym_paths[0]}" ]; then
  echo "ERROR: no dSYMs found at ${dsym_paths[*]}" >&2
  exit 1
fi

echo "Uploading dSYMs from ${dsym_paths[*]} using $gsp"
"$upload_symbols" -gsp "$gsp" -p "$upload_platform" -- "${dsym_paths[@]}"
