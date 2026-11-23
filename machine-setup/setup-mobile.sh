#!/usr/bin/env bash
# Native SDK setup; deliberately does not boot devices or run application tests.
set -euo pipefail
case "${1:-}" in
  --plan)
    echo 'Xcode and iOS Simulator runtime: install through Xcode; licenses are interactive.'
    echo 'Android licenses: interactive sdkmanager --licenses.'
    echo 'SDK: platforms;android-36 platforms;android-37.0 build-tools;36.0.0 platform-tools emulator'
    echo 'AVD: Dev_Phone_API_36, ARM64 Google APIs image; no emulator is started.'
    exit 0 ;;
  '') ;;
  *) echo 'Usage: setup-mobile.sh [--plan]' >&2; exit 2 ;;
esac
if ! xcodebuild -version >/dev/null 2>&1; then
  echo 'Install full Xcode, open it, accept its license and install the iOS platform.' >&2
  echo 'Then select it: sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer' >&2
  exit 1
fi
export JAVA_HOME="$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
command -v sdkmanager >/dev/null || { echo 'Run dev-install.sh first; Android command-line tools are missing.' >&2; exit 1; }
mkdir -p "$ANDROID_HOME"
echo 'Review the Android SDK licenses. This step needs your input.'
sdkmanager --sdk_root="$ANDROID_HOME" --licenses
sdkmanager --sdk_root="$ANDROID_HOME" 'platform-tools' 'emulator' \
  'platforms;android-36' 'platforms;android-37.0' 'build-tools;36.0.0' 'build-tools;37.0.0' \
  'system-images;android-36;google_apis;arm64-v8a'
if ! avdmanager list avd -c | grep -qx 'Dev_Phone_API_36'; then
  printf 'no\n' | avdmanager create avd --name Dev_Phone_API_36 \
    --package 'system-images;android-36;google_apis;arm64-v8a'
fi
xcrun simctl list runtimes
if ! xcrun simctl list runtimes | grep -q 'iOS.*com.apple.CoreSimulator'; then
  echo 'No iOS Simulator runtime installed. In Xcode Settings, install an iOS runtime, then rerun this script.' >&2
  exit 1
fi
echo 'SDKs are installed. No simulator, emulator, database, or app was started.'
