# Sparkle setup (one-time per app)

Sparkle 2 ships with the app and gives users "Check for Updates..." in the menu, plus daily automatic checks. This document covers the one-time setup required for a new macOS app.

The release script handles everything that happens on every release. Steps 1-5 below happen once, ever.

## URLs you will end up with

For an app called `MyApp` with R2 folder `myapp` and shortlink `https://your-domain.com/myapp-updates`, the URLs look like this:

- **Feed (baked into the app)**: `https://your-domain.com/myapp-updates` (Dub shortlink)
- **Appcast destination**: `https://downloads.example.com/apps/myapp/appcast.xml`
- **DMG pattern**: `https://downloads.example.com/apps/myapp/MyApp-<version>.dmg`
- **Latest DMG (stable alias)**: `https://downloads.example.com/apps/myapp/MyApp-latest.dmg` (overwritten on every release)

## 1. Generate the signing key

Sparkle's `generate_keys` tool creates an Ed25519 key pair. The private key lives in the macOS keychain. **If you lose it, every installed copy is permanently stranded.** There is no recovery.

If you already have a Sparkle key from another project, **do not reuse it**. Each app gets its own key so a compromise in one app does not let an attacker push fake updates to another.

After running `./scripts/debug.sh` once (or opening the project in Xcode) so SPM resolves Sparkle, the tool is at:

```
~/Library/Developer/Xcode/DerivedData/{{APP_NAME_NOSPACE}}-*/SourcePackages/artifacts/sparkle/Sparkle/bin/generate_keys
```

For convenience, link the binaries to a stable path:

```bash
mkdir -p ~/bin/sparkle
ln -sf ~/Library/Developer/Xcode/DerivedData/{{APP_NAME_NOSPACE}}-*/SourcePackages/artifacts/sparkle/Sparkle/bin/generate_keys ~/bin/sparkle/generate_keys
ln -sf ~/Library/Developer/Xcode/DerivedData/{{APP_NAME_NOSPACE}}-*/SourcePackages/artifacts/sparkle/Sparkle/bin/sign_update ~/bin/sparkle/sign_update
```

Run `generate_keys` with a per-app keychain account name so it does not collide with other Sparkle keys:

```bash
~/bin/sparkle/generate_keys --account {{SPARKLE_KEY_ACCOUNT}}
```

It will:
- Create a new key pair on first run, or print the existing public key on later runs.
- Store the private key in the login keychain under "Private key for signing Sparkle updates" with account `{{SPARKLE_KEY_ACCOUNT}}`.
- Print the base64 **public** key to stdout.

Copy the public key. You will paste it in step 4.

## 2. Back up the private key now

Keychain Access cannot export the Sparkle private key directly. Use `generate_keys -x` to dump it to a PEM file:

```bash
~/bin/sparkle/generate_keys --account {{SPARKLE_KEY_ACCOUNT}} -x ~/sparkle-private.pem
```

Store the PEM contents in your password manager or secret manager. Then wipe the local file:

```bash
doppler secrets set SPARKLE_PRIVATE_KEY="$(cat ~/sparkle-private.pem)" \
  --project {{DOPPLER_PROJECT}} --config {{DOPPLER_CONFIG}}
rm -P ~/sparkle-private.pem
```

### Restoring the private key on a new machine

Pull the PEM from Doppler and re-import:

```bash
doppler secrets get SPARKLE_PRIVATE_KEY \
  --project {{DOPPLER_PROJECT}} --config {{DOPPLER_CONFIG}} --plain \
  > /tmp/sparkle-private.pem

~/bin/sparkle/generate_keys --account {{SPARKLE_KEY_ACCOUNT}} -f /tmp/sparkle-private.pem

rm -P /tmp/sparkle-private.pem
```

Verify the restore by running `~/bin/sparkle/generate_keys --account {{SPARKLE_KEY_ACCOUNT}} -p` and comparing the printed public key to `SUPublicEDKey` in `Info.plist`. If they differ, the restore produced a mismatched pair and any DMG signed with it will fail verification on installed apps.

## 3. Confirm the R2 bucket layout

Each app lives under `apps/<app-folder>/` in your R2 bucket. The release script handles the actual uploads. To confirm the layout works:

```bash
echo "ok" | wrangler r2 object put {{R2_BUCKET}}/apps/{{R2_APP_FOLDER}}/healthcheck.txt --remote
curl -sI {{R2_PUBLIC_BASE}}/apps/{{R2_APP_FOLDER}}/healthcheck.txt | head -1
wrangler r2 object delete {{R2_BUCKET}}/apps/{{R2_APP_FOLDER}}/healthcheck.txt --remote
```

Seed the bucket with the bootstrap appcast (an empty channel) so the URL exists before your first release:

```bash
wrangler r2 object put {{R2_BUCKET}}/apps/{{R2_APP_FOLDER}}/appcast.xml \
  --file=templates/appcast-bootstrap.xml \
  --content-type="application/xml; charset=utf-8" \
  --remote
```

## 4. Create the Dub.co shortlink

This is the URL baked into every shipped copy of the app. Create it once in the Dub dashboard:

- **Short URL**: `{{DUB_SHORTLINK}}`
- **Destination URL**: `{{R2_PUBLIC_BASE}}/apps/{{R2_APP_FOLDER}}/appcast.xml`

Settings that matter:

- **Cloaking/frame: OFF.** Sparkle needs a plain HTTP redirect, not an iframe wrapper. If cloaking is on, the appcast feed appears as HTML and Sparkle silently fails.
- **Password: OFF.**
- **Link expiration: OFF.**

Test the redirect:

```bash
curl -sI "{{DUB_SHORTLINK}}" | grep -i '^location:'
```

Expected: a `location:` header pointing at the R2 appcast URL.

**The slug is permanent.** The destination URL can be repointed any time. The slug cannot be changed without re-shipping every installed copy of the app.

## 5. Paste the public key into Info.plist

Open the project's `Info.plist` and replace the placeholder with the base64 public key from step 1:

```xml
<key>SUPublicEDKey</key>
<string>PASTE_BASE64_PUBLIC_KEY_HERE</string>
```

Confirm `SUFeedURL` is set to your Dub shortlink:

```xml
<key>SUFeedURL</key>
<string>{{DUB_SHORTLINK}}</string>
```

Commit `Info.plist`.

## 6. Register the notarytool keychain profile

Generate an [app-specific password](https://support.apple.com/en-us/HT204397) at appleid.apple.com. Use that, not your Apple ID password.

```bash
xcrun notarytool store-credentials "{{NOTARY_PROFILE}}" \
  --apple-id "you@example.com" \
  --team-id "{{TEAM_ID}}" \
  --password "app-specific-password"
```

Verify:

```bash
xcrun notarytool history --keychain-profile "{{NOTARY_PROFILE}}"
```

You should see an empty history (or past submissions if reusing a profile). An error means the profile name is wrong or credentials are invalid.

## You are done

After step 6, you can cut a release with:

```bash
./scripts/release.sh 1.0.0 "<li>Initial release.</li>"
```

See [release-workflow.md](release-workflow.md) for what happens during a release.
