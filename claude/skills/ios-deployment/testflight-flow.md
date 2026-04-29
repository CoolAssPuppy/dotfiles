# TestFlight flow

What `./scripts/debug-testflight.sh "<changelog>"` does, in detail.

## When to use TestFlight

- **Internal team builds.** Up to 100 internal testers (Apple Developer team members and named users in App Store Connect). No review. Build appears within minutes of upload.
- **External beta.** Up to 10,000 external testers via email invite or public TestFlight link. First build with new external testers requires beta review (1-2 business days). Subsequent builds for the same testers do not require review unless you change "What to Test" significantly or change tester groups.
- **Last-stop validation before App Store submission.** Real device, real Apple processing, real-world install path. Catch issues that only surface outside the simulator.

## The 7 steps

### 1. Bump CURRENT_PROJECT_VERSION

`MARKETING_VERSION` does not change for TestFlight builds. Build number does, every time. Apple rejects re-uploads of the same `(version, build)` pair.

```python
# scripts/debug-testflight.sh excerpt
CURRENT_BUILD=$(awk -F'"' '/CURRENT_PROJECT_VERSION:/ {print $2}' project.yml)
NEW_BUILD=$((CURRENT_BUILD + 1))
# update project.yml in place
```

### 2. Regenerate the Xcode project

```
xcodegen generate
```

Without this, the bumped build number is silently lost.

### 3. Archive (Release configuration)

```
xcodebuild -project {{APP_NAME_NOSPACE}}.xcodeproj \
  -scheme {{APP_NAME_NOSPACE}} \
  -configuration Release \
  -archivePath dist/{{APP_NAME_NOSPACE}}-<build>.xcarchive \
  -allowProvisioningUpdates \
  -destination 'generic/platform=iOS' \
  archive
```

`-destination 'generic/platform=iOS'` builds for device (not simulator). Without this, you get an x86_64 simulator binary that App Store Connect rejects.

`-allowProvisioningUpdates` lets Xcode automatically download or update provisioning profiles when needed. Without it, missing-profile errors are silent and confusing.

### 4. Export the IPA

```
xcodebuild -exportArchive \
  -archivePath dist/{{APP_NAME_NOSPACE}}-<build>.xcarchive \
  -exportPath dist/export-<build> \
  -exportOptionsPlist scripts/export-options.plist \
  -allowProvisioningUpdates
```

`scripts/export-options.plist` declares `method: app-store-connect`. The output is `dist/export-<build>/{{APP_NAME_NOSPACE}}.ipa`.

### 5. Upload to App Store Connect via altool

```
xcrun altool --upload-app \
  -f dist/export-<build>/{{APP_NAME_NOSPACE}}.ipa \
  -t ios \
  --apiKey {{ASC_KEY_ID}} \
  --apiIssuer {{ASC_ISSUER_ID}}
```

`-t ios` declares the platform. Other valid values: `macos`, `tvos`, `visionos`.

The upload includes the symbols by default (you can opt out via `<key>uploadSymbols</key><false/>` in export-options.plist). Symbols help Apple symbolicate crash reports for you.

Successful output ends with something like:

```
No errors uploading 'dist/export-<build>/{{APP_NAME_NOSPACE}}.ipa'.
```

If validation fails, the message is `ITMS-90xxx` followed by a description. See [troubleshooting.md](troubleshooting.md).

### 6. Wait for processing

The build does not appear in TestFlight immediately. Apple processes it (5-30 minutes typically) before testers can install.

You can monitor via the REST API:

```bash
xcrun altool --notarization-history 0 \
  --apiKey {{ASC_KEY_ID}} \
  --apiIssuer {{ASC_ISSUER_ID}}
```

(Note: `--notarization-history` works for both macOS notarization and iOS upload status.)

Or just wait 10 minutes and check App Store Connect > TestFlight > Builds.

### 7. (Optional) Update "What to Test"

The `<changelog>` argument is meant to fill in the TestFlight "What to Test" field. Currently `debug-testflight.sh` writes it to `dist/whats-new.txt` but does not push it to App Store Connect. To push it, the script would need a REST API call to `POST /v1/builds/{id}/relationships/betaBuildLocalizations` after processing finishes.

> **NOT YET TESTED.** This optional step is left as a TODO in the script. Manually copy the changelog into the "What to Test" field in App Store Connect for now, or implement the REST API push when you have the patience.

## What happens for testers

After processing completes:

- **Internal testers** see the build in their TestFlight app immediately, get a push notification, and can install with one tap. No review.
- **External testers**: if this is the first build with new external testers, the build goes into Apple's beta review queue (1-2 business days). After approval, testers get an email invite or can use a public link. Subsequent builds for already-approved tester groups do not require re-review unless you trigger it.

## Promoting an internal build to external testers

After the build appears in App Store Connect > TestFlight > Builds, click the build and add the relevant external tester groups under "External Testing". The first time a build is sent to a new external group, it triggers beta review.

This is one of the operations that's easier in the web UI than via the API.

## Reverting a bad build

You cannot delete a build from TestFlight. You can:

1. **Expire it.** App Store Connect > TestFlight > Builds > Build > Expire. Testers can no longer install or run it. Existing installs continue to work.
2. **Upload a higher-numbered build.** TestFlight prefers the latest build by default; testers will be prompted to upgrade.
3. **For external testers**, remove the build from the external testing group. Testers get an email that the beta is no longer available.

The build itself stays in App Store Connect history forever, with the same `(version, build)` reserved.
