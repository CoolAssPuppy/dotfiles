---
name: macos-deployment
description: Ship a macOS app from the command line without opening Xcode. Covers debug builds, Developer ID signing, notarization, DMG packaging, Sparkle auto-updates, and Cloudflare R2 distribution. Use when scaffolding a new macOS app, cutting a release, or debugging the release pipeline. Mirrors a battle-tested workflow.
---

# macOS deployment without Xcode

## When to use this skill

Invoke this skill when:

- Scaffolding a new macOS app that will ship outside the App Store (Developer ID + Sparkle).
- Cutting a release of an existing macOS app that already uses this workflow.
- Diagnosing a release pipeline failure (signature mismatch, notarization timeout, "you're up to date" bug, etc.).

Do not use this skill for App Store submissions. App Store macOS apps follow the iOS-style flow in the `ios-deployment` skill.

## What this skill provides

```
macos-deployment/
├── SKILL.md                  ← you are here
├── sparkle-setup.md          ← one-time: Sparkle keys, R2 bucket, appcast
├── release-workflow.md       ← deep dive on release.sh
├── troubleshooting.md        ← recovering from common failures
└── templates/
    ├── debug.sh              ← local Debug build + launch
    ├── release.sh            ← one-shot Developer ID release + upload
    ├── build-dmg.sh          ← DMG packaging + notarization + Sparkle sign
    ├── export-options.plist  ← xcodebuild export config
    ├── project.yml           ← XcodeGen scaffold (Sparkle SPM included)
    ├── Info.plist            ← Sparkle keys + version vars + URL schemes
    ├── entitlements          ← unsandboxed, hardened runtime
    ├── Secrets.xcconfig.example
    └── appcast-bootstrap.xml
```

Templates use `{{PLACEHOLDER}}` syntax. When scaffolding a new app, find-and-replace each placeholder before committing.

## Two workflows

### A. Scaffold a new macOS app

Six one-time steps. After these, releases are a single command.

1. **Gather project values** (see "Project values" below).
2. **Copy templates** to the new repo and fill in placeholders.
3. **Generate Sparkle EdDSA signing key** and back it up to your secret manager. See [sparkle-setup.md](sparkle-setup.md).
4. **Set up R2 bucket folder** (or your CDN of choice) for DMG and appcast hosting.
5. **Create a Dub.co shortlink** (or equivalent stable redirect) for the appcast feed URL.
6. **Register notarytool keychain profile** with `xcrun notarytool store-credentials`.

Detailed walkthrough in [sparkle-setup.md](sparkle-setup.md).

### B. Cut a release

Once steps 1-6 are done, a release is one command:

```bash
./scripts/release.sh 1.2.3 "<li>What changed.</li><li>Another thing.</li>"
```

The script does ten things in order: bumps version, regenerates Xcode project, archives, exports a Developer ID `.app`, notarizes and staples it, builds a signed and notarized DMG with Sparkle signature, uploads everything to R2, prepends a new item to `dist/appcast.xml`, uploads the appcast, and verifies the feed is live.

Full walkthrough in [release-workflow.md](release-workflow.md).

## Prerequisites (machine-wide, one-time)

Install these on every machine that will cut releases:

```bash
brew install xcodegen create-dmg
npm install -g wrangler   # or use 'npx wrangler' in scripts
brew install dopplerhq/cli/doppler
doppler login
```

Sparkle's `sign_update` binary lives inside the Sparkle SPM artifact directory, which only exists after Xcode resolves SPM dependencies. The setup walkthrough in [sparkle-setup.md](sparkle-setup.md) shows how to extract it and link it to a stable path like `~/bin/sparkle/sign_update`.

Notarization requires an app-specific password (not your Apple ID password). Generate one at appleid.apple.com, then store it in your keychain so the release script can use it without prompts:

```bash
xcrun notarytool store-credentials "{{NOTARY_PROFILE}}" \
  --apple-id "you@example.com" \
  --team-id "{{TEAM_ID}}" \
  --password "app-specific-password"
```

## Project values

When scaffolding, you will fill in these placeholders across every template file. Gather them first.

| Placeholder | Example | Where it comes from |
|---|---|---|
| `{{APP_NAME}}` | `Mail Notifier` | Display name with spaces |
| `{{APP_NAME_NOSPACE}}` | `MailNotifier` | Bare name for files, schemes, bundle |
| `{{BUNDLE_ID}}` | `com.example.MyApp` | Reverse-DNS, must match App Store Connect |
| `{{TEAM_ID}}` | `ABC123XYZ` | Apple Developer team ID |
| `{{SIGN_IDENTITY}}` | `Developer ID Application: Your Name (ABC123XYZ)` | `security find-identity -v -p codesigning` |
| `{{NOTARY_PROFILE}}` | `myapp` | Keychain profile name you choose |
| `{{SPARKLE_KEY_ACCOUNT}}` | `com.example.MyApp` | Per-app account name in keychain. Use the bundle ID so it never collides with another app's Sparkle key. |
| `{{R2_APP_FOLDER}}` | `myapp` | Subfolder under `apps/` in your bucket |
| `{{R2_BUCKET}}` | `your-downloads-bucket` | R2 bucket name |
| `{{R2_PUBLIC_BASE}}` | `https://downloads.example.com` | Public domain pointing at the bucket |
| `{{DUB_SHORTLINK}}` | `https://your-domain.com/myapp-updates` | Stable redirect; baked into the app forever |
| `{{DOPPLER_PROJECT}}` | `myproject` | Doppler project that holds R2 + Sparkle creds |
| `{{DOPPLER_CONFIG}}` | `prd` | Usually `prd` or `production` |
| `{{MIN_MACOS}}` | `14.0` | Earliest macOS version you support |
| `{{COMPANY}}` | `Your Company` | Copyright string |
| `{{COPYRIGHT_YEAR}}` | `2025` | Current year |

