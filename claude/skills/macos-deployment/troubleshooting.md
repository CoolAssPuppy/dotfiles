# Troubleshooting

## "You're up to date" when an update is available

Three usual causes, in order of frequency:

**1. `CURRENT_PROJECT_VERSION` did not increase.**

Sparkle compares the build number, not the version string. If `release.sh` failed mid-bump or someone reverted `project.yml`, the new appcast item has the same `sparkle:version` as the installed copy and Sparkle treats them as equal.

```bash
# Check the live appcast
curl -sL {{DUB_SHORTLINK}} | grep sparkle:version | head -3

# Compare to the installed copy
defaults read /Applications/{{APP_NAME}}.app/Contents/Info.plist CFBundleVersion
```

The number in the latest `<item>` must be strictly greater than the installed copy.

**2. `pubDate` is malformed.**

Sparkle requires RFC 822 with a numeric timezone offset, not a name:

```
Mon, 01 Jan 2026 12:00:00 +0000     ✓ correct
Mon, 01 Jan 2026 12:00:00 GMT       ✗ Sparkle silently rejects this item
```

The release script uses `LC_ALL=C date -u +"%a, %d %b %Y %H:%M:%S +0000"` which always produces the correct format. If you hand-edit appcast items, double-check this.

**3. Dub.co cloaking turned on.**

Sparkle expects a 30x redirect at the feed URL. If cloaking/frame is on, Dub returns HTML wrapping the appcast in an iframe. Sparkle parses the HTML, finds no `<channel>`, and treats the feed as empty.

```bash
# This should print "location:" pointing at the R2 appcast URL
curl -sI {{DUB_SHORTLINK}} | grep -i '^location:'
```

If it returns HTML instead, fix in the Dub dashboard: Link settings > Cloaking > OFF.

## Signature verification failed during update

Two causes:

**1. Mismatched Ed25519 keys.**

The private key in your keychain does not match `SUPublicEDKey` in the shipped `Info.plist`. This happens after a key restore on a new machine produced the wrong pair.

```bash
# Print your current public key from keychain
~/bin/sparkle/generate_keys --account {{SPARKLE_KEY_ACCOUNT}} -p

# Compare to what shipped
defaults read /Applications/{{APP_NAME}}.app/Contents/Info.plist SUPublicEDKey
```

If they differ, **the shipped Info.plist is correct and the keychain is wrong.** Do not re-ship a new public key. Restore the matching private key from Doppler:

```bash
doppler secrets get SPARKLE_PRIVATE_KEY \
  --project {{DOPPLER_PROJECT}} --config {{DOPPLER_CONFIG}} --plain \
  > /tmp/sparkle-private.pem
~/bin/sparkle/generate_keys --account {{SPARKLE_KEY_ACCOUNT}} -f /tmp/sparkle-private.pem
rm -P /tmp/sparkle-private.pem
```

If Doppler does not have the private key, the key is lost and there is no recovery. Every installed copy is permanently stranded. You will need to ship a new app under a new bundle ID and shepherd users to migrate.

**2. DMG modified after `sign_update` ran.**

Anything that changes a single byte of the DMG invalidates the signature. The release script signs the DMG as the last step before upload, so this only happens if you manually intervene. Re-run `release.sh`.

## notarytool errors

**"Profile not found."**

Re-register the keychain profile:

```bash
xcrun notarytool store-credentials "{{NOTARY_PROFILE}}" \
  --apple-id "you@example.com" \
  --team-id "{{TEAM_ID}}" \
  --password "app-specific-password"
```

The password must be an [app-specific password](https://support.apple.com/en-us/HT204397), not your Apple ID password.

**"Invalid credentials" or "Authentication failed."**

App-specific passwords are tied to the Apple ID that generated them. If you changed your Apple ID password, all app-specific passwords are revoked. Generate a new one at appleid.apple.com and re-register.

**"The notarization request was rejected" with a submission ID.**

```bash
xcrun notarytool log <submission-id> --keychain-profile "{{NOTARY_PROFILE}}"
```

The log enumerates per-binary issues. Common ones: hardened runtime not enabled on a helper bundle, an embedded binary not signed by your team, or an entitlement that requires a profile your team does not have.

## OAuth callback hangs in Debug builds

Symptom: clicking "Sign in with Google/Microsoft/whatever" opens a browser, you authenticate, the browser redirects to the app, and nothing happens.

Cause: LaunchServices has multiple registered copies of the app (the DerivedData copy and the `dist/debug` copy). macOS routes the OAuth callback to the wrong one, which silently drops it because that copy does not have the pending session.

Fix is built into `debug.sh`:

```bash
LSREG="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
"$LSREG" -u "$DERIVED_APP" >/dev/null 2>&1 || true
rm -rf "$DERIVED_APP"
"$LSREG" -f "$DIST_APP" >/dev/null 2>&1 || true
```

If you have already accumulated multiple copies from manual builds, sweep them:

```bash
mdfind "kMDItemCFBundleIdentifier == {{BUNDLE_ID}}" | while read -r path; do
  /System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister -u "$path"
done
```

Then re-run `./scripts/debug.sh`.

## `xcodebuild test` fails with "Library not loaded: @rpath/...debug.dylib"

Xcode 15+ enables mergeable libraries, which split the host binary in Debug into `{{APP_NAME}}` plus `{{APP_NAME}}.debug.dylib`. The test bundle's rpath does not reach the host's MacOS directory and `dlopen` fails.

Fix lives in `project.yml`:

```yaml
configs:
  Debug:
    MERGED_BINARY_TYPE: manual
    MERGEABLE_LIBRARY: NO
```

This forces a statically merged Debug binary. Tests pass, app behavior is unchanged.

The bundled `project.yml` template includes this. If you ever delete it because "it looks weird," tests will break.

## `xcodebuild` fails with "No signing certificate found"

You probably do not have the Developer ID Application certificate installed.

```bash
security find-identity -v -p codesigning
```

You should see at least one `Developer ID Application: Your Name (TEAM_ID)`. If not, generate one in Apple Developer > Certificates and download the resulting `.cer`. Double-clicking imports it into Keychain Access. The matching private key must already be on this machine; if it is not, you are signing on the wrong Mac.

## `wrangler r2 object put` fails with 401 or 403

Cloudflare API token does not have R2 write access for the bucket. Regenerate the token in Cloudflare dashboard > My Profile > API Tokens with the "Edit Cloudflare Workers" template, or a custom token with R2 Storage > Edit on the specific bucket. Update the token in Doppler:

```bash
doppler secrets set CLOUDFLARE_API_TOKEN="..." \
  --project {{DOPPLER_PROJECT}} --config {{DOPPLER_CONFIG}}
```

## Test the appcast without shipping

Force-feed Sparkle a different appcast URL temporarily without re-shipping:

```bash
defaults write {{BUNDLE_ID}} SUFeedURL "https://your-test-url.example.com/appcast.xml"
```

Then trigger "Check for Updates..." manually. To revert:

```bash
defaults delete {{BUNDLE_ID}} SUFeedURL
```

Useful for debugging appcast format issues without burning a real release version.

## Hardened runtime breaks something

If a feature works in Debug but fails in Release, check whether it requires an entitlement that hardened runtime blocks by default. Common culprits:

- JIT compilation: needs `com.apple.security.cs.allow-jit`
- Loading unsigned libraries: needs `com.apple.security.cs.disable-library-validation`
- Apple Events to other apps: needs `com.apple.security.automation.apple-events`

Add the relevant entitlement to your `.entitlements` file. Hardened runtime denials usually log to Console.app under your app's process name with "Sandbox" or "amfi" in the message.
