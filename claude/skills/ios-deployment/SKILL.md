---
name: ios-deployment
description: Ship an iOS app from the command line without opening Xcode. Covers archive, IPA export, App Store Connect API authentication, TestFlight upload (debug builds), and App Store submission (release builds). First-pass workflow inspired by the macos-deployment skill. Use when scaffolding a new iOS app, sending a build to TestFlight, or submitting to the App Store.
---

# iOS deployment without Xcode

> **Status: first pass, not yet battle-tested.** This skill captures Apple's documented CLI workflow but has not been validated end to end on a real submission. Sections marked `> NOT YET TESTED` are best-effort and should be verified on the first real run. Refine this skill after each release.

The 99.9% goal: open Xcode only for asset catalogs (icons, launch screens), interface builders if any, and the rare interactive provisioning prompt. Everything else lives in scripts.

## When to use this skill

- Scaffolding a new iOS app to use the CLI workflow.
- Sending a build to TestFlight (internal beta or external testers).
- Submitting a release to the App Store for review.
- Diagnosing upload or submission failures (ITMS-90xxx errors, signing, provisioning).

Do not use this skill for macOS apps. Use `macos-deployment` for those.

## What this skill provides

```
ios-deployment/
├── SKILL.md                    ← you are here
├── asc-api-setup.md            ← one-time: ASC API key, JWT mechanics
├── testflight-flow.md          ← debug → TestFlight, in detail
├── app-store-flow.md           ← release → App Store (NOT YET TESTED in places)
├── troubleshooting.md          ← signing, ITMS errors, processing delays
└── templates/
    ├── debug-testflight.sh         ← bump build, archive, export, upload
    ├── release-app-store.sh        ← bump version, archive, export, upload, submit
    ├── export-options.plist        ← method: app-store-connect
    ├── project.yml                 ← iOS XcodeGen scaffold
    ├── Info.plist                  ← iOS-style
    ├── entitlements                ← empty by default
    ├── submit-for-review.py        ← ASC REST API submitter (NOT YET TESTED)
    └── Secrets.xcconfig.example
```

Templates use `{{PLACEHOLDER}}` syntax. Find-and-replace each placeholder when scaffolding a new app.

## Two workflows

### A. Send a build to TestFlight (debug or beta)

After the one-time setup, this is one command:

```bash
./scripts/debug-testflight.sh "<changelog text>"
```

The script bumps `CURRENT_PROJECT_VERSION` (build number), regenerates the Xcode project, archives Release, exports an IPA with `app-store-connect` method, and uploads it to App Store Connect via `xcrun altool`. The build appears in TestFlight after Apple finishes processing (usually 5-30 minutes). Internal testers see it immediately. External testers require beta review (1-2 days).

Internal testing is for the dev team, no review needed. External testing is for outside testers, needs Apple's beta review the first time.

Full details in [testflight-flow.md](testflight-flow.md).

### B. Submit a release to the App Store

```bash
./scripts/release-app-store.sh 1.2.3 "<release notes>"
```

The script does everything `debug-testflight.sh` does, then additionally calls the App Store Connect REST API to:

1. Create a new App Store version (if one for `1.2.3` does not already exist).
2. Attach the just-uploaded build to that version.
3. Submit the version for review.

> **NOT YET TESTED.** The submission step is implemented in `templates/submit-for-review.py` based on Apple's ASC REST API documentation, but has not been run against a real submission. On the first release, run the script up through the upload step, then manually verify and submit through the ASC web UI. Once the manual submission works, run `submit-for-review.py` against a known-good submission to confirm parity.

Full details in [app-store-flow.md](app-store-flow.md).

## The 1% you still need Xcode for

- **Asset catalog editing.** App icon image sets, launch screens. CLI tools exist but are awkward.
- **Capabilities the first time.** Adding push notifications, App Groups, iCloud, etc. to the App ID. Once enabled in the Apple Developer portal, the entitlement file drives the rest from CLI.
- **Initial app metadata.** First-time App Store Connect setup: app name, description, screenshots, keywords, age rating, pricing. After that, the REST API can update most fields, but the first creation is web-only.
- **Beta tester invites.** Adding external TestFlight testers and groups. The REST API can do it, but the web UI is the path of least resistance.

Everything else is scripts.

## Prerequisites (machine-wide, one-time)