The `{{DUB_SHORTLINK}}` is the only value that, once shipped, can never change. The shortlink target can be repointed; the shortlink itself cannot, because it lives in `Info.plist` of every installed copy. Treat it like a permanent commitment.

## Daily commands

Once a project is scaffolded:

```bash
# Build a Debug copy and launch it (no Xcode UI)
./scripts/debug.sh

# Build only, do not launch
./scripts/debug.sh --no-launch

# Cut a release
./scripts/release.sh 1.2.3 "<li>Release notes in HTML.</li>"

# Run tests
xcodebuild -project {{APP_NAME_NOSPACE}}.xcodeproj -scheme {{APP_NAME_NOSPACE}} \
  -destination 'platform=macOS' test
```

After a successful release, commit `project.yml` (the bumped version) and `dist/appcast.xml` (the new item).

## Architecture (why this works)

Five decisions explain the rest of the workflow:

1. **XcodeGen is the source of truth.** `project.yml` is committed; `*.xcodeproj` is regenerated and gitignored. This eliminates merge conflicts in `pbxproj` files and makes project structure reviewable in plain YAML.
2. **No Xcode UI required.** Everything goes through `xcodebuild`, `xcrun notarytool`, `xcrun stapler`, `xcodegen`, `create-dmg`, and Sparkle's `sign_update`. Xcode itself is needed only to resolve SPM dependencies the first time (so Sparkle's tooling appears in DerivedData).
3. **Secrets in Doppler.** Cloudflare R2 credentials and the Sparkle private key (PEM backup) live in Doppler and are pulled at release time. Nothing sensitive in the repo.
4. **R2 with a public domain.** Cheap, fast, no egress fees, public CDN domain. The release script uploads the DMG twice: once to a versioned URL (`MyApp-1.2.3.dmg`) and once to a stable alias (`MyApp-latest.dmg`) so the marketing site can deep-link the latest build.
5. **Dub.co shortlink in front of the appcast.** The appcast URL baked into the app is the shortlink, not the R2 URL directly. If you ever need to move hosts, repoint the shortlink. If you bake the R2 URL into the app, you are stuck on R2 forever.

## Common failures

These are the high-frequency ones. Full diagnoses in [troubleshooting.md](troubleshooting.md).

- **"You're up to date" when an update is available.** Usually `CURRENT_PROJECT_VERSION` did not actually increment, or the appcast `pubDate` is malformed.
- **Signature verification failed during update.** The Ed25519 key in keychain does not match `SUPublicEDKey` in shipped `Info.plist`. The DMG was modified after `sign_update` ran.
- **`notarytool` profile not found.** Re-run `xcrun notarytool store-credentials` with the same profile name your `release.sh` expects.
- **OAuth callback hangs in Debug builds.** LaunchServices registered duplicate copies of the app (DerivedData copy and `dist/debug` copy). The bundled `debug.sh` mitigates this with `lsregister -u` plus `lsregister -f`.
- **`xcodebuild test` fails with "Library not loaded: @rpath/...debug.dylib".** Xcode 15+ mergeable libraries split the host binary in Debug. The bundled `project.yml` template forces `MERGED_BINARY_TYPE: manual` and `MERGEABLE_LIBRARY: NO` for Debug to fix this.

## Hard-earned lessons (do not skip)

- **Back up your Sparkle private key the day you generate it.** Sparkle has no key rotation. Lose the key and every installed copy is permanently stranded with no recovery.
- **Never reuse a Sparkle key across apps.** A compromise of one app's key would let an attacker push fake updates to every app sharing it.
- **Notarize the DMG too, not just the `.app` inside.** Sparkle verifies notarization before mounting the DMG. A notarized `.app` inside an unnotarized DMG fails Sparkle's pre-mount check.
- **Never amend a released `<item>` in `appcast.xml`.** If you ship a bad build, bump the version and ship a new one. Editing a published item silently breaks Sparkle's signature comparison.
- **The hardened runtime breaks XCTest in Debug.** Disable it for Debug only via `ENABLE_HARDENED_RUNTIME: NO` in the Debug config of `project.yml`. Release keeps it on.
