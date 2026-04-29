#!/bin/bash
#
# Build {{APP_NAME}}, archive, export an IPA, and upload it to TestFlight.
# No App Store submission. Internal testers see it after Apple finishes
# processing (5-30 min). External testers see it after their group is added
# in App Store Connect.
#
# Usage:
#   ./scripts/debug-testflight.sh "<changelog text>"
#
# Example:
#   ./scripts/debug-testflight.sh "Fixed login bug, improved settings UI"

set -euo pipefail

CHANGELOG="${1:-No changelog provided.}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$REPO_ROOT/dist"
SCRIPTS="$REPO_ROOT/scripts"

ASC_KEY_ID="${ASC_KEY_ID:-{{ASC_KEY_ID}}}"
ASC_ISSUER_ID="${ASC_ISSUER_ID:-{{ASC_ISSUER_ID}}}"

#----------------------------------------------------------------------
# Preflight
#----------------------------------------------------------------------
for tool in xcodebuild xcodegen; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Error: required tool not found: $tool"
    exit 1
  fi
done

if ! ls ~/.private_keys/AuthKey_${ASC_KEY_ID}.p8 >/dev/null 2>&1; then
  echo "Error: ASC API key not found at ~/.private_keys/AuthKey_${ASC_KEY_ID}.p8"
  echo "See asc-api-setup.md."
  exit 1
fi

mkdir -p "$DIST"

#----------------------------------------------------------------------
# 1. Bump CURRENT_PROJECT_VERSION (build number) only.
#    Marketing version stays unchanged for TestFlight builds.
#----------------------------------------------------------------------
CURRENT_BUILD=$(awk -F'"' '/CURRENT_PROJECT_VERSION:/ {print $2}' "$REPO_ROOT/project.yml")
NEW_BUILD=$((CURRENT_BUILD + 1))
echo "==> Bumping build number $CURRENT_BUILD -> $NEW_BUILD"
python3 - <<PY
import re, pathlib
p = pathlib.Path("$REPO_ROOT/project.yml")
text = p.read_text()
text = re.sub(r'CURRENT_PROJECT_VERSION: "[^"]+"', 'CURRENT_PROJECT_VERSION: "$NEW_BUILD"', text)
p.write_text(text)
PY

#----------------------------------------------------------------------
# 2. Regenerate the Xcode project from project.yml.
#----------------------------------------------------------------------
echo "==> Regenerating Xcode project"
(cd "$REPO_ROOT" && xcodegen generate)

#----------------------------------------------------------------------
# 3. Archive (Release configuration, device build).
#    -destination 'generic/platform=iOS' avoids accidentally archiving the
#    simulator binary, which the App Store rejects with ITMS-90087.
#    -allowProvisioningUpdates lets Xcode auto-fetch missing profiles.
#----------------------------------------------------------------------
ARCHIVE="$DIST/{{APP_NAME_NOSPACE}}-$NEW_BUILD.xcarchive"
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
# 4. Export the IPA with method: app-store-connect.
#----------------------------------------------------------------------
EXPORT_DIR="$DIST/export-$NEW_BUILD"
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
# 5. Upload to App Store Connect via altool.
#----------------------------------------------------------------------
echo "==> Uploading $IPA_PATH to App Store Connect"
xcrun altool --upload-app \
  -f "$IPA_PATH" \
  -t ios \
  --apiKey "$ASC_KEY_ID" \
  --apiIssuer "$ASC_ISSUER_ID"

# Save the changelog for manual paste into TestFlight "What to Test".
# TODO: push this via REST API after processing completes.
echo "$CHANGELOG" > "$DIST/whats-new-$NEW_BUILD.txt"

echo ""
echo "============================================================"
echo "Uploaded {{APP_NAME}} build $NEW_BUILD to App Store Connect"
echo ""
echo "Next steps:"
echo "  1. Wait 5-30 min for Apple to finish processing."
echo "  2. Build appears in App Store Connect > TestFlight > Builds."
echo "  3. Internal testers get it automatically. External: add to group."
echo "  4. Paste this changelog into 'What to Test':"
echo ""
echo "  $CHANGELOG"
echo ""
echo "  Saved to: $DIST/whats-new-$NEW_BUILD.txt"
echo "============================================================"
