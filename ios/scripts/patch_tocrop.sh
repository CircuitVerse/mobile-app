#!/bin/bash
# Patches TOCropViewController.m to guard UIViewLayoutRegion usage behind
# #if __IPHONE_OS_VERSION_MAX_ALLOWED < 180000 so it compiles on Xcode 16+
# (iOS 18 SDK) where those APIs were removed.
#
# Safe to run multiple times — skips if already patched.

set -euo pipefail

PODS_ROOT="${1:-$(dirname "$0")/../../ios/Pods}"
FILE="$PODS_ROOT/TOCropViewController/Objective-C/TOCropViewController/TOCropViewController.m"

if [ ! -f "$FILE" ]; then
  echo "patch_tocrop.sh: $FILE not found, skipping."
  exit 0
fi

if grep -q '__IPHONE_OS_VERSION_MAX_ALLOWED' "$FILE"; then
  echo "patch_tocrop.sh: already patched, skipping."
  exit 0
fi

echo "patch_tocrop.sh: patching $FILE ..."

perl -0777 -i -pe '
  s{(\s+)(UIViewLayoutRegion\s+\*layoutRegion\s*=\s*\[UIViewLayoutRegion[^\n]+;\n\s+UIEdgeInsets edgeInsets\s*=\s*\[self\.view edgeInsetsForLayoutRegion[^\n]+;\n\s+insets\.top\s*=[^\n]+;\n\s+insets\.left\s*=[^\n]+;\n\s+insets\.bottom\s*=[^\n]+;)}
  {$1#if __IPHONE_OS_VERSION_MAX_ALLOWED < 180000\n$1$2\n$1#endif}gms
' "$FILE"

if grep -q '__IPHONE_OS_VERSION_MAX_ALLOWED' "$FILE"; then
  echo "patch_tocrop.sh: patch applied successfully."
else
  echo "patch_tocrop.sh: WARNING — patch did not match. Manual review needed."
  exit 1
fi
