#!/usr/bin/env python3
"""
Submit an iOS App Store version for review via the App Store Connect REST API.

NOT YET TESTED end to end. This is a first-pass implementation based on
Apple's documented API. On the first real release, run release-app-store.sh
up through the upload step, then submit manually via the ASC web UI. Once
manual submission works, validate this script against a known-good outcome
and refine.

Usage:
    submit-for-review.py \\
        --key-path ~/.private_keys/AuthKey_KEYID.p8 \\
        --key-id KEYID \\
        --issuer-id ISSUERID \\
        --app-id 1234567890 \\
        --version 1.2.3 \\
        --build 42 \\
        --release-notes "What's new in this release"

Required Python packages: pyjwt, requests
"""

import argparse
import json
import sys
import time
from pathlib import Path

try:
    import jwt
    import requests
except ImportError:
    sys.exit("Run: python3 -m pip install pyjwt requests")


ASC_BASE = "https://api.appstoreconnect.apple.com/v1"


def make_token(key_path: Path, key_id: str, issuer_id: str) -> str:
    """Build a 20-minute JWT for ASC API auth."""
    private_key = key_path.read_text()
    now = int(time.time())
    return jwt.encode(
        {
            "iss": issuer_id,
            "iat": now,
            "exp": now + 1200,
            "aud": "appstoreconnect-v1",
        },
        private_key,
        algorithm="ES256",
        headers={"kid": key_id, "typ": "JWT"},
    )


def asc_get(token: str, path: str, params: dict | None = None) -> dict:
    r = requests.get(
        f"{ASC_BASE}{path}",
        headers={"Authorization": f"Bearer {token}"},
        params=params or {},
    )
    if r.status_code >= 400:
        sys.exit(f"GET {path} failed [{r.status_code}]: {r.text}")
    return r.json()


def asc_post(token: str, path: str, body: dict) -> dict:
    r = requests.post(
        f"{ASC_BASE}{path}",
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        data=json.dumps(body),
    )
    if r.status_code >= 400:
        sys.exit(f"POST {path} failed [{r.status_code}]: {r.text}")
    return r.json() if r.text else {}


def asc_patch(token: str, path: str, body: dict) -> dict:
    r = requests.patch(
        f"{ASC_BASE}{path}",
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        data=json.dumps(body),
    )
    if r.status_code >= 400:
        sys.exit(f"PATCH {path} failed [{r.status_code}]: {r.text}")
    return r.json() if r.text else {}


def find_build(token: str, app_id: str, build_number: str) -> str:
    """Wait for the build to finish processing, return its ASC build ID."""
    deadline = time.time() + 60 * 60  # 60 minutes
    print(f"Polling for build {build_number} to finish processing...")
    while time.time() < deadline:
        resp = asc_get(
            token,
            "/builds",
            {
                "filter[app]": app_id,
                "filter[version]": build_number,
                "fields[builds]": "version,processingState,uploadedDate",
                "limit": 1,
            },
        )
        builds = resp.get("data", [])
        if builds:
            state = builds[0]["attributes"]["processingState"]
            if state == "VALID":
                print(f"  Build is VALID. ID: {builds[0]['id']}")
                return builds[0]["id"]
            elif state in {"INVALID", "FAILED"}:
                sys.exit(f"Build processing failed: {state}")
            else:
                print(f"  Still {state}, waiting 30s...")
        else:
            print("  Build not found yet, waiting 30s...")
        time.sleep(30)
    sys.exit("Timed out waiting for build to process (60 min).")


