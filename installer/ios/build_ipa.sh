#!/usr/bin/env bash
# Builds the iOS app. Must run on macOS with Xcode + CocoaPods.
#
#   ./installer/ios/build_ipa.sh [version]
#
# Without signing secrets it produces an UNSIGNED ipa
#   installer/dist/FrameWorkz-<version>-unsigned.ipa
# which can be installed on your own iPhone with a sideloading tool that
# re-signs with your Apple ID (AltStore, Sideloadly) — no paid developer
# account needed, re-sign every 7 days with a free Apple ID.
#
# With these environment variables set it produces a signed, App Store /
# TestFlight-ready ipa (installer/dist/FrameWorkz-<version>.ipa):
#   IOS_P12_BASE64                   base64 of your Apple Distribution .p12
#   IOS_P12_PASSWORD                 its password
#   IOS_PROVISIONING_PROFILE_BASE64  base64 of the App Store provisioning profile
#   IOS_TEAM_ID                      your 10-character Apple team id
set -euo pipefail

VERSION="${1:-$(grep '^version:' pubspec.yaml | sed 's/version: *//; s/+.*//')}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
DIST="installer/dist"
mkdir -p "$DIST"

if [[ -n "${IOS_P12_BASE64:-}" && -n "${IOS_PROVISIONING_PROFILE_BASE64:-}" && -n "${IOS_TEAM_ID:-}" ]]; then
  echo "▶ Signed build for team $IOS_TEAM_ID"
  KEYCHAIN="$RUNNER_TEMP/frameworkz.keychain-db"
  KEYCHAIN_PW="$(openssl rand -hex 16)"
  echo "$IOS_P12_BASE64" | base64 --decode > "$RUNNER_TEMP/cert.p12"
  echo "$IOS_PROVISIONING_PROFILE_BASE64" | base64 --decode > "$RUNNER_TEMP/profile.mobileprovision"
  security create-keychain -p "$KEYCHAIN_PW" "$KEYCHAIN"
  security set-keychain-settings -lut 21600 "$KEYCHAIN"
  security unlock-keychain -p "$KEYCHAIN_PW" "$KEYCHAIN"
  security import "$RUNNER_TEMP/cert.p12" -P "${IOS_P12_PASSWORD:-}" -A -t cert -f pkcs12 -k "$KEYCHAIN"
  security list-keychain -d user -s "$KEYCHAIN"
  mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
  UUID=$(/usr/libexec/PlistBuddy -c 'Print UUID' /dev/stdin <<< "$(security cms -D -i "$RUNNER_TEMP/profile.mobileprovision")")
  cp "$RUNNER_TEMP/profile.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/"$UUID".mobileprovision

  sed "s/TEAM_ID_PLACEHOLDER/$IOS_TEAM_ID/; s/PROFILE_UUID_PLACEHOLDER/$UUID/" installer/ios/ExportOptions.plist > "$RUNNER_TEMP/ExportOptions.plist"
  flutter build ipa --release --build-name="$VERSION" --export-options-plist="$RUNNER_TEMP/ExportOptions.plist"
  cp build/ios/ipa/*.ipa "$DIST/FrameWorkz-$VERSION.ipa"
  echo "✅ Signed: $DIST/FrameWorkz-$VERSION.ipa"
else
  echo "▶ Unsigned build (no signing secrets provided)"
  flutter build ios --release --no-codesign --build-name="$VERSION"
  STAGING="$(mktemp -d)"
  mkdir -p "$STAGING/Payload"
  cp -R build/ios/iphoneos/Runner.app "$STAGING/Payload/"
  (cd "$STAGING" && zip -qr "$ROOT/$DIST/FrameWorkz-$VERSION-unsigned.ipa" Payload)
  rm -rf "$STAGING"
  echo "✅ Unsigned: $DIST/FrameWorkz-$VERSION-unsigned.ipa"
fi