```bash
brew install xcodegen
# Xcode + command-line tools must be installed and selected
xcode-select -p   # should print /Applications/Xcode.app/Contents/Developer
```

Optional (for `submit-for-review.py`):

```bash
python3 -m pip install pyjwt requests
```

## Project values

When scaffolding, fill in these placeholders.

| Placeholder | Example | Source |
|---|---|---|
| `{{APP_NAME}}` | `MyApp` | Display name |
| `{{APP_NAME_NOSPACE}}` | `MyApp` | iOS scheme + bundle name (usually no spaces) |
| `{{BUNDLE_ID}}` | `com.example.MyApp` | Reverse-DNS, must match App Store Connect |
| `{{TEAM_ID}}` | `ABC123XYZ` | Apple Developer team ID |
| `{{ASC_KEY_ID}}` | `2X9Y8Z7W6V` | App Store Connect API key ID |
| `{{ASC_ISSUER_ID}}` | `69a6de8a-...` | UUID, per-team in ASC |
| `{{ASC_APP_ID}}` | `1234567890` | Numeric App Store Connect "Apple ID" of the app |
| `{{MIN_IOS}}` | `17.0` | Minimum iOS version |
| `{{DEVICE_FAMILY}}` | `1` (iPhone), `2` (iPad), `1,2` (Universal) | TARGETED_DEVICE_FAMILY |
| `{{DOPPLER_PROJECT}}` | `myproject` | Doppler project for ASC creds |
| `{{DOPPLER_CONFIG}}` | `prd` | Doppler config |

The ASC API .p8 file goes in `~/.private_keys/AuthKey_<KEY_ID>.p8` (where `altool` looks by default). See [asc-api-setup.md](asc-api-setup.md).

## Daily commands

```bash
# Send a build to TestFlight
./scripts/debug-testflight.sh "Fixed login bug, improved settings UI"

# Submit a release for review
./scripts/release-app-store.sh 1.2.3 "What's new in 1.2.3"

# Verify a recent upload status
xcrun altool --list-providers --apiKey {{ASC_KEY_ID}} --apiIssuer {{ASC_ISSUER_ID}}
```

## Architecture (why this works)

1. **XcodeGen as source of truth.** Same as macos-deployment. `project.yml` is committed; `*.xcodeproj` is regenerated and gitignored.
2. **App Store Connect API key, not Apple ID password.** `.p8` key file with JWT signing. Scriptable, no 2FA prompts.
3. **One IPA, two destinations.** Both TestFlight and App Store use `method: app-store-connect` in the export options. The IPA itself is identical; what differs is whether you submit it for review afterward.
4. **`xcrun altool --upload-app` for upload.** Apple's officially supported tool. Reliable, handles app thinning automatically, prints clear ITMS errors when validation fails. The deprecated `--upload-app` notice you may have seen is for the older Apple ID auth path; ASC API key auth is supported and current.
5. **REST API for submission orchestration.** `altool` uploads the build but cannot submit a version for review. The ASC REST API does that. JWT-signed requests with the same .p8 key.

## Common failures

- **`No accounts with iTunes Connect access`**. ASC API key is missing or path is wrong. See [asc-api-setup.md](asc-api-setup.md).
- **`ITMS-90xxx` after upload**. App Store validation rejected the IPA. The error text usually names the file or key. See [troubleshooting.md](troubleshooting.md).
- **Build does not appear in TestFlight after upload**. Usually still processing (5-30 min). If it never appears, the IPA was rejected. Check the email Apple sends to the team's Account Holder.
- **"This bundle is invalid" with no further detail**. Almost always a missing or wrong icon set. iOS rejects builds without the full required icon set.

## Hard-earned conventions (apply from day one)

- **Use Apple's automatic signing.** Manual signing with provisioning profile files is a treadmill. Automatic signing with the ASC API key works for both Debug device builds and Release App Store distribution.
- **Build numbers are monotonic across the app's lifetime.** Not per-version. A build number `42` cannot be reused for a different upload, ever, regardless of marketing version. The release scripts increment by 1 every time.
- **Marketing version is whatever you want.** Semantic versioning is conventional; Apple does not enforce a format.
- **Keep the .p8 file out of git.** Store it in `~/.private_keys/` and back up the key contents to your secret manager.
- **Test the upload before testing the submit.** TestFlight upload is the more common operation; you will run it many times before each App Store submission. Get that flow boringly reliable first. App Store submission can stay manual for the first few releases.
