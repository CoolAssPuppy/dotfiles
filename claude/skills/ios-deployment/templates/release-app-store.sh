#!/bin/bash
#
# Build {{APP_NAME}}, archive, export, upload, and submit to the App Store
# for review. NOT YET TESTED end to end. The upload portion is identical to
# debug-testflight.sh and is reliable. The submission portion uses the ASC
# REST API and may need refinement after the first real run.
#
# Usage:
#   ./scripts/release-app-store.sh <version> "<release notes text>"
#
# Example:
#   ./scripts/release-app-store.sh 1.2.3 "Fixed crash on settings screen. New widget."
#
# After this script completes, the submission is in Apple's review queue.
# Approval typically takes 24-72 hours. You'll get email when approved.

set -euo pipefail

VERSION="${1:?Usage: $0 <version> \"<release notes>\"}"
NOTES="${2:?Usage: $0 <version> \"<release notes>\"}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$REPO_ROOT/dist"
SCRIPTS="$REPO_ROOT/scripts"

ASC_KEY_ID="${ASC_KEY_ID:-{{ASC_KEY_ID}}}"
ASC_ISSUER_ID="${ASC_ISSUER_ID:-{{ASC_ISSUER_ID}}}"
ASC_APP_ID="${ASC_APP_ID:-{{ASC_APP_ID}}}"
ASC_KEY_PATH="${ASC_KEY_PATH:-$HOME/.private_keys/AuthKey_${ASC_KEY_ID}.p8}"

#----------------------------------------------------------------------
# Preflight
#----------------------------------------------------------------------
for tool in xcodebuild xcodegen python3; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Error: required tool not found: $tool"
    exit 1
  fi
done

if [ ! -f "$ASC_KEY_PATH" ]; then
  echo "Error: ASC API key not found at $ASC_KEY_PATH"
  echo "See asc-api-setup.md."
  exit 1
fi

if ! python3 -c "import jwt, requests" >/dev/null 2>&1; then
  echo "Error: Python deps missing. Run: python3 -m pip install pyjwt requests"
  exit 1
fi

mkdir -p "$DIST"

#----------------------------------------------------------------------
# 1. Bump MARKETING_VERSION + CURRENT_PROJECT_VERSION
#----------------------------------------------------------------------
CURRENT_BUILD=$(awk -F'"' '/CURRENT_PROJECT_VERSION:/ {print $2}' "$REPO_ROOT/project.yml")
NEW_BUILD=$((CURRENT_BUILD + 1))
echo "==> Bumping to version $VERSION (build $NEW_BUILD)"
python3 - <<PY
import re, pathlib
p = pathlib.Path("$REPO_ROOT/project.yml")
text = p.read_text()
text = re.sub(r'MARKETING_VERSION: "[^"]+"', 'MARKETING_VERSION: "$VERSION"', text)
text = re.sub(r'CURRENT_PROJECT_VERSION: "[^"]+"', 'CURRENT_PROJECT_VERSION: "$NEW_BUILD"', text)
p.write_text(text)
PY

#----------------------------------------------------------------------
# 2. Regenerate Xcode project
#----------------------------------------------------------------------
echo "==> Regenerating Xcode project"
(cd "$REPO_ROOT" && xcodegen generate)

#----------------------------------------------------------------------
# 3. Archive
#----------------------------------------------------------------------
ARCHIVE="$DIST/{{APP_NAME_NOSPACE}}-$VERSION-$NEW_BUILD.xcarchive"
rm -rf "$ARCHIVE"
echo "==> Archiving"
xcodebuild -project "$REPO_ROOT/{{APP_NAME_NOSPACE}}.xcodeproj" \
  -scheme {{APP_NAME_NOSPACE}} \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE" \
  -allowProvisioningUpdates \
  archive | xcpretty 2>/dev/null || \
xcodebuild -project "$REPO_ROOT/{{APP_NAME_NOSPACE}}.xcodeproj" \
  -scheme {{APP_NAME_NOSPACE}} \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE" \
  -allowProvisioningUpdates \
  archive >/dev/null

#----------------------------------------------------------------------
# 4. Export IPA
#----------------------------------------------------------------------
EXPORT_DIR="$DIST/export-$VERSION-$NEW_BUILD"
rm -rf "$EXPORT_DIR"
echo "==> Exporting IPA"
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE" \
  -exportPath "$EXPORT_DIR" \
  -exportOptionsPlist "$SCRIPTS/export-options.plist" \
  -allowProvisioningUpdates >/dev/null

IPA_PATH="$EXPORT_DIR/{{APP_NAME_NOSPACE}}.ipa"
if [ ! -f "$IPA_PATH" ]; then
  echo "Error: export did not produce $IPA_PATH"
  exit 1
fi

#----------------------------------------------------------------------
# 5. Upload to App Store Connect
#----------------------------------------------------------------------
echo "==> Uploading $IPA_PATH"
xcrun altool --upload-app \
  -f "$IPA_PATH" \
  -t ios \
  --apiKey "$ASC_KEY_ID" \
  --apiIssuer "$ASC_ISSUER_ID"

#----------------------------------------------------------------------
# 6-8. NOT YET TESTED: create version, attach build, submit for review.
# On the first release, comment out this block and complete the
# submission manually in the App Store Connect web UI. Once you have
# a successful manual submission, run this block against the next
# release to confirm parity.
#----------------------------------------------------------------------
echo ""
echo "==> Submitting for review via ASC REST API (NOT YET TESTED)"
echo "    If this fails, the build is already uploaded. Complete the"
echo "    submission manually in App Store Connect web UI."
echo ""
python3 "$SCRIPTS/submit-for-review.py" \
  --key-path "$ASC_KEY_PATH" \
  --key-id "$ASC_KEY_ID" \
  --issuer-id "$ASC_ISSUER_ID" \
  --app-id "$ASC_APP_ID" \
  --version "$VERSION" \
  --build "$NEW_BUILD" \
  --release-notes "$NOTES"

echo ""
echo "============================================================"
echo "Released {{APP_NAME}} $VERSION (build $NEW_BUILD)"
echo ""
echo "Submission state: in review."
echo "Apple typically responds within 24-72 hours."
echo "Check status: https://appstoreconnect.apple.com/apps/$ASC_APP_ID"
echo ""
echo "Don't forget to commit project.yml and tag the release:"
echo "  git commit -am \"Release $VERSION\""
echo "  git tag v$VERSION"
echo "  git push --tags"
echo "============================================================"
