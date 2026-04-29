# Troubleshooting

## ITMS-90xxx errors after upload

App Store validation rejected the IPA. The error number is the lookup key.

**ITMS-90176: Invalid signature.**
The IPA is not properly signed. Almost always: wrong export method, wrong team in `export-options.plist`, or a stale provisioning profile. Try `xcodebuild clean`, then rerun the script.

**ITMS-90165: No matching provisioning profile.**
Automatic signing failed. Add `-allowProvisioningUpdates` to the `xcodebuild archive` call (the script template does this, but if you customized the script, double-check).

**ITMS-90683: Missing Purpose String in Info.plist.**
You used a permission API (camera, location, etc.) without declaring a usage string. Add the relevant `NSXxxUsageDescription` key to `Info.plist`.

**ITMS-90087: Unsupported architectures.**
Usually a simulator binary leaked into the archive. Make sure the archive command uses `-destination 'generic/platform=iOS'`. The script template does this.

**ITMS-90130: This bundle is invalid. The Info.plist contains an invalid key.**
Some `Info.plist` key is misspelled, deprecated, or not allowed for App Store distribution. The error usually names the key.

**ITMS-90713: Missing Info.plist value.**
A required key (like `CFBundleShortVersionString` or `CFBundleVersion`) is missing or empty. Verify the variable substitution worked: `defaults read dist/export-*/{{APP_NAME_NOSPACE}}.app/Info.plist`.

**ITMS-91056: Invalid app icon.**
Either the icon set is missing required sizes, or the app icon contains transparency or an alpha channel (not allowed). Open the asset catalog in Xcode, regenerate the icon set, rebuild.

## "No accounts with iTunes Connect access" from altool

The .p8 file is not in the search path or the Key ID is wrong.

```bash
# Confirm the .p8 file is where altool looks
ls ~/.private_keys/AuthKey_*.p8

# Verify with --list-providers
xcrun altool --list-providers \
  --apiKey {{ASC_KEY_ID}} \
  --apiIssuer {{ASC_ISSUER_ID}}
```

If the file is in a non-standard location, pass `--apiKeyPath`:

```bash
xcrun altool --upload-app \
  --apiKeyPath /path/to/AuthKey_XXX.p8 \
  --apiKey {{ASC_KEY_ID}} \
  --apiIssuer {{ASC_ISSUER_ID}} \
  ...
```

Permissions matter. The `.p8` should be `chmod 600`.

## Build does not appear in TestFlight after upload

Three causes, in order of likelihood:

**1. Still processing.** Wait 30 minutes. Check App Store Connect > TestFlight > Builds. A processing build is listed but greyed out.

**2. Apple rejected it.** Check email sent to the team's Account Holder. The rejection email lists the ITMS error. The build will not appear in App Store Connect at all if rejected outright at upload.

**3. Wrong app bundle ID or team ID.** The IPA was uploaded successfully, but to a different app record. Check that `PRODUCT_BUNDLE_IDENTIFIER` in `project.yml` matches the bundle ID in App Store Connect, and that `DEVELOPMENT_TEAM` matches `{{TEAM_ID}}`.

## "This build was rejected because it does not meet App Review Guideline X"

The script is not the cause. Address the rejection per Apple's email, fix the issue in the app, bump the build number, and re-upload. Build number monotonicity matters.

## Build number monotonicity violation

Symptom on upload: `ITMS-90478: Invalid Bundle. The same version (X build Y) has already been uploaded.`

Apple does not allow re-uploading the same `(MARKETING_VERSION, CURRENT_PROJECT_VERSION)` pair, ever. Bump the build number and re-archive.

If you upload `1.0.0 build 5` then `1.0.1 build 3`, that is also rejected — build numbers are monotonic across all versions of the app's lifetime, not per-version.

The release scripts always increment, so you should not hit this in normal use. You hit it when the script fails partway through and you fix-and-rerun without bumping again.

## Archive is much larger than expected

Common cause: build settings include device-architecture binaries you do not need. Check:

```bash
lipo -info dist/export-*/Payload/{{APP_NAME_NOSPACE}}.app/{{APP_NAME_NOSPACE}}
```

You should see `arm64` only (and possibly `arm64e` for iPhone 15+). If you see `x86_64`, simulator binary leaked in.

Other cause: too many resources. `du -sh dist/export-*/Payload/{{APP_NAME_NOSPACE}}.app/*` shows where the bytes are going.

## "Provisioning profile expired"

Profiles expire annually. Apple silently issues new ones the next time `-allowProvisioningUpdates` runs, but if you have manual signing or a stale cached profile, you can hit this.

Quickest fix:

```bash
# Force regeneration of all profiles for this app
rm -rf ~/Library/MobileDevice/Provisioning\ Profiles/*
xcodebuild -resolvePackageDependencies   # or just open Xcode once
./scripts/debug-testflight.sh "rebuild after profile refresh"
```

## "Apple ID password" prompt during xcodebuild

You are using legacy authentication. Switch to ASC API key:

- Set the team's signing in `project.yml` via `DEVELOPMENT_TEAM: {{TEAM_ID}}` and `CODE_SIGN_STYLE: Automatic`.
- Pass `-allowProvisioningUpdates` to `xcodebuild`.
- Make sure your ASC API key is in `~/.private_keys/`.

The CLI tools should not prompt for an Apple ID password if all of the above is configured.

## ASC REST API returns 401 Unauthorized

JWT issue. Common causes:

- **Token expired.** Tokens are valid for max 20 minutes. The script generates a fresh one per request, so this should not happen unless the system clock is wrong.
- **Wrong audience.** Must be `appstoreconnect-v1`.
- **Wrong algorithm.** Must be `ES256`, not `RS256` or `HS256`.
- **Wrong key ID in `kid` header.** Must match the .p8 you signed with.
- **Wrong issuer ID.** Per-team, not per-key. Get from the same ASC > Keys page.

Debug:

```bash
# Decode the JWT (header + payload, no signature verification)
echo "<token>" | cut -d. -f1 | base64 -d
echo "<token>" | cut -d. -f2 | base64 -d
```

Check the values match what you expect.

## ASC REST API returns 403 Forbidden

The API key has insufficient permissions. App Manager role is enough for upload + submit + version edits. Developer role is read-only.

## ASC REST API returns 409 Conflict on POST /v1/appStoreVersions

A version with the same `versionString` already exists for the platform. The script should detect this and use the existing version. If it does not, the version was probably created in the web UI for a previous attempt. Either delete it via the web UI and re-run, or modify the script to GET the existing version's ID.

## "Build not yet associated with a version" on submission

You tried to submit before the build attachment took effect. Wait 30 seconds after the PATCH to `/v1/appStoreVersions/{id}/relationships/build` before submitting. The script does this; if you see this manually, retry.

## Submission failed but build is uploaded fine

Recover via the web UI:

1. ASC > My Apps > YourApp > App Store tab > the version you tried to submit.
2. Verify the build is attached. If not, click + Build and select.
3. Verify "What's New", screenshots, etc. are all set.
4. Click "Add for Review" then "Submit for Review".

Then refine `submit-for-review.py` to handle whatever step you had to do manually.
