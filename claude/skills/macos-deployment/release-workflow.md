# Release workflow

This is what `./scripts/release.sh 1.2.3 "<li>Notes</li>"` actually does, in order. Read this before modifying the release script.

## Prerequisites the script enforces at startup

- `xcodegen` on PATH
- `xcodebuild` on PATH (Xcode command-line tools)
- `create-dmg` on PATH (`brew install create-dmg`)
- `doppler` on PATH and authenticated for `{{DOPPLER_PROJECT}}/{{DOPPLER_CONFIG}}`
- `python3` on PATH (used for inline plist + appcast manipulation)
- `wrangler` on PATH or `npx wrangler` working
- Sparkle `sign_update` at `$HOME/bin/sparkle/sign_update` (or `SPARKLE_SIGN_UPDATE` env var pointing to it)
- A registered notarytool keychain profile named `{{NOTARY_PROFILE}}`

If any of these are missing the script exits before touching anything.

## Required Doppler secrets

The script pulls these from `{{DOPPLER_PROJECT}}/{{DOPPLER_CONFIG}}`:

- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_ACCOUNT_ID`
- `R2_BUCKET_NAME` (defaults to `{{R2_BUCKET}}` if not set)
- `R2_PUBLIC_BASE_URL` (defaults to `{{R2_PUBLIC_BASE}}` if not set)
- `SPARKLE_PRIVATE_KEY` (only needed if restoring on a new machine, see [sparkle-setup.md](sparkle-setup.md))

## The 10 steps

### 1. Bump version in project.yml

Reads the current `CURRENT_PROJECT_VERSION` from `project.yml`, increments it by 1, and rewrites both `MARKETING_VERSION` (the user-facing version like `1.2.3`) and `CURRENT_PROJECT_VERSION` (the monotonic build number Sparkle uses to compare).

The build number must be monotonically increasing. The version string can be anything semver-shaped.

### 2. Regenerate Xcode project

`xcodegen generate` rewrites `{{APP_NAME_NOSPACE}}.xcodeproj` from `project.yml`. Without this step, the version bump is silently lost.

### 3. Archive

```
xcodebuild -project ... -scheme {{APP_NAME_NOSPACE}} -configuration Release \
  -archivePath dist/{{APP_NAME_NOSPACE}}-<version>.xcarchive \
  -allowProvisioningUpdates archive
```

`-allowProvisioningUpdates` is required when entitlements (e.g. iCloud KVS) need a Developer ID provisioning profile that Xcode has not yet downloaded.

### 4. Export Developer ID `.app`

```
xcodebuild -exportArchive \
  -archivePath dist/{{APP_NAME_NOSPACE}}-<version>.xcarchive \
  -exportPath dist/export-<version> \
  -exportOptionsPlist scripts/export-options.plist \
  -allowProvisioningUpdates
```

`scripts/export-options.plist` declares `method: developer-id`. The output is `dist/export-<version>/{{APP_NAME}}.app`.

### 5. Notarize and staple the `.app`

```
ditto -c -k --sequesterRsrc --keepParent <app> <zip>
xcrun notarytool submit <zip> --keychain-profile {{NOTARY_PROFILE}} --wait
xcrun stapler staple <app>
xcrun stapler validate <app>
```

`--wait` blocks until Apple's notarization service responds. Typical time: 1-5 minutes. The `.zip` is throwaway.

### 6. Build, notarize, and Sparkle-sign the DMG

`scripts/build-dmg.sh` runs `create-dmg` with the project's background art and icon positions, then:

```
codesign --force --sign "{{SIGN_IDENTITY}}" --timestamp <dmg>
xcrun notarytool submit <dmg> --keychain-profile {{NOTARY_PROFILE}} --wait
xcrun stapler staple <dmg>
xcrun stapler validate <dmg>
spctl -a -t open --context context:primary-signature -v <dmg>
~/bin/sparkle/sign_update --account {{SPARKLE_KEY_ACCOUNT}} <dmg>
```

The DMG must itself be notarized and stapled, not just the `.app` inside. Sparkle verifies notarization before mounting the DMG; an unnotarized DMG fails the pre-mount check even if the inner `.app` is fine.

The `sign_update` output (a one-line string with `sparkle:edSignature` and `length` attributes) is captured to `dist/{{APP_NAME_NOSPACE}}-<version>.sparkle.txt` for the appcast step.

### 7. Pull Cloudflare R2 credentials from Doppler

`doppler secrets get` fetches the four R2-related secrets. Defaults kick in if the optional ones are not set.

### 8. Upload the DMG to R2

Two uploads to two paths:

- `apps/{{R2_APP_FOLDER}}/{{APP_NAME_NOSPACE}}-<version>.dmg` (versioned, immutable URL)
- `apps/{{R2_APP_FOLDER}}/{{APP_NAME_NOSPACE}}-latest.dmg` (stable alias overwritten every release)

Both use `wrangler r2 object put --remote`. The `--remote` flag matters: without it, wrangler writes to a local emulator and you wonder for an hour why the URL is 404ing.

### 9. Update appcast.xml and upload it

The script extracts `sparkle:edSignature` and `length` from the `.sparkle.txt` artifact, formats a current `pubDate` (RFC 822 in UTC), then prepends a new `<item>` to `dist/appcast.xml` after the `<language>en</language>` marker. The marker has to exist in the appcast, otherwise the script bails.

The new item looks like:

```xml
<item>
  <title>Version 1.2.3</title>
  <pubDate>Mon, 01 Jan 2026 12:00:00 +0000</pubDate>
  <sparkle:version>42</sparkle:version>
  <sparkle:shortVersionString>1.2.3</sparkle:shortVersionString>
  <sparkle:minimumSystemVersion>{{MIN_MACOS}}</sparkle:minimumSystemVersion>
  <description><![CDATA[
    <ul>
      <li>What changed.</li>
    </ul>
  ]]></description>
  <enclosure
    url="{{R2_PUBLIC_BASE}}/apps/{{R2_APP_FOLDER}}/{{APP_NAME_NOSPACE}}-1.2.3.dmg"
    sparkle:edSignature="..."
    length="123456789"
    type="application/x-apple-diskimage" />
</item>
```

Then uploads `dist/appcast.xml` to `apps/{{R2_APP_FOLDER}}/appcast.xml` in R2.

### 10. Verify

Three curl checks confirm everything is live:

```bash
curl -sI {{R2_PUBLIC_BASE}}/apps/{{R2_APP_FOLDER}}/{{APP_NAME_NOSPACE}}-<version>.dmg
curl -sI {{R2_PUBLIC_BASE}}/apps/{{R2_APP_FOLDER}}/appcast.xml
curl -sL {{DUB_SHORTLINK}} | grep -E '<(title|sparkle:shortVersionString|enclosure)'
```

The third check follows the Dub redirect. If it returns HTML instead of XML, cloaking got turned on in the Dub dashboard and Sparkle will silently break.

## After the script finishes

Commit `project.yml` (the bumped version) and `dist/appcast.xml` (the new item). Push to your release branch. The release is complete.

## Manual verification on a previous version

On a machine running an older copy of the app:

1. Status bar icon (or the equivalent menu in your app) > "Check for Updates..."
2. You should see the update prompt with your release notes.
3. Let it download and install.

If the check says "You're up to date", see [troubleshooting.md](troubleshooting.md). The most common cause is that `CURRENT_PROJECT_VERSION` did not actually increase.
