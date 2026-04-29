# App Store Connect API setup

One-time setup to authenticate your CLI to App Store Connect without using your Apple ID password or 2FA.

## Generate the API key

1. Go to [App Store Connect > Users and Access > Integrations > App Store Connect API](https://appstoreconnect.apple.com/access/integrations/api).
2. Click **Generate API Key** (or **+** if you have keys already).
3. Name: something descriptive like `ci-uploads` or `myapp-ci`.
4. Access: **App Manager** is enough for upload + submit. **Admin** if you also want to manage users.
5. Click **Generate**.

You get three pieces of information:

- **Issuer ID**: a UUID, the same for every key in your team. Visible at the top of the keys page.
- **Key ID**: 10-character ID, unique per key.
- **`.p8` file**: the private key. **You can only download it once.** If you lose it, regenerate the key.

## Store the .p8 file

`xcrun altool` looks in these locations by default:

```
./private_keys/AuthKey_<KEY_ID>.p8
~/private_keys/AuthKey_<KEY_ID>.p8
~/.private_keys/AuthKey_<KEY_ID>.p8
~/.appstoreconnect/private_keys/AuthKey_<KEY_ID>.p8
```

Recommended placement:

```bash
mkdir -p ~/.private_keys
mv ~/Downloads/AuthKey_*.p8 ~/.private_keys/
chmod 600 ~/.private_keys/AuthKey_*.p8
```

If you place the file there with the conventional name, you do not need to pass `--apiKeyPath` to `altool`. Only the `--apiKey <KEY_ID>` and `--apiIssuer <ISSUER_ID>` flags are required.

## Back up to your secret manager

Store the .p8 contents and metadata in Doppler so a new machine can rebuild the key file:

```bash
doppler secrets set ASC_KEY_ID="{{ASC_KEY_ID}}" \
  --project {{DOPPLER_PROJECT}} --config {{DOPPLER_CONFIG}}

doppler secrets set ASC_ISSUER_ID="{{ASC_ISSUER_ID}}" \
  --project {{DOPPLER_PROJECT}} --config {{DOPPLER_CONFIG}}

doppler secrets set ASC_PRIVATE_KEY="$(cat ~/.private_keys/AuthKey_{{ASC_KEY_ID}}.p8)" \
  --project {{DOPPLER_PROJECT}} --config {{DOPPLER_CONFIG}}
```

Restoring on a new machine:

```bash
mkdir -p ~/.private_keys
chmod 700 ~/.private_keys

doppler secrets get ASC_PRIVATE_KEY \
  --project {{DOPPLER_PROJECT}} --config {{DOPPLER_CONFIG}} --plain \
  > ~/.private_keys/AuthKey_{{ASC_KEY_ID}}.p8

chmod 600 ~/.private_keys/AuthKey_{{ASC_KEY_ID}}.p8
```

## Verify the key works

```bash
xcrun altool --list-providers \
  --apiKey {{ASC_KEY_ID}} \
  --apiIssuer {{ASC_ISSUER_ID}}
```

This should print one or more providers (your team or teams). An error here means the key is wrong, expired, or not in the search path.

For more granular verification using the ASC REST API directly, see the JWT mechanics below.

## How the JWT auth works

The ASC REST API and `altool` both authenticate with a JWT signed by your .p8 key. You usually do not see this directly because `altool` handles it for you. But for `submit-for-review.py` and any custom REST calls, you need to know:

The JWT has these claims:

```json
{
  "iss": "<ASC_ISSUER_ID>",
  "iat": <unix-timestamp>,
  "exp": <iat + 1200>,
  "aud": "appstoreconnect-v1",
  "scope": ["GET /v1/apps", ...]
}
```

Header:

```json
{
  "alg": "ES256",
  "kid": "<ASC_KEY_ID>",
  "typ": "JWT"
}
```

Signed with the .p8 (ECDSA with the P-256 curve, SHA-256). Maximum lifetime is 20 minutes (`iat + 1200`).

In Python with `pyjwt`:

```python
import time, jwt

with open(KEY_PATH) as f:
    private_key = f.read()

now = int(time.time())
token = jwt.encode(
    {
        "iss": ISSUER_ID,
        "iat": now,
        "exp": now + 1200,
        "aud": "appstoreconnect-v1",
    },
    private_key,
    algorithm="ES256",
    headers={"kid": KEY_ID, "typ": "JWT"},
)

# Use as: Authorization: Bearer <token>
```

The bundled `templates/submit-for-review.py` does this for you.

## Permissions cheat sheet

- **App Manager**: enough for upload + submit + edit version metadata. Use this for CI keys.
- **Developer**: read-only for most things; cannot submit. Insufficient for the release script.
- **Admin**: full access including user management. Overkill for CI.

## When to rotate the key

- **Every 12 months** as a baseline.
- **Immediately** if a machine with the key is lost or stolen, or if the .p8 file might have been committed to git.

To rotate:

1. Generate a new key in ASC.
2. Replace the .p8 file in `~/.private_keys/`.
3. Update Doppler secrets.
4. Revoke the old key from the ASC keys page.