def find_or_create_version(token: str, app_id: str, version_string: str) -> str:
    """Return the ASC version ID for version_string, creating if needed."""
    # Look for existing
    resp = asc_get(
        token,
        "/appStoreVersions",
        {
            "filter[app]": app_id,
            "filter[platform]": "IOS",
            "filter[versionString]": version_string,
            "limit": 1,
        },
    )
    if resp.get("data"):
        version_id = resp["data"][0]["id"]
        print(f"Reusing existing App Store version: {version_id}")
        return version_id

    # Create new
    print(f"Creating App Store version {version_string}...")
    body = {
        "data": {
            "type": "appStoreVersions",
            "attributes": {
                "platform": "IOS",
                "versionString": version_string,
                "releaseType": "MANUAL",
            },
            "relationships": {
                "app": {"data": {"type": "apps", "id": app_id}},
            },
        }
    }
    resp = asc_post(token, "/appStoreVersions", body)
    version_id = resp["data"]["id"]
    print(f"  Created version: {version_id}")
    return version_id


def attach_build(token: str, version_id: str, build_id: str) -> None:
    print(f"Attaching build {build_id} to version {version_id}...")
    body = {"data": {"type": "builds", "id": build_id}}
    asc_patch(token, f"/appStoreVersions/{version_id}/relationships/build", body)
    print("  Build attached.")


def set_whats_new(token: str, version_id: str, notes: str) -> None:
    """Update the 'What's New' field for the en-US localization."""
    print("Updating release notes...")
    resp = asc_get(
        token,
        f"/appStoreVersions/{version_id}/appStoreVersionLocalizations",
        {"limit": 50},
    )
    en_loc = None
    for loc in resp.get("data", []):
        if loc["attributes"].get("locale") == "en-US":
            en_loc = loc
            break
    if not en_loc:
        sys.exit("No en-US localization found. Create one in the ASC web UI first.")

    asc_patch(
        token,
        f"/appStoreVersionLocalizations/{en_loc['id']}",
        {
            "data": {
                "type": "appStoreVersionLocalizations",
                "id": en_loc["id"],
                "attributes": {"whatsNew": notes},
            }
        },
    )
    print(f"  Release notes updated for en-US (id {en_loc['id']}).")


def submit_for_review(token: str, app_id: str, version_id: str) -> None:
    """Create a review submission and add the version to it."""
    print("Creating review submission...")
    resp = asc_post(
        token,
        "/reviewSubmissions",
        {
            "data": {
                "type": "reviewSubmissions",
                "attributes": {"platform": "IOS"},
                "relationships": {
                    "app": {"data": {"type": "apps", "id": app_id}},
                },
            }
        },
    )
    submission_id = resp["data"]["id"]
    print(f"  Submission ID: {submission_id}")

    print("Adding version to submission...")
    asc_post(
        token,
        "/reviewSubmissionItems",
        {
            "data": {
                "type": "reviewSubmissionItems",
                "relationships": {
                    "reviewSubmission": {
                        "data": {"type": "reviewSubmissions", "id": submission_id}
                    },
                    "appStoreVersion": {
                        "data": {"type": "appStoreVersions", "id": version_id}
                    },
                },
            }
        },
    )
    print("  Version added.")

    print("Submitting...")
    asc_patch(
        token,
        f"/reviewSubmissions/{submission_id}",
        {
            "data": {
                "type": "reviewSubmissions",
                "id": submission_id,
                "attributes": {"submitted": True},
            }
        },
    )
    print("  Submitted.")


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--key-path", required=True, type=Path)
    p.add_argument("--key-id", required=True)
    p.add_argument("--issuer-id", required=True)
    p.add_argument("--app-id", required=True, help="Numeric ASC app ID")
    p.add_argument("--version", required=True, help="Marketing version, e.g. 1.2.3")
    p.add_argument("--build", required=True, help="Build number")
    p.add_argument("--release-notes", required=True)
    args = p.parse_args()

    token = make_token(args.key_path, args.key_id, args.issuer_id)

    build_id = find_build(token, args.app_id, args.build)
    version_id = find_or_create_version(token, args.app_id, args.version)
    attach_build(token, version_id, build_id)
    set_whats_new(token, version_id, args.release_notes)
    submit_for_review(token, args.app_id, version_id)

    print()
    print("=" * 60)
    print(f"Submitted {args.version} (build {args.build}) for review.")
    print(f"App: https://appstoreconnect.apple.com/apps/{args.app_id}")
    print("=" * 60)


if __name__ == "__main__":
    main()
