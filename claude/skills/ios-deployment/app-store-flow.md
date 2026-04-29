# App Store flow

What `./scripts/release-app-store.sh 1.2.3 "<release notes>"` does.

> **Status: first pass, NOT YET TESTED end to end.** The upload portion (steps 1-5) is identical to TestFlight and is reliable. The version-creation and submit-for-review portion (steps 6-8) uses the App Store Connect REST API and has not been validated against a real submission. Treat the submission script as a starting point; on the first release, run through step 5 then complete the submission manually in the ASC web UI. Once that works, validate `submit-for-review.py` against a known-good outcome and refine.

## The big picture

App Store submission has more moving parts than TestFlight because it requires:

- **A version record**: the App Store Connect entity that holds release notes, "What's New", and the build assignment for a specific marketing version.
- **A build attachment**: linking the just-uploaded build to that version.
- **A submission**: explicitly submitting the version for Apple's review.

`altool` only uploads the build. Everything after that needs the REST API or the web UI.

## The 8 steps

Steps 1-5 are identical to TestFlight. Steps 6-8 are App Store-specific.

### 1-5. Bump, regenerate, archive, export, upload

Same as TestFlight. See [testflight-flow.md](testflight-flow.md). The difference is that `MARKETING_VERSION` is updated to the argument (e.g. `1.2.3`) in addition to bumping the build number.

After step 5, the build is uploaded and processing in App Store Connect. It will eventually appear in TestFlight (same as a TestFlight upload) and will also be available to attach to an App Store version.

### 6. Wait for processing to complete

> **NOT YET TESTED.** Submission requires that the build has finished processing. Currently the script polls the REST API.

The script polls:

```
GET /v1/builds?filter[app]={{ASC_APP_ID}}&filter[version]=<build>&fields[builds]=processingState
```

Until `processingState` is `VALID` (meaning ready to use). Other states: `PROCESSING`, `INVALID`, `FAILED`.

Typical processing time: 5-30 minutes. The script polls every 30 seconds with a 60-minute timeout.

### 7. Create or update the App Store version

> **NOT YET TESTED.**

```
POST /v1/appStoreVersions
```

with body:

```json
{
  "data": {
    "type": "appStoreVersions",
    "attributes": {
      "platform": "IOS",
      "versionString": "1.2.3",
      "releaseType": "MANUAL"
    },
    "relationships": {
      "app": {
        "data": { "type": "apps", "id": "{{ASC_APP_ID}}" }
      }
    }
  }
}
```

`releaseType: MANUAL` means after Apple approves, the release waits for you to push the "Release this version" button. `AUTOMATIC` releases immediately on approval. `SCHEDULED` releases at a specified date.

If a version with the same `versionString` already exists for the platform, this returns 409 Conflict. The script should detect this and use the existing version's ID instead of creating a new one. **Watch for this on the first run.**

### 8. Attach build, set release notes, and submit

> **NOT YET TESTED.**

Three sequential REST calls:

```
PATCH /v1/appStoreVersions/{version-id}
```

with body containing the new release notes ("What's New in This Version"):

```json
{
  "data": {
    "type": "appStoreVersionLocalizations",
    "id": "<localization-id>",
    "attributes": {
      "whatsNew": "<release notes text>"
    }
  }
}
```

The localization ID is found by GET-ing `/v1/appStoreVersions/{id}/appStoreVersionLocalizations` and picking the locale you want (usually `en-US`). The script handles this lookup.

Next, attach the build:

```
PATCH /v1/appStoreVersions/{version-id}/relationships/build
```

with body:

```json
{
  "data": { "type": "builds", "id": "<build-id>" }
}
```

Finally, submit for review:

```
POST /v1/reviewSubmissions
```

(then add the version to the submission and submit). The REST API has a slightly tortuous structure here; `submit-for-review.py` handles the dance.

After submission, Apple reviews. Typical turnaround: 24-72 hours. You receive email when approved or rejected.

## What can go wrong on a real submission

These are the issues the script does not yet handle gracefully:

- **App not yet "Ready for Review."** Some metadata fields might be missing (screenshots, age rating, privacy policy URL). The script will get a 400 response. Fix metadata in the web UI; once "Submit for Review" appears as a button there, the script will succeed.
- **"What's New" required for non-first releases.** First release allows empty. Subsequent releases require non-empty `whatsNew`. The script always sets it.
- **Export compliance not configured.** If your app uses encryption (most do, even if just HTTPS), you may need to declare export compliance once per version. ASC will block submission until you do.
- **Pricing or availability not set.** First release requires pricing. The script does not handle this; do it in the web UI.
- **Age rating not declared.** Same — first release only.

> **Recommendation: do the first 1-2 App Store submissions manually through the ASC web UI.** Watch what fields it asks for. After you have a working manual submission, run `submit-for-review.py` against a follow-up submission to confirm it produces the same result. Refine the script based on what it gets wrong.

## Manual fallback when the script fails

If `submit-for-review.py` fails partway through:

1. **Build uploaded but version not created**: log into ASC web UI, go to the app, "Add Version" with the marketing version, attach the build, submit.
2. **Version created but build not attached**: in the web UI version page, click the "+ Build" button under "Build" and select the build.
3. **Build attached but submission failed**: in the web UI, click "Add for Review" then "Submit for Review".

The script logs which step failed so you know where to pick up manually.

## Release strategy after Apple approval

If `releaseType: MANUAL` (the default in `release-app-store.sh`):

- After Apple approves the build, the version sits in "Pending Developer Release" state.
- Click "Release This Version" in ASC when you want it live. Typically 1-2 hours from button-press to actual rollout to the App Store.

If you used `AUTOMATIC`:

- Apple's approval triggers the release immediately. Useful for non-time-sensitive shipping. Risky if you wanted to coordinate with marketing or social.

## Phased release

For automatic releases, App Store Connect supports phased rollout: 1% > 2% > 5% > 10% > 20% > 50% > 100% over 7 days. To enable, set `releaseType: AFTER_APPROVAL` and toggle the phased release option in the version settings before submission.

> **NOT YET TESTED**. The script does not currently configure phased release. Add it manually in the web UI before clicking submit if you want it.

## After release

Commit `project.yml` (the bumped version + build) and any other generated artifacts. Tag the commit:

```bash
git commit -am "Release 1.2.3"
git tag v1.2.3
git push origin main --tags
```

The script does not currently automate the commit or tag; they belong to you.
